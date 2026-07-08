import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/providers/database_providers.dart';
import '../../data/repositories/ai_chat_repository.dart';
import '../../data/datasources/preference_summary_builder.dart';
import '../../domain/models/family_profile.dart';
import '../../../pantry/domain/models/pantry_item.dart';
import '../../../recipes/data/datasources/recipe_mapper.dart';
import '../../../../shared/models/product_category.dart';

/// Chat-style interface for conversational meal planning.
///
/// User sends text describing what they want, AI responds with a meal plan.
class ChatPlanningScreen extends ConsumerStatefulWidget {
  const ChatPlanningScreen({super.key});

  @override
  ConsumerState<ChatPlanningScreen> createState() =>
      _ChatPlanningScreenState();
}

class _ChatPlanningScreenState extends ConsumerState<ChatPlanningScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _messages.add(const _ChatMessage(
      text: 'Hi! Tell me what you\'re in the mood for, and I\'ll help plan '
          'your meals. Try something like:\n\n'
          '"I want comfort food for 3 days"\n'
          '"Plan a week of quick healthy dinners"\n'
          '"What can I make with chicken and rice?"',
      isUser: false,
    ));
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
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Chat Planner'),
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

          // Input area
          Container(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).viewPadding.bottom + 8),
            decoration: const BoxDecoration(
              color: AppColors.cardBackground,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'What are you in the mood for?',
                      filled: true,
                      fillColor: AppColors.cream,
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
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading ? null : _sendMessage,
                  icon: const Icon(Icons.send, size: 20),
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
    return Align(
      alignment:
          message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.coral
              : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight:
                message.isUser ? const Radius.circular(4) : null,
            bottomLeft:
                !message.isUser ? const Radius.circular(4) : null,
          ),
          border: message.isUser
              ? null
              : Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : AppColors.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
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
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
          border: Border.all(color: AppColors.divider, width: 0.5),
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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _controller.clear();
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

      final summary = summaryBuilder.build(
        profile: profile,
        pantryItems: domainPantryItems,
      );

      // Call the AI chat Cloud Function.
      final chatRepo = ref.read(aiChatRepositoryProvider);
      final response = await chatRepo.sendMessage(
        userMessage: text,
        chatHistory: historyBuffer.toString(),
        preferenceSummary: summary,
      );

      // Save any recipes returned by the AI to the local database.
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
      setState(() {
        _isLoading = false;
        _messages.add(const _ChatMessage(
          text: 'Something went wrong. Please check your connection and try again.',
          isUser: false,
        ));
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

  const _ChatMessage({required this.text, required this.isUser});
}
