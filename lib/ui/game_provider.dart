import 'package:flutter/material.dart';
import 'package:speed_typer/notifiers/game_notifier.dart';

class GameProvider extends InheritedNotifier<GameNotifier> {
  const GameProvider({
    Key? key,
    required GameNotifier notifier,
    required Widget child,
  }) : super(key: key, child: child, notifier: notifier);

  static GameNotifier of(BuildContext context) {
    final GameNotifier? result = context.dependOnInheritedWidgetOfExactType<GameProvider>()?.notifier;
    assert(result != null, 'No GameNotifier found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(GameProvider oldWidget) => notifier != oldWidget.notifier;
}
