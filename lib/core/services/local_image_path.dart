import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Finds recipe photos saved on the device.
///
/// Photos are stored by absolute path, and on iOS that path includes the
/// app's container folder, which changes when the app is reinstalled or
/// updated. The file itself moves with the app's Documents folder, so a stale
/// path is re-rooted onto today's Documents folder.
class LocalImagePath {
  LocalImagePath._();

  static String? _documents;

  /// Call once at startup, before photos are shown.
  static Future<void> init() async {
    _documents = (await getApplicationDocumentsDirectory()).path;
  }

  static String resolve(String path) {
    if (File(path).existsSync()) return path;
    final documents = _documents;
    const marker = '/Documents/';
    final i = path.indexOf(marker);
    if (documents == null || i < 0) return path;
    return '$documents/${path.substring(i + marker.length)}';
  }
}
