import 'package:flutter_test/flutter_test.dart';
import 'package:pure_pantry/features/recipes/data/services/local_command_matcher.dart';

void main() {
  final matcher = LocalCommandMatcher();

  Duration? timer(String said) {
    final r = matcher.match(said);
    expect(r?.type, LocalCommandType.setTimer, reason: said);
    return r!.timerDuration;
  }

  group('set timer', () {
    test('minutes in digits and words', () {
      expect(timer('Set a timer for 10 minutes'), const Duration(minutes: 10));
      expect(timer('set timer for ten minutes'), const Duration(minutes: 10));
      expect(timer('timer 5 min'), const Duration(minutes: 5));
      expect(timer('set a timer for twenty five minutes'),
          const Duration(minutes: 25));
      expect(timer('set a timer for twenty-five minutes'),
          const Duration(minutes: 25));
      expect(timer('set a timer for 90 minutes'), const Duration(minutes: 90));
    });

    test('hours, seconds, and combinations', () {
      expect(timer('set a timer for an hour'), const Duration(hours: 1));
      expect(timer('set a timer for 30 seconds'), const Duration(seconds: 30));
      expect(timer('set a timer for 1 hour 15 minutes'),
          const Duration(minutes: 75));
      expect(timer('set a timer for an hour and a half'),
          const Duration(minutes: 90));
      expect(timer('set a timer for one and a half hours'),
          const Duration(minutes: 90));
      expect(timer('set a timer for 2 minutes and 30 seconds'),
          const Duration(seconds: 150));
    });

    test('everyday phrasings', () {
      expect(timer('set a timer for a minute'), const Duration(minutes: 1));
      expect(timer('set a timer for half an hour'), const Duration(minutes: 30));
      expect(timer('start a ten minute timer'), const Duration(minutes: 10));
      expect(timer('remind me in 5 minutes'), const Duration(minutes: 5));
      expect(timer('set a timer for a couple of minutes'),
          const Duration(minutes: 2));
      expect(timer('set a timer for ten'), const Duration(minutes: 10));
    });

    test('no time given asks how long', () {
      expect(timer('set a timer'), isNull);
    });
  });

  test('stop and check the timer', () {
    for (final said in ['stop the timer', 'cancel timer', 'turn off the timer']) {
      expect(matcher.match(said)?.type, LocalCommandType.stopTimer, reason: said);
    }
    for (final said in ['how much time is left on the timer', 'how long on the timer']) {
      expect(matcher.match(said)?.type, LocalCommandType.timerStatus, reason: said);
    }
  });

  test('a duration on its own, after "how long?"', () {
    expect(LocalCommandMatcher.parseDuration('ten minutes'),
        const Duration(minutes: 10));
    expect(LocalCommandMatcher.parseDuration('15', bareNumberIsMinutes: true),
        const Duration(minutes: 15));
    expect(LocalCommandMatcher.parseDuration('next'), isNull);
  });

  group('talking naturally', () {
    LocalCommandType? type(String said) => matcher.match(said)?.type;

    test('finishing what they were told moves on', () {
      for (final said in [
        'Ready', 'done', 'OK', 'okay', 'got it', "OK it's all prepped",
        "it's in", "I'm done", 'all done', "okay that's chopped",
      ]) {
        expect(type(said), LocalCommandType.done, reason: said);
      }
      for (final said in ["what's next", 'now what', 'what do I do now']) {
        expect(type(said), LocalCommandType.next, reason: said);
      }
    });

    test('questions still go to the AI', () {
      for (final said in [
        'is the pasta done', 'is it ready yet?', 'okay how long should I stir',
        'I already added the salt, is that ok', 'does the butter need to be soft',
      ]) {
        expect(type(said), isNull, reason: said);
      }
    });

    test('repeat and finish', () {
      expect(type('what do I do first'), LocalCommandType.repeat);
      expect(type('what was that'), LocalCommandType.repeat);
      expect(type('finish cooking'), LocalCommandType.finishCooking);
      expect(type("I'm done cooking"), LocalCommandType.finishCooking);
    });
  });

  test('other commands still work', () {
    expect(matcher.match('next')?.type, LocalCommandType.next);
    expect(matcher.match('go back')?.type, LocalCommandType.previous);
    expect(matcher.match('can I use butter instead'), isNull);
  });
}
