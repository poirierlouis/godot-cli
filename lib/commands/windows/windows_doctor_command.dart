import 'package:gd/commands/doctor_command.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/services/git_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:gd/services/python_service.dart';
import 'package:gd/services/visual_studio_service.dart';

class WindowsDoctorCommand extends DoctorCommand {
  @override
  final List<DoctorProgram> programs = [
    DoctorProgram(
      programTitle: "Git",
      service: GitService.instance,
      installUrl: "https://git-scm.com/download/win",
    ),
    DoctorProgram(
      programTitle: "Python",
      service: PythonService.instance,
      installUrl: "https://www.python.org/downloads/windows/",
      delegate: [
        PythonPackage(packageTitle: "SCons", packageName: "scons", requiredVersion: SemVer(3, 0, 0)),
      ],
    ),
    DoctorProgram(
      programTitle: "Visual Studio",
      service: VisualStudioService.instance,
      installUrl: "https://visualstudio.microsoft.com/vs/community/",
      installHelp: ["Make sure to enable C++ in the list of workflows when installing."],
      // TODO: test C++ module is installed along with Visual Studio.
      delegate: [],
    ),
  ];

  @override
  Future<void> run() async {
    if (argResults == null) {
      return;
    }
    if (app.config.isFirstRun) {
      await app.setFirstRun();
    }
    int issues = 0;

    for (final program in programs) {
      if (!await detectProgram(program)) {
        issues++;
      }
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
}
