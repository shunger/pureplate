import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'firebase_options.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/update/app_version.dart';
import 'core/update/update_check_service.dart';
import 'core/update/update_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase — wrapped in try/catch so the app still works
  // offline or if Firebase configuration is missing.
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Activate App Check (required by Cloud Functions).
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider:
          kDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
    );

    // Silent anonymous sign-in — ensures a UID exists for Cloud Functions.
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
  } catch (e) {
    debugPrint('Firebase init failed (app will run in offline mode): $e');
  }

  // A build below the minimum version starts nothing but the update screen.
  if (await updateCheck.checkAtLaunch() == UpdateStatus.required) {
    runApp(UpdateRequiredApp(
      appName: 'Pure Pantry AI',
      service: updateCheck,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
    ));
    return;
  }
  unawaited(updateCheck.recordVersion());

  // Initialize timezone data for scheduled notifications.
  tz.initializeTimeZones();

  // Set up FCM + local notification channels.
  // Separate try/catch so an APNS error on simulator doesn't block Firebase.
  try {
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Notification init failed (non-fatal): $e');
  }

  runApp(
    const ProviderScope(
      child: PurePantryApp(),
    ),
  );
}
