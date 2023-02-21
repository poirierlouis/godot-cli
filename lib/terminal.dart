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

/// Provides common functions to use ANSI escape sequences.
class Terminal {
  static final String _loaders = "⣷⣯⣟⡿⢿⣻⣽⣾";

  static String get hideCursor => "\x1B[?25l";
  static String get showCursor => "\x1B[?25h";

  static String get endAll => "\x1B[0m";
  static String get startOfLine => "\x1B[0F";
  static String get previousLine => "\x1B[1F";
  static String get clearLine => "\x1B[2K";

  /// Clears [lines] from terminal, positioning the cursor at the beginning of the line.
  static void clearLines(final int lines) {
    String sequences = startOfLine;

    for (int i = 0; i < lines; i++) {
      sequences += "$clearLine$previousLine";
    }
    print(sequences);
  }

  /// Prints an infinite loader with [text] while [task] is executed.
  ///
  /// Returns result of [task] upon completion or `rethrow` when task throws an error.
  ///
  /// Optionally prints [padding] before loader's indicator.
  static Future<T> showInfiniteLoader<T>(
    final String text, {
    final String padding = "",
    required final Future<T> task,
  }) async {
    final Completer<void> completer = Completer();
    int i = 0;

    stdout.write(hideCursor);
    final loader = Future.doWhile(() async {
      String loader = _loaders[i];

      stdout.write("\r$padding ${loader.blue}  $text");
      await Future.delayed(const Duration(milliseconds: 200));
      i++;
      i %= _loaders.length;
      return !completer.isCompleted;
    });

    try {
      final result = await task;

      completer.complete();
      await loader;
      print(showCursor);
      return result;
    } catch (_) {
      completer.complete();
      await loader;
      print(showCursor);
      rethrow;
    }
  }

  /// Prints [text] and waits for user's input, accepting only [yes] or [no].
  ///
  /// Returns true when user's input equals [yes].
  static bool promptQuestion(final String text, {final String yes = "Y", final String no = "n"}) {
    stdout.write("$text ");
    String? answer = stdin.readLineSync(encoding: utf8);

    answer ??= no;
    return answer == yes;
  }

  /// Prints [text] with [color]. Resets any Select Graphic Rendition sequences.
  static String text(final int color, final String text) {
    final startColor = "\x1B[${color}m";

    return "$startColor$text$endAll";
  }

  /// Prints [text] in bold. Resets any Select Graphic Rendition sequences.
  static String bold(final String text) {
    final startBold = "\x1B[1m";

    return "$startBold$text$endAll";
  }
}
