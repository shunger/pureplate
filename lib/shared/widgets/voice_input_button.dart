import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/providers/speech_providers.dart';
import '../../core/theme/app_colors.dart';

/// Spoken-word-to-digit mapping for numeric fields.
const _wordToDigit = <String, String>{
  'zero': '0',
  'one': '1',
  'two': '2',
  'three': '3',
  'four': '4',
  'five': '5',
  'six': '6',
  'seven': '7',
  'eight': '8',
  'nine': '9',
  'ten': '10',
};

/// Reusable mic button that streams speech-to-text into a [TextEditingController]
/// or fires an [onResult] callback.
///
/// **Dual-mode API**:
/// - Pass [controller] to append recognised text directly.
/// - Pass [onResult] to handle the final string yourself.
///
/// Set [isNumeric] to convert spoken number words ("five") into digits ("5").
class VoiceInputButton extends ConsumerStatefulWidget {
  const VoiceInputButton({
    super.key,
    this.controller,
    this.onResult,
    this.isNumeric = false,
    this.color,
    this.activeColor,
    this.iconSize = 20,
  }) : assert(controller != null || onResult != null,
            'Provide a controller or onResult callback');

  final TextEditingController? controller;
  final ValueChanged<String>? onResult;
  final bool isNumeric;
  final Color? color;
  final Color? activeColor;
  final double iconSize;

  @override
  ConsumerState<VoiceInputButton> createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends ConsumerState<VoiceInputButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    if (_listening) _stopListening();
    _pulse.dispose();
    super.dispose();
  }

  // ── Public tap handler ──────────────────────────────────────
  Future<void> _onTap() async {
    if (_listening) {
      _stopListening();
      return;
    }

    // Global lock check
    if (ref.read(isListeningProvider)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Another field is already using voice input'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final stt = ref.read(speechToTextProvider);
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    // Initialise (requests permission on first call)
    final available = await stt.initialize(
      onError: (_) => _stopListening(),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _stopListening();
        }
      },
    );

    if (!available) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Microphone access required'),
            content: const Text(
              'Please enable microphone and speech recognition '
              'permissions in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    // Acquire lock
    ref.read(isListeningProvider.notifier).state = true;
    setState(() => _listening = true);
    if (!reduceMotion) _pulse.repeat(reverse: true);

    stt.listen(
      onResult: (result) {
        final text = _processText(result.recognizedWords);
        if (widget.controller != null) {
          widget.controller!.text = text;
          widget.controller!.selection = TextSelection.fromPosition(
            TextPosition(offset: text.length),
          );
        }
        widget.onResult?.call(text);

        if (result.finalResult) {
          _stopListening();
        }
      },
      listenOptions: SpeechListenOptions(
        pauseFor: const Duration(seconds: 3),
        listenMode: ListenMode.dictation,
      ),
    );
  }

  void _stopListening() {
    final stt = ref.read(speechToTextProvider);
    stt.stop();
    _pulse.stop();
    _pulse.value = 0;
    if (mounted) setState(() => _listening = false);
    ref.read(isListeningProvider.notifier).state = false;
  }

  String _processText(String raw) {
    if (!widget.isNumeric) return raw;
    // Try to convert each word to a digit
    final words = raw.toLowerCase().split(RegExp(r'\s+'));
    final buffer = StringBuffer();
    for (final word in words) {
      final digit = _wordToDigit[word];
      if (digit != null) {
        buffer.write(digit);
      } else if (RegExp(r'^[\d.]+$').hasMatch(word)) {
        buffer.write(word);
      }
      // drop non-numeric non-digit words
    }
    final result = buffer.toString();
    return result.isEmpty ? raw : result;
  }

  @override
  Widget build(BuildContext context) {
    final defaultColor = widget.color ?? Theme.of(context).colorScheme.onSurfaceVariant;
    final activeClr = widget.activeColor ?? AppColors.coral;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return IconButton(
          onPressed: _onTap,
          icon: Icon(
            _listening ? Icons.mic : Icons.mic_none,
            size: widget.iconSize,
            color: _listening
                ? (reduceMotion
                    ? activeClr
                    : Color.lerp(activeClr.withValues(alpha: 0.4), activeClr, _pulse.value))
                : defaultColor,
          ),
          splashRadius: widget.iconSize,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: widget.iconSize + 16,
            minHeight: widget.iconSize + 16,
          ),
        );
      },
    );
  }
}
