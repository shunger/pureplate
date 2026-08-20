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
import '../../../pantry/data/services/pantry_consumption_service.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../data/datasources/recipe_mapper.dart';
import '../../data/services/local_command_matcher.dart';
import '../../data/services/voice_loop_service.dart';
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

class _VoiceCookingScreenState extends ConsumerState<VoiceCookingScreen> {
  int _currentStep = 0;
  Recipe? _recipe;
  VoiceLoopService? _voiceLoop;
  bool _initialized = false;

  // Timer state
  Timer? _timer;
  int _timerSeconds = 0;
  bool _timerRunning = false;
  int? _timerMinutes;

  // UI state
  String _statusLabel = 'Starting...';
  String _lastHeardText = '';

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initVoiceAssistant();
  }

  Future<void> _initVoiceAssistant() async {
    // Initialize TTS.
    final tts = ref.read(ttsServiceProvider);
    await tts.init();

    // Load recipe.
    final recipe =
        await ref.read(recipeDetailProvider(widget.recipeId).future);
    if (recipe == null || !mounted) return;

    setState(() => _recipe = recipe);

    // Acquire global listening lock.
    ref.read(isListeningProvider.notifier).state = true;

    // Create voice loop service.
    final stt = ref.read(speechToTextProvider);
    final voiceLoop = VoiceLoopService(
      tts: tts,
      stt: stt,
      onResult: _handleVoiceResult,
      onError: (error) {
        if (mounted) {
          setState(() => _statusLabel = 'Error: $error');
        }
      },
    );

    voiceLoop.addListener(_onVoiceLoopStateChanged);
    setState(() {
      _voiceLoop = voiceLoop;
      _initialized = true;
    });

    // Start with greeting.
    final firstStep = recipe.instructions.isNotEmpty
        ? recipe.instructions[0].instruction
        : 'No instructions available';
    final greeting = "Let's cook ${recipe.name}. "
        "Step 1: $firstStep. "
        "Say next to move forward, or ask me anything.";

    await voiceLoop.startLoop(greeting);
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

  Future<void> _handleVoiceResult(String text) async {
    final recipe = _recipe;
    final voiceLoop = _voiceLoop;
    if (recipe == null || voiceLoop == null) return;

    final matcher = ref.read(localCommandMatcherProvider);
    final result = matcher.match(text);

    if (result != null) {
      await _handleLocalCommand(result, recipe, voiceLoop);
    } else {
      await _handleAiQuestion(text, recipe, voiceLoop);
    }
  }

  Future<void> _handleLocalCommand(
    LocalCommandResult command,
    Recipe recipe,
    VoiceLoopService voiceLoop,
  ) async {
    switch (command.type) {
      case LocalCommandType.next:
        if (_currentStep < recipe.instructions.length - 1) {
          setState(() => _currentStep++);
          final step = recipe.instructions[_currentStep];
          await voiceLoop.speakThenListen(
            'Step ${step.stepNumber}: ${step.instruction}',
          );
        } else {
          await voiceLoop.speakThenListen(
            "You're already on the last step. Say finish cooking when you're done.",
          );
        }

      case LocalCommandType.previous:
        if (_currentStep > 0) {
          setState(() => _currentStep--);
          final step = recipe.instructions[_currentStep];
          await voiceLoop.speakThenListen(
            'Step ${step.stepNumber}: ${step.instruction}',
          );
        } else {
          await voiceLoop.speakThenListen(
            "You're already on the first step.",
          );
        }

      case LocalCommandType.repeat:
        if (recipe.instructions.isNotEmpty) {
          final step = recipe.instructions[_currentStep];
          await voiceLoop.speakThenListen(
            'Step ${step.stepNumber}: ${step.instruction}',
          );
        }

      case LocalCommandType.readIngredients:
        final ingredientsList = recipe.ingredients
            .map((i) =>
                '${i.quantity ?? ""} ${i.unit ?? ""} ${i.name}'.trim())
            .join(', ');
        await voiceLoop.speakThenListen(
          'You need: $ingredientsList',
        );

      case LocalCommandType.whatStep:
        final total = recipe.instructions.length;
        await voiceLoop.speakThenListen(
          "You're on step ${_currentStep + 1} of $total.",
        );

      case LocalCommandType.setTimer:
        final minutes = command.timerMinutes ?? 1;
        _startTimer(minutes);
        await voiceLoop.speakThenListen(
          'Timer set for $minutes minute${minutes == 1 ? '' : 's'}.',
        );

      case LocalCommandType.stopTimer:
        if (_timerRunning) {
          _stopTimer();
          await voiceLoop.speakThenListen('Timer stopped.');
        } else {
          await voiceLoop.speakThenListen('No timer is running.');
        }

      case LocalCommandType.finishCooking:
        await _finishCooking();

      case LocalCommandType.help:
        await voiceLoop.speakThenListen(
          'You can say: next, previous, repeat, ingredients, '
          'what step am I on, set timer for N minutes, stop timer, '
          'pause, finish cooking, or ask me any question about the recipe.',
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
        preferenceSummary: preferenceSummary,
      );
      await voiceLoop.speakThenListen(answer);
    } catch (e) {
      await voiceLoop.speakThenListen(
        "Sorry, I couldn't answer that. Try asking again, or say a command like next or repeat.",
      );
    }
  }

  Future<Map<String, dynamic>> _buildPreferenceSummary() async {
    final familyProfileDao = ref.read(familyProfileDaoProvider);
    final pantryDao = ref.read(pantryDaoProvider);
    final summaryBuilder = ref.read(preferenceSummaryBuilderProvider);

    final dbProfile = await familyProfileDao.getProfile();
    final profile =
        dbProfile != null ? _profileFromDb(dbProfile) : FamilyProfile(id: 'default');

    final pantryItems = await pantryDao.getAllItems();
    final domainPantryItems = pantryItems
        .map((item) => PantryItem(
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
            ))
        .toList();

    final mealPlanDao = ref.read(mealPlanDaoProvider);
    final recentMealRows = await mealPlanDao.getRecentMeals();
    final domainRecentMeals =
        recentMealRows.map(MealPlanMapper.dayFromDb).toList();

    final feedbackDao = ref.read(feedbackDaoProvider);
    final recipeDao = ref.read(recipeDaoProvider);
    final allFeedback = await feedbackDao.getAllFeedback();
    final feedbackWithCuisine = <FeedbackCuisine>[];
    for (final fb in allFeedback) {
      final recipe = await recipeDao.getRecipeById(fb.recipeId);
      if (recipe != null && recipe.cuisine.isNotEmpty) {
        feedbackWithCuisine.add(FeedbackCuisine(
          feedback: fb.feedback,
          cuisine: recipe.cuisine,
        ));
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
  void _startTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _timerMinutes = minutes;
      _timerSeconds = minutes * 60;
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
      _timerMinutes = null;
    });
  }

  Future<void> _onTimerComplete() async {
    final voiceLoop = _voiceLoop;
    if (voiceLoop == null) return;

    final minutes = _timerMinutes ?? 0;
    setState(() => _timerMinutes = null);
    await voiceLoop.speakThenListen(
      'Your $minutes minute timer is done!',
    );
  }

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // Finish cooking (same logic as CookingModeScreen)
  Future<void> _finishCooking() async {
    final voiceLoop = _voiceLoop;
    await voiceLoop?.speakOnly("Great job! Marking your meal as done.");

    final meal = await ref.read(mealPlanDaoProvider).getTodaysMeal();
    if (meal != null && meal.recipeId == widget.recipeId) {
      await ref.read(mealPlanDaoProvider).markCooked(meal.id, true);
    }

    ConsumptionResult? result;
    final dbRecipe =
        await ref.read(recipeDaoProvider).getRecipeById(widget.recipeId);
    if (dbRecipe != null) {
      final recipe = RecipeMapper.fromDb(dbRecipe);
      result = await ref
          .read(pantryConsumptionServiceProvider)
          .deductIngredientsForRecipe(
            recipe: recipe,
            pantryDao: ref.read(pantryDaoProvider),
            shoppingListDao: ref.read(shoppingListDaoProvider),
          );
    }

    if (!mounted) return;

    await _cleanup();

    if (!mounted) return;

    final message = _buildCookingMessage(result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.sage,
      ),
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
    final parsedRestrictions =
        _parseDietaryRestrictions(row.dietaryRestrictionsJson as String);
    return FamilyProfile(
      id: row.id as String,
      adults: row.adults as int,
      kids: row.kids as int,
      dietaryRestrictions: parsedRestrictions.enumRestrictions,
      customDietaryRestrictions: parsedRestrictions.customRestrictions,
      skillLevel: SkillLevel.values
              .where((s) => s.name == (row.skillLevel as String))
              .firstOrNull ??
          SkillLevel.comfortable,
      spiceTolerance: SpiceTolerance.values
              .where((s) => s.name == (row.spiceTolerance as String))
              .firstOrNull ??
          SpiceTolerance.medium,
      varietyPreference: VarietyPreference.values
              .where((v) => v.name == (row.varietyPreference as String))
              .firstOrNull ??
          VarietyPreference.mixed,
      dislikedIngredients:
          _parseJsonList(row.dislikedIngredientsJson as String),
    );
  }

  ({
    List<DietaryRestriction> enumRestrictions,
    List<String> customRestrictions
  }) _parseDietaryRestrictions(String json) {
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
        customRestrictions: customRestrictions
      );
    } catch (_) {
      return (
        enumRestrictions: <DietaryRestriction>[],
        customRestrictions: <String>[]
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
    final step =
        instructions.isNotEmpty ? instructions[_currentStep] : null;
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
                        horizontal: 12, vertical: 6),
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
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
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
                      // Animated mic icon
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorForState(voiceLoopState)
                              .withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          _iconForState(voiceLoopState),
                          size: 48,
                          color: _colorForState(voiceLoopState),
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
                              horizontal: 20, vertical: 12),
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
                                    FontFeature.tabularFigures()
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
                          'Step ${step.stepNumber}',
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
