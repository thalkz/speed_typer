import 'package:flutter/material.dart';

class WordPrompt extends StatelessWidget {
  const WordPrompt({
    Key? key,
    required this.prompt,
    required this.inputLength,
    required this.isCorrect,
  }) : super(key: key);

  final String prompt;
  final int inputLength;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        prompt.length,
        (index) => Padding(
          padding: const EdgeInsets.all(1.0),
          child: LetterPrompt(
            key: Key('letter-$index'),
            letter: prompt[index],
            isCorrect: inputLength <= index ? null : isCorrect,
          ),
        ),
      ),
    );
  }
}

class LetterPrompt extends StatelessWidget {
  const LetterPrompt({
    Key? key,
    required this.letter,
    this.isCorrect,
  }) : super(key: key);

  final String letter;
  final bool? isCorrect; // null for not typed yet

  Color get color {
    if (isCorrect == null) {
      return Colors.grey.shade800;
    } else if (isCorrect == true) {
      return Colors.green;
    } else {
      return Colors.red.shade300;
    }
  }

  Color get borderColor {
    if (isCorrect == null) {
      return Colors.grey.shade600;
    } else if (isCorrect == true) {
      return Colors.greenAccent;
    } else {
      return Colors.red;
    }
  }

  EdgeInsets get padding {
    if (isCorrect == null) {
      return const EdgeInsets.all(8.0);
    } else {
      return const EdgeInsets.all(12.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (letter == ' ') {
      return const SizedBox(width: 16);
    } else {
      return AnimatedContainer(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
        ),
        duration: const Duration(milliseconds: 100),
        padding: padding,
        child: Text(
          letter.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    }
  }
}
