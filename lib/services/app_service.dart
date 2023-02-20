import 'dart:convert';
import 'dart:io';

import 'package:gd/config.dart';
import 'package:gd/platform_path.dart';

class AppService {
  static final AppService instance = AppService._();

  AppService._();

  Directory _appData = Directory("");
  Config _config = Config.empty();

  Directory get appData => _appData;
  Config get config => _config;

  /// Loads configuration's data of [this] application.
  Future<void> load() async {
    _appData = await getAppData();
    _config = await _getConfig();
  }

  /// Sets [isFirstRun] flag after first running 'doctor' command.
  Future<void> setFirstRun() {
    config.isFirstRun = false;
    return _saveConfig(config);
  }

  /// Sets number of [issues] after running 'doctor' command.
  Future<void> setIssues(final int issues) {
    config.issues = issues;
    return _saveConfig(config);
  }

  Future<void> _saveConfig(final Config config) async {
    final file = File("${appData.path}${sep}config.json");
    final json = jsonEncode(config.toJson());

    await file.writeAsString(json);
  }

  Future<Config> _getConfig() async {
    final file = File("${appData.path}${sep}config.json");
    Config config = Config.empty();

    if (!await file.exists()) {
      final json = jsonEncode(config.toJson());

      await file.create();
      await file.writeAsString(json);
    } else {
      final data = await file.readAsString();
      final json = jsonDecode(data);

      config = Config.fromJson(json);
    }
    return config;
  }
}
