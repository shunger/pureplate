import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_version.dart';

/// Pure Pantry's update check. Smart Shopping Scanner has the same service
/// with its own prefix.
final updateCheck =
    UpdateCheckService(keyPrefix: 'pure_pantry', clientKey: 'purePantry');

/// Checks this build against the minimum and recommended versions in Remote
/// Config, so old builds can be retired once a backend change needs them gone.
///
/// The Firebase project and its Remote Config template are shared with Smart
/// Shopping Scanner, so every key carries an app prefix:
///
/// - `<prefix>_min_version`: builds below it are blocked until updated.
/// - `<prefix>_recommended_version`: builds below it are offered an update.
/// - `<prefix>_store_url`: optional store link, overriding the default.
///
/// Values look like "1.3.0" or "1.3.0+7"; use Remote Config's platform
/// conditions if iOS and Android need different values. Unset, malformed or
/// unreachable values never block anyone.
class UpdateCheckService {
  /// Remote Config key prefix.
  final String keyPrefix;

  /// Key for this app under `users/{uid}.appVersions`.
  final String clientKey;

  final ValueNotifier<UpdateStatus> status =
      ValueNotifier(UpdateStatus.upToDate);

  PackageInfo? _info;
  StreamSubscription<RemoteConfigUpdate>? _realtime;

  UpdateCheckService({required this.keyPrefix, required this.clientKey});

  /// The first ever check waits this long for Remote Config; later launches
  /// use the values fetched last time and refresh in the background.
  static const _firstFetchWait = Duration(seconds: 3);

  String get _minKey => '${keyPrefix}_min_version';
  String get _recommendedKey => '${keyPrefix}_recommended_version';
  String get _storeUrlKey => '${keyPrefix}_store_url';
  String get _dismissedKey => 'update_check.dismissed_version';
  String get _recordedKey => 'update_check.recorded';

  /// The version this build is, e.g. "1.3.0+7".
  String get currentVersion =>
      _info == null ? '' : '${_info!.version}+${_info!.buildNumber}';

  /// Runs before the app starts. Requires Firebase to be initialized; if it
  /// isn't, or anything fails, the app is treated as up to date.
  Future<UpdateStatus> checkAtLaunch() async {
    try {
      _info = await PackageInfo.fromPlatform();
      final rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await rc.setDefaults({_minKey: '', _recommendedKey: '', _storeUrlKey: ''});

      if (rc.lastFetchTime.millisecondsSinceEpoch > 0) {
        await rc.activate();
        unawaited(refresh());
      } else {
        await rc.fetchAndActivate().timeout(_firstFetchWait);
      }
    } catch (e) {
      debugPrint('[UpdateCheck] launch check failed: $e');
    }
    await _evaluate();
    _listenForChanges();
    return status.value;
  }

  /// Fetches newer values (at most hourly) and re-evaluates. Called on resume.
  Future<void> refresh() async {
    try {
      await FirebaseRemoteConfig.instance.fetchAndActivate();
      await _evaluate();
    } catch (e) {
      debugPrint('[UpdateCheck] refresh failed: $e');
    }
  }

  /// Hides the update offer for the current recommended version.
  Future<void> dismissRecommended() async {
    status.value = UpdateStatus.upToDate;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dismissedKey, _remote(_recommendedKey));
    } catch (_) {}
  }

  /// Opens this app's store page.
  Future<void> openStore() async {
    final url = await _storeUrl();
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('[UpdateCheck] could not open $url: $e');
    }
  }

  /// Records this build's version on the user's doc, once per version, so
  /// it can be seen how many people still run an old build before it is
  /// retired.
  Future<void> recordVersion() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || _info == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final marker = '$uid|$currentVersion';
      if (prefs.getString(_recordedKey) == marker) return;
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'appVersions': {
          clientKey: {
            'version': _info!.version,
            'build': int.tryParse(_info!.buildNumber),
            'platform': defaultTargetPlatform.name,
            'seenAt': FieldValue.serverTimestamp(),
          },
        },
      }, SetOptions(merge: true));
      await prefs.setString(_recordedKey, marker);
    } catch (e) {
      debugPrint('[UpdateCheck] could not record version: $e');
    }
  }

  void _listenForChanges() {
    if (_realtime != null) return;
    try {
      _realtime = FirebaseRemoteConfig.instance.onConfigUpdated.listen(
        (update) async {
          if (!update.updatedKeys.any((k) => k.startsWith(keyPrefix))) return;
          await FirebaseRemoteConfig.instance.activate();
          await _evaluate();
        },
        onError: (Object e) => debugPrint('[UpdateCheck] realtime: $e'),
      );
    } catch (e) {
      debugPrint('[UpdateCheck] realtime unavailable: $e');
    }
  }

  Future<void> _evaluate() async {
    final current = AppVersion.tryParse(currentVersion);
    if (current == null) return;
    var next = evaluateUpdate(
      current: current,
      minimum: AppVersion.tryParse(_remote(_minKey)),
      recommended: AppVersion.tryParse(_remote(_recommendedKey)),
    );
    if (next == UpdateStatus.recommended) {
      try {
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getString(_dismissedKey) == _remote(_recommendedKey)) {
          next = UpdateStatus.upToDate;
        }
      } catch (_) {}
    }
    status.value = next;
  }

  String _remote(String key) {
    try {
      return FirebaseRemoteConfig.instance.getString(key).trim();
    } catch (_) {
      return '';
    }
  }

  Future<String> _storeUrl() async {
    final configured = _remote(_storeUrlKey);
    if (configured.isNotEmpty) return configured;
    final id = _info?.packageName ?? '';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'https://play.google.com/store/apps/details?id=$id';
    }
    // The App Store link needs the numeric app ID; look it up by bundle ID.
    try {
      final response = await Dio().get<String>(
        'https://itunes.apple.com/lookup',
        queryParameters: {'bundleId': id},
        options: Options(receiveTimeout: const Duration(seconds: 5)),
      );
      final results = (jsonDecode(response.data ?? '{}') as Map)['results'];
      final url = results is List && results.isNotEmpty
          ? results.first['trackViewUrl']
          : null;
      if (url is String) return url;
    } catch (e) {
      debugPrint('[UpdateCheck] App Store lookup failed: $e');
    }
    return 'https://apps.apple.com/';
  }
}
