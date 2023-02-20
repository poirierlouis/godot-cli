import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gd/commands/windows/windows_runner.dart';
import 'package:gd/ui/core_ui.dart';

Future<CommandRunner> createRunner(final CoreUi ui) {
  final runner = CommandRunner(
    "gd",
    "A command line tool to setup your environment with Godot sources and GDExtension (v4+).",
    usageLineLength: 80,
    suggestionDistanceLimit: 1,
  );

  if (Platform.isWindows) {
    return createWindowsRunner(ui, runner);
  }
  throw UnimplementedError();
}
