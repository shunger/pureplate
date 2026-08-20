import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart';

/// Reusable wrapper around [FlutterTts] with a `speak(text)` API that
/// returns a Future completing when speech finishes.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  Completer<void>? _completer;

  /// Initialize TTS with cooking-friendly settings.
  Future<void> init() async {
    await _tts.setSharedInstance(true);

    // Keep audio session alive when screen is off.
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );

    await _tts.setSpeechRate(0.48);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    await _tts.setLanguage('en-US');

    _tts.setCompletionHandler(() {
      _completer?.complete();
      _completer = null;
    });

    _tts.setCancelHandler(() {
      _completer?.complete();
      _completer = null;
    });

    _tts.setErrorHandler((error) {
      _completer?.completeError(error);
      _completer = null;
    });
  }

  /// Speak the given [text] and return a Future that completes when done.
  Future<void> speak(String text) async {
    // Cancel any in-progress speech first.
    await stop();

    _completer = Completer<void>();
    await _tts.speak(text);
    return _completer!.future;
  }

  /// Stop any in-progress speech.
  Future<void> stop() async {
    _completer?.complete();
    _completer = null;
    await _tts.stop();
  }

  /// Clean up resources.
  Future<void> dispose() async {
    await stop();
  }
}
