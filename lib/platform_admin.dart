import 'dart:io';

/// Whether session is running with Administrator access?
///
/// Throws an [UnimplementedError] when running on unsupported OS.
Future<bool> isAdministrator() {
  if (Platform.isWindows) {
    return _isWindowsAdministrator();
  } else if (Platform.isLinux) {
    return _isLinuxAdministrator();
  }
  throw UnimplementedError();
}

Future<bool> _isWindowsAdministrator() async {
  ProcessResult result = await Process.run("net", ["session"]);

  return result.exitCode == 0;
}

Future<bool> _isLinuxAdministrator() async {
  ProcessResult result = await Process.run("id", ["-u"]);

  if (result.exitCode != 0) {
    return false;
  }
  final output = result.stdout as String;
  final id = int.tryParse(output.substring(0, output.indexOf("\n")));

  return id != null && id == 0;
}
