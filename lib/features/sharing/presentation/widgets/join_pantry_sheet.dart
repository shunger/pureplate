import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_providers.dart';
import '../../../../core/providers/database_providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/firestore_pantry_sharing_service.dart';

/// Shows a bottom sheet for joining a shared pantry via invite code.
Future<void> showJoinPantrySheet(BuildContext context, WidgetRef ref) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const _JoinPantrySheetContent(),
  );
}

class _JoinPantrySheetContent extends ConsumerStatefulWidget {
  const _JoinPantrySheetContent();

  @override
  ConsumerState<_JoinPantrySheetContent> createState() =>
      _JoinPantrySheetContentState();
}

class _JoinPantrySheetContentState
    extends ConsumerState<_JoinPantrySheetContent> {
  final _controller = TextEditingController();
  SharedPantryInfo? _previewPantry;
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
      _previewPantry = null;
    });

    try {
      final service = ref.read(firestorePantrySharingServiceProvider);
      final pantry = await service.lookupByInviteCode(code);
      if (!mounted) return;

      if (pantry == null) {
        setState(() {
          _error = 'Invalid code';
          _isLooking = false;
        });
        return;
      }

      // Check expiry.
      if (pantry.inviteCodeExpiresAt != null &&
          DateTime.now().isAfter(pantry.inviteCodeExpiresAt!)) {
        setState(() {
          _error = 'Code expired';
          _isLooking = false;
        });
        return;
      }

      setState(() {
        _previewPantry = pantry;
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

  Future<void> _joinPantry() async {
    final pantry = _previewPantry;
    if (pantry == null) return;

    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;

    setState(() => _isJoining = true);

    try {
      final service = ref.read(firestorePantrySharingServiceProvider);
      final pantryId = await service.joinPantry(
        inviteCode: _controller.text.toUpperCase(),
        uid: user.uid,
        displayName: user.displayName ?? 'Member',
      );

      await ref.read(preferencesDaoProvider).setSharedPantryId(pantryId);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Joined "${pantry.name}"')),
      );
      context.push(Routes.collaborators.replaceFirst(':firestoreId', pantryId));
    } on PantrySharingException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _isJoining = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to join pantry';
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
          Text('Join a Pantry',
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
                  _previewPantry = null;
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
          if (_previewPantry != null) ...[
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
                      child: const Icon(Icons.kitchen,
                          color: AppColors.sage),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _previewPantry!.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${_previewPantry!.collaborators.length} member${_previewPantry!.collaborators.length == 1 ? '' : 's'}',
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
                _previewPantry != null && !_isJoining ? _joinPantry : null,
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
                : const Text('Join Pantry'),
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
