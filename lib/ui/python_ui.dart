import 'dart:io';

import 'package:gd/extensions/string_utils.dart';
import 'package:gd/sem_ver.dart';
import 'package:gd/services/python_service.dart';

class PythonUi {
  String packageTitle = "<unknown>";

  void withPackage(PythonPackage package) {
    packageTitle = package.packageTitle;
  }

  void printNotFound() {
    stderr.writeln("    ${"[X]".red} $packageTitle (Package not found)");
  }

  String detecting() {
    return "$packageTitle (Detecting)";
  }

  String checkingUpdate() {
    return "$packageTitle (Checking for update)";
  }

  String updating() {
    return "$packageTitle (Updating)";
  }

  String installing() {
    return "$packageTitle (Installing)";
  }

  void printInstallFailure(final PackageInstallFailure error) {
    stderr.writeln("    ${"[X]".red} $packageTitle (Installation failed)");
    stderr.writeln(error);
  }

  void printUpdateFailure(final PackageUpdateFailure error) {
    stderr.writeln("    ${"[X]".red} $packageTitle (Update failed)");
    stderr.writeln(error);
  }

  void printMissingSemVer() {
    print("    ${"[!]".yellow} $packageTitle (Unknown version)");
  }

  void printRequiredVersion(final SemVer version, final SemVer requiredVersion) {
    stderr.writeln("    ${"[X]".red} $packageTitle ($version)");
    stderr.writeln("        ${"·".red} ${"Requires v$requiredVersion or higher, please update manually.".bold}");
  }

  void printDetected(final SemVer version) {
    print("    ${"[√]".green} $packageTitle ($version)");
  }

  void printInstalled() {
    print("    ${"[√]".green} $packageTitle (Installed)");
  }

  void printUpdated() {
    print("    ${"[√]".green} $packageTitle (Updated)");
  }
}
