import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/voice_input_button.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/repositories/ai_chat_repository.dart';
import '../../data/datasources/preference_summary_builder.dart';
import '../../domain/models/family_profile.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../../recipes/domain/models/recipe.dart';
import '../../../../shared/models/product_category.dart';
import '../../data/datasources/meal_plan_mapper.dart';

/// Chat-style interface for conversational meal planning.
///
/// User sends text describing what they want, AI responds with a meal plan.
class ChatPlanningScreen extends ConsumerStatefulWidget {
  final String? mode;

  const ChatPlanningScreen({super.key, this.mode});

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
      final greeting = isIdea
          ? "Let me check your pantry and find $mealType ideas!"
          : "Let me check your pantry and find something great for $mealType!";
      final prompt = isIdea
          ? "What $mealType can I make using what's in my pantry?"
          : "What can I make for $mealType using what's in my pantry?";
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
        title: Text(_isMealMode ? 'Chat Planner' : 'Chat'),
        actions: [
          TextButton(
            onPressed: () => context.push(Routes.planGeneration),
            child: const Text('Quick Plan',
                style: TextStyle(color: AppColors.coral)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
    return GestureDetector(
      onTap: () => context.push('/recipes/${recipe.id}'),
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.coral.withValues(alpha: 0.3)),
        ),
        child: Row(
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
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
      ),
    );
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
      // Build chat history from previous messages.
      final historyBuffer = StringBuffer();
      for (final msg in _messages) {
        final role = msg.isUser ? 'User' : 'Chef';
        historyBuffer.writeln('$role: ${msg.text}');
      }

      // Build preference summary from local data.
      final familyProfileDao = ref.read(familyProfileDaoProvider);
      final pantryDao = ref.read(pantryDaoProvider);
      final summaryBuilder = ref.read(preferenceSummaryBuilderProvider);

      final dbProfile = await familyProfileDao.getProfile();
      final profile = dbProfile != null
          ? FamilyProfile(
              id: dbProfile.id,
              adults: dbProfile.adults,
              kids: dbProfile.kids,
            )
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
