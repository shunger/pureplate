import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Singleton [SpeechToText] instance shared across the app.
final speechToTextProvider = Provider<SpeechToText>((ref) {
  return SpeechToText();
});

/// Global lock — only one field may listen at a time.
final isListeningProvider = StateProvider<bool>((ref) => false);
