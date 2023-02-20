import 'dart:io';

import 'package:gd/sem_ver.dart';
import 'package:gd/services/program_service.dart';

/// Abstract service layer to detect a program is installed and well-configured.
abstract class DetectService {
  String get executable;
  SemVer? get requiredVersion => null;

  /// Gets [SemVer] number of [executable], after [isInstalled] succeeded.
  SemVer? get version => _version;

  SemVer? _version;

  /// Whether [executable] is installed on user's system.
  ///
  /// Gets version number when it is installed, use [getVersion].
  Future<void> isInstalled({final List<String> arguments = const ["--version"]}) async {
    try {
      ProcessResult result = await ProgramService.run(executable, arguments);

      _version = ProgramService.getVersion(result.stdout as String);
    } catch (_) {
      rethrow;
    }
  }

  /// Whether [executable]'s version is equal or higher to [requiredVersion]?
  bool hasRequiredVersion() {
    if (requiredVersion == null) {
      return true;
    }
    if (version == null) {
      return false;
    }
    return version! >= requiredVersion!;
  }

  /// Whether specific dependencies related to [this] service are installed?
  ///
  /// Defaults to no-op.
  Future<bool> delegate(final List<dynamic> data) async {
    return true;
  }
}
