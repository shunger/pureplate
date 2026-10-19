import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/services/tts_service.dart';

/// The voice cooking assistant's voice: natural speech from Amazon Polly via
/// the `synthesizeSpeech` Cloud Function, falling back to the device voice
/// ([TtsService]) whenever that isn't available.
///
/// Audio is cached on the device by text, so a step is only synthesized the
/// first time it is spoken, and [prefetch] lets the next step be ready before
/// the user asks for it.
class NaturalVoiceService implements Speaker {
  /// Bump when the server voice changes so old cached audio isn't reused.
  static const _voiceVersion = 'polly-ruth-2';
  static const _maxCachedFiles = 300;
  static const _maxChars = 3000;

  final TtsService _fallback;
  final FirebaseFunctions _functions;
  final AudioPlayer _player = AudioPlayer();

  Directory? _cacheDir;
  final _inFlight = <String, Future<File?>>{};

  /// Set when the server says this account can't use the cloud voice, so the
  /// rest of the session goes straight to the device voice.
  bool _cloudDisabled = false;

  Completer<void>? _playing;

  /// Bumped by [stop] so a speak() still waiting on the network is dropped.
  int _generation = 0;

  NaturalVoiceService({
    required TtsService fallback,
    FirebaseFunctions? functions,
  })  : _fallback = fallback,
        _functions = functions ?? FirebaseFunctions.instance;

  @override
  Future<void> init() async {
    await _fallback.init();

    try {
      await _applyAudioContext();
      await _player.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      // Can't play cloud audio; the device voice still works.
      debugPrint('NaturalVoiceService audio setup failed, using device voice: $e');
      _cloudDisabled = true;
      return;
    }

    try {
      final base = await getApplicationCacheDirectory();
      _cacheDir = await Directory('${base.path}/voice_cooking').create();
      unawaited(_pruneCache());
    } catch (e) {
      debugPrint('NaturalVoiceService cache unavailable: $e');
    }
  }

  /// Puts the phone back into media playback before each line.
  ///
  /// Speech recognition switches iOS to play-and-record while listening and
  /// doesn't fully restore it, and audio in that mode plays at the much
  /// quieter call volume. Bluetooth headphones work with `playback` as is;
  /// iOS rejects allowBluetoothA2DP on this category.
  Future<void> _applyAudioContext() => _player.setAudioContext(AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: const {AVAudioSessionOptions.mixWithOthers},
        ),
        android: const AudioContextAndroid(
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.assistant,
          audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        ),
      ));

  /// Fetches audio for [text] in the background so a later [speak] is instant.
  void prefetch(String text) {
    if (_cloudDisabled) return;
    unawaited(_audioFor(text));
  }

  @override
  Future<void> speak(String text) async {
    await stop();
    final generation = _generation;

    debugPrint('NaturalVoiceService fetching audio');
    final file = await _audioFor(text);
    if (generation != _generation) return; // stopped while fetching

    if (file == null) {
      debugPrint('NaturalVoiceService no cloud audio, using device voice');
      return _fallback.speak(text);
    }

    final done = Completer<void>();
    _playing = done;
    final sub = _player.onPlayerComplete.listen((_) {
      if (!done.isCompleted) done.complete();
    });
    try {
      debugPrint('NaturalVoiceService playing ${await file.length()} bytes');
      await _bounded('audio context', _applyAudioContext);
      await _player
          .play(DeviceFileSource(file.path))
          .timeout(const Duration(seconds: 5));

      // iOS can accept play() and then never start, which would leave the
      // screen on "Speaking..." in silence. Check the audio is moving.
      await Future.any(
          [done.future, Future.delayed(const Duration(milliseconds: 1500))]);
      if (!done.isCompleted) {
        final position = await _player.getCurrentPosition();
        if (position == null || position == Duration.zero) {
          throw StateError('audio did not start (state ${_player.state})');
        }
        final total = await _player.getDuration() ?? const Duration(minutes: 2);
        await done.future.timeout(total + const Duration(seconds: 3),
            onTimeout: () {});
      }
    } catch (e) {
      debugPrint('NaturalVoiceService playback failed, using device voice: $e');
      // Don't keep trying a player that isn't working this session.
      _cloudDisabled = true;
      await _bounded('player.stop', _player.stop);
      if (generation == _generation) await _fallback.speak(text);
    } finally {
      await sub.cancel();
      if (identical(_playing, done)) _playing = null;
    }
  }

  @override
  Future<void> stop() async {
    _generation++;
    final playing = _playing;
    _playing = null;
    if (playing != null && !playing.isCompleted) playing.complete();
    await _bounded('player.stop', _player.stop);
    await _bounded('fallback.stop', _fallback.stop);
  }

  /// Runs an audio plugin call that iOS may never answer, so it can't hang
  /// voice cooking.
  static Future<void> _bounded(
      String name, Future<dynamic> Function() call) async {
    try {
      await call().timeout(const Duration(seconds: 2));
    } catch (e) {
      debugPrint('NaturalVoiceService $name failed (continuing): $e');
    }
  }

  @override
  Future<void> dispose() async {
    await stop();
    await _player.dispose();
    await _fallback.dispose();
  }

  /// Cached audio for [text], synthesizing it if needed. Null means use the
  /// device voice.
  Future<File?> _audioFor(String text) {
    final dir = _cacheDir;
    if (_cloudDisabled || dir == null || text.length > _maxChars) {
      return Future.value(null);
    }
    final key = sha256.convert(utf8.encode('$_voiceVersion|$text')).toString();
    // The block body matters: `=> _inFlight.remove(key)` would return this
    // same future to whenComplete, which then waits on itself forever.
    return _inFlight[key] ??= _fetch(text, File('${dir.path}/$key.mp3'))
        .whenComplete(() {
      _inFlight.remove(key);
    });
  }

  Future<File?> _fetch(String text, File file) async {
    try {
      if (await file.exists()) {
        // Marks it recently used for pruning.
        unawaited(file.setLastModified(DateTime.now()).then((_) {},
            onError: (Object _) {}));
        return file;
      }

      final result = await _functions
          .httpsCallable(
            'synthesizeSpeech',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 12)),
          )
          .call({'text': text})
          // The callable's own timeout doesn't cover getting an App Check
          // token first, which can wait indefinitely.
          .timeout(const Duration(seconds: 15));
      final audio = base64Decode(
          (Map<String, dynamic>.from(result.data as Map))['audio'] as String);

      // Write then rename, so a half-written file is never played.
      final tmp = File('${file.path}.part');
      await tmp.writeAsBytes(audio, flush: true);
      return await tmp.rename(file.path);
    } on FirebaseFunctionsException catch (e) {
      debugPrint('synthesizeSpeech failed (${e.code}): ${e.message}');
      if (e.code == 'permission-denied' || e.code == 'not-found') {
        _cloudDisabled = true;
      }
      return null;
    } catch (e) {
      debugPrint('synthesizeSpeech failed: $e');
      return null;
    }
  }

  /// Keeps the cache to the most recently used files.
  Future<void> _pruneCache() async {
    final dir = _cacheDir;
    if (dir == null) return;
    try {
      final files = await dir
          .list()
          .where((e) => e is File && e.path.endsWith('.mp3'))
          .cast<File>()
          .toList();
      if (files.length <= _maxCachedFiles) return;
      final stats = {for (final f in files) f: await f.lastModified()};
      files.sort((a, b) => stats[b]!.compareTo(stats[a]!));
      for (final f in files.skip(_maxCachedFiles)) {
        await f.delete();
      }
    } catch (e) {
      debugPrint('NaturalVoiceService prune failed: $e');
    }
  }
}
