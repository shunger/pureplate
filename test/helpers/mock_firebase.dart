import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_functions_platform_interface/cloud_functions_platform_interface.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

class MockHttpsCallable extends Mock implements HttpsCallable {}

class MockHttpsCallableResult<T> extends Mock
    implements HttpsCallableResult<T> {}

/// Test helper to construct [FirebaseFunctionsException] since the real
/// constructor is `@protected`.
class TestFirebaseFunctionsException extends FirebaseFunctionsException {
  TestFirebaseFunctionsException(String code)
      : super(code: code, message: code);
}
