import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gd/extensions/string_utils.dart';

class TermColor {
  static int black = 30;
  static int red = 31;
  static int green = 32;
  static int yellow = 33;
  static int blue = 34;
  static int purple = 35;
  static int cyan = 36;
  static int grey = 37;
}

class Terminal {
  static final String _loaders = "⣷⣯⣟⡿⢿⣻⣽⣾";

  static String get hideCursor => "\x1B[?25l";
  static String get showCursor => "\x1B[?25h";

  static String get hideBlinking => "\x1B[?12l";
  static String get showBlinking => "\x1B[?12h";

  static String get endAll => "\x1B[0m";
  static String get startOfLine => "\x1B[0F";
  static String get previousLine => "\x1B[1F";
  static String get clearEndOfLine => "\x1B[0K";
  static String get clearStartOfLine => "\x1B[1K";
  static String get clearLine => "\x1B[2K";

  static String moveCursorUp(final int cells) => "\x1B[${cells}A";
  static String moveCursorDown(final int cells) => "\x1B[${cells}B";
  static String moveCursorForward(final int cells) => "\x1B[${cells}C";
  static String moveCursorBack(final int cells) => "\x1B[${cells}D";

  static void clearLines(final int lines) {
    String sequences = startOfLine;

    for (int i = 0; i < lines; i++) {
      sequences += "$clearLine$previousLine";
    }
    print(sequences);
  }

  static void showInfiniteLoader(Completer<void> task, String? text, [String? padding = ""]) {
    int i = 0;

    text ??= "";
    padding ??= "";
    print("$padding ${_loaders[0].blue}  $text$hideCursor");
    Future.doWhile(() async {
      String loader = _loaders[i];

      print("$startOfLine$padding ${loader.blue}");
      await Future.delayed(const Duration(milliseconds: 200));
      i++;
      i %= _loaders.length;
      return !task.isCompleted;
    });
    print("$showCursor$previousLine");
  }

  static bool promptQuestion(final String text, {final String yes = "Y", final String no = "n"}) {
    stdout.write("$text ");
    String? answer = stdin.readLineSync(encoding: utf8);

    answer ??= no;
    return answer == yes;
  }

  static String text(final int color, final String text) {
    final startColor = "\x1B[${color}m";

    return "$startColor$text$endAll";
  }

  static String bold(final String text) {
    final startBold = "\x1B[1m";

    return "$startBold$text$endAll";
  }
}
