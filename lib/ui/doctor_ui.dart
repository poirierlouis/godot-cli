import 'dart:io';

import 'package:gd/commands/doctor_command.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/platform_flavor.dart';
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

  void printAccessDenied() {
    String roleHint = "(as Administrator)";

    if (Platform.isLinux || Platform.isMacOS) {
      roleHint = "(as root)";
    }
    stderr.writeln("${"[X]".red} Access denied");
    stderr.writeln("    ${"·".red} ${"You must run this command using elevated privileges $roleHint.".bold}");
  }

  void printNotFound() {
    stderr.writeln("${"[X]".red} $programTitle (Program not found)");
  }

  void printInstallHelp() {
    stderr.writeln("    ${"·".red} ${"Install $programTitle manually from $installUrl.".bold}");
    stderr.writeln(
        "    ${"·".red} ${"You might need to add path to the binary in your PATH environment variable.".bold}");
    stderr.writeln("    ${"·".red} ${"Or you can use \"gd config\" to configure a custom path.".bold}");
    for (final help in installHelp) {
      stderr.writeln("    ${"·".red} ${help.bold}");
    }
  }

  void printMissingSemVer() {
    print("${"[!]".yellow} $programTitle (Unknown version)");
  }

  void printRequiredVersion(final SemVer version, final SemVer requiredVersion) {
    stderr.writeln("${"[X]".red} $programTitle ($version)");
    stderr.writeln("    ${"·".red} ${"Requires v$requiredVersion or higher, please update manually.".bold}");
  }

  void printFixPath(final String path) {
    stderr.writeln("    ${"·".red} ${"Note that a custom path is set ($path).".bold}");
  }

  void printDetected(final SemVer version) {
    print("${"[√]".green} $programTitle ($version)");
  }

  void printHomeEnvDisclaimer(final String appDataPath) {
    print("${"[!]".yellow} Environment variable");
    print("    ${"·".yellow} ${"Instructions below allows you to work with Git when creating a GDExtension.".bold}");
    print("    ${"·".yellow} ${"Add following environment variable on your system:".bold}");
    print("    ${"·".yellow} ${"$kHome: $appDataPath".bold}");
    print("    ${"·".yellow} ${"Make sure to re-run command 'doctor' after restarting your terminal / IDE.".bold}");
  }

  void printHomeEnvNotFound(final String appDataPath) {
    stderr.writeln("${"[X]".red} Missing environment variable");
    stderr.writeln("    ${"·".red} ${"Add following environment variable on your system:".bold}");
    stderr.writeln("    ${"·".red} ${"$kHome: $appDataPath".bold}");
    stderr
        .writeln("    ${"·".red} ${"Make sure to re-run command 'doctor' after restarting your terminal / IDE.".bold}");
  }

  void printWrongHomeEnv(final String appDataPath) {
    stderr.writeln("${"[X]".red} Wrong environment variable");
    stderr.writeln("    ${"·".red} ${"Value of $kHome must be:".bold}");
    stderr.writeln("    ${"·".red} ${appDataPath.bold}");
  }

  void printHomeEnvDetected(final String appDataPath) {
    print("${"[√]".green} Environment variable ($kHome)");
  }
}
