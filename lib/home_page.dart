import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:speed_typer/words_loader.dart';

const int initialMs = 10000;
const int increaseMsPerWord = 1000;
const int lostMsPerWord = 500;
const int initialDifficulty = 4;
const int difficultyIncrease = 5;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FocusNode _node;
  late FocusAttachment _nodeAttachment;
  late DateTime _end;
  late StreamController<int?> _timerStream;
  late StreamSubscription _subscription;

  List<String> _words = [];
  String _current = '';
  String _written = '';
  int _score = 0;
  bool _isPlaying = false;
  int _difficulty = initialDifficulty;
  Color _timerColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _node = FocusNode(debugLabel: 'KeyboardListener');
    _node.addListener(_handleFocusChange);
    _nodeAttachment = _node.attach(context, onKey: _handleKeyPress);
    _timerStream = StreamController<int?>();
    _subscription = Stream.periodic(const Duration(milliseconds: 100)).listen((event) {
      if (!_isPlaying) {
        _timerStream.sink.add(null);
      } else {
        var ms = _end.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
        ms = max(ms, 0);
        if (ms == 0) {
          _gameOver();
        }
        _timerStream.sink.add(ms);
      }
    });
  }

  void _handleFocusChange() {
    debugPrint('hasFocus=${_node.hasFocus}');
  }

  KeyEventResult _handleKeyPress(FocusNode node, RawKeyEvent event) {
    debugPrint(event.logicalKey.keyLabel);
    if (event is RawKeyDownEvent && event.logicalKey.keyLabel.length == 1 && _isPlaying) {
      setState(() {
        _written += event.logicalKey.keyLabel;
      });
      if (_written.length == _current.length) {
        _updateScore();
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          _pickRandomWord();
        });
      }
      return KeyEventResult.handled;
    } else if (!_isPlaying && event.logicalKey.keyLabel == 'Enter') {
      _start();
    } else if (_isPlaying && event.logicalKey.keyLabel == 'Escape') {
      _gameOver();
    }
    return KeyEventResult.ignored;
  }

  void _updateScore() {
    if (_current == _written) {
      _score++;
      _end = _end.add(const Duration(milliseconds: increaseMsPerWord));
      _timerColor = Colors.green;
    } else {
      _end = _end.subtract(const Duration(milliseconds: increaseMsPerWord));
      _timerColor = Colors.red;
    }
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      _timerColor = Colors.black;
    });
  }

  void _pickRandomWord() {
    final random = Random();
    _difficulty = initialDifficulty + (_score / difficultyIncrease).floor();
    final availableWords = _words.where((word) => word.length == _difficulty).toList();
    if (availableWords.isEmpty) {
      _difficulty--;
    }
    setState(() {
      _current = availableWords[random.nextInt(availableWords.length)].toUpperCase().trim();
      _written = '';
      print(_current);
    });
  }

  void _start() async {
    _end = DateTime.now().add(const Duration(milliseconds: initialMs));
    final words = await loadWords('fr');
    _words = words;
    _score = 0;
    _isPlaying = true;
    _pickRandomWord();
  }

  void _gameOver() {
    setState(() {
      _current = '';
      _end = DateTime.now();
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    _node.requestFocus();
    return Scaffold(
      appBar: AppBar(
        title: _isPlaying ? Text('Score: $_score') : const Text('Speed Typer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<int?>(
              stream: _timerStream.stream,
              builder: (context, snap) {
                final ms = snap.data;
                if (ms == null) {
                  return Text('Ready ?', style: Theme.of(context).textTheme.headline3);
                } else if (ms == 0) {
                  return Text('GAME OVER', style: Theme.of(context).textTheme.headline3);
                } else {
                  return Text(
                    (ms / 1000.0).toStringAsFixed(1),
                    style: Theme.of(context).textTheme.headline3?.copyWith(color: _timerColor),
                  );
                }
              },
            ),
            if (!_isPlaying && _score != 0) Text('Score: $_score', style: Theme.of(context).textTheme.headline5),
            const SizedBox(height: 16),
            if (_isPlaying)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _current.length,
                  (index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _current[index].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    color: _written.length <= index
                        ? Colors.white
                        : _current[index] == _written[index]
                            ? Colors.green
                            : Colors.red,
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: _start,
                child: const Text('Start'),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _node.removeListener(_handleFocusChange);
    _node.dispose();
    _subscription.cancel();
    _timerStream.close();
    super.dispose();
  }
}
