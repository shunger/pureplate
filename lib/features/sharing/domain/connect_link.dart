/// Links that connect Smart Shopping Scanner and Pure Pantry on one phone,
/// so the user doesn't have to share invite codes with themselves.
///
/// 1. Pure Pantry asks: `smartshoppingscanner://purepantry@settings`.
///    Scanner 1.1.0 just opens Settings; later builds open the Connect screen.
///    The request is marked in the user-info part because 1.1.0 also hands
///    links to Flutter's router, and a path or query there leaves it stuck on
///    the splash screen.
/// 2. After the user confirms, the scanner sends invite codes back:
///    `purepantry://connect?pantry=ABC234&lists=DEF567,GHJ892`.
///
/// Pure Pantry joins with the codes as if the user had typed them, so the
/// usual join checks apply. Keep this file the same in both apps.
class ConnectLink {
  /// The shared pantry's invite code, if the pantry is included.
  final String? pantryCode;

  /// Invite codes of the shared lists included.
  final List<String> listCodes;

  const ConnectLink({this.pantryCode, this.listCodes = const []});

  static final _code = RegExp(r'^[A-Z0-9]{6}$');

  /// Pure Pantry's request for the scanner's pantry and lists.
  static final Uri scannerRequest =
      Uri.parse('smartshoppingscanner://purepantry@settings');

  /// Whether [uri] is [scannerRequest].
  static bool isScannerRequest(Uri uri) =>
      uri.scheme.toLowerCase() == 'smartshoppingscanner' &&
      uri.host.toLowerCase() == 'settings' &&
      uri.userInfo.toLowerCase() == 'purepantry';

  bool get isEmpty => pantryCode == null && listCodes.isEmpty;

  /// The link that hands these codes to Pure Pantry.
  Uri toPurePantryUri() {
    final params = <String, String>{};
    if (pantryCode case final code?) params['pantry'] = code;
    if (listCodes.isNotEmpty) params['lists'] = listCodes.join(',');
    return Uri(scheme: 'purepantry', host: 'connect', queryParameters: params);
  }

  /// Reads a `purepantry://connect` link; null if [uri] isn't one or holds no
  /// valid code. Malformed codes are dropped.
  static ConnectLink? parse(Uri uri) {
    if (uri.scheme.toLowerCase() != 'purepantry' ||
        uri.host.toLowerCase() != 'connect') {
      return null;
    }
    String? valid(String raw) {
      final code = raw.trim().toUpperCase();
      return _code.hasMatch(code) ? code : null;
    }

    final pantry = valid(uri.queryParameters['pantry'] ?? '');
    final lists = (uri.queryParameters['lists'] ?? '')
        .split(',')
        .map(valid)
        .whereType<String>()
        .toSet()
        .toList();
    final link = ConnectLink(pantryCode: pantry, listCodes: lists);
    return link.isEmpty ? null : link;
  }
}
