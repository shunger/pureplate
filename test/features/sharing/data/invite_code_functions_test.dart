import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_list_sharing_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/firestore_pantry_sharing_service.dart';
import 'package:pure_pantry/features/sharing/data/datasources/invite_code_functions.dart';

class _MockFunctions extends Mock implements FirebaseFunctions {}

class _MockCallable extends Mock implements HttpsCallable {}

class _MockResult extends Mock implements HttpsCallableResult<Object?> {}

void main() {
  late _MockFunctions functions;
  late _MockCallable callable;
  late InviteCodeFunctions inviteCodes;

  setUp(() {
    functions = _MockFunctions();
    callable = _MockCallable();
    inviteCodes = InviteCodeFunctions(functions);
    when(() => functions.httpsCallable(any())).thenReturn(callable);
  });

  void respond(Object? data) {
    final result = _MockResult();
    when(() => result.data).thenReturn(data);
    when(() => callable.call<Object?>(any())).thenAnswer((_) async => result);
  }

  void fail(String code, [String? message]) {
    when(() => callable.call<Object?>(any())).thenThrow(
      FirebaseFunctionsException(code: code, message: message ?? code),
    );
  }

  test('sends the kind, code and display name, but no source app', () async {
    respond({'id': 'P1'});
    await inviteCodes.join('pantry', 'ABC234', displayName: 'Me');
    verify(() => functions.httpsCallable('joinByInviteCode')).called(1);
    verify(() => callable.call<Object?>({
          'kind': 'pantry',
          'code': 'ABC234',
          'displayName': 'Me',
        })).called(1);
  });

  test('returns the summary with string keys at every level', () async {
    respond(<Object?, Object?>{
      'id': 'L1',
      'collaborators': <Object?, Object?>{
        'u1': <Object?, Object?>{'role': 'owner'},
      },
    });
    final summary = await inviteCodes.lookup('list', 'ABC234');
    expect(summary!['collaborators'], isA<Map<String, dynamic>>());
    expect(summary['collaborators'], {
      'u1': {'role': 'owner'},
    });
  });

  test('refused codes throw with the server message', () {
    fail('invalid-argument');
    expect(inviteCodes.lookup('list', 'ZZZ999'),
        throwsA(isA<InviteCodeRefused>()));
    fail('resource-exhausted', 'Too many incorrect invite codes.');
    expect(
        inviteCodes.join('list', 'ZZZ999', displayName: 'Me'),
        throwsA(isA<InviteCodeRefused>().having(
            (e) => e.message, 'message', 'Too many incorrect invite codes.')));
    fail('failed-precondition', 'This invite code has expired.');
    expect(inviteCodes.lookup('pantry', 'ZZZ999'),
        throwsA(isA<InviteCodeRefused>()));
  });

  test('a missing function or an outage falls back', () async {
    fail('not-found');
    expect(await inviteCodes.lookup('list', 'ABC234'), isNull);
    fail('unavailable');
    expect(await inviteCodes.join('pantry', 'ABC234', displayName: 'Me'),
        isNull);
    when(() => callable.call<Object?>(any())).thenThrow(Exception('offline'));
    expect(await inviteCodes.lookup('pantry', 'ABC234'), isNull);
  });

  test('summaries become pantry and list previews', () {
    final summary = {
      'id': 'S1',
      'name': 'Home',
      'storeName': 'Aldi',
      'ownerUid': 'u1',
      'inviteCodeExpiresAt': 1767225600000,
      'createdAt': 1767139200000,
      'collaborators': {
        'u1': {'role': 'owner', 'displayName': 'Sam'},
        'u2': {'role': 'editor'},
      },
    };
    final pantry = SharedPantryInfo.fromSummary(summary);
    expect(pantry.firestoreId, 'S1');
    expect(pantry.name, 'Home');
    expect(pantry.inviteCodeExpiresAt,
        DateTime.fromMillisecondsSinceEpoch(1767225600000));
    expect(pantry.collaborators['u1']!.role, 'owner');
    expect(pantry.collaborators['u2']!.displayName, 'Unknown');

    final list = SharedListInfo.fromSummary(summary);
    expect(list.storeName, 'Aldi');
    expect(list.ownerUid, 'u1');
    expect(list.createdAt, DateTime.fromMillisecondsSinceEpoch(1767139200000));
  });
}
