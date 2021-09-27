import 'package:flutter/material.dart';
import 'package:speed_typer/ui/game_provider.dart';
import 'package:speed_typer/ui/keyboard_listener.dart';
import 'package:speed_typer/ui/text_timer.dart';
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
        appBar: AppBar(
          title: notifier.isPlaying ? Text('Score: ${notifier.score}') : const Text('Speed Typer'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TimerText(
                timerStream: notifier.timerStream,
                inputState: notifier.inputState,
              ),
              if (!notifier.isPlaying && notifier.score != 0)
                Text(
                  'Score: ${notifier.score}',
                  style: Theme.of(context).textTheme.headline5,
                ),
              const SizedBox(height: 16),
              if (notifier.isPlaying)
                WordPrompt(prompt: notifier.prompt, input: notifier.input)
              else
                ElevatedButton(
                  onPressed: notifier.start,
                  child: const Text('Start'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
