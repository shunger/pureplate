import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/core/update/app_version.dart';

AppVersion v(String s) => AppVersion.tryParse(s)!;

void main() {
  group('AppVersion', () {
    test('parses versions with and without a build number', () {
      expect(v('1.2.0').toString(), '1.2.0');
      expect(v(' 1.2.0+5 ').toString(), '1.2.0+5');
      expect(v('2').toString(), '2');
    });

    test('treats empty and malformed values as unset', () {
      for (final bad in [null, '', '  ', 'abc', '1.x', '1.2+', '1+2+3', '1..2']) {
        expect(AppVersion.tryParse(bad), isNull, reason: '$bad');
      }
    });

    test('compares numerically, padding missing parts with zero', () {
      expect(v('1.10.0') < v('1.9.0'), isFalse);
      expect(v('1.9.9') < v('1.10.0'), isTrue);
      expect(v('1.2').compareTo(v('1.2.0')), 0);
    });

    test('compares builds only when both sides have one', () {
      expect(v('1.3.0+2') < v('1.3.0'), isFalse);
      expect(v('1.3.0+2') < v('1.3.0+7'), isTrue);
      expect(v('1.3.0+7') < v('1.3.0+7'), isFalse);
    });
  });

  group('evaluateUpdate', () {
    final current = v('1.2.0+2');

    test('nothing set means up to date', () {
      expect(evaluateUpdate(current: current), UpdateStatus.upToDate);
    });

    test('below the minimum is required, even if also below recommended', () {
      expect(
        evaluateUpdate(
            current: current, minimum: v('1.3.0'), recommended: v('1.4.0')),
        UpdateStatus.required,
      );
    });

    test('at the minimum but below recommended is recommended', () {
      expect(
        evaluateUpdate(
            current: current, minimum: v('1.2.0'), recommended: v('1.3.0')),
        UpdateStatus.recommended,
      );
    });

    test('at or above both is up to date', () {
      expect(
        evaluateUpdate(
            current: current, minimum: v('1.2.0+2'), recommended: v('1.1.9')),
        UpdateStatus.upToDate,
      );
    });
  });
}
