import 'package:gd/sem_ver.dart';

class Config {
  Config({required this.version, required this.programs, required this.isFirstRun, required this.issues});

  final SemVer version;
  final Map<String, String> programs;
  bool isFirstRun;
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
      version: SemVer.parse(json["version"] ?? "1.0.0"),
      programs: Map<String, String>.from(json["programs"] ?? {}),
      isFirstRun: json["is_first_run"] ?? true,
      issues: json["issues"] ?? -1,
    );
  }
}
