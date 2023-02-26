import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gd/commands/runner.dart';
import 'package:gd/platform_admin.dart';
import 'package:gd/services/app_service.dart';
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
      exit(2);
    }
    final configService = AppService.instance;
    final runner = await createRunner(ui);

    await configService.load();
    await runner.run(arguments);
  } on UnimplementedError {
    ui.printUnimplementedOperatingSystem();
    exit(1);
  } on UsageException catch (error) {
    stderr.writeln(error);
    exit(2);
  } catch (error) {
    stderr.writeln(error);
    exit(3);
  }
}

/// Whether global option '--version' is parsed?
///
/// Returns true when version number has to be shown.
bool showVersion(final List<String> arguments) {
  final version = arguments.firstWhere((arg) => arg == "--version", orElse: () => "");

  return version.isNotEmpty;
}
