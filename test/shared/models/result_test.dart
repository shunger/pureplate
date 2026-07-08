import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/shared/models/result.dart';

void main() {
  group('Result', () {
    group('Success', () {
      test('isSuccess returns true', () {
        const result = Result.success(42);
        expect(result.isSuccess, isTrue);
      });

      test('isFailure returns false', () {
        const result = Result.success(42);
        expect(result.isFailure, isFalse);
      });

      test('dataOrNull returns data', () {
        const result = Result.success('hello');
        expect(result.dataOrNull, 'hello');
      });

      test('when() calls success callback', () {
        const result = Result.success(42);
        final value = result.when(
          success: (data) => 'got $data',
          failure: (msg, err) => 'failed',
        );
        expect(value, 'got 42');
      });

      test('equality works', () {
        expect(
          const Result.success(42),
          equals(const Result.success(42)),
        );
      });

      test('different values are not equal', () {
        expect(
          const Result.success(42),
          isNot(equals(const Result.success(43))),
        );
      });
    });

    group('Failure', () {
      test('isSuccess returns false', () {
        const result = Result<int>.failure('error');
        expect(result.isSuccess, isFalse);
      });

      test('isFailure returns true', () {
        const result = Result<int>.failure('error');
        expect(result.isFailure, isTrue);
      });

      test('dataOrNull returns null', () {
        const result = Result<int>.failure('error');
        expect(result.dataOrNull, isNull);
      });

      test('when() calls failure callback', () {
        const result = Result<int>.failure('oops', 'detail');
        final value = result.when(
          success: (data) => 'got $data',
          failure: (msg, err) => 'failed: $msg ($err)',
        );
        expect(value, 'failed: oops (detail)');
      });

      test('equality works', () {
        expect(
          const Result<int>.failure('error'),
          equals(const Result<int>.failure('error')),
        );
      });
    });
  });
}
