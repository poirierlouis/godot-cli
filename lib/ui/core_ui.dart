import 'dart:io';

import 'package:gd/extensions/string_utils.dart';
import 'package:gd/platform_version.dart';

/// View-like class to print common information throughout the application.
class CoreUi {
  void printUnimplementedOperatingSystem() {
    stderr.writeln("${"[X]".red} Operating System (unimplemented)");
    stderr.writeln("    ${"·".blue} ${"There is currently no support for your Operating System.".bold}");
    stderr.writeln("    ${"·".blue} ${"Feel free to contribute at https://github.com/poirierlouis/godot-cli.".bold}");
  }

  void printCurrentVersion() {
    print("godot-cli version $packageVersion");
  }

  void printFirstRun() {
    print("${"[!]".yellow} Command denied");
    print("    ${"·".yellow} ${"Please run 'doctor' first.".bold}");
  }

  void printNeedFix() {
    print("${"[!]".yellow} Issues detected");
    print("    ${"·".yellow} ${"Please fix all issues with 'doctor'.".bold}");
  }
}
