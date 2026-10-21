import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/sharing/domain/invite_link.dart';

void main() {
  group('InviteLink.parse', () {
    test('reads both apps\' list and pantry links', () {
      final cases = {
        'smartshoppingscanner://join?code=ABC234': InviteKind.list,
        'smartshoppingscanner://pantry/join?code=ABC234': InviteKind.pantry,
        'purepantry://join?code=ABC234': InviteKind.list,
        'purepantry://pantry/join?code=ABC234': InviteKind.pantry,
      };
      cases.forEach((link, kind) {
        final invite = InviteLink.parse(link);
        expect(invite?.kind, kind, reason: link);
        expect(invite?.code, 'ABC234', reason: link);
      });
    });

    test('reads a bare code, any case, with no kind', () {
      final invite = InviteLink.parse(' abc234 ');
      expect(invite?.kind, isNull);
      expect(invite?.code, 'ABC234');
    });

    test('uppercases a lowercase code in a link', () {
      expect(InviteLink.parse('purepantry://join?code=abc234')?.code, 'ABC234');
    });

    test('rejects anything that is not an invite', () {
      for (final raw in [
        '',
        'https://example.com/join?code=ABC234',
        'smartshoppingscanner://import?data=xyz',
        'smartshoppingscanner://join',
        'smartshoppingscanner://join?code=ABC',
        'smartshoppingscanner://join?code=ABC234X',
        'purepantry://pantry?code=ABC234',
        'ABC 234',
        '012345678901',
      ]) {
        expect(InviteLink.parse(raw), isNull, reason: raw);
      }
    });
  });

  test('build makes links that parse back', () {
    for (final kind in InviteKind.values) {
      for (final scheme in InviteLink.schemes) {
        final invite = InviteLink.parse(InviteLink.build(scheme, kind, 'XYZ789'));
        expect(invite?.kind, kind);
        expect(invite?.code, 'XYZ789');
      }
    }
  });
}
