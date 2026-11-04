import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_router.dart';
import '../../../core/routing/route_names.dart';
import '../domain/connect_link.dart';
import '../domain/invite_link.dart';
import 'family_sharing_gate.dart';
import 'widgets/connect_scanner_sheet.dart';
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
/// links, from a QR code scanned with the Camera app or a shared message, and
/// `purepantry://connect?…` links from Smart Shopping Scanner on this phone.
///
/// A link that starts the app waits until the splash screen and onboarding
/// are done, so the join sheet isn't covered by the first screen.
///
/// When no link opened the app, it also asks once whether to connect Smart
/// Shopping Scanner, if that's installed ([maybePromptScannerConnection]).
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
  /// Opens the sheet for the latest link, once the app is ready for it.
  void Function(BuildContext context)? _pending;

  /// Whether a link arrived this session; the connect prompt then waits.
  bool _sawLink = false;
  bool _promptStarted = false;

  @override
  void initState() {
    super.initState();
    _router = ref.read(routerProvider).routerDelegate;
    _router.addListener(_onRouteChanged);
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
    _router.removeListener(_onRouteChanged);
    super.dispose();
  }

  void _onLink(Uri uri) {
    // Scheme and host only: invite codes stay out of release logs.
    debugPrint('[InviteLinks] ${uri.scheme}://${uri.host}');
    if (uri.scheme != 'purepantry') return;
    final connect = ConnectLink.parse(uri);
    final invite = InviteLink.parse(uri.toString());
    if (connect != null) {
      _pending = (context) => showConnectScannerSheet(context, ref, connect);
    } else if (invite != null) {
      _pending = (context) => openInvite(context, ref, invite);
    } else {
      return;
    }
    _sawLink = true;
    _openPending();
  }

  void _onRouteChanged() {
    _openPending();
    _startConnectPrompt();
  }

  /// The navigator, once the app is past the splash screen and onboarding.
  BuildContext? get _readyContext {
    final path = _router.currentConfiguration.uri.path;
    if (path == Routes.splash || path.startsWith('/onboarding')) return null;
    return _router.navigatorKey.currentContext;
  }

  void _openPending() {
    final open = _pending;
    if (open == null) return;
    final navigatorContext = _readyContext;
    if (navigatorContext == null) return;
    _pending = null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorContext.mounted) open(navigatorContext);
    });
  }

  /// Waits a moment after the first screen, so a link that opened the app
  /// (or an update notice) goes first.
  Future<void> _startConnectPrompt() async {
    if (_promptStarted || _readyContext == null) return;
    _promptStarted = true;
    await Future<void>.delayed(const Duration(seconds: 3));
    final navigatorContext = _readyContext;
    if (!mounted || _sawLink || navigatorContext == null) return;
    if (!navigatorContext.mounted) return;
    await maybePromptScannerConnection(navigatorContext);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
