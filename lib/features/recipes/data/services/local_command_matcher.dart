/// Result of matching a voice command to a local action.
class LocalCommandResult {
  final LocalCommandType type;

  /// For [LocalCommandType.setTimer], how long; null when they asked for a
  /// timer without saying how long.
  final Duration? timerDuration;

  const LocalCommandResult(this.type, {this.timerDuration});
}

enum LocalCommandType {
  next,

  /// "Done", "I'm done", "okay": they finished what they were told. Moves on,
  /// or finishes cooking if that was the last thing to do.
  done,
  previous,
  repeat,
  readIngredients,
  whatStep,
  setTimer,
  stopTimer,
  timerStatus,
  finishCooking,
  help,
  pause,
}

/// Matches raw speech input to local on-device commands.
///
/// Returns a [LocalCommandResult] if the input matches a known command,
/// or `null` if it should be forwarded to the AI.
class LocalCommandMatcher {
  static const _ones = <String, int>{
    'zero': 0, 'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5,
    'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10, 'eleven': 11,
    'twelve': 12, 'thirteen': 13, 'fourteen': 14, 'fifteen': 15,
    'sixteen': 16, 'seventeen': 17, 'eighteen': 18, 'nineteen': 19,
  };

  static const _tens = <String, int>{
    'twenty': 20, 'thirty': 30, 'forty': 40, 'fifty': 50,
    'sixty': 60, 'seventy': 70, 'eighty': 80, 'ninety': 90,
  };

  static const _unitSeconds = <String, int>{
    'hour': 3600, 'hours': 3600, 'hr': 3600, 'hrs': 3600,
    'minute': 60, 'minutes': 60, 'min': 60, 'mins': 60,
    'second': 1, 'seconds': 1, 'sec': 1, 'secs': 1,
  };

  // "<amount> [and a half] <unit> [and a half]", e.g. "1 hour", "an hour and
  // a half", "1 and a half minutes", "2.5 min".
  static final _amountUnit = RegExp(
    r'(\d+(?:\.\d+)?|\ban?\b)(\s+and\s+a\s+half)?\s*'
    r'(hours?|hrs?|minutes?|mins?|seconds?|secs?)\b(\s+and\s+a\s+half)?',
  );

  /// How long a spoken duration is: "10 minutes", "an hour and 15 minutes",
  /// "half an hour", "twenty five minutes", "90 seconds". With
  /// [bareNumberIsMinutes], "ten" alone means ten minutes, which is what a
  /// cook means. Null if it names no duration. Capped at 24 hours.
  static Duration? parseDuration(String input,
      {bool bareNumberIsMinutes = false}) {
    var s = ' ${input.toLowerCase().replaceAll('-', ' ')} ';
    s = s
        .replaceAll(RegExp(r'\b(?:a\s+)?half\s+(?:an\s+)?hour\b'), ' 30 minutes ')
        .replaceAll(RegExp(r'\b(?:a\s+)?quarter\s+(?:of\s+)?(?:an\s+)?hour\b'),
            ' 15 minutes ')
        .replaceAll(RegExp(r'\bhalf\s+a\s+minute\b'), ' 30 seconds ')
        .replaceAll(RegExp(r'\ba\s+couple(?:\s+of)?\b'), ' 2 ')
        .replaceAll(RegExp(r'\ba\s+few\b'), ' 3 ');

    // Number words to digits: "twenty five" → "25".
    final words = s.trim().split(RegExp(r'\s+'));
    final out = <String>[];
    for (var i = 0; i < words.length; i++) {
      final w = words[i];
      final tens = _tens[w];
      if (tens != null) {
        final next = i + 1 < words.length ? _ones[words[i + 1]] : null;
        if (next != null && next > 0 && next < 10) {
          out.add('${tens + next}');
          i++;
        } else {
          out.add('$tens');
        }
      } else if (_ones.containsKey(w)) {
        out.add('${_ones[w]}');
      } else {
        out.add(w);
      }
    }

    final normalized = out.join(' ');
    var seconds = 0.0;
    for (final m in _amountUnit.allMatches(normalized)) {
      final amount = double.tryParse(m[1]!) ?? 1; // "a" / "an"
      final half = m[2] != null || m[4] != null ? 0.5 : 0.0;
      seconds += (amount + half) * _unitSeconds[m[3]]!;
    }
    if (seconds <= 0 && bareNumberIsMinutes) {
      final bare = RegExp(r'\b(\d+(?:\.\d+)?)\b').firstMatch(normalized);
      if (bare != null) seconds = double.parse(bare[1]!) * 60;
    }
    if (seconds <= 0) return null;
    return Duration(seconds: seconds.round().clamp(1, 24 * 3600));
  }

  LocalCommandResult? match(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return null;

    // Timers come first: "set a timer for the next step" is a timer.
    if (lower.contains('timer') || lower.startsWith('remind me')) {
      if (_matches(lower, ['stop', 'cancel', 'clear', 'turn off', 'end the'])) {
        return const LocalCommandResult(LocalCommandType.stopTimer);
      }
      if (_matches(lower, ['how long', 'how much', 'time left', 'left on'])) {
        return const LocalCommandResult(LocalCommandType.timerStatus);
      }
      return LocalCommandResult(
        LocalCommandType.setTimer,
        timerDuration: parseDuration(lower, bareNumberIsMinutes: true),
      );
    }

    // Repeat / re-read. Checked before "next" so "what do I do first"
    // doesn't move on.
    if (_matches(lower, [
      'repeat', 'say again', 'read again', 'say that again', 'what was that',
      'come again', 'what did you say', 'what do i do first',
    ])) {
      return const LocalCommandResult(LocalCommandType.repeat);
    }

    // Navigation
    if (_matches(lower, [
      'next', 'move on', 'continue', 'what now', 'now what',
      'what do i do now', "what's after", 'go on',
    ])) {
      return const LocalCommandResult(LocalCommandType.next);
    }
    if (_matches(lower, ['previous step', 'previous', 'go back', 'back', 'last step'])) {
      return const LocalCommandResult(LocalCommandType.previous);
    }

    // Finish. Only explicit phrases: a plain "I'm done" mid-recipe means
    // that action is done (handled above), not the whole meal.
    if (_matches(lower, [
      'finish cooking', 'done cooking', 'finished cooking', "we're finished",
      'end cooking',
    ])) {
      return const LocalCommandResult(LocalCommandType.finishCooking);
    }

    // Finished what they were told: "done", "ready", "it's in", "okay".
    // Whole words only, so "already" isn't "ready"; "is it done?" is a
    // question for the AI, not a command.
    if ((_finishedThat.hasMatch(lower) && !_isQuestion(lower)) ||
        _justAcknowledging(lower)) {
      return const LocalCommandResult(LocalCommandType.done);
    }

    // Ingredients
    if (_matches(lower, ['ingredients', 'what do i need', 'ingredient list'])) {
      return const LocalCommandResult(LocalCommandType.readIngredients);
    }

    // Current step
    if (_matches(lower, ['what step', 'where am i', 'current step'])) {
      return const LocalCommandResult(LocalCommandType.whatStep);
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

  static final _finishedThat = RegExp(
    r"\b(done|ready|finished|all set|did (it|that)|it'?s in|it'?s on|"
    r"added( it)?|prepped|that'?s (done|in))\b",
  );

  static final _ack = RegExp(
    r"^(ok(ay)?|alright|all right|got it|yes|yeah|yep|sure|mm+ ?hmm|uh huh)\b",
  );

  static final _questionWord = RegExp(
    r"\b(how|what|why|when|where|which|who|can|could|should|would|will|"
    r"do|does|is|are)\b",
  );

  bool _isQuestion(String lower) =>
      lower.contains('?') || _questionWord.hasMatch(lower);

  /// "Okay", "got it", "okay that's chopped": acknowledging, not asking.
  bool _justAcknowledging(String lower) =>
      _ack.hasMatch(lower) && !_isQuestion(lower);

  /// Returns true if [input] contains any of the [phrases].
  bool _matches(String input, List<String> phrases) {
    return phrases.any((phrase) => input.contains(phrase));
  }
}
