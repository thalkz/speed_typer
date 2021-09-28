import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:speed_typer/consts.dart';
import 'package:speed_typer/utils/normalizer.dart';
import 'package:speed_typer/utils/words_loader.dart';

enum InputState { typing, error, valid }

class GameNotifier extends ChangeNotifier {
  late DateTime _end;
  late StreamController<int> _timerStream;
  late StreamSubscription _subscription;
  final random = Random();
  int _maxWordLength = 0;
  List<String> _words = [];
  String _normalizedPrompt = '';
  String _normalizedInput = '';

  // State
  String prompt = '';
  String input = '';
  int score = 0;
  bool isPlaying = false;
  int difficulty = initialDifficulty;
  InputState inputState = InputState.typing;

  // Getters
  Stream<int> get timerStream => _timerStream.stream;

  GameNotifier() {
    _timerStream = StreamController.broadcast();
    _subscription = Stream.periodic(const Duration(milliseconds: 100)).listen(_onPeriodicEvent);
  }

  void _onPeriodicEvent(event) {
    if (!isPlaying) {
      _timerStream.sink.add(0);
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
      _normalizedInput = normalize(input);
      notifyListeners();
      if (!isCorrect) {
        inputState = InputState.error;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 400)).then((_) {
          _pickRandomWord();
        });
      } else if (input.length == prompt.length) {
        score++;
        _end = _end.add(const Duration(milliseconds: increaseMsPerWord));
        inputState = InputState.valid;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 200)).then((_) {
          _pickRandomWord();
        });
      }
    }
  }

  bool get isCorrect => _normalizedPrompt.startsWith(_normalizedInput);

  void start() async {
    if (!isPlaying) {
      _end = DateTime.now().add(const Duration(milliseconds: initialMs));
      _words = await loadWords('fr');
      _maxWordLength = _words.fold<int>(0, (previousValue, word) => max(previousValue, word.length));
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
    difficulty = min(initialDifficulty + (score / difficultyIncrease).floor(), _maxWordLength);
    final availableWords = _words.where((word) => word.length == difficulty).toList();
    prompt = availableWords[random.nextInt(availableWords.length)].toUpperCase().trim();
    _normalizedPrompt = normalize(prompt);
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
