import 'package:flutter/material.dart';

import 'app_version.dart';
import 'update_check_service.dart';

/// Shown instead of the app when this build is below the minimum version.
class UpdateRequiredScreen extends StatelessWidget {
  final String appName;
  final UpdateCheckService service;

  const UpdateRequiredScreen({
    super.key,
    required this.appName,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.system_update,
                      size: 72, color: theme.colorScheme.primary),
                  const SizedBox(height: 24),
                  Text('Update required',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    'This version of $appName is no longer supported. '
                    'Update to keep using the app and to keep shared '
                    'pantries and lists in sync. Your data stays on your '
                    'device and will be there after you update.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: service.openStore,
                    icon: const Icon(Icons.download),
                    label: const Text('Update'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The whole app when the launch check finds the build too old, so nothing
/// else (sync, notifications, purchases) starts.
class UpdateRequiredApp extends StatelessWidget {
  final String appName;
  final UpdateCheckService service;
  final ThemeData? theme;
  final ThemeData? darkTheme;

  const UpdateRequiredApp({
    super.key,
    required this.appName,
    required this.service,
    this.theme,
    this.darkTheme,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: theme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: UpdateRequiredScreen(appName: appName, service: service),
    );
  }
}

/// Wraps the running app (from `MaterialApp.builder`): blocks it if the
/// minimum version is raised while it is open, and offers an update when a
/// newer version is recommended. Re-checks when the app returns to the
/// foreground.
class UpdateGate extends StatefulWidget {
  final String appName;
  final UpdateCheckService service;
  final Widget child;

  const UpdateGate({
    super.key,
    required this.appName,
    required this.service,
    required this.child,
  });

  @override
  State<UpdateGate> createState() => _UpdateGateState();
}

class _UpdateGateState extends State<UpdateGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) widget.service.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UpdateStatus>(
      valueListenable: widget.service.status,
      builder: (context, status, _) => Stack(
        children: [
          widget.child,
          if (status == UpdateStatus.required)
            Positioned.fill(
              child: UpdateRequiredScreen(
                  appName: widget.appName, service: widget.service),
            ),
          if (status == UpdateStatus.recommended)
            Positioned(
              left: 16,
              right: 16,
              bottom: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 88),
                  child: _UpdateOffer(
                      appName: widget.appName, service: widget.service),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UpdateOffer extends StatelessWidget {
  final String appName;
  final UpdateCheckService service;

  const _UpdateOffer({required this.appName, required this.service});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(16),
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('A new version of $appName is available.',
                style: theme.textTheme.bodyLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: service.dismissRecommended,
                  child: const Text('Later'),
                ),
                FilledButton(
                  onPressed: service.openStore,
                  child: const Text('Update'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
