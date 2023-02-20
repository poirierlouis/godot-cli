import 'dart:io';

final String sep = Platform.pathSeparator;

const String _appDataName = "gd-cli";

/// Gets [Directory] of data of this application depending on Operating System.
///
/// Creates [Directory] when it does not exist.
Future<Directory> getAppData() async {
  String path = _getAppDataPath();
  final appData = Directory(path);

  if (!await appData.exists()) {
    await appData.create();
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

  if (Platform.isMacOS) {
    return env["HOME"]!;
  } else if (Platform.isLinux) {
    return env["HOME"]!;
  } else if (Platform.isWindows) {
    return env["UserProfile"]!;
  }
  throw Error();
}
