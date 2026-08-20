import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/tts_service.dart';
import '../../../meal_plan/data/repositories/ai_chat_repository.dart';
import '../../data/services/cooking_assistant_ai_service.dart';
import '../../data/services/local_command_matcher.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

final localCommandMatcherProvider =
    Provider<LocalCommandMatcher>((ref) => LocalCommandMatcher());

final cookingAssistantAiServiceProvider =
    Provider<CookingAssistantAiService>((ref) => CookingAssistantAiService(
          chatRepo: ref.watch(aiChatRepositoryProvider),
        ));
