import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  // TODO: Initialize services on startup:
  // - Anonymous sign-in (Firebase Auth)
  // - Local database (Drift)
  // - Load bundled recipes on first launch
  // - Set up notification channels (FCM + local)
  // - Start pantry sync orchestrator
  // - Check for data migration from old apps

  runApp(
    const ProviderScope(
      child: PurePlateApp(),
    ),
  );
}
