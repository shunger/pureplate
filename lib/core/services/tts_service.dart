import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Something that can say text aloud; [speak] completes when speech ends.
abstract interface class Speaker {
  Future<void> init();
  Future<void> speak(String text);
  Future<void> stop();
  Future<void> dispose();
}

/// Reusable wrapper around [FlutterTts] with a `speak(text)` API that
/// returns a Future completing when speech finishes.
class TtsService implements Speaker {
  final FlutterTts _tts = FlutterTts();
  Completer<void>? _completer;

  /// Initialize TTS with cooking-friendly settings.
  @override
  Future<void> init() async {
    // Each platform call is bounded: iOS can reject an audio setting without
    // the plugin ever answering, which would hang voice cooking at startup.
    Future<void> step(String name, Future<dynamic> Function() call) async {
      try {
        await call().timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('TtsService.$name failed (continuing): $e');
      }
    }

    await step('setSharedInstance', () => _tts.setSharedInstance(true));

    await step('setIosAudioCategory', _applyAudioCategory);

    await step('setSpeechRate', () => _tts.setSpeechRate(0.48));
    await step('setVolume', () => _tts.setVolume(1.0));
    await step('setPitch', () => _tts.setPitch(1.0));
    await step('setLanguage', () => _tts.setLanguage('en-US'));

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

  /// Media playback, which also keeps the session alive when the screen is
  /// off. Re-applied before each line because speech recognition leaves iOS
  /// in play-and-record, where speech plays at the quieter call volume.
  /// Bluetooth output works with `playback` as is; iOS rejects the
  /// allowBluetooth options here.
  Future<void> _applyAudioCategory() => _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.mixWithOthers],
        IosTextToSpeechAudioMode.voicePrompt,
      );

  /// Speak the given [text] and return a Future that completes when done.
  @override
  Future<void> speak(String text) async {
    // Cancel any in-progress speech first.
    await stop();

    try {
      await _applyAudioCategory().timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('TtsService audio category failed (continuing): $e');
    }

    final completer = _completer = Completer<void>();
    debugPrint('TtsService speaking ${text.length} chars');
    try {
      await _tts.speak(text).timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint('TtsService.speak failed: $e');
      if (identical(_completer, completer)) _completer = null;
      return;
    }
    // If iOS never reports completion, don't wait forever: allow generously
    // for the length of the text.
    final limit = Duration(seconds: 10 + text.length ~/ 8);
    return completer.future.timeout(limit, onTimeout: () {
      debugPrint('TtsService: no completion after $limit, moving on');
    });
  }

  /// Stop any in-progress speech.
  @override
  Future<void> stop() async {
    final completer = _completer;
    _completer = null;
    if (completer != null && !completer.isCompleted) completer.complete();
    try {
      await _tts.stop().timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('TtsService.stop failed (continuing): $e');
    }
  }

  /// Clean up resources.
  @override
  Future<void> dispose() async {
    await stop();
  }
}
