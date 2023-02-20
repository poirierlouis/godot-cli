import 'package:gd/extensions/string_utils.dart';
import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/terminal.dart';

class VisualStudioService extends DetectService {
  static final VisualStudioService instance = VisualStudioService._();
  static final SemVer vs2017 = SemVer(15, 0, 0);
  static final SemVer vs2019 = SemVer(16, 0, 0);
  static final SemVer vs2022 = SemVer(17, 0, 0);

  VisualStudioService._();

  @override
  final String executable = "C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer\\vswhere.exe";

  @override
  final SemVer? requiredVersion = vs2017;

  @override
  Future<void> isInstalled({final List<String> arguments = const ["--version"]}) async {
    return super.isInstalled(
      arguments: [
        "-latest",
        "-property",
        "catalog_productDisplayVersion",
      ],
    );
  }

  @override
  Future<bool> delegate(final List<dynamic> data) async {
    if (version! < vs2019) {
      Terminal.clearLines(1);
      print("${"[!]".yellow} Visual Studio ($version)");
      print("    ${"·".yellow} ${"Minimum recommended version is v16.0.0.".bold}");
      print("    ${"·".yellow} ${"Please consider updating to Visual Studio 2019.".bold}");
    }
    return true;
  }
}
