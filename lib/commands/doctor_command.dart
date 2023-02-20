import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/ui/doctor_ui.dart';

class DoctorProgram {
  DoctorProgram({
    required this.programTitle,
    required this.service,
    required this.installUrl,
    this.installHelp,
    this.delegate,
  });

  final String programTitle;
  final DetectService service;
  final String installUrl;
  final List<String>? installHelp;
  final List<dynamic>? delegate;
}

abstract class DoctorCommand extends Command {
  @override
  final name = "doctor";
  @override
  final description = "Show information about the required tools.";
  @override
  final argParser = ArgParser(usageLineLength: 80);

  final AppService app = AppService.instance;
  final DoctorUi ui = DoctorUi();

  List<DoctorProgram> get programs;
}
