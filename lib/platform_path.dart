import 'dart:io';

import 'package:gd/platform_flavor.dart';

final String sep = Platform.pathSeparator;

const String _appDataName = "gd-cli";

/// Gets [Directory] of data of this application depending on Operating System.
///
/// Creates [Directory] when it does not exist.
Future<Directory> getAppData() async {
  String path = _getAppDataPath();
  final appData = Directory(path);

  if (!await appData.exists()) {
    await appData.create(recursive: !kReleaseMode);
  }
  return appData;
}

String _getAppDataPath() {
  String path = _getHomePath();

  if (Platform.isMacOS) {
    return "$path$sep.$_appDataName";
  } else if (Platform.isLinux) {
    return "$path$sep.$_appDataName";
  } else if (Platform.isWindows) {
    return "$path${sep}AppData${sep}Roaming$sep$_appDataName";
  }
  throw Error();
}

String _getHomePath() {
  final env = Platform.environment;
  final cwd = Directory.current.path;
  final path = (kTestMode) ? "$cwd${sep}test-fake" : "$cwd${sep}fake";

  if (Platform.isMacOS) {
    return (kReleaseMode) ? env["HOME"]! : path;
  } else if (Platform.isLinux) {
    return (kReleaseMode) ? env["HOME"]! : path;
  } else if (Platform.isWindows) {
    return (kReleaseMode) ? env["UserProfile"]! : path;
  }
  throw Error();
}
