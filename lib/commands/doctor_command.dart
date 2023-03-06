import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/platform_flavor.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:gd/ui/doctor_ui.dart';

/// Entry of an executable program to detect and analyze.
class DoctorProgram {
  DoctorProgram({
    required this.programTitle,
    required this.service,
    required this.installUrl,
    this.installHelp,
    this.delegate,
  });

  /// Name of program used in UI.
  final String programTitle;

  /// Service implementation to detect this program.
  final DetectService service;

  /// Url link where to look for to install this program (OS dependent).
  final String installUrl;

  /// Optional list of additional messages to show when program is not installed.
  final List<String>? installHelp;

  /// Optional list of data to delegate additional detection / analysis with [DetectService] implementation.
  final List<dynamic>? delegate;
}

/// Abstract class with common features to execute 'doctor' command.
abstract class DoctorCommand extends Command {
  @override
  final name = "doctor";
  @override
  final description = "Show information about the required tools.";
  @override
  final argParser = ArgParser(usageLineLength: 80);

  final AppService app = AppService.instance;
  final DoctorUi ui = DoctorUi();

  /// List of programs to be detected and analyzed.
  List<DoctorProgram> get programs;

  @override
  Future<void> run() async {
    if (argResults == null) {
      return;
    }
    final isFirstRun = app.config.isFirstRun;

    if (app.config.isFirstRun) {
      await app.setFirstRun();
    }
    int issues = 0;

    for (final program in programs) {
      if (!await detectProgram(program)) {
        issues++;
      }
    }
    if (!await detectHomeEnvironment(isFirstRun)) {
      issues++;
    }
    await app.setIssues(issues);
    print("");
    if (issues != 0) {
      print("${"!".yellow} Doctor found $issues issue${issues > 1 ? "s" : ""}.");
    } else {
      print("${"√".green} Doctor found no issue.");
    }
  }

  /// Detects [program] on user's system.
  ///
  /// Returns true when [program] is detected and well-configured.
  ///
  /// Prints logs depending on detection result.
  Future<bool> detectProgram(final DoctorProgram program) async {
    final DetectService service = program.service;

    ui.withProgram(program);
    try {
      await service.isInstalled();

      if (!service.hasRequiredVersion()) {
        ui.printRequiredVersion(service.version!, service.requiredVersion!);
        final path = app.getProgram(program.programTitle);

        if (path != null) {
          ui.printFixPath(path);
        }
        return false;
      }
      ui.printDetected(service.version!);
      if (program.delegate != null && !await service.delegate(program.delegate!)) {
        return false;
      }
      return true;
    } on ProgramNotFound {
      ui.printNotFound();
      ui.printInstallHelp();
      return false;
    } on ProgramFailure {
      ui.printMissingSemVer();
    }
    return false;
  }

  /// Detects GODOT_CLI_HOME environment variable on user's system.
  ///
  /// Returns true when environment variable is detected and well-configured.
  ///
  /// Prints logs depending on detection result.
  Future<bool> detectHomeEnvironment(final bool isFirstRun) async {
    final appDataPath = app.appData.path;

    if (isFirstRun) {
      ui.printHomeEnvDisclaimer(appDataPath);
      return false;
    }
    final home = Platform.environment[kHome];

    if (home == null) {
      ui.printHomeEnvNotFound(appDataPath);
      return false;
    } else if (home != appDataPath) {
      ui.printWrongHomeEnv(appDataPath);
      return false;
    }
    ui.printHomeEnvDetected(appDataPath);
    return true;
  }
}
