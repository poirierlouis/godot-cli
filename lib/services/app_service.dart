import 'dart:convert';
import 'dart:io';

import 'package:gd/config.dart';
import 'package:gd/platform_path.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

class AppService {
  static AppService get instance => _instance;
  @visibleForTesting
  static set instance(AppService value) => _instance = value;

  static AppService _instance = AppService._();

  AppService._();

  late Directory _appData;
  late Config _config;
  late File _configFile;

  Directory get appData => _appData;
  Directory get godotCpp => Directory(p.join(_appData.path, "godot-cpp"));
  Config get config => _config;

  /// Loads configuration's data of [this] application.
  Future<void> load() async {
    _appData = await getAppData();
    _configFile = File(p.join(_appData.path, "config.json"));
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

  /// Gets [path] directory where to find binary of [program].
  String? getProgram(final String program) {
    return config.programs[program.toLowerCase()];
  }

  /// Sets [path] directory where to find binary of [program].
  Future<void> defineProgram(final String program, final String path) async {
    config.programs[program.toLowerCase()] = path;
    await _saveConfig(config);
  }

  /// Removes [path] directory of [program].
  ///
  /// Returns true when [program] existed and is now removed.
  Future<bool> removeProgram(final String program) async {
    final path = config.programs.remove(program.toLowerCase());

    if (path == null) {
      return false;
    }
    await _saveConfig(config);
    return true;
  }

  Future<void> _saveConfig(final Config config) async {
    final json = jsonEncode(config.toJson());

    await _configFile.writeAsString(json);
  }

  Future<Config> _getConfig() async {
    Config config = Config.empty();

    if (!await _configFile.exists()) {
      final json = jsonEncode(config.toJson());

      await _configFile.create();
      await _configFile.writeAsString(json);
    } else {
      final data = await _configFile.readAsString();
      final json = jsonDecode(data);

      config = Config.fromJson(json);
    }
    return config;
  }
}
