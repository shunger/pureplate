import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/routing/route_names.dart';
import '../domain/invite_link.dart';
import 'family_sharing_gate.dart';
import 'widgets/join_list_sheet.dart';
import 'widgets/join_pantry_sheet.dart';

/// Opens the join sheet for [invite]. Pantry invites first go through the
/// same Premium and sign-in gates as the Share button on the Pantry tab.
Future<void> openInvite(
    BuildContext context, WidgetRef ref, InviteLink invite) async {
  if (invite.kind == InviteKind.pantry) {
    final pantryId = await passFamilySharingGates(context, ref);
    if (pantryId == null || !context.mounted) return;
    await showJoinPantrySheet(context, ref, initialCode: invite.code);
  } else {
    await showJoinListSheet(context, ref, initialCode: invite.code);
  }
}

/// Opens `purepantry://join?code=…` and `purepantry://pantry/join?code=…`
/// links, from a QR code scanned with the Camera app or a shared message.
///
/// A link that starts the app waits until the splash screen and onboarding
/// are done, so the join sheet isn't covered by the first screen.
class InviteLinkListener extends ConsumerStatefulWidget {
  final Widget child;

  const InviteLinkListener({super.key, required this.child});

  @override
  ConsumerState<InviteLinkListener> createState() =>
      _InviteLinkListenerState();
}

class _InviteLinkListenerState extends ConsumerState<InviteLinkListener> {
  late final GoRouterDelegate _router;
  StreamSubscription<Uri>? _links;
  InviteLink? _pending;

  @override
  void initState() {
    super.initState();
    _router = ref.read(routerProvider).routerDelegate;
    _router.addListener(_openPending);
    try {
      // Delivers the link that started the app, then any later ones.
      _links = AppLinks().uriLinkStream.listen(_onLink,
          onError: (Object e) => debugPrint('[InviteLinks] $e'));
    } catch (e) {
      debugPrint('[InviteLinks] unavailable: $e');
    }
  }

  @override
  void dispose() {
    _links?.cancel();
    _router.removeListener(_openPending);
    super.dispose();
  }

  void _onLink(Uri uri) {
    if (uri.scheme != 'purepantry') return;
    final invite = InviteLink.parse(uri.toString());
    if (invite == null) return;
    _pending = invite;
    _openPending();
  }

  void _openPending() {
    final invite = _pending;
    if (invite == null) return;
    final path = _router.currentConfiguration.uri.path;
    if (path == Routes.splash || path.startsWith('/onboarding')) return;
    final navigatorContext = _router.navigatorKey.currentContext;
    if (navigatorContext == null) return;
    _pending = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorContext.mounted) openInvite(navigatorContext, ref, invite);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
