import 'dart:io';
import 'package:flutter/services.dart';

const _channel = MethodChannel('com.purepantry/scan_feedback');

/// Plays the scan detection sound and medium haptic.
/// Call with the results of reading user preferences to gate each effect.
void playScanFeedback({
  required bool sound,
  required bool haptic,
  int soundId = 1108,
}) {
  if (haptic) {
    HapticFeedback.mediumImpact();
  }
  if (sound) {
    if (Platform.isIOS) {
      _channel.invokeMethod('playSystemSound', {'soundId': soundId});
    } else {
      SystemSound.play(SystemSoundType.click);
    }
  }
}
