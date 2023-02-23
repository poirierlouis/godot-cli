import 'dart:io';

import 'package:gd/commands/install_command.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/services/git_service.dart';
import 'package:gd/services/scons_service.dart';

/// View-like class to print common information when installing and building sources.
class InstallUi {
  Repository? _repository;

  String get name => _repository?.domain ?? "<unknown>";

  void withRepository(final Repository repository) {
    _repository = repository;
  }

  String cloning() {
    return "Cloning ($name)";
  }

  String checkingStatus() {
    return "Checking status ($name)";
  }

  String restoring() {
    return "Restoring working tree ($name)";
  }

  String pulling() {
    return "Pulling ($name)";
  }

  String checkingOut() {
    return "Checking out ($name)";
  }

  String searching() {
    return "Searching commit ($name)";
  }

  String building() {
    return "Building ($name)";
  }

  void printCloned() {
    print("${"[√]".green} Cloned ($name)");
  }

  void printCheckedStatus() {
    print("${"[√]".green} Status checked ($name)");
  }

  void printRestored() {
    print("${"[√]".green} Restored ($name)");
  }

  void printPulled() {
    print("${"[√]".green} Pulled ($name)");
  }

  void printCheckedOut() {
    print("${"[√]".green} Checked out ($name)");
  }

  void printBuilt() {
    print("${"[√]".green} Built ($name)");
  }

  void printIgnored() {
    print("${"[√]".green} Ignored ($name)");
  }

  void printCloningFailure(final GitCloneFailure error) {
    stderr.writeln("${"[X]".red} Cloning ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to clone repository:".bold}");
    stderr.writeln(error.stderr);
  }

  void printRestoringFailure(final GitRestoreFailure error) {
    stderr.writeln("${"[X]".red} Restoring ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to restore working tree of repository:".bold}");
    stderr.writeln(error.stderr);
  }

  void printPullingFailure(final GitPullFailure error) {
    stderr.writeln("${"[X]".red} Pulling ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to pull repository:".bold}");
    stderr.writeln(error.stderr);
  }

  void printCheckingOutFailure(final String commit, final GitCheckoutFailure error) {
    stderr.writeln("${"[X]".red} Checking out ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to checkout repository ($commit):".bold}");
    stderr.writeln(error.stderr);
  }

  void printBuildingFailure(final BuildFailure error) {
    stderr.writeln("${"[X]".red} Building ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to build with 'target=${error.target}':".bold}");
    stderr.writeln(error.stderr);
  }

  void printCommitNotFound(final String commit) {
    stderr.writeln("${"[X]".red} Searching commit ($name)");
    stderr.writeln("    ${"·".red} ${"Failed to find synchronous upstream commit ($commit).".bold}");
  }
}
