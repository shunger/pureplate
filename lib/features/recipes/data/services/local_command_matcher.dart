/// Result of matching a voice command to a local action.
class LocalCommandResult {
  final LocalCommandType type;

  /// For [LocalCommandType.setTimer], the number of minutes.
  final int? timerMinutes;

  const LocalCommandResult(this.type, {this.timerMinutes});
}

enum LocalCommandType {
  next,
  previous,
  repeat,
  readIngredients,
  whatStep,
  setTimer,
  stopTimer,
  finishCooking,
  help,
  pause,
}

/// Matches raw speech input to local on-device commands.
///
/// Returns a [LocalCommandResult] if the input matches a known command,
/// or `null` if it should be forwarded to the AI.
class LocalCommandMatcher {
  // Matches: "set timer for 5 minutes", "set a timer for 10 min",
  // "timer 5 minutes", "set timer for five minutes", etc.
  static final _timerDigitRegex = RegExp(
    r'(?:set\s+(?:a\s+)?timer\s+(?:for\s+)?|timer\s+(?:for\s+)?)(\d+)\s*min',
    caseSensitive: false,
  );

  // Matches spoken number words: "set timer for five minutes"
  static final _timerWordRegex = RegExp(
    r'(?:set\s+(?:a\s+)?timer\s+(?:for\s+)?|timer\s+(?:for\s+)?)'
    r'(one|two|three|four|five|six|seven|eight|nine|ten|'
    r'eleven|twelve|thirteen|fourteen|fifteen|twenty|thirty|forty|fifty)\s*min',
    caseSensitive: false,
  );

  static const _wordToNumber = <String, int>{
    'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
    'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
    'eleven': 11, 'twelve': 12, 'thirteen': 13, 'fourteen': 14,
    'fifteen': 15, 'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50,
  };

  LocalCommandResult? match(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return null;

    // Timer (check regex first since it's more specific).
    final timerDigitMatch = _timerDigitRegex.firstMatch(lower);
    if (timerDigitMatch != null) {
      final minutes = int.tryParse(timerDigitMatch.group(1)!);
      if (minutes != null && minutes > 0) {
        return LocalCommandResult(
          LocalCommandType.setTimer,
          timerMinutes: minutes,
        );
      }
    }
    final timerWordMatch = _timerWordRegex.firstMatch(lower);
    if (timerWordMatch != null) {
      final minutes = _wordToNumber[timerWordMatch.group(1)!.toLowerCase()];
      if (minutes != null && minutes > 0) {
        return LocalCommandResult(
          LocalCommandType.setTimer,
          timerMinutes: minutes,
        );
      }
    }

    // Navigation
    if (_matches(lower, ['next step', 'next', 'move on', 'continue'])) {
      return const LocalCommandResult(LocalCommandType.next);
    }
    if (_matches(lower, ['previous step', 'previous', 'go back', 'back', 'last step'])) {
      return const LocalCommandResult(LocalCommandType.previous);
    }

    // Repeat / re-read
    if (_matches(lower, ['repeat', 'say again', 'read again', 'say that again'])) {
      return const LocalCommandResult(LocalCommandType.repeat);
    }

    // Ingredients
    if (_matches(lower, ['ingredients', 'what do i need', 'ingredient list'])) {
      return const LocalCommandResult(LocalCommandType.readIngredients);
    }

    // Current step
    if (_matches(lower, ['what step', 'where am i', 'current step'])) {
      return const LocalCommandResult(LocalCommandType.whatStep);
    }

    // Timer stop
    if (_matches(lower, ['stop timer', 'cancel timer', 'stop the timer'])) {
      return const LocalCommandResult(LocalCommandType.stopTimer);
    }

    // Finish
    if (_matches(lower, ["i'm done", 'finish cooking', 'all done', "i am done", 'done cooking'])) {
      return const LocalCommandResult(LocalCommandType.finishCooking);
    }

    // Help
    if (lower == 'help' || lower == 'what can i say') {
      return const LocalCommandResult(LocalCommandType.help);
    }

    // Pause
    if (_matches(lower, ['pause', 'stop listening', 'stop'])) {
      return const LocalCommandResult(LocalCommandType.pause);
    }

    return null;
  }

  /// Returns true if [input] contains any of the [phrases].
  bool _matches(String input, List<String> phrases) {
    return phrases.any((phrase) => input.contains(phrase));
  }
}
