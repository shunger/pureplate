/// A dotted app version such as "1.2.0", optionally with a build number
/// ("1.2.0+5"), as written in pubspec.yaml and in Remote Config.
class AppVersion implements Comparable<AppVersion> {
  final List<int> parts;
  final int? build;

  const AppVersion(this.parts, [this.build]);

  /// Null for an empty or malformed value, which the update check treats as
  /// "no minimum set".
  static AppVersion? tryParse(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final halves = text.split('+');
    if (halves.length > 2) return null;
    final parts = halves.first.split('.').map(int.tryParse).toList();
    if (parts.length > 4 || parts.contains(null)) return null;
    final build = halves.length == 2 ? int.tryParse(halves.last) : null;
    if (halves.length == 2 && build == null) return null;
    return AppVersion(parts.cast<int>(), build);
  }

  /// Compares version numbers, then build numbers when both sides have one,
  /// so a minimum of "1.3.0" accepts any 1.3.0 build and "1.3.0+7" requires
  /// build 7 or later.
  @override
  int compareTo(AppVersion other) {
    final length =
        parts.length > other.parts.length ? parts.length : other.parts.length;
    for (var i = 0; i < length; i++) {
      final a = i < parts.length ? parts[i] : 0;
      final b = i < other.parts.length ? other.parts[i] : 0;
      if (a != b) return a.compareTo(b);
    }
    if (build != null && other.build != null) return build!.compareTo(other.build!);
    return 0;
  }

  bool operator <(AppVersion other) => compareTo(other) < 0;

  @override
  String toString() => build == null ? parts.join('.') : '${parts.join('.')}+$build';
}

enum UpdateStatus { upToDate, recommended, required }

/// Decides whether [current] must or should be updated. Unset or malformed
/// thresholds never block anyone.
UpdateStatus evaluateUpdate({
  required AppVersion current,
  AppVersion? minimum,
  AppVersion? recommended,
}) {
  if (minimum != null && current < minimum) return UpdateStatus.required;
  if (recommended != null && current < recommended) {
    return UpdateStatus.recommended;
  }
  return UpdateStatus.upToDate;
}
