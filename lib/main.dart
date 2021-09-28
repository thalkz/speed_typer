import 'package:flutter/material.dart';
import 'package:speed_typer/notifiers/game_notifier.dart';
import 'package:speed_typer/ui/game_provider.dart';
import 'package:speed_typer/ui/game_page.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameProvider(
      notifier: GameNotifier(),
      child: MaterialApp(
        title: 'Speed Typer',
        theme: ThemeData.dark(),
        home: const GamePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
