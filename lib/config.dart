import 'package:gd/sem_ver.dart';

class Config {
  Config({required this.version, required this.isFirstRun, required this.issues});

  final SemVer version;
  bool isFirstRun;
  int issues;

  Map<String, dynamic> toJson() {
    return {
      "version": "$version",
      "is_first_run": isFirstRun,
      "issues": issues,
    };
  }

  factory Config.empty() {
    return Config(version: SemVer(1, 0, 0), isFirstRun: true, issues: -1);
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
      version: SemVer.parse(json["version"] ?? "1.0.0"),
      isFirstRun: json["is_first_run"] ?? true,
      issues: json["issues"] ?? -1,
    );
  }
}
