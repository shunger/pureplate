/// Invite links shared as text and QR codes.
///
/// Pure Pantry and Smart Shopping Scanner join each other's lists and
/// pantries, so each reads both apps' links as well as a bare code:
///
/// - `smartshoppingscanner://join?code=ABC234` (list)
/// - `smartshoppingscanner://pantry/join?code=ABC234` (pantry)
/// - `purepantry://join?code=ABC234`, `purepantry://pantry/join?code=ABC234`
/// - `ABC234`
enum InviteKind { list, pantry }

class InviteLink {
  /// Null for a bare code, which doesn't say what it is for.
  final InviteKind? kind;
  final String code;

  const InviteLink(this.kind, this.code);

  static const schemes = {'smartshoppingscanner', 'purepantry'};
  static final _code = RegExp(r'^[A-Z0-9]{6}$');

  /// The link this app shares for [code].
  static String build(String scheme, InviteKind kind, String code) =>
      kind == InviteKind.pantry
          ? '$scheme://pantry/join?code=$code'
          : '$scheme://join?code=$code';

  /// Reads a scanned QR code or pasted text; null if it isn't an invite.
  static InviteLink? parse(String raw) {
    final text = raw.trim();
    final bare = text.toUpperCase();
    if (_code.hasMatch(bare)) return InviteLink(null, bare);

    final uri = Uri.tryParse(text);
    if (uri == null || !schemes.contains(uri.scheme.toLowerCase())) {
      return null;
    }
    final code = uri.queryParameters['code']?.trim().toUpperCase() ?? '';
    if (!_code.hasMatch(code)) return null;
    final path = '${uri.host}${uri.path}'.toLowerCase();
    if (path == 'join') return InviteLink(InviteKind.list, code);
    if (path == 'pantry/join') return InviteLink(InviteKind.pantry, code);
    return null;
  }
}
