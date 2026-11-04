import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/sharing/domain/connect_link.dart';

void main() {
  group('ConnectLink', () {
    test('round-trips the pantry and list codes', () {
      const link = ConnectLink(
          pantryCode: 'ABC234', listCodes: ['DEF567', 'GHJ892']);
      final uri = link.toPurePantryUri();
      expect(uri.toString(),
          'purepantry://connect?pantry=ABC234&lists=DEF567%2CGHJ892');
      final parsed = ConnectLink.parse(uri)!;
      expect(parsed.pantryCode, 'ABC234');
      expect(parsed.listCodes, ['DEF567', 'GHJ892']);
    });

    test('reads lists without a pantry, dropping bad and repeated codes', () {
      final parsed = ConnectLink.parse(
          Uri.parse('purepantry://connect?lists=def567,bad,DEF567,GHJ892'))!;
      expect(parsed.pantryCode, isNull);
      expect(parsed.listCodes, ['DEF567', 'GHJ892']);
    });

    test('ignores other links and links with no valid code', () {
      expect(ConnectLink.parse(Uri.parse('purepantry://join?code=ABC234')),
          isNull);
      expect(ConnectLink.parse(Uri.parse('smartshoppingscanner://connect?pantry=ABC234')),
          isNull);
      expect(ConnectLink.parse(Uri.parse('purepantry://connect?pantry=XX')),
          isNull);
    });

    test('recognises the scanner request, which 1.1.0 opens as Settings', () {
      expect(ConnectLink.isScannerRequest(ConnectLink.scannerRequest), isTrue);
      // Nothing a router would read beyond the host, so 1.1.0 can't get
      // stuck on its splash screen.
      expect(ConnectLink.scannerRequest.host, 'settings');
      expect(ConnectLink.scannerRequest.path, '');
      expect(ConnectLink.scannerRequest.query, '');
      expect(
          ConnectLink.isScannerRequest(
              Uri.parse('smartshoppingscanner://settings')),
          isFalse);
    });
  });
}
