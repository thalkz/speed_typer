import 'package:flutter/material.dart';

class WordPrompt extends StatelessWidget {
  const WordPrompt({
    Key? key,
    required String prompt,
    required String input,
  })  : _current = prompt,
        _written = input,
        super(key: key);

  final String _current;
  final String _written;

  Color _letterColor(int index) {
    if (_written.length <= index) {
      return Colors.white;
    } else if (_current[index] == _written[index]) {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
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
          color: _letterColor(index),
        ),
      ),
    );
  }
}
