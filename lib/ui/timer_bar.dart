import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speed_typer/notifiers/game_notifier.dart';

class TimerBar extends StatelessWidget {
  const TimerBar({
    Key? key,
    required this.timerStream,
    required this.inputState,
  }) : super(key: key);

  final Stream<int> timerStream;
  final InputState inputState;

  Color get color {
    switch (inputState) {
      case InputState.typing:
        return Colors.grey.shade600;
      case InputState.error:
        return Colors.red;
      case InputState.valid:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width / 1.5;
    return StreamBuilder<int?>(
      stream: timerStream,
      builder: (context, snap) {
        final ms = snap.data ?? 0;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          height: 1,
          width: min(50 * (ms / 1000.0), maxWidth),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color, width: 1),
          ),
        );
      },
    );
  }
}
