import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'core/services/notification_service.dart';

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
          kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
    );

    // Silent anonymous sign-in — ensures a UID exists for Cloud Functions.
    final auth = FirebaseAuth.instance;
    if (auth.currentUser == null) {
      await auth.signInAnonymously();
    }
  } catch (e) {
    debugPrint('Firebase init failed (app will run in offline mode): $e');
  }

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
