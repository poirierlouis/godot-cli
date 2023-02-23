import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:gd/commands/runner.dart';
import 'package:gd/platform_admin.dart';
import 'package:gd/platform_version.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/ui/core_ui.dart';

void main(List<String> arguments) async {
  final ui = CoreUi();

  try {
    if (showVersion(arguments)) {
      return;
    }
    await isAdministrator();
    final configService = AppService.instance;
    final runner = await createRunner(ui);

    await configService.load();
    await runner.run(arguments);
  } on UnimplementedError {
    ui.printUnimplementedOperatingSystem();
    exit(1);
  } on AdministratorAccessDenied {
    ui.printAccessDenied();
    exit(2);
  } on UsageException catch (error) {
    stderr.writeln(error);
    exit(3);
  } catch (error) {
    stderr.writeln(error);
    exit(4);
  }
}

/// Show version number of this tool when global option '--version' is parsed.
///
/// Returns true when version number is showed.
bool showVersion(final List<String> arguments) {
  final version = arguments.firstWhere((arg) => arg == "--version", orElse: () => "");

  if (version.isEmpty) {
    return false;
  }
  print("godot-cli version $packageVersion");
  return true;
}
