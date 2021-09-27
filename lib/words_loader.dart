import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<List<String>> loadWords(String langcode) async {
  final file = await rootBundle.loadString('res/$langcode.txt');
  return file.split('\n');
}
