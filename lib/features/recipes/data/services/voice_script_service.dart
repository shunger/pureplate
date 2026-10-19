import 'dart:convert';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/recipe.dart';
import 'spoken_text.dart';

/// One thing the voice assistant says, belonging to a written step.
class VoiceLine {
  /// Index into [Recipe.instructions] this line belongs to.
  final int stepIndex;
  final String text;

  const VoiceLine(this.stepIndex, this.text);

  @override
  String toString() => 'VoiceLine($stepIndex, $text)';
}

/// Builds the hands-free script for voice cooking: each written step broken
/// into short spoken actions, every ingredient with its amount, said one at a
/// time. The written steps on screen are unchanged.
///
/// The script comes from the `buildVoiceScript` Cloud Function and is cached
/// on the device per recipe. Any step it can't provide gets a local version.
class VoiceScriptService {
  /// Bump when the prompt changes so cached scripts are rebuilt.
  static const _version = 'v1';

  final FirebaseFunctions _functions;

  VoiceScriptService({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  /// The full script for [recipe], in order. Never throws.
  Future<List<VoiceLine>> load(Recipe recipe) async {
    final remote = await _cached(recipe) ?? await _fetch(recipe);
    return assemble(recipe, remote ?? const {});
  }

  /// Combines server lines (keyed by step number) with local fallback lines
  /// for any step the server didn't cover.
  @visibleForTesting
  static List<VoiceLine> assemble(
      Recipe recipe, Map<int, List<String>> remote) {
    final lines = <VoiceLine>[];
    for (var i = 0; i < recipe.instructions.length; i++) {
      final step = recipe.instructions[i];
      final spoken = remote[step.stepNumber]
              ?.map(SpokenText.forSpeech)
              .where((l) => l.isNotEmpty)
              .toList() ??
          const <String>[];
      final texts = spoken.isNotEmpty ? spoken : fallbackLines(recipe, i);
      lines.addAll(texts.map((t) => VoiceLine(i, t)));
    }
    return lines;
  }

  /// Local version of a step: one line per sentence, with the amounts of any
  /// ingredients the sentence mentions said right after it.
  @visibleForTesting
  static List<String> fallbackLines(Recipe recipe, int stepIndex) {
    final step = recipe.instructions[stepIndex];
    final sentences = SpokenText.forSpeech(step.instruction)
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty);

    final lines = <String>[];
    for (final sentence in sentences) {
      final lower = sentence.toLowerCase();
      final mentioned = recipe.ingredients.where((i) {
        final name = i.name.toLowerCase();
        if (lower.contains(name)) return true;
        // "heavy cream" is often just "the cream" in the steps.
        final last = name.split(RegExp(r'\s+')).last;
        return last.length > 3 &&
            RegExp('\\b${RegExp.escape(last)}\\b').hasMatch(lower);
      }).where((i) => (i.quantity ?? '').trim().isNotEmpty);

      final line = SpokenText.forSpeech(sentence);
      lines.add(mentioned.isEmpty || RegExp(r'\d').hasMatch(sentence)
          ? line
          : "$line That's ${SpokenText.joinNaturally(mentioned.map(SpokenText.ingredient).toList())}.");
    }
    final tip = step.tip?.trim();
    if (tip != null && tip.isNotEmpty) {
      lines.add('Quick tip: ${SpokenText.forSpeech(tip)}');
    }
    return lines.isEmpty ? [SpokenText.forSpeech(step.instruction)] : lines;
  }

  Future<Map<int, List<String>>?> _fetch(Recipe recipe) async {
    try {
      final result = await _functions
          .httpsCallable(
            'buildVoiceScript',
            options: HttpsCallableOptions(timeout: const Duration(seconds: 45)),
          )
          .call(_request(recipe))
          // Also bounds waiting for an App Check token, which the callable's
          // own timeout doesn't cover.
          .timeout(const Duration(seconds: 50));
      final steps = _parse(result.data);
      if (steps.isNotEmpty) await _store(recipe, result.data);
      return steps;
    } catch (e) {
      debugPrint('buildVoiceScript failed, using local script: $e');
      return null;
    }
  }

  static Map<String, dynamic> _request(Recipe recipe) => {
        'name': recipe.name,
        'ingredients': [
          for (final i in recipe.ingredients)
            {
              'name': i.name,
              'quantity': i.quantity ?? '',
              'unit': i.unit ?? '',
              'optional': i.optional,
            },
        ],
        'instructions': [
          for (final s in recipe.instructions)
            {
              'step_number': s.stepNumber,
              'instruction': (s.tip?.trim().isNotEmpty ?? false)
                  ? '${s.instruction} (Tip: ${s.tip!.trim()})'
                  : s.instruction,
            },
        ],
      };

  static Map<int, List<String>> _parse(dynamic data) {
    final out = <int, List<String>>{};
    final steps = data is Map ? data['steps'] : null;
    if (steps is! List) return out;
    for (final s in steps) {
      if (s is! Map) continue;
      final n = s['step_number'];
      final lines = s['lines'];
      if (n is! int || lines is! List) continue;
      out[n] = lines.whereType<String>().toList();
    }
    return out;
  }

  // ── Device cache, keyed by the recipe's content ─────────────────────

  Future<File?> _cacheFile(Recipe recipe) async {
    try {
      final base = await getApplicationCacheDirectory();
      final dir = await Directory('${base.path}/voice_scripts').create();
      final key = sha256
          .convert(utf8.encode('$_version|${jsonEncode(_request(recipe))}'))
          .toString();
      return File('${dir.path}/$key.json');
    } catch (_) {
      return null;
    }
  }

  Future<Map<int, List<String>>?> _cached(Recipe recipe) async {
    try {
      final file = await _cacheFile(recipe);
      if (file == null || !await file.exists()) return null;
      final steps = _parse(jsonDecode(await file.readAsString()));
      return steps.isEmpty ? null : steps;
    } catch (_) {
      return null;
    }
  }

  Future<void> _store(Recipe recipe, dynamic data) async {
    try {
      await (await _cacheFile(recipe))?.writeAsString(jsonEncode(data));
    } catch (_) {}
  }
}
