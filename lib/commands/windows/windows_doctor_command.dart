import 'package:gd/commands/doctor_command.dart';
import 'package:gd/sem_ver.dart';
import 'package:gd/services/git_service.dart';
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
}
