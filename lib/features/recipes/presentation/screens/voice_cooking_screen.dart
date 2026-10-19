import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../../../../shared/models/product_category.dart';
import '../../../meal_plan/data/datasources/meal_plan_mapper.dart';
import '../../../meal_plan/data/datasources/preference_summary_builder.dart';
import '../../../meal_plan/domain/models/family_profile.dart';
import '../../../pantry/data/datasources/pantry_sync_orchestrator.dart';
import '../../../pantry/data/services/pantry_consumption_service.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../../shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../../data/services/local_command_matcher.dart';
import '../../data/services/natural_voice_service.dart';
import '../../data/services/spoken_text.dart';
import '../../data/services/voice_loop_service.dart';
import '../../data/services/voice_script_service.dart';
import '../../domain/models/recipe.dart';
import '../providers/recipe_providers.dart';
import '../providers/voice_cooking_providers.dart';
import '../../../../core/providers/speech_providers.dart';

/// Hands-free voice cooking assistant screen.
///
/// Reads recipe steps aloud via TTS, continuously listens for voice
/// commands/questions, responds via TTS, and loops.
class VoiceCookingScreen extends ConsumerStatefulWidget {
  final String recipeId;

  const VoiceCookingScreen({super.key, required this.recipeId});

  @override
  ConsumerState<VoiceCookingScreen> createState() => _VoiceCookingScreenState();
}

class _VoiceCookingScreenState extends ConsumerState<VoiceCookingScreen>
    with WidgetsBindingObserver {
  int _currentStep = 0;
  Recipe? _recipe;
  VoiceLoopService? _voiceLoop;
  NaturalVoiceService? _voice;
  bool _initialized = false;

  /// The hands-free script: short spoken actions, said one per "next".
  List<VoiceLine> _lines = const [];
  int _lineIndex = 0;

  /// Set once the screen starts closing, so a slow setup can't restart it.
  bool _closing = false;

  /// Setup failed, so the status circle should stop pulsing.
  bool _setupFailed = false;

  /// Paused because they switched to another app (not by their choice), so
  /// listening resumes when they come back.
  bool _pausedForBackground = false;

  /// Just being friendly ("thanks", "cool"): keep listening rather than
  /// sending it to the AI. "Okay" and "got it" mean "next" (the matcher's
  /// [LocalCommandType.done]).
  static final _acknowledgement = RegExp(
    r"^(cool|great|nice|awesome|thanks|thank you|sounds good|perfect)[.!]*$",
    caseSensitive: false,
  );

  // Timer state
  Timer? _timer;
  int _timerSeconds = 0;
  bool _timerRunning = false;
  Duration? _timerLength;

  /// They asked for a timer without saying how long; the next thing they
  /// say is the length.
  bool _awaitingTimerLength = false;

  // UI state
  String _statusLabel = 'Starting...';
  String _lastHeardText = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    _initVoiceAssistant().catchError((Object e, StackTrace st) {
      // Without this a setup failure leaves the screen on "Starting..." forever.
      debugPrint('Voice cooking setup failed: $e\n$st');
      if (mounted) {
        setState(() {
          _statusLabel = "Couldn't start voice cooking";
          _setupFailed = true;
        });
      }
    });
  }

  Future<void> _initVoiceAssistant() async {
    // Initialize TTS.
    debugPrint('Voice cooking: setting up audio');
    final voice = ref.read(cookingVoiceProvider);
    await voice.init();
    _voice = voice;
    debugPrint('Voice cooking: audio ready');

    // Load recipe.
    final recipe = await ref.read(recipeDetailProvider(widget.recipeId).future);
    debugPrint(
      'Voice cooking: recipe ${recipe == null ? 'not found' : 'loaded'}',
    );
    if (recipe == null || !mounted) return;

    setState(() => _recipe = recipe);

    // Acquire global listening lock.
    ref.read(isListeningProvider.notifier).state = true;

    // Create voice loop service.
    final stt = ref.read(speechToTextProvider);
    final voiceLoop = VoiceLoopService(
      tts: voice,
      stt: stt,
      onResult: _handleVoiceResult,
      onError: (error) {
        if (mounted) {
          setState(() => _statusLabel = error);
        }
      },
    );

    voiceLoop.addListener(_onVoiceLoopStateChanged);
    setState(() {
      _voiceLoop = voiceLoop;
      _initialized = true;
    });

    if (recipe.instructions.isEmpty) {
      await voiceLoop.startLoop(
        "Let's make ${recipe.name}! This one doesn't have any steps saved, "
        'but you can ask me anything about it.',
      );
      return;
    }

    // The script is prepared while the greeting plays.
    final script = ref.read(voiceScriptServiceProvider).load(recipe);
    if (recipe.ingredients.isNotEmpty) {
      voice.prefetch(_ingredientsSpeech(recipe));
    }
    await voiceLoop.speakOnly(
      "Alright, let's make ${recipe.name}! I'll take you through it one "
      "thing at a time, so you won't need to touch your phone. Just say "
      'next when you\'re ready for the next part, or ask me anything.',
    );

    if (mounted) setState(() => _statusLabel = 'Getting ready...');
    debugPrint('Voice cooking: greeting done, waiting for script');
    final lines = await script;
    debugPrint('Voice cooking: script ready, ${lines.length} lines');
    if (!mounted || _closing) return;
    setState(() {
      _lines = lines;
      _lineIndex = 0;
      _currentStep = lines.first.stepIndex;
    });
    _prefetchAhead();
    await voiceLoop.startLoop('First up: ${lines.first.text}');
  }

  /// " · part 2 of 4" when the current step is spoken in several parts, so
  /// it's clear "next" is moving even before the step changes.
  String _partLabel() {
    if (_lines.isEmpty) return '';
    final step = _lines[_lineIndex].stepIndex;
    final parts = _lines.where((l) => l.stepIndex == step).length;
    if (parts < 2) return '';
    final part = _lines
        .take(_lineIndex + 1)
        .where((l) => l.stepIndex == step)
        .length;
    return ' · part $part of $parts';
  }

  /// Fetches audio for the next couple of lines so "next" plays instantly.
  void _prefetchAhead() {
    for (final line in _lines.skip(_lineIndex + 1).take(2)) {
      _voice?.prefetch(line.text);
    }
  }

  /// Moves to line [index] and says it.
  Future<void> _sayLine(int index, VoiceLoopService voiceLoop) async {
    debugPrint('Voice cooking: line ${index + 1}/${_lines.length}, '
        'step ${_lines[index].stepIndex + 1}');
    setState(() {
      _lineIndex = index;
      _currentStep = _lines[index].stepIndex;
    });
    _prefetchAhead();
    await voiceLoop.speakThenListen(_lines[index].text);
  }

  void _onVoiceLoopStateChanged() {
    if (!mounted) return;
    final loop = _voiceLoop;
    if (loop == null) return;

    setState(() {
      _lastHeardText = loop.lastHeardText;
      switch (loop.state) {
        case VoiceLoopState.idle:
          _statusLabel = 'Paused';
        case VoiceLoopState.listening:
          _statusLabel = 'Listening...';
        case VoiceLoopState.processing:
          _statusLabel = 'Thinking...';
        case VoiceLoopState.speaking:
          _statusLabel = 'Speaking...';
      }
    });
  }

  /// iOS takes the mic away from apps in the background, so pause while
  /// they're in another app and pick up again when they're back.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final loop = _voiceLoop;
    if (loop == null || _closing) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (loop.state != VoiceLoopState.idle) {
        debugPrint('Voice cooking: app in background, pausing');
        _pausedForBackground = true;
        loop.pauseListening();
      }
    } else if (state == AppLifecycleState.resumed && _pausedForBackground) {
      debugPrint('Voice cooking: back in the app, listening again');
      _pausedForBackground = false;
      loop.resumeListening();
    }
  }

  Future<void> _handleVoiceResult(String text) async {
    final recipe = _recipe;
    final voiceLoop = _voiceLoop;
    if (recipe == null || voiceLoop == null) return;

    if (_acknowledgement.hasMatch(text.trim())) {
      debugPrint('Voice cooking: heard "$text" -> acknowledgement');
      await voiceLoop.listenAgain();
      return;
    }

    if (_awaitingTimerLength) {
      _awaitingTimerLength = false;
      final length =
          LocalCommandMatcher.parseDuration(text, bareNumberIsMinutes: true);
      debugPrint('Voice cooking: heard timer length "$text" -> $length');
      if (length != null) {
        await _setTimerAndConfirm(length, voiceLoop);
        return;
      }
    }

    final matcher = ref.read(localCommandMatcherProvider);
    final result = matcher.match(text);
    debugPrint('Voice cooking: heard "$text" -> ${result?.type ?? 'question'}');

    if (result != null) {
      await _handleLocalCommand(result, recipe, voiceLoop);
    } else {
      await _handleAiQuestion(text, recipe, voiceLoop);
    }
  }

  String _ingredientsSpeech(Recipe recipe) {
    if (recipe.ingredients.isEmpty) {
      return "This recipe doesn't have an ingredient list saved.";
    }
    final list = SpokenText.joinNaturally(
      recipe.ingredients.map(SpokenText.ingredient).toList(),
    );
    return "Here's what you'll need: $list.";
  }

  Future<void> _handleLocalCommand(
    LocalCommandResult command,
    Recipe recipe,
    VoiceLoopService voiceLoop,
  ) async {
    switch (command.type) {
      case LocalCommandType.next:
        if (_lineIndex < _lines.length - 1) {
          await _sayLine(_lineIndex + 1, voiceLoop);
        } else {
          await voiceLoop.speakThenListen(
            "That's everything! Just say finish cooking when you're all done.",
          );
        }

      case LocalCommandType.done:
        // They did what they were told: carry on, or wrap up after the last.
        if (_lines.isNotEmpty && _lineIndex >= _lines.length - 1) {
          await _finishCooking();
        } else if (_lineIndex < _lines.length - 1) {
          await _sayLine(_lineIndex + 1, voiceLoop);
        }

      case LocalCommandType.previous:
        if (_lineIndex > 0) {
          await _sayLine(_lineIndex - 1, voiceLoop);
        } else {
          await voiceLoop.speakThenListen(
            "We're right at the beginning. ${_lines.isEmpty ? '' : _lines.first.text}",
          );
        }

      case LocalCommandType.repeat:
        if (_lines.isNotEmpty) {
          await voiceLoop.speakThenListen(_lines[_lineIndex].text);
        }

      case LocalCommandType.readIngredients:
        await voiceLoop.speakThenListen(_ingredientsSpeech(recipe));

      case LocalCommandType.whatStep:
        final total = recipe.instructions.length;
        await voiceLoop.speakThenListen(
          _currentStep == total - 1
              ? "You're on the last step, step $total."
              : "You're on step ${_currentStep + 1} of $total.",
        );

      case LocalCommandType.setTimer:
        final length = command.timerDuration;
        if (length == null) {
          _awaitingTimerLength = true;
          await voiceLoop.speakThenListen('Sure, how long should I set it for?');
        } else {
          await _setTimerAndConfirm(length, voiceLoop);
        }

      case LocalCommandType.timerStatus:
        await voiceLoop.speakThenListen(_timerRunning
            ? "There's about ${_spokenDuration(Duration(seconds: _timerSeconds))} left."
            : "There's no timer going right now.");

      case LocalCommandType.stopTimer:
        if (_timerRunning) {
          _stopTimer();
          await voiceLoop.speakThenListen('Okay, I stopped the timer.');
        } else {
          await voiceLoop.speakThenListen("There's no timer going right now.");
        }

      case LocalCommandType.finishCooking:
        await _finishCooking();

      case LocalCommandType.help:
        await voiceLoop.speakThenListen(
          'Say next, go back, or repeat to move through the steps. '
          'You can ask for the ingredients, or say something like set a '
          'timer for ten minutes, and ask how much time is left. Say pause '
          'if you need a break, and '
          "finish cooking when you're done. And you can ask me anything "
          'about the recipe.',
        );

      case LocalCommandType.pause:
        await voiceLoop.pauseListening();
    }
  }

  Future<void> _handleAiQuestion(
    String question,
    Recipe recipe,
    VoiceLoopService voiceLoop,
  ) async {
    try {
      final preferenceSummary = await _buildPreferenceSummary();
      final aiService = ref.read(cookingAssistantAiServiceProvider);
      final answer = await aiService.askQuestion(
        question: question,
        recipe: recipe,
        currentStep: _currentStep,
        currentLine: _lines.isEmpty ? null : _lines[_lineIndex].text,
        preferenceSummary: preferenceSummary,
      );
      await voiceLoop.speakThenListen(answer);
    } catch (e) {
      await voiceLoop.speakThenListen(
        "Sorry, I'm having trouble answering right now. You can try "
        'asking again, or just say next to keep going.',
      );
    }
  }

  Future<Map<String, dynamic>> _buildPreferenceSummary() async {
    final familyProfileDao = ref.read(familyProfileDaoProvider);
    final pantryDao = ref.read(pantryDaoProvider);
    final summaryBuilder = ref.read(preferenceSummaryBuilderProvider);

    final dbProfile = await familyProfileDao.getProfile();
    final profile = dbProfile != null
        ? _profileFromDb(dbProfile)
        : FamilyProfile(id: 'default');

    final pantryItems = await pantryDao.getAllItems();
    final domainPantryItems = pantryItems
        .map(
          (item) => PantryItem(
            id: item.id,
            name: item.name,
            category: ProductCategory.values.firstWhere(
              (c) => c.name == item.category,
              orElse: () => ProductCategory.other,
            ),
            quantity: item.quantity,
            unitType: item.unitType,
            expiresAt: item.expiresAt,
            isStaple: item.isStaple,
            reorderThreshold: item.reorderThreshold.toDouble(),
            createdAt: item.createdAt,
          ),
        )
        .toList();

    final mealPlanDao = ref.read(mealPlanDaoProvider);
    final recentMealRows = await mealPlanDao.getRecentMeals();
    final domainRecentMeals = recentMealRows
        .map(MealPlanMapper.dayFromDb)
        .toList();

    final feedbackDao = ref.read(feedbackDaoProvider);
    final recipeDao = ref.read(recipeDaoProvider);
    final allFeedback = await feedbackDao.getAllFeedback();
    final feedbackWithCuisine = <FeedbackCuisine>[];
    for (final fb in allFeedback) {
      final recipe = await recipeDao.getRecipeById(fb.recipeId);
      if (recipe != null && recipe.cuisine.isNotEmpty) {
        feedbackWithCuisine.add(
          FeedbackCuisine(feedback: fb.feedback, cuisine: recipe.cuisine),
        );
      }
    }

    return summaryBuilder.build(
      profile: profile,
      pantryItems: domainPantryItems,
      recentMeals: domainRecentMeals,
      feedbackWithCuisine: feedbackWithCuisine,
    );
  }

  // Timer management
  Future<void> _setTimerAndConfirm(
      Duration length, VoiceLoopService voiceLoop) async {
    final replacing = _timerRunning;
    _startTimer(length);
    await voiceLoop.speakThenListen(
      "${replacing ? 'Okay, I replaced your other timer. ' : 'Got it, '}"
      "${_spokenDuration(length)}. I'll let you know when it's up.",
    );
  }

  void _startTimer(Duration length) {
    _timer?.cancel();
    setState(() {
      _timerLength = length;
      _timerSeconds = length.inSeconds;
      _timerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds <= 0) {
        timer.cancel();
        setState(() => _timerRunning = false);
        _onTimerComplete();
        return;
      }
      setState(() => _timerSeconds--);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _timerRunning = false;
      _timerLength = null;
    });
  }

  Future<void> _onTimerComplete() async {
    final voiceLoop = _voiceLoop;
    if (voiceLoop == null) return;

    final length = _timerLength;
    setState(() => _timerLength = null);
    await voiceLoop.speakThenListen(length == null
        ? "Hey, your timer's done!"
        : 'Hey, your ${_spokenDuration(length)} timer just went off!');
  }

  /// "1 hour and 30 minutes", "45 seconds", "1 minute".
  static String _spokenDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    // Round seconds away once it's over a few minutes; nobody needs them.
    final s = d.inMinutes >= 5 ? 0 : d.inSeconds % 60;
    String unit(int n, String name) => '$n $name${n == 1 ? '' : 's'}';
    final parts = [
      if (h > 0) unit(h, 'hour'),
      if (m > 0) unit(m, 'minute'),
      if (s > 0) unit(s, 'second'),
    ];
    if (parts.isEmpty) return 'less than a minute';
    return parts.length == 1
        ? parts.first
        : '${parts.sublist(0, parts.length - 1).join(', ')} and ${parts.last}';
  }

  String _formatTimer(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    String two(int n) => n.toString().padLeft(2, '0');
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  // Finish cooking (same logic as CookingModeScreen)
  Future<void> _finishCooking() async {
    final voiceLoop = _voiceLoop;
    await voiceLoop?.speakOnly(
      "Nice work! I'll mark this one as cooked. Enjoy your meal!",
    );

    await ref.read(recipeDaoProvider).markMine(widget.recipeId);
    final meal = await ref.read(mealPlanDaoProvider).getTodaysMeal();
    if (meal != null && meal.recipeId == widget.recipeId) {
      await ref.read(mealPlanDaoProvider).markCooked(meal.id, true);
    }

    ConsumptionResult? result;
    final dbRecipe = await ref
        .read(recipeDaoProvider)
        .getRecipeById(widget.recipeId);
    if (dbRecipe != null) {
      final recipe = RecipeMapper.fromDb(dbRecipe);
      result = await ref
          .read(pantryConsumptionServiceProvider)
          .deductIngredientsForRecipe(
            recipe: recipe,
            pantryDao: ref.read(pantryDaoProvider),
            shoppingListDao: ref.read(shoppingListDaoProvider),
            pantrySync: ref.read(pantrySyncOrchestratorProvider),
            listSync: ref.read(shoppingListSyncOrchestratorProvider),
          );
    }

    if (!mounted) return;

    await _cleanup();

    if (!mounted) return;

    final message = _buildCookingMessage(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.sage),
    );
    Navigator.of(context).pop();
  }

  String _buildCookingMessage(ConsumptionResult? result) {
    if (result == null || result.deductedCount == 0) {
      return 'Great cooking! Meal marked as done.';
    }
    final parts = <String>[
      'Pantry updated — ${result.deductedCount} item${result.deductedCount == 1 ? '' : 's'} deducted',
    ];
    if (result.addedToListCount > 0) {
      parts.add(
        '${result.addedToListCount} added to ${result.shoppingListName ?? 'shopping list'}',
      );
    }
    return parts.join(', ');
  }

  Future<void> _cleanup() async {
    _closing = true;
    _timer?.cancel();
    _voiceLoop?.removeListener(_onVoiceLoopStateChanged);
    await _voiceLoop?.stopLoop();
    ref.read(isListeningProvider.notifier).state = false;
    WakelockPlus.disable();
  }

  Future<bool> _confirmExit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Exit voice cooking?'),
        content: const Text(
          'The voice assistant will stop. You can always restart it from the recipe screen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _voiceLoop?.removeListener(_onVoiceLoopStateChanged);
    _voiceLoop?.stopLoop();
    // Release global listening lock.
    try {
      ref.read(isListeningProvider.notifier).state = false;
    } catch (_) {}
    WakelockPlus.disable();
    super.dispose();
  }

  FamilyProfile _profileFromDb(dynamic row) {
    final parsedRestrictions = _parseDietaryRestrictions(
      row.dietaryRestrictionsJson as String,
    );
    return FamilyProfile(
      id: row.id as String,
      adults: row.adults as int,
      kids: row.kids as int,
      dietaryRestrictions: parsedRestrictions.enumRestrictions,
      customDietaryRestrictions: parsedRestrictions.customRestrictions,
      skillLevel:
          SkillLevel.values
              .where((s) => s.name == (row.skillLevel as String))
              .firstOrNull ??
          SkillLevel.comfortable,
      spiceTolerance:
          SpiceTolerance.values
              .where((s) => s.name == (row.spiceTolerance as String))
              .firstOrNull ??
          SpiceTolerance.medium,
      varietyPreference:
          VarietyPreference.values
              .where((v) => v.name == (row.varietyPreference as String))
              .firstOrNull ??
          VarietyPreference.mixed,
      dislikedIngredients: _parseJsonList(
        row.dislikedIngredientsJson as String,
      ),
    );
  }

  ({List<DietaryRestriction> enumRestrictions, List<String> customRestrictions})
  _parseDietaryRestrictions(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      final enumRestrictions = <DietaryRestriction>[];
      final customRestrictions = <String>[];
      for (final item in list) {
        final name = item.toString();
        final dr = DietaryRestriction.values
            .where((d) => d.name == name)
            .firstOrNull;
        if (dr != null) {
          enumRestrictions.add(dr);
        } else {
          customRestrictions.add(name);
        }
      }
      return (
        enumRestrictions: enumRestrictions,
        customRestrictions: customRestrictions,
      );
    } catch (_) {
      return (
        enumRestrictions: <DietaryRestriction>[],
        customRestrictions: <String>[],
      );
    }
  }

  List<String> _parseJsonList(String json) {
    try {
      return (jsonDecode(json) as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = _recipe;
    final theme = Theme.of(context);

    if (recipe == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Voice Cooking')),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.coral),
        ),
      );
    }

    final instructions = recipe.instructions;
    final step = instructions.isNotEmpty ? instructions[_currentStep] : null;
    final progress = instructions.isNotEmpty
        ? (_currentStep + 1) / instructions.length
        : 0.0;

    final voiceLoopState = _voiceLoop?.state ?? VoiceLoopState.idle;
    final isPaused = voiceLoopState == VoiceLoopState.idle && _initialized;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit()) {
          await _cleanup();
          if (mounted) Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(recipe.name),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _confirmExit()) {
                await _cleanup();
                if (mounted) Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            if (_timerRunning)
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _timerSeconds <= 10
                          ? AppColors.error.withValues(alpha: 0.15)
                          : AppColors.coral.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: _timerSeconds <= 10
                              ? AppColors.error
                              : AppColors.coral,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimer(_timerSeconds),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _timerSeconds <= 10
                                ? AppColors.error
                                : AppColors.coral,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  '${_currentStep + 1} / ${instructions.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: theme.colorScheme.outline,
                  color: AppColors.coral,
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 32),

              // Center status indicator
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Status circle: pulses while working, still when paused.
                      _PulsingCircle(
                        active:
                            voiceLoopState != VoiceLoopState.idle ||
                            (!_initialized && !_setupFailed),
                        color: _colorForState(voiceLoopState),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _colorForState(
                              voiceLoopState,
                            ).withValues(alpha: 0.12),
                          ),
                          child: Icon(
                            _iconForState(voiceLoopState),
                            size: 48,
                            color: _colorForState(voiceLoopState),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Status label
                      Text(
                        _statusLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _colorForState(voiceLoopState),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Timer display (prominent)
                      if (_timerRunning) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _timerSeconds <= 10
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.coral.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _timerSeconds <= 10
                                  ? AppColors.error.withValues(alpha: 0.3)
                                  : AppColors.coral.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 24,
                                color: _timerSeconds <= 10
                                    ? AppColors.error
                                    : AppColors.coral,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _formatTimer(_timerSeconds),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28,
                                  color: _timerSeconds <= 10
                                      ? AppColors.error
                                      : AppColors.coral,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Current step text
                      if (step != null) ...[
                        Text(
                          'Step ${step.stepNumber}${_partLabel()}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.coral,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.instruction,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                            height: 1.5,
                          ),
                        ),

                        // What the assistant just said, in case it was missed.
                        if (_lines.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.sage.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.volume_up,
                                  size: 18,
                                  color: AppColors.sage,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    _lines[_lineIndex].text,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: theme.colorScheme.onSurface,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],

                      // Last heard text
                      if (_lastHeardText.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        Text(
                          '"$_lastHeardText"',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom mic button
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: FloatingActionButton(
                        onPressed: () {
                          if (isPaused) {
                            _voiceLoop?.resumeListening();
                          } else {
                            _voiceLoop?.pauseListening();
                          }
                        },
                        backgroundColor: isPaused
                            ? AppColors.coral
                            : theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          isPaused ? Icons.mic : Icons.mic_off,
                          size: 28,
                          color: isPaused
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPaused ? 'Tap to resume' : 'Tap to pause',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForState(VoiceLoopState state) {
    return switch (state) {
      VoiceLoopState.idle => Icons.mic_off,
      VoiceLoopState.listening => Icons.mic,
      VoiceLoopState.processing => Icons.psychology,
      VoiceLoopState.speaking => Icons.volume_up,
    };
  }

  Color _colorForState(VoiceLoopState state) {
    return switch (state) {
      VoiceLoopState.idle => Colors.grey,
      VoiceLoopState.listening => AppColors.coral,
      VoiceLoopState.processing => AppColors.info,
      VoiceLoopState.speaking => AppColors.sage,
    };
  }
}

/// Wraps the status circle in a soft expanding ring and a gentle breathing
/// scale while [active], so it's obvious the assistant is doing something.
class _PulsingCircle extends StatefulWidget {
  final bool active;
  final Color color;
  final Widget child;

  const _PulsingCircle({
    required this.active,
    required this.color,
    required this.child,
  });

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(_PulsingCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value;
          // Breathe in and out once per cycle.
          final breathe = 1 + 0.06 * (1 - (2 * t - 1).abs());
          return Stack(
            alignment: Alignment.center,
            children: [
              if (widget.active)
                Container(
                  width: 100 + 50 * t,
                  height: 100 + 50 * t,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: 0.35 * (1 - t)),
                      width: 3,
                    ),
                  ),
                ),
              Transform.scale(scale: breathe, child: child),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
