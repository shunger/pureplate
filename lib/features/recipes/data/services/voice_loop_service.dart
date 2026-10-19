import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../../../core/services/tts_service.dart';

/// The current state of the voice loop state machine.
enum VoiceLoopState { idle, listening, processing, speaking }

/// Manages the TTS -> STT -> process -> TTS loop for hands-free cooking.
///
/// State machine: idle -> speaking -> listening -> processing -> speaking -> ...
class VoiceLoopService extends ChangeNotifier {
  final Speaker _tts;
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

  /// The one pending "start listening again"; a new one replaces it, so the
  /// error and status handlers can't both restart the mic at once.
  Timer? _restartTimer;

  /// Mic starts that failed in a row (e.g. another app has the mic).
  int _listenFailures = 0;
  static const _maxListenFailures = 5;

  bool _sttReady = false;

  /// The iPhone's on-device recognizer starts faster, so fewer first words
  /// are lost between listening sessions. Turned off if the device lacks it.
  bool _onDevice = true;

  /// Set by [pauseListening] and cleared only by [resumeListening], so a line
  /// that finishes after a pause doesn't quietly start the mic again.
  bool _paused = false;

  VoiceLoopService({
    required Speaker tts,
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

    // Transition out of speaking before starting to listen —
    // _startListening guards against being called while speaking.
    if (_loopActive) {
      _setState(VoiceLoopState.idle);
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
    _restartTimer?.cancel();
    _safetyTimer?.cancel();
    _safetyTimer = null;
    await _tts.stop();
    await _stt.stop();
    _setState(VoiceLoopState.idle);
  }

  /// Pause listening (user said "pause" or tapped mic).
  Future<void> pauseListening() async {
    _paused = true;
    _processing = false;
    _restartTimer?.cancel();
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
    _paused = false;
    _processing = false;
    _listenFailures = 0;
    _setState(VoiceLoopState.idle);
    await _startListening();
  }

  /// Go back to listening without saying anything, e.g. after "okay".
  Future<void> listenAgain() async {
    if (!_loopActive) return;
    _processing = false;
    _setState(VoiceLoopState.idle);
    await _startListening();
  }

  /// Restarts listening after [delay], replacing any restart already pending.
  void _scheduleListen(Duration delay) {
    _restartTimer?.cancel();
    _restartTimer = Timer(delay, () {
      if (_loopActive && !_processing && _state != VoiceLoopState.speaking) {
        _startListening();
      }
    });
  }

  void _onSttError(SpeechRecognitionError error) {
    debugPrint('VoiceLoopService STT error: ${error.errorMsg}');
    _safetyTimer?.cancel();
    if (!_loopActive || _processing || _state != VoiceLoopState.listening) {
      return;
    }
    if (error.errorMsg == 'error_no_match' ||
        error.errorMsg == 'error_speech_timeout') {
      // Just silence; listen again straight away. Words said while the mic
      // restarts are lost, so the gap must be as short as possible.
      _scheduleListen(Duration.zero);
      return;
    }
    // The mic itself failed. Back off, and stop after a few tries rather
    // than hammering it (which crashed the speech plugin).
    _listenFailures++;
    if (_listenFailures >= _maxListenFailures) {
      debugPrint('VoiceLoopService: mic keeps failing, pausing');
      _restartTimer?.cancel();
      _setState(VoiceLoopState.idle);
      onError?.call('Microphone unavailable. Tap the mic to try again.');
      return;
    }
    _scheduleListen(Duration(seconds: 1 << (_listenFailures - 1)));
  }

  void _onSttStatus(String status) {
    if (status != 'done' && status != 'notListening') return;
    _safetyTimer?.cancel();
    // Ended without a result: listen again (unless an error already
    // scheduled a restart, which this replaces with the same thing).
    if (_loopActive && !_processing && _state == VoiceLoopState.listening) {
      if (!(_restartTimer?.isActive ?? false)) {
        _scheduleListen(Duration.zero);
      }
    }
  }

  Future<void> _startListening() async {
    if (!_loopActive || _paused) return;
    // Don't restart if we're currently processing a result or speaking.
    if (_processing || _state == VoiceLoopState.speaking) return;

    _setState(VoiceLoopState.listening);

    // Initialize once; re-initializing on every restart tore down the speech
    // engine underneath itself. The recognizer is shared with other screens,
    // so (re)attach this loop's listeners each time.
    if (!_sttReady) {
      _sttReady = await _stt.initialize(
        onError: _onSttError,
        onStatus: _onSttStatus,
      );
    }
    _stt.errorListener = _onSttError;
    _stt.statusListener = _onSttStatus;

    if (!_sttReady) {
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
        _scheduleListen(const Duration(milliseconds: 300));
      }
    });

    try {
      await _listen();
    } catch (e) {
      debugPrint('VoiceLoopService listen threw: $e');
      if (_onDevice && '$e'.contains('on device')) {
        _onDevice = false;
        _scheduleListen(Duration.zero);
        return;
      }
      _onSttError(SpeechRecognitionError('error_listen_failed', true));
    }
  }

  Future<void> _listen() {
    return _stt.listen(
      onResult: (result) {
        if (result.finalResult) {
          _safetyTimer?.cancel();
          final text = result.recognizedWords.trim();
          _lastHeardText = text;
          _listenFailures = 0;
          notifyListeners();

          if (text.isEmpty) {
            // Empty result — silently restart listening.
            _scheduleListen(Duration.zero);
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
        onDevice: _onDevice,
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
    _restartTimer?.cancel();
    _safetyTimer?.cancel();
    _tts.stop();
    _stt.stop();
    super.dispose();
  }
}
