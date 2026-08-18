import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/providers/database_providers.dart';
import '../../data/repositories/ai_chat_repository.dart';
import '../../data/datasources/preference_summary_builder.dart';
import '../../domain/models/family_profile.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../../shared/models/dietary_restriction.dart';
import '../../../../shared/models/product_category.dart';
import '../../data/datasources/meal_plan_mapper.dart';
import '../../../home/presentation/widgets/meal_preferences_sheet.dart';
import '../../../recipes/data/datasources/recipe_mapper.dart';

/// Chat-style interface for conversational meal planning.
///
/// User sends text describing what they want, AI responds with a meal plan.
class ChatPlanningScreen extends ConsumerStatefulWidget {
  final String? mode;
  final String? prefsParam;

  const ChatPlanningScreen({super.key, this.mode, this.prefsParam});

  @override
  ConsumerState<ChatPlanningScreen> createState() =>
      _ChatPlanningScreenState();
}

class _ChatPlanningScreenState extends ConsumerState<ChatPlanningScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  final _messages = <_ChatMessage>[];
  bool _isLoading = false;
  File? _selectedImage;
  bool _pantryOnly = false;
  // Track feedback state per recipe: recipeId → 'loved' | 'disliked' | null.
  final _feedbackState = <String, String>{};

  bool get _isMealMode =>
      widget.mode == 'dinner' ||
      widget.mode == 'breakfast' ||
      widget.mode == 'lunch' ||
      widget.mode == 'dessert' ||
      widget.mode == 'snack';

  @override
  void initState() {
    super.initState();
    if (_isMealMode) {
      final mealType = widget.mode!;
      final isIdea = mealType == 'dessert' || mealType == 'snack';

      // Parse meal preferences from query param (if provided).
      final prefs = widget.prefsParam != null
          ? MealPreferences.fromQueryParam(widget.prefsParam!)
          : const MealPreferences();
      _pantryOnly = prefs.pantryOnly;
      final prefFragment = prefs.toPromptFragment();

      final pantryConstraint = prefs.pantryOnly
          ? ' using ONLY ingredients already in my pantry (no extra shopping)'
          : " using what's in my pantry";

      final greeting = isIdea
          ? "Let me check your pantry and find $mealType ideas!"
          : prefs.pantryOnly
              ? prefFragment.isNotEmpty
                  ? "Got it — only pantry ingredients! Let me find $mealType ideas that are $prefFragment."
                  : "Got it — only pantry ingredients! Let me find something great for $mealType!"
              : prefFragment.isNotEmpty
                  ? "Great choices! Let me find $mealType ideas that are $prefFragment."
                  : "Let me check your pantry and find something great for $mealType!";

      // Build a prompt that incorporates the user's preferences.
      String prompt;
      if (prefFragment.isNotEmpty) {
        prompt = isIdea
            ? "What $mealType can I make$pantryConstraint? I'm in the mood for: $prefFragment."
            : "What can I make for $mealType$pantryConstraint? I'm in the mood for: $prefFragment.";
      } else {
        prompt = isIdea
            ? "What $mealType can I make$pantryConstraint?"
            : "What can I make for $mealType$pantryConstraint?";
      }

      // Append free-form notes if provided.
      if (prefs.notes != null && prefs.notes!.isNotEmpty) {
        prompt += '\nAdditional notes: ${prefs.notes}';
      }

      _messages.add(_ChatMessage(text: greeting, isUser: false));
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.text = prompt;
        _sendMessage();
      });
    } else {
      _messages.add(const _ChatMessage(
        text: 'Hi! Tell me what you\'re in the mood for, and I\'ll help plan '
            'your meals. Try something like:\n\n'
            '"I want comfort food for 3 days"\n'
            '"Plan a week of quick healthy dinners"\n'
            '"What can I make with chicken and rice?"',
        isUser: false,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: _isMealMode
            ? IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Back to home',
                onPressed: () => context.go(Routes.home),
              )
            : null,
        title: Text(_isMealMode ? 'Chat Planner' : 'Chat'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.planGeneration),
            child: const Text('Quick Plan',
                style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return _buildLoadingBubble();
                }
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),

          // Image preview
          if (_selectedImage != null)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Semantics(
                        button: true,
                        label: 'Remove attached photo',
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImage = null),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.close,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Input area
          Container(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).viewPadding.bottom + 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: _selectedImage == null
                  ? Border(
                      top: BorderSide(color: Theme.of(context).colorScheme.outline, width: 0.5),
                    )
                  : null,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _isLoading ? null : _showImageSourceSheet,
                  icon: const Icon(Icons.camera_alt_outlined, size: 24),
                  color: AppColors.coral,
                  tooltip: 'Attach photo',
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'What are you in the mood for?',
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                VoiceInputButton(
                  controller: _controller,
                  color: AppColors.coral,
                ),
                const SizedBox(width: 4),
                IconButton.filled(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send, size: 20),
                  tooltip: 'Send message',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.coral,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final maxWidth = MediaQuery.of(context).size.width * 0.8;
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.coral
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomRight:
                      message.isUser ? const Radius.circular(4) : null,
                  bottomLeft:
                      !message.isUser ? const Radius.circular(4) : null,
                ),
                border: message.isUser
                    ? null
                    : Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.imageFile != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 200),
                          child: Image.file(message.imageFile!,
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  if (message.text.isNotEmpty)
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                ],
              ),
            ),
            if (message.recipes.isNotEmpty)
              ...message.recipes
                  .where((r) => r.id.isNotEmpty)
                  .map((recipe) => _buildRecipeCard(recipe)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final feedback = _feedbackState[recipe.id];

    return Card(
      margin: const EdgeInsets.only(top: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.coral.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: () => context.push('/recipes/${recipe.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${recipe.totalTimeDisplay} · ${recipe.servings} servings',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.coral,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _FeedbackButton(
                    icon: Icons.thumb_up_outlined,
                    activeIcon: Icons.thumb_up,
                    label: 'Looks good',
                    isActive: feedback == 'loved',
                    activeColor: AppColors.sage,
                    onTap: () => _submitFeedback(recipe, 'loved'),
                  ),
                  const SizedBox(width: 8),
                  _FeedbackButton(
                    icon: Icons.thumb_down_outlined,
                    activeIcon: Icons.thumb_down,
                    label: 'Not for me',
                    isActive: feedback == 'disliked',
                    activeColor: AppColors.coral,
                    onTap: () => _submitFeedback(recipe, 'disliked'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitFeedback(Recipe recipe, String feedbackType) {
    final current = _feedbackState[recipe.id];
    final isToggleOff = current == feedbackType;

    setState(() {
      if (isToggleOff) {
        _feedbackState.remove(recipe.id);
      } else {
        _feedbackState[recipe.id] = feedbackType;
      }
    });

    final feedbackDao = ref.read(feedbackDaoProvider);
    if (isToggleOff) {
      // Remove feedback — delete by recipe ID (use same ID convention).
      feedbackDao.deleteFeedback('chat_${recipe.id}');
    } else {
      feedbackDao.insertFeedback(db.RecipeFeedbackCompanion(
        id: Value('chat_${recipe.id}'),
        recipeId: Value(recipe.id),
        feedback: Value(feedbackType),
        createdAt: Value(DateTime.now()),
      ));
    }
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
          border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
        ),
        child: const SizedBox(
          width: 40,
          height: 20,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.coral,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Photo Library'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    final imageFile = _selectedImage;
    if (text.isEmpty && imageFile == null) return;

    // Prepare image data before clearing state.
    String? imageBase64;
    String? imageMediaType;
    if (imageFile != null) {
      final bytes = await imageFile.readAsBytes();
      imageBase64 = base64Encode(bytes);
      final ext = imageFile.path.split('.').last.toLowerCase();
      imageMediaType = ext == 'png' ? 'image/png'
          : ext == 'webp' ? 'image/webp'
          : 'image/jpeg';
    }

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isUser: true,
        imageFile: imageFile,
      ));
      _controller.clear();
      _selectedImage = null;
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      // Build chat history from previous messages, including recipe data.
      final historyBuffer = StringBuffer();
      for (final msg in _messages) {
        final role = msg.isUser ? 'User' : 'Chef';
        historyBuffer.writeln('$role: ${msg.text}');
        if (!msg.isUser && msg.recipes.isNotEmpty) {
          for (final recipe in msg.recipes) {
            historyBuffer.writeln('[Recipe: ${recipe.name}]');
            historyBuffer.writeln('Cuisine: ${recipe.cuisine ?? "unspecified"}');
            historyBuffer.writeln('Ingredients: ${recipe.ingredients.map((i) => '${i.quantity} ${i.unit ?? ""} ${i.name}'.trim()).join(", ")}');
            historyBuffer.writeln('Instructions: ${recipe.instructions.map((i) => '${i.stepNumber}. ${i.instruction}').join(" ")}');
            historyBuffer.writeln('[/Recipe]');
          }
        }
      }

      // Build preference summary from local data.
      final familyProfileDao = ref.read(familyProfileDaoProvider);
      final pantryDao = ref.read(pantryDaoProvider);
      final summaryBuilder = ref.read(preferenceSummaryBuilderProvider);

      final dbProfile = await familyProfileDao.getProfile();
      final profile = dbProfile != null
          ? _profileFromDb(dbProfile)
          : FamilyProfile(id: 'default');

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

      // Fetch recent cooked meals from DB (same pattern as plan_generation_providers).
      final mealPlanDao = ref.read(mealPlanDaoProvider);
      final recentMealRows = await mealPlanDao.getRecentMeals();
      final domainRecentMeals =
          recentMealRows.map(MealPlanMapper.dayFromDb).toList();

      // Build feedback-cuisine pairs for auto-adjusting cuisine affinities.
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

      // Collect recipe names already suggested in this session.
      final sessionSuggestions = _messages
          .expand((m) => m.recipes)
          .map((r) => r.name)
          .where((name) => name.isNotEmpty)
          .toList();

      final summary = summaryBuilder.build(
        profile: profile,
        pantryItems: domainPantryItems,
        recentMeals: domainRecentMeals,
        recentSuggestions: sessionSuggestions,
        feedbackWithCuisine: feedbackWithCuisine,
        pantryOnly: _pantryOnly,
      );

      // Use a default message when the user sends only an image.
      final userMessage = text.isNotEmpty
          ? text
          : 'What dish is this? Can you give me the recipe?';

      // Call the AI chat Cloud Function.
      final chatRepo = ref.read(aiChatRepositoryProvider);
      final response = await chatRepo.sendMessage(
        userMessage: userMessage,
        chatHistory: historyBuffer.toString(),
        preferenceSummary: summary,
        imageBase64: imageBase64,
        imageMediaType: imageMediaType,
      );

      // Persist returned recipes to local DB so detail screen can find them.
      if (response.recipes.isNotEmpty) {
        final recipeDao = ref.read(recipeDaoProvider);
        final companions =
            response.recipes.map(RecipeMapper.toCompanion).toList();
        await recipeDao.insertRecipes(companions);
      }

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(
          text: response.responseText,
          isUser: false,
          recipes: response.recipes,
        ));
      });
    } on AiChatException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(text: e.message, isUser: false));
      });
    } catch (e, stackTrace) {
      debugPrint('ChatScreen error: $e');
      debugPrint('ChatScreen stack: $stackTrace');
      if (!mounted) return;
      final wrapped = AiChatException(
        'Something went wrong. Please try again.',
        code: e.runtimeType.toString(),
      );
      setState(() {
        _isLoading = false;
        _messages.add(_ChatMessage(text: wrapped.message, isUser: false));
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  FamilyProfile _profileFromDb(db.FamilyProfile row) {
    final parsedRestrictions = _parseDietaryRestrictions(row.dietaryRestrictionsJson);
    return FamilyProfile(
      id: row.id,
      adults: row.adults,
      kids: row.kids,
      dietaryRestrictions: parsedRestrictions.enumRestrictions,
      customDietaryRestrictions: parsedRestrictions.customRestrictions,
      skillLevel: SkillLevel.values
              .where((s) => s.name == row.skillLevel)
              .firstOrNull ??
          SkillLevel.comfortable,
      spiceTolerance: SpiceTolerance.values
              .where((s) => s.name == row.spiceTolerance)
              .firstOrNull ??
          SpiceTolerance.medium,
      varietyPreference: VarietyPreference.values
              .where((v) => v.name == row.varietyPreference)
              .firstOrNull ??
          VarietyPreference.mixed,
      dislikedIngredients: _parseJsonList(row.dislikedIngredientsJson),
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
      return (enumRestrictions: enumRestrictions, customRestrictions: customRestrictions);
    } catch (_) {
      return (enumRestrictions: <DietaryRestriction>[], customRestrictions: <String>[]);
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
}

class _FeedbackButton extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.4)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: 16,
              color: isActive
                  ? activeColor
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? activeColor
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final File? imageFile;
  final List<Recipe> recipes;

  const _ChatMessage({
    required this.text,
    required this.isUser,
    this.imageFile,
    this.recipes = const [],
  });
}
