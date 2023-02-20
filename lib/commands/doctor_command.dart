import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/services/detect_service.dart';
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
}
