import 'package:gd/terminal.dart';

extension StringUtils on String {
  String get black => _color(TermColor.black);
  String get red => _color(TermColor.red);
  String get green => _color(TermColor.green);
  String get yellow => _color(TermColor.yellow);
  String get blue => _color(TermColor.blue);
  String get purple => _color(TermColor.purple);
  String get cyan => _color(TermColor.cyan);
  String get grey => _color(TermColor.grey);

  String get bold => Terminal.bold(this);

  String _color(final int c) {
    return Terminal.text(c, this);
  }
}
