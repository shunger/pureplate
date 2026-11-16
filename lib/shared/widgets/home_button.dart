import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routing/route_names.dart';

/// Top-bar button that goes straight back to Home, clearing everything opened
/// on the way. Screens without the bottom navigation bar show it, so Home is
/// one tap away however deep the user is.
class HomeButton extends StatelessWidget {
  /// Runs first; returning false stays on the screen (e.g. "Stop cooking?").
  final Future<bool> Function()? confirm;

  const HomeButton({super.key, this.confirm});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.home_outlined),
      tooltip: 'Home',
      onPressed: () async {
        final check = confirm;
        if (check != null && !await check()) return;
        if (context.mounted) context.go(Routes.home);
      },
    );
  }
}
