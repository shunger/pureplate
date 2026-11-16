import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'route_names.dart';

/// Remembers the screen the user was on, so reopening the app after iOS or
/// Android closed it in the background lands back there instead of on Home.
class LastLocation {
  LastLocation._();

  static const _locationKey = 'last_location';
  static const _savedAtKey = 'last_location_saved_at';

  /// Away at least this long, the user has likely moved on, so the app starts
  /// at Home: whether iOS or Android closed it meanwhile (see [restore]) or
  /// kept it in memory (see [track]). Coming back the next day to yesterday's
  /// chat or recipe is confusing.
  static const maxAge = Duration(hours: 4);

  static AppLifecycleListener? _lifecycle;

  /// Records the top-most screen whenever navigation changes, and goes Home
  /// when the app comes back after [maxAge] in the background.
  static void track(GoRouter router) {
    DateTime? leftAt;
    String? leftFrom;
    _lifecycle?.dispose();
    _lifecycle = AppLifecycleListener(
      onHide: () {
        leftAt ??= DateTime.now();
        leftFrom = _currentLocation(router);
      },
      onShow: () {
        final since = leftAt;
        leftAt = null;
        if (since == null) return;
        if (shouldStartOver(
          away: DateTime.now().difference(since),
          leftFrom: leftFrom,
          current: _currentLocation(router),
        )) {
          router.go(Routes.home);
        }
      },
    );

    String? last;
    router.routerDelegate.addListener(() {
      final location = _currentLocation(router);
      if (location == null || location == last) return;
      // The splash screen and onboarding aren't places to come back to, and
      // the splash must not overwrite the spot it is about to restore.
      if (location == Routes.splash || location.startsWith('/onboarding')) {
        return;
      }
      last = location;
      _save(location);
    });
  }

  static String? _currentLocation(GoRouter router) {
    final config = router.routerDelegate.currentConfiguration;
    if (config.isEmpty) return null;
    final top = config.last;
    final matches = top is ImperativeRouteMatch ? top.matches : config;
    return matches.uri.toString();
  }

  static Future<void> _save(String location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_locationKey, location);
      await prefs.setInt(_savedAtKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('LastLocation: save failed: $e');
    }
  }

  /// Whether an app returning after [away] in the background should go Home
  /// instead of staying on [leftFrom].
  @visibleForTesting
  static bool shouldStartOver({
    required Duration away,
    required String? leftFrom,
    required String? current,
  }) {
    if (away < maxAge || leftFrom == null) return false;
    // A link that brought the app back has already gone somewhere new.
    if (current != leftFrom) return false;
    final path = Uri.tryParse(leftFrom)?.path ?? '';
    return path != Routes.home &&
        path != Routes.splash &&
        !path.startsWith('/onboarding');
  }

  /// Takes the user back to where they were, or to Home.
  static Future<void> restore(GoRouter router) async {
    String? location;
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedAt = prefs.getInt(_savedAtKey) ?? 0;
      final age = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(savedAt));
      if (age < maxAge) location = prefs.getString(_locationKey);
    } catch (e) {
      debugPrint('LastLocation: read failed: $e');
    }

    final plan = restorePlan(location);
    router.go(plan.first);
    for (final pushed in plan.skip(1)) {
      router.push(pushed);
    }
  }

  /// The screens to rebuild for a saved [location]: the first is gone to,
  /// the rest are pushed on top so Back still works.
  @visibleForTesting
  static List<String> restorePlan(String? location) {
    final path = location == null ? null : Uri.tryParse(location)?.path;
    if (path == null) return const [Routes.home];
    final segments = Uri(path: path).pathSegments;
    if (segments.isEmpty) return const [Routes.home];

    switch (segments.first) {
      // Bottom-nav tabs and their own detail screens.
      case 'pantry':
      case 'lists':
      case 'chat':
        return [path];
      case 'planner':
        // Plan generation and chat start over, so show the planner itself.
        return const [Routes.planner];

      case 'recipes':
        if (segments.length == 1) return const [Routes.home, Routes.recipes];
        return [Routes.home, Routes.recipes, '/recipes/${segments[1]}'];

      // Cooking screens come back as the recipe, rather than starting the
      // microphone or timers by surprise.
      case 'cooking':
      case 'voice-cooking':
        if (segments.length < 2) return const [Routes.home];
        return [Routes.home, Routes.recipes, '/recipes/${segments[1]}'];

      default:
        return const [Routes.home];
    }
  }
}
