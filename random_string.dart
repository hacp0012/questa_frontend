// ignore_for_file: avoid_print

import 'package:random_string/random_string.dart';

void main(List<String> args) {
  String string = randomAlphaNumeric(int.tryParse(args.firstOrNull ?? '9') ?? 9);

  print(">>> $string");
}
