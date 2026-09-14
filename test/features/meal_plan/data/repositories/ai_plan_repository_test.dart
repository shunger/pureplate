import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pure_pantry/features/meal_plan/data/repositories/ai_plan_repository.dart';
import 'package:pure_pantry/features/meal_plan/domain/models/meal_plan.dart';

import '../../../../helpers/mock_firebase.dart';

void main() {
  late MockFirebaseFunctions mockFunctions;
  late MockHttpsCallable mockCallable;
  late AiPlanRepository repository;

  setUp(() {
    mockFunctions = MockFirebaseFunctions();
    mockCallable = MockHttpsCallable();
    repository = AiPlanRepository(mockFunctions);

    when(() => mockFunctions.httpsCallable('generatePlan'))
        .thenReturn(mockCallable);
  });

  Map<String, dynamic> _makeSuccessResponse({int dayCount = 3}) {
    return {
      'plan': {
        'days': List.generate(dayCount, (i) => {
              'day_label': 'Day ${i + 1}',
              'meal': {
                'name': 'Recipe ${i + 1}',
                'description': 'A tasty recipe',
                'cuisine': 'Italian',
                'prep_time': 10,
                'cook_time': 20,
                'servings': 4,
                'ingredients': [
                  {
                    'name': 'Ingredient ${i + 1}',
                    'quantity': '1',
                    'unit': 'cup',
                  },
                ],
                'instructions': [
                  {
                    'step_number': 1,
                    'instruction': 'Cook it',
                  },
                ],
              },
            }),
      },
      'shopping_list': [
        {'name': 'Item 1', 'quantity': '2', 'unit': 'cups', 'category': 'produce'},
        {'name': 'Item 2', 'quantity': '1', 'unit': 'lb', 'category': 'meat'},
      ],
    };
  }

  group('AiPlanRepository', () {
    group('generatePlan - success', () {
      test('returns correct number of days', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(_makeSuccessResponse(dayCount: 5));
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 5,
          dayLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
          preferenceSummary: {},
        );

        expect(result.plan.days.length, 5);
      });

      test('parses recipes correctly', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(_makeSuccessResponse(dayCount: 2));
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 2,
          dayLabels: ['Mon', 'Tue'],
          preferenceSummary: {},
        );

        expect(result.recipes.length, 2);
        expect(result.recipes.first.name, 'Recipe 1');
        expect(result.recipes.first.ingredients.length, 1);
        expect(result.recipes.first.instructions.length, 1);
      });

      test('parses shopping items', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(_makeSuccessResponse());
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 3,
          dayLabels: ['Mon', 'Tue', 'Wed'],
          preferenceSummary: {},
        );

        expect(result.suggestedShoppingItems.length, 2);
        expect(result.suggestedShoppingItems.first.name, 'Item 1');
      });

      test('plan type is quick', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(_makeSuccessResponse());
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 3,
          dayLabels: ['Mon', 'Tue', 'Wed'],
          preferenceSummary: {},
        );

        expect(result.plan.planType, PlanType.quick);
      });

      test('start date is next Monday', () async {
        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(_makeSuccessResponse());
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 3,
          dayLabels: ['Mon', 'Tue', 'Wed'],
          preferenceSummary: {},
        );

        // startDate should be a Monday (weekday 1) or today if today is Monday.
        final weekday = result.plan.startDate.weekday;
        final today = DateTime.now();
        if (today.weekday == DateTime.monday) {
          expect(weekday, DateTime.monday);
        } else {
          expect(weekday, DateTime.monday);
          expect(result.plan.startDate.isAfter(today), isTrue);
        }
      });
    });

    group('generatePlan - null shopping_list', () {
      test('handles null shopping_list in response', () async {
        final response = _makeSuccessResponse();
        response.remove('shopping_list');

        final mockResult = MockHttpsCallableResult<dynamic>();
        when(() => mockResult.data).thenReturn(response);
        when(() => mockCallable.call(any())).thenAnswer((_) async => mockResult);

        final result = await repository.generatePlan(
          numDays: 3,
          dayLabels: ['Mon', 'Tue', 'Wed'],
          preferenceSummary: {},
        );

        expect(result.suggestedShoppingItems, isEmpty);
      });
    });

    group('generatePlan - error mapping', () {
      test('resource-exhausted maps to quota message', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('resource-exhausted'),
        );

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: ['Mon', 'Tue', 'Wed'],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.code,
            'code',
            'resource-exhausted',
          )),
        );
      });

      test('unavailable maps to unavailable message', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('unavailable'),
        );

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.code,
            'code',
            'unavailable',
          )),
        );
      });

      test('permission-denied maps correctly', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('permission-denied'),
        );

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.code,
            'code',
            'permission-denied',
          )),
        );
      });

      test('deadline-exceeded maps correctly', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('deadline-exceeded'),
        );

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.code,
            'code',
            'deadline-exceeded',
          )),
        );
      });

      test('invalid-argument shows the server\'s explanation', () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('invalid-argument',
              message: 'A meal plan can be 1 to 14 days long.'),
        );

        expect(
          () => repository.generatePlan(
            numDays: 30,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>()
              .having((e) => e.code, 'code', 'invalid-argument')
              .having((e) => e.message, 'message',
                  'A meal plan can be 1 to 14 days long.')),
        );
      });

      test('invalid-argument without an explanation maps to generic message',
          () async {
        when(() => mockCallable.call(any())).thenThrow(
          TestFirebaseFunctionsException('invalid-argument', message: ''),
        );

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.message,
            'message',
            'Something went wrong generating your plan. Try again?',
          )),
        );
      });

      test('unknown error maps to generic message', () async {
        when(() => mockCallable.call(any()))
            .thenThrow(Exception('random error'));

        expect(
          () => repository.generatePlan(
            numDays: 3,
            dayLabels: [],
            preferenceSummary: {},
          ),
          throwsA(isA<AiPlanException>().having(
            (e) => e.code,
            'code',
            'unknown',
          )),
        );
      });
    });
  });
}
