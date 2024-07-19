import 'package:flutter/material.dart';
import 'package:speed_typer/notifiers/game_notifier.dart';
import 'package:speed_typer/ui/game_provider.dart';
import 'package:speed_typer/ui/keyboard_listener.dart';
import 'package:speed_typer/ui/shake_animation.dart';
import 'package:speed_typer/ui/timer_bar.dart';
import 'package:speed_typer/ui/timer_text.dart';
import 'package:speed_typer/ui/word_prompt.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = GameProvider.of(context);
    return PlayerKeyboardListener(
      onInputKey: (String key) => notifier.inputKey(key),
      onStart: () => notifier.start(),
      onStop: () => notifier.stop(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: notifier.isPlaying ? const PlayScreen() : const MenuScreen(),
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = GameProvider.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const WordPrompt(
            prompt: 'Speed Typer',
            inputLength: 0,
            isCorrect: true,
          ),
          const SizedBox(height: 16),
          if (notifier.score != 0) ...[
            Text(
              'Score: ${notifier.score}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
          ],
          Text(
            '— Press Enter to start —',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = GameProvider.of(context);

    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Score: ${notifier.score}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TimerText(
              timerStream: notifier.timerStream,
              inputState: notifier.inputState,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        Center(
          child: ShakeAnimation(
            isShaking: notifier.inputState == InputState.error,
            shakeDistance: 8,
            shakeSpeed: const Duration(milliseconds: 50),
            child: WordPrompt(
              prompt: notifier.prompt,
              inputLength: notifier.input.length,
              isCorrect: notifier.isCorrect,
            ),
          ),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, 50),
            child: TimerBar(
              timerStream: notifier.timerStream,
              inputState: notifier.inputState,
            ),
          ),
        ),
      ],
    );
  }
}
