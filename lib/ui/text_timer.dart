import 'package:flutter/material.dart';
import 'package:speed_typer/notifiers/game_notifier.dart';

class TimerText extends StatelessWidget {
  const TimerText({
    Key? key,
    required this.timerStream,
    required this.inputState,
  }) : super(key: key);

  final Stream<int?> timerStream;
  final InputState inputState;

  Color get color {
    switch (inputState) {
      case InputState.typing:
        return Colors.black;
      case InputState.error:
        return Colors.red;
      case InputState.valid:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: timerStream,
      builder: (context, snap) {
        final ms = snap.data ?? 0;
        return Text(
          (ms / 1000.0).toStringAsFixed(1),
          style: Theme.of(context).textTheme.headline3?.copyWith(color: color),
        );
      },
    );
  }
}
