import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/firestore_list_sharing_service.dart';

/// Shows a bottom sheet for joining a shared shopping list via invite code.
Future<void> showJoinListSheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _JoinListSheetContent(),
  );
}

class _JoinListSheetContent extends ConsumerStatefulWidget {
  const _JoinListSheetContent();

  @override
  ConsumerState<_JoinListSheetContent> createState() =>
      _JoinListSheetContentState();
}

class _JoinListSheetContentState
    extends ConsumerState<_JoinListSheetContent> {
  final _controller = TextEditingController();
  SharedListInfo? _previewList;
  String? _error;
  bool _isLooking = false;
  bool _isJoining = false;

  static const _validChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _lookup(String code) async {
    setState(() {
      _isLooking = true;
      _error = null;
      _previewList = null;
    });

    try {
      final service = ref.read(firestoreListSharingServiceProvider);
      final list = await service.lookupByInviteCode(code);
      if (!mounted) return;

      if (list == null) {
        setState(() {
          _error = 'Invalid code';
          _isLooking = false;
        });
        return;
      }

      if (list.inviteCodeExpiresAt != null &&
          DateTime.now().isAfter(list.inviteCodeExpiresAt!)) {
        setState(() {
          _error = 'Code expired';
          _isLooking = false;
        });
        return;
      }

      setState(() {
        _previewList = list;
        _isLooking = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Lookup failed';
        _isLooking = false;
      });
    }
  }

  Future<void> _joinList() async {
    final list = _previewList;
    if (list == null) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isJoining = true);

    try {
      final service = ref.read(firestoreListSharingServiceProvider);
      final listId = await service.joinList(
        inviteCode: _controller.text.toUpperCase(),
        uid: user.uid,
        displayName: user.displayName ?? 'Member',
      );

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined "${list.name}"')),
      );
      context.push(Routes.listCollaborators
          .replaceFirst(':firestoreId', listId));
    } on ListSharingException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isJoining = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to join list';
        _isJoining = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Join a Shared List',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            'Enter the 6-character invite code shared with you.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            textCapitalization: TextCapitalization.characters,
            maxLength: 6,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 8,
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z2-9]')),
              _UpperCaseFormatter(),
            ],
            decoration: InputDecoration(
              counterText: '',
              hintText: 'ABC123',
              hintStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 8,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              errorText: _error,
            ),
            onChanged: (value) {
              final upper = value.toUpperCase();
              if (upper.length == 6 &&
                  upper.split('').every((c) => _validChars.contains(c))) {
                _lookup(upper);
              } else {
                setState(() {
                  _previewList = null;
                  _error = null;
                });
              }
            },
          ),
          if (_isLooking) ...[
            const SizedBox(height: 16),
            const Center(
                child: SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(strokeWidth: 2))),
          ],
          if (_previewList != null) ...[
            const SizedBox(height: 16),
            Card(
              color: AppColors.sage.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                          AppColors.sage.withValues(alpha: 0.2),
                      child: const Icon(Icons.shopping_cart,
                          color: AppColors.sage),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _previewList!.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_previewList!.collaborators.length} member${_previewList!.collaborators.length == 1 ? '' : 's'}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.check_circle,
                        color: AppColors.sage),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 20),
          FilledButton(
            onPressed:
                _previewList != null && !_isJoining ? _joinList : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.coral,
              minimumSize: const Size.fromHeight(48),
            ),
            child: _isJoining
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white))
                : const Text('Join List'),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
