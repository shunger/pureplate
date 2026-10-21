import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_providers.dart';
import '../../../core/routing/route_names.dart';
import '../../../shared/widgets/sign_in_bottom_sheet.dart';
import '../../settings/presentation/providers/settings_providers.dart';
import 'providers/sharing_providers.dart';

/// Takes the user through the Premium and sign-in gates for family sharing.
/// Returns their shared pantry id, or null if they stopped at a gate.
Future<String?> passFamilySharingGates(
    BuildContext context, WidgetRef ref) async {
  // 1. Premium gate
  final isPremium = ref.read(isPremiumProvider);
  if (isPremium.valueOrNull != true) {
    context.push(Routes.premium);
    return null;
  }

  // 2. Sign-in gate
  final isSignedIn = ref.read(isCloudSignedInProvider);
  if (!isSignedIn) {
    final signedIn = await showSignInBottomSheet(context, ref);
    if (!signedIn || !context.mounted) return null;
    // After sign-in, _ensurePersonalPantry runs and sets sharedPantryId.
    // Wait a frame for providers to update.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!context.mounted) return null;
  }

  return ref.read(sharedPantryIdProvider).valueOrNull;
}
