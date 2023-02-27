import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gd/commands/runner.dart';
import 'package:gd/platform_admin.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/terminal.dart';
import 'package:gd/ui/core_ui.dart';

void main(List<String> arguments) async {
  final ui = CoreUi();

  if (showVersion(arguments)) {
    ui.printCurrentVersion();
    return;
  }
  try {
    if (!await isAdministrator()) {
      ui.printAccessDenied();
      abort(2);
    }
    final app = AppService.instance;
    final runner = await createRunner(ui);

    await app.load();
    await runner.run(arguments);
  } on UnimplementedError {
    ui.printUnimplementedOperatingSystem();
    abort(1);
  } on UsageException catch (error) {
    stderr.writeln(error);
    abort(3);
  } catch (error) {
    stderr.writeln(error);
    abort(4);
  }
}

/// Abort program with error [code] and reset terminal ANSI escape sequences.
void abort(final int code) {
  stdout.write(Terminal.reset);
  stderr.write(Terminal.reset);
  exit(code);
}

/// Whether global option '--version' is parsed?
///
/// Returns true when version number has to be shown.
bool showVersion(final List<String> arguments) {
  final version = arguments.firstWhere((arg) => arg == "--version", orElse: () => "");

  return version.isNotEmpty;
}
