import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'remote_doc.dart';

/// Bookkeeping shared by the pantry and shopping list sync orchestrators.
///
/// - Stamps outgoing writes with this session's client ID and recognises their
///   echoes (see [updatedByClientField]).
/// - Remembers items this session created or deleted until a snapshot reflects
///   it. Snapshots are delivered asynchronously, so one taken just before a
///   write can arrive after it; without this, that stale snapshot would delete
///   a just-created item locally or resurrect a just-deleted one.
/// - Runs sync work one task at a time so reconciles never interleave.
class SyncTracker {
  SyncTracker({String? clientId, required this.logTag})
      : clientId = clientId ?? const Uuid().v4();

  final String clientId;
  final String logTag;

  final Set<String> _awaitingCreate = {};
  final Set<String> _awaitingDelete = {};
  Future<void> _tail = Future.value();

  Map<String, dynamic> stamp(Map<String, dynamic> data) =>
      {...data, updatedByClientField: clientId};

  void markCreated(Iterable<String> itemIds) => _awaitingCreate.addAll(itemIds);

  void markDeleted(Iterable<String> itemIds) {
    _awaitingDelete.addAll(itemIds);
    _awaitingCreate.removeAll(itemIds);
  }

  /// Filters a snapshot of item docs for a user [uid].
  ///
  /// [toApply] excludes this session's own echoes and items it has deleted.
  /// [keepIds] is the set of item IDs whose local rows must survive: everything
  /// in the snapshot plus items created but not yet visible in snapshots.
  ({List<RemoteDoc> toApply, Set<String> keepIds}) filter(
    List<RemoteDoc> docs, {
    required String? uid,
  }) {
    final remoteIds = {for (final doc in docs) doc.id};
    _awaitingCreate.removeAll(remoteIds);
    _awaitingDelete.retainWhere(remoteIds.contains);
    return (
      toApply: [
        for (final doc in docs)
          if (!_awaitingDelete.contains(doc.id) && !_isOwnEcho(doc, uid)) doc,
      ],
      keepIds: {...remoteIds, ..._awaitingCreate},
    );
  }

  // The client ID alone isn't enough: a Smart Shopping Scanner edit leaves our
  // client ID in place but changes `updatedBy`, and must still be applied.
  bool _isOwnEcho(RemoteDoc doc, String? uid) =>
      doc.data[updatedByClientField] == clientId && doc.data['updatedBy'] == uid;

  /// Runs [task] after all previously queued tasks, returning its result.
  Future<T> exclusive<T>(Future<T> Function() task) {
    final result = _tail.then((_) => task());
    _tail = result.then((_) {}, onError: (Object _) {});
    return result;
  }

  /// Queues [task], logging rather than propagating any failure.
  void run(String label, Future<void> Function() task) {
    unawaited(exclusive(task).then((_) {}, onError: (Object e) {
      debugPrint('[$logTag] $label failed: $e');
    }));
  }

  void reset() {
    _awaitingCreate.clear();
    _awaitingDelete.clear();
  }
}
