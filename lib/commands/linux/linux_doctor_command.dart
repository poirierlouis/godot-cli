import 'package:gd/commands/doctor_command.dart';
import 'package:gd/sem_ver.dart';
import 'package:gd/services/gcc_service.dart';
import 'package:gd/services/git_service.dart';
import 'package:gd/services/python_service.dart';

class LinuxDoctorCommand extends DoctorCommand {
  @override
  final List<DoctorProgram> programs = [
    DoctorProgram(
      programTitle: "Git",
      service: GitService.instance,
      installUrl: "https://git-scm.com/download/linux",
    ),
    DoctorProgram(
      programTitle: "Python",
      service: PythonService.instance,
      installUrl: "https://www.python.org/downloads/source/",
      delegate: [
        PythonPackage(packageTitle: "SCons", packageName: "scons", requiredVersion: SemVer(3, 0, 0)),
      ],
    ),
    DoctorProgram(
      programTitle: "GCC",
      service: GCCService.instance,
      installUrl: "https://gcc.gnu.org/",
    ),
  ];
}
