import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../pantry/data/datasources/pantry_sync_orchestrator.dart';
import '../../../pantry/presentation/widgets/merge_quantities_sheet.dart';
import '../../../shopping_list/data/datasources/shopping_list_sync_orchestrator.dart';
import '../../data/datasources/firestore_list_sharing_service.dart';
import '../../data/datasources/firestore_pantry_sharing_service.dart';
import '../../domain/connect_link.dart';
import '../providers/sharing_providers.dart';

/// Whether Smart Shopping Scanner is installed on this phone.
final scannerInstalledProvider = FutureProvider<bool>((ref) async {
  try {
    return await canLaunchUrl(ConnectLink.scannerRequest);
  } catch (_) {
    return false;
  }
});

/// Opens Smart Shopping Scanner's Connect screen. It sends its invite codes
/// back in a `purepantry://connect` link, which opens [showConnectScannerSheet].
Future<bool> requestScannerConnection() async {
  try {
    return await launchUrl(ConnectLink.scannerRequest,
        mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

/// Joins the pantry and lists Smart Shopping Scanner sent in [link], after
/// the user confirms.
///
/// Joining the scanner's pantry this way is free and works without Google or
/// Apple sign-in: it's the user's own pantry from the other app. Sharing a
/// pantry with other people still needs Premium.
Future<void> showConnectScannerSheet(
    BuildContext context, WidgetRef ref, ConnectLink link) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ConnectScannerSheet(link: link),
  );
}

class _ConnectScannerSheet extends ConsumerStatefulWidget {
  final ConnectLink link;

  const _ConnectScannerSheet({required this.link});

  @override
  ConsumerState<_ConnectScannerSheet> createState() =>
      _ConnectScannerSheetState();
}

class _ConnectScannerSheetState extends ConsumerState<_ConnectScannerSheet> {
  bool _isLooking = true;
  bool _isConnecting = false;
  String? _error;
  SharedPantryInfo? _pantry;
  final _lists = <(String code, SharedListInfo info)>[];

  /// Codes that didn't look up: expired, refreshed since, or invalid.
  int _unusable = 0;

  @override
  void initState() {
    super.initState();
    _lookup();
  }

  Future<void> _lookup() async {
    final pantryCode = widget.link.pantryCode;
    final pantryService = ref.read(firestorePantrySharingServiceProvider);
    final listService = ref.read(firestoreListSharingServiceProvider);

    Future<T?> attempt<T>(Future<T?> Function() lookup) async {
      try {
        return await lookup();
      } catch (_) {
        return null;
      }
    }

    final pantry = pantryCode == null
        ? null
        : await attempt(() => pantryService.lookupByInviteCode(pantryCode));
    final lists = await Future.wait(widget.link.listCodes.map(
        (code) => attempt(() => listService.lookupByInviteCode(code))));
    if (!mounted) return;

    setState(() {
      _pantry = pantry;
      for (var i = 0; i < lists.length; i++) {
        final info = lists[i];
        if (info != null) _lists.add((widget.link.listCodes[i], info));
      }
      _unusable = (pantryCode != null && pantry == null ? 1 : 0) +
          lists.where((l) => l == null).length;
      _isLooking = false;
    });
  }

  String? get _uid => ref.read(currentUserProvider).valueOrNull?.uid;

  bool _isMember(Map<String, dynamic> collaborators) =>
      _uid != null && collaborators.containsKey(_uid);

  bool get _pantryJoined =>
      _pantry != null &&
      (_isMember(_pantry!.collaborators) ||
          ref.read(sharedPantryIdProvider).valueOrNull == _pantry!.firestoreId);

  Future<void> _connect() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) {
      setState(() => _error = 'Not signed in yet. Try again in a moment.');
      return;
    }
    final displayName = user.displayName ?? 'Member';
    setState(() {
      _isConnecting = true;
      _error = null;
    });

    var joined = 0;
    final failed = <String>[];
    for (final (code, info) in _lists) {
      if (_isMember(info.collaborators)) continue;
      try {
        await ref
            .read(shoppingListSyncOrchestratorProvider)
            .joinList(inviteCode: code, displayName: displayName);
        joined++;
      } catch (_) {
        failed.add(info.name);
      }
    }

    final pantry = _pantry;
    final pantryCode = widget.link.pantryCode;
    if (pantry != null && pantryCode != null && !_pantryJoined) {
      try {
        await ref.read(pantrySyncOrchestratorProvider).joinAndMerge(
              inviteCode: pantryCode,
              displayName: displayName,
              resolveQuantities: (conflicts) => showMergeQuantitiesSheet(
                context,
                conflicts,
                sharedLabel: 'Scanner',
                localLabel: 'Pure Pantry',
              ),
            );
        joined++;
      } catch (_) {
        failed.add(pantry.name);
      }
    }

    if (!mounted) return;
    if (failed.isNotEmpty) {
      setState(() {
        _error = 'Could not connect ${failed.join(', ')}. Try again.';
        _isConnecting = false;
      });
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pop(context);
    messenger.showSnackBar(SnackBar(
      content: Text(joined == 0
          ? 'Already connected to Smart Shopping Scanner'
          : 'Connected to Smart Shopping Scanner'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final muted = theme.colorScheme.onSurfaceVariant;
    final pantry = _pantry;
    final anythingToJoin = _lists.any((l) => !_isMember(l.$2.collaborators)) ||
        (pantry != null && !_pantryJoined);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Connect Smart Shopping Scanner',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(
              'Changes in either app will show up in both.',
              style: theme.textTheme.bodyMedium?.copyWith(color: muted),
            ),
            const SizedBox(height: 16),
            if (_isLooking)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (pantry != null)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.kitchen, color: AppColors.sage),
                  title: Text(pantry.name),
                  subtitle: Text(_pantryJoined
                      ? 'Already connected'
                      : 'Your Pure Pantry items will be added to it'),
                ),
              for (final (_, info) in _lists)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading:
                      const Icon(Icons.shopping_cart, color: AppColors.sage),
                  title: Text(info.name),
                  subtitle: Text(_isMember(info.collaborators)
                      ? 'Already connected'
                      : 'Shopping list'),
                ),
              if (_unusable > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _unusable == 1
                        ? "One item couldn't be found. Try connecting again "
                            'from Smart Shopping Scanner.'
                        : "$_unusable items couldn't be found. Try connecting "
                            'again from Smart Shopping Scanner.',
                    style: theme.textTheme.bodySmall?.copyWith(color: muted),
                  ),
                ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _isLooking || _isConnecting
                  ? null
                  : anythingToJoin
                      ? _connect
                      : () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.coral,
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isConnecting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(anythingToJoin ? 'Connect' : 'Done'),
            ),
          ],
        ),
      ),
    );
  }
}
