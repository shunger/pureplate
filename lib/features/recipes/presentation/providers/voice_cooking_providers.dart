import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/tts_service.dart';
import '../../../meal_plan/data/repositories/ai_chat_repository.dart';
import '../../data/services/cooking_assistant_ai_service.dart';
import '../../data/services/local_command_matcher.dart';
import '../../data/services/natural_voice_service.dart';
import '../../data/services/voice_script_service.dart';

final ttsServiceProvider = Provider<TtsService>((ref) => TtsService());

/// The voice cooking assistant's voice: Polly, with the device voice as
/// fallback. Only voice cooking uses it.
final cookingVoiceProvider = Provider<NaturalVoiceService>(
    (ref) => NaturalVoiceService(fallback: ref.watch(ttsServiceProvider)));

final voiceScriptServiceProvider =
    Provider<VoiceScriptService>((ref) => VoiceScriptService());

final localCommandMatcherProvider =
    Provider<LocalCommandMatcher>((ref) => LocalCommandMatcher());

final cookingAssistantAiServiceProvider =
    Provider<CookingAssistantAiService>((ref) => CookingAssistantAiService(
          chatRepo: ref.watch(aiChatRepositoryProvider),
        ));
