import 'dart:io';

import 'package:gd/extensions/string_utils.dart';
import 'package:gd/services/gdtemplate_service.dart';

/// View-like class to print common information when generating a GDTemplate.
class GDTemplateUi {
  void printDirectoryExists() {
    stderr.writeln("${"[X]".red} Directory already exists");
    stderr.writeln("    ${"·".blue} ${"Make sure to choose an empty path to create a new GDExtension.".bold}");
  }

  void printWriteFileFailure(final WriteFileFailure error) {
    stderr.writeln("${"[X]".red} Failed to write in file (${error.file.path})");
  }

  void printDeclarationGenerated(final String libraryName) {
    print("${"[√]".green} GDExtension generated ($libraryName)");
  }

  void printClassGenerated(final String className) {
    print("${"[√]".green} Class generated ($className)");
  }
}
