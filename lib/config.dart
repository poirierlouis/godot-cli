import 'package:gd/commands/doctor_command.dart';
import 'package:gd/platform_version.dart';
import 'package:gd/sem_ver.dart';

class Config {
  Config({required this.version, required this.programs, required this.isFirstRun, required this.issues});

  /// Current version of [this] application.
  final SemVer version;

  /// Path where to locate program to execute, e.g. `program: path`.
  final Map<String, String> programs;

  /// Returns true when [this] application is run for the first time.
  bool isFirstRun;

  /// Number of issues detected since the last run of [DoctorCommand].
  int issues;

  Map<String, dynamic> toJson() {
    return {
      "version": "$version",
      "programs": programs,
      "is_first_run": isFirstRun,
      "issues": issues,
    };
  }

  factory Config.empty() {
    return Config(version: SemVer(1, 0, 0), programs: {}, isFirstRun: true, issues: -1);
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      version: SemVer.parse(json["version"] ?? packageVersion),
      programs: Map<String, String>.from(json["programs"] ?? {}),
      isFirstRun: json["is_first_run"] ?? true,
      issues: json["issues"] ?? -1,
    );
  }
}
