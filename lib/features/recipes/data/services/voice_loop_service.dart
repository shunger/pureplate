import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/services/tts_service.dart';

/// The current state of the voice loop state machine.
enum VoiceLoopState { idle, listening, processing, speaking }

/// Manages the TTS -> STT -> process -> TTS loop for hands-free cooking.
///
/// State machine: idle -> speaking -> listening -> processing -> speaking -> ...
class VoiceLoopService extends ChangeNotifier {
  final TtsService _tts;
  final SpeechToText _stt;

  /// Callback invoked when speech recognition produces a final result.
  final void Function(String text)? onResult;

  /// Callback invoked when an error occurs (for UI display).
  final void Function(String error)? onError;

  VoiceLoopState _state = VoiceLoopState.idle;
  VoiceLoopState get state => _state;

  bool _loopActive = false;
  bool get isActive => _loopActive;

  /// True while processing a voice result (prevents error-handler restarts).
  bool _processing = false;

  String _lastHeardText = '';
  String get lastHeardText => _lastHeardText;

  Timer? _safetyTimer;

  VoiceLoopService({
    required TtsService tts,
    required SpeechToText stt,
    this.onResult,
    this.onError,
  })  : _tts = tts,
        _stt = stt;

  /// Start the voice loop with an initial greeting spoken via TTS.
  Future<void> startLoop(String greeting) async {
    _loopActive = true;
    await speakThenListen(greeting);
  }

  /// Speak [text] via TTS, then automatically start listening when done.
  Future<void> speakThenListen(String text) async {
    if (!_loopActive) return;

    _processing = false;
    // Stop any existing STT session before speaking.
    _safetyTimer?.cancel();
    await _stt.stop();

    _setState(VoiceLoopState.speaking);
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('VoiceLoopService TTS error: $e');
    }

    if (_loopActive) {
      await _startListening();
    }
  }

  /// Speak text without auto-starting listen afterwards (for final messages).
  Future<void> speakOnly(String text) async {
    _setState(VoiceLoopState.speaking);
    try {
      await _tts.speak(text);
    } catch (e) {
      debugPrint('VoiceLoopService TTS error: $e');
    }
    if (_loopActive) {
      _setState(VoiceLoopState.idle);
    }
  }

  /// Stop the entire voice loop.
  Future<void> stopLoop() async {
    _loopActive = false;
    _processing = false;
    _safetyTimer?.cancel();
    _safetyTimer = null;
    await _tts.stop();
    await _stt.stop();
    _setState(VoiceLoopState.idle);
  }

  /// Pause listening (user said "pause" or tapped mic).
  Future<void> pauseListening() async {
    _processing = false;
    _safetyTimer?.cancel();
    await _tts.stop();
    await _stt.stop();
    _setState(VoiceLoopState.idle);
  }

  /// Resume listening after a pause.
  Future<void> resumeListening() async {
    if (!_loopActive) {
      _loopActive = true;
    }
    await _startListening();
  }

  Future<void> _startListening() async {
    if (!_loopActive) return;
    // Don't restart if we're currently processing a result or speaking.
    if (_processing || _state == VoiceLoopState.speaking) return;

    _setState(VoiceLoopState.listening);

    final available = await _stt.initialize(
      onError: (error) {
        debugPrint('VoiceLoopService STT error: ${error.errorMsg}');
        _safetyTimer?.cancel();
        // Auto-retry after a brief delay, but only if we're not processing
        // or speaking (which means speakThenListen will handle restart).
        if (_loopActive && !_processing && _state == VoiceLoopState.listening) {
          Future.delayed(const Duration(seconds: 1), () {
            if (_loopActive && !_processing) _startListening();
          });
        }
      },
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _safetyTimer?.cancel();
          // If STT ended without a result and we're still supposed to listen,
          // restart. But don't if we're processing or speaking.
          if (_loopActive && !_processing && _state == VoiceLoopState.listening) {
            Future.delayed(const Duration(milliseconds: 500), () {
              if (_loopActive && !_processing && _state != VoiceLoopState.speaking) {
                _startListening();
              }
            });
          }
        }
      },
    );

    if (!available) {
      onError?.call('Speech recognition is not available');
      _setState(VoiceLoopState.idle);
      return;
    }

    // 55-second safety timer — proactively stop STT before iOS ~60s limit.
    _safetyTimer?.cancel();
    _safetyTimer = Timer(const Duration(seconds: 55), () {
      if (_loopActive && _state == VoiceLoopState.listening && !_processing) {
        _stt.stop();
        // Restart listening after a brief gap.
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_loopActive && !_processing) _startListening();
        });
      }
    });

    _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          _safetyTimer?.cancel();
          final text = result.recognizedWords.trim();
          _lastHeardText = text;
          notifyListeners();

          if (text.isEmpty) {
            // Empty result — silently restart listening.
            if (_loopActive && !_processing) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (_loopActive && !_processing) _startListening();
              });
            }
            return;
          }

          // Mark as processing to prevent error/status handlers from
          // restarting listening while we handle the command.
          _processing = true;
          _setState(VoiceLoopState.processing);
          onResult?.call(text);
        }
      },
      listenOptions: SpeechListenOptions(
        pauseFor: const Duration(seconds: 3),
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _setState(VoiceLoopState newState) {
    if (_state == newState) return;
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _safetyTimer?.cancel();
    _tts.stop();
    _stt.stop();
    super.dispose();
  }
}
