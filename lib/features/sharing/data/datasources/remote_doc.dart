/// A Firestore document's ID and data, decoupled from the Firestore SDK so the
/// sync orchestrators can be tested without a Firestore instance.
class RemoteDoc {
  final String id;
  final Map<String, dynamic> data;

  const RemoteDoc(this.id, this.data);
}

/// Field recording which app session last wrote a shared item.
///
/// Echo suppression keys on this rather than `updatedBy` (the user's UID), so a
/// user's changes from another device — or from a previous install being
/// restored — are still applied. Smart Shopping Scanner doesn't write it, so
/// scanner changes are always applied.
const updatedByClientField = 'updatedByClient';
