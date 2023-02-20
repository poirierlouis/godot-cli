import 'dart:io';

import 'package:gd/commands/doctor_command.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/sem_ver.dart';

/// View-like class to print common information about the status of a [DoctorProgram].
class DoctorUi {
  DoctorProgram? _program;

  String get programTitle => _program?.programTitle ?? "<unknown>";
  String get installUrl => _program?.installUrl ?? "";
  List<String> get installHelp => _program?.installHelp ?? [];

  void withProgram(final DoctorProgram program) {
    _program = program;
  }

  void printNotFound() {
    stderr.writeln("${"[X]".red} $programTitle (Program not found)");
  }

  void printInstallHelp() {
    print("    ${"·".red} ${"Install $programTitle manually from $installUrl.".bold}");
    print("    ${"·".red} ${"You might need to add path to the binary in your PATH environment variable.".bold}");
    for (final help in installHelp) {
      print("    ${"·".red} ${help.bold}");
    }
  }

  void printMissingSemVer() {
    print("${"[!]".yellow} $programTitle (Unknown version)");
  }

  void printRequiredVersion(final SemVer version, final SemVer requiredVersion) {
    stderr.writeln("${"[X]".red} $programTitle ($version)");
    stderr.writeln("    ${"·".red} ${"Requires v$requiredVersion or higher, please update manually.".bold}");
  }

  void printDetected(final SemVer version) {
    print("${"[√]".green} $programTitle ($version)");
  }
}
