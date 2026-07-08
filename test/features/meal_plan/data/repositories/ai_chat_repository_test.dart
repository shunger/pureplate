import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/features/meal_plan/data/repositories/ai_chat_repository.dart';

import '../../../../helpers/mock_firebase.dart';

void main() {
  late MockFirebaseFunctions mockFunctions;
  late MockHttpsCallable mockCallable;
  late AiChatRepository repository;

  setUp(() {
    mockFunctions = MockFirebaseFunctions();
    mockCallable = MockHttpsCallable();
    repository = AiChatRepository(mockFunctions);

    when(() => mockFunctions.httpsCallable('chatWithChef'))
        .thenReturn(mockCallable);
  });

  group('AiChatRepository', () {
    group('sendMessage - success', () {
      test('returns responseText and recipes', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn({
          'responseText': 'Here is a recipe for you!',
          'recipes': [
            {
              'id': 'r1',
              'name': 'Pasta Primavera',
              'description': 'Fresh veggies with pasta',
              'cuisine': 'Italian',
              'prep_time': 10,
              'cook_time': 20,
              'servings': 4,
              'ingredients': [
                {'name': 'Pasta', 'quantity': '1', 'unit': 'lb'},
              ],
              'instructions': [
                {'step_number': 1, 'instruction': 'Boil pasta'},
              ],
            },
          ],
        });
        when(() => mockCallable.call(any()))
            .thenAnswer((_) async => mockResult);

        final response = await repository.sendMessage(
          userMessage: 'Suggest a pasta recipe',
          chatHistory: '',
          preferenceSummary: {},
        );

        expect(response.responseText, 'Here is a recipe for you!');
        expect(response.recipes.length, 1);
        expect(response.recipes.first.name, 'Pasta Primavera');
        expect(response.recipes.first.ingredients.length, 1);
      });

      test('handles empty recipes list', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn({
          'responseText': 'Just a chat message.',
          'recipes': [],
        });
        when(() => mockCallable.call(any()))
            .thenAnswer((_) async => mockResult);

        final response = await repository.sendMessage(
          userMessage: 'Hello',
          chatHistory: '',
          preferenceSummary: {},
        );

        expect(response.responseText, 'Just a chat message.');
        expect(response.recipes, isEmpty);
      });

      test('handles missing recipes key', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn({
          'responseText': 'No recipes here.',
        });
        when(() => mockCallable.call(any()))
            .thenAnswer((_) async => mockResult);

        final response = await repository.sendMessage(
          userMessage: 'Tell me about nutrition',
          chatHistory: '',
          preferenceSummary: {},
        );

        expect(response.recipes, isEmpty);
      });
    });

    group('sendMessage - error mapping', () {
      test('resource-exhausted maps to quota message', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('resource-exhausted'),
        );

        expect(
          () => repository.sendMessage(
            userMessage: 'Hi',
            chatHistory: '',
            preferenceSummary: {},
          ),
          throwsA(isA<AiChatException>().having(
            (e) => e.code,
            'code',
            'resource-exhausted',
          )),
        );
      });

      test('unavailable maps correctly', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('unavailable'),
        );

        expect(
          () => repository.sendMessage(
            userMessage: 'Hi',
            chatHistory: '',
            preferenceSummary: {},
          ),
          throwsA(isA<AiChatException>().having(
            (e) => e.code,
            'code',
            'unavailable',
          )),
        );
      });

      test('unknown error maps to generic message', () async {
        when(() => mockCallable.call(any()))
            .thenThrow(Exception('random'));

        expect(
          () => repository.sendMessage(
            userMessage: 'Hi',
            chatHistory: '',
            preferenceSummary: {},
          ),
          throwsA(isA<AiChatException>().having(
            (e) => e.code,
            'code',
            'unknown',
          )),
        );
      });
    });
  });
}
