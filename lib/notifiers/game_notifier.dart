import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speed_typer/consts.dart';
import 'package:speed_typer/utils/words_loader.dart';

enum InputState {
  typing,
  error,
  valid
}

class GameNotifier extends ChangeNotifier {
  late DateTime _end;
  late StreamController<int?> _timerStream;
  late StreamSubscription _subscription;
  final random = Random();
  List<String> _words = [];

  // State
  String prompt = '';
  String input = '';
  int score = 0;
  bool isPlaying = false;
  int difficulty = initialDifficulty;
  InputState inputState = InputState.typing;

  // Getters
  Stream<int?> get timerStream => _timerStream.stream;

  GameNotifier() {
    _timerStream = StreamController<int?>();
    _subscription = Stream.periodic(const Duration(milliseconds: 100)).listen(_onPeriodicEvent);
  }

  void _onPeriodicEvent(event) {
    if (!isPlaying) {
      _timerStream.sink.add(null);
    } else {
      final ms = max(_end.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch, 0);
      if (ms <= 0) {
        stop();
      }
      _timerStream.sink.add(ms);
    }
  }

  void inputKey(String keyLabel) {
    if (isPlaying && inputState == InputState.typing) {
      input += keyLabel;
      notifyListeners();
      if (input.length == prompt.length) {
        score++;
        _end = _end.add(const Duration(milliseconds: increaseMsPerWord));
        inputState = InputState.typing;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          _pickRandomWord();
        });
      } else if (!prompt.startsWith(input)) {
        _end = _end.subtract(const Duration(milliseconds: increaseMsPerWord));
        inputState = InputState.error;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 500)).then((_) {
          _pickRandomWord();
        });
      }
    }
  }

  void start() async {
    if (!isPlaying) {
      _end = DateTime.now().add(const Duration(milliseconds: initialMs));
      final words = await loadWords('fr');
      _words = words;
      score = 0;
      isPlaying = true;
      _pickRandomWord();
    }
  }

  void stop() {
    if (isPlaying) {
      _end = DateTime.now();
      prompt = '';
      isPlaying = false;
      notifyListeners();
    }
  }

  void _pickRandomWord() {
    difficulty = initialDifficulty + (score / difficultyIncrease).floor();
    final availableWords = _words.where((word) => word.length == difficulty).toList();
    if (availableWords.isEmpty) {
      difficulty--;
    }
    prompt = availableWords[random.nextInt(availableWords.length)].toUpperCase().trim();
    input = '';
    inputState = InputState.typing;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _timerStream.close();
    super.dispose();
  }
}
