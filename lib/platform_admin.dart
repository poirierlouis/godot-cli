import 'dart:io';

class AdministratorAccessDenied {}

/// Whether session is running with Administrator access?
///
/// Throws an [AdministratorAccessDenied] when running without access.
Future<void> isAdministrator() {
  if (Platform.isWindows) {
    return _isWindowsAdministrator();
  } else if (Platform.isLinux) {
    return _isLinuxAdministrator();
  }
  throw UnimplementedError();
}

Future<void> _isWindowsAdministrator() async {
  ProcessResult result = await Process.run("net", ["session"]);

  if (result.exitCode != 0) {
    throw AdministratorAccessDenied();
  }
}

Future<void> _isLinuxAdministrator() async {
  ProcessResult result = await Process.run("id", ["-u"]);

  if (result.exitCode != 0) {
    throw AdministratorAccessDenied();
  }
  final output = result.stdout as String;
  final id = int.tryParse(output.substring(0, output.indexOf("\n")));

  if (id == null || id != 0) {
    throw AdministratorAccessDenied();
  }
}
