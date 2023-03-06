import 'dart:async';

import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:gd/terminal.dart';
import 'package:gd/ui/python_ui.dart';
import 'package:path/path.dart' as p;

class PackageNotFound {}

class PackageMissingSemVer {}

class PackageInstallFailure {
  const PackageInstallFailure(this.stderr);

  final String stderr;
}

class PackageUpdateFailure {
  const PackageUpdateFailure(this.stderr);

  final String stderr;
}

class PythonPackage {
  PythonPackage({
    required this.packageTitle,
    required this.packageName,
    this.requiredVersion,
  });

  final String packageTitle;
  final String packageName;
  final SemVer? requiredVersion;
}

class PythonService extends DetectService {
  static final PythonService instance = PythonService._();

  PythonService._();

  @override
  String get executable {
    final path = app.getProgram("Python");

    if (path == null) {
      return "python";
    }
    return p.join(path, "python");
  }

  String get pip {
    final path = app.getProgram("Python");

    if (path == null) {
      return "pip";
    }
    return p.join(path, "Scripts", "pip");
  }

  @override
  final SemVer? requiredVersion = SemVer(3, 6, 0);

  final PythonUi ui = PythonUi();

  @override
  Future<bool> delegate(final List<dynamic> data) async {
    final packages = data.cast<PythonPackage>();
    int issues = 0;

    for (final package in packages) {
      ui.withPackage(package);

      try {
        final version = await Terminal.showInfiniteLoader(
          ui.detecting(),
          padding: "    ",
          task: detectPackage(package),
        );

        Terminal.clearLines(1);
        ui.printDetected(version);

        Terminal.clearLines(1);
        final hasUpdate = await Terminal.showInfiniteLoader(
          ui.checkingUpdate(),
          padding: "    ",
          task: hasPackageUpdate(package),
        );

        if (hasUpdate) {
          Terminal.clearLines(1);
          await Terminal.showInfiniteLoader(
            ui.updating(),
            padding: "    ",
            task: updatePackage(package),
          );
          Terminal.clearLines(1);
          ui.printUpdated();
        } else {
          Terminal.clearLines(1);
          ui.printDetected(version);
        }
      } on ProgramNotFound {
        Terminal.clearLines(1);
        ui.printPipNotFound();
        return false;
      } on PackageMissingSemVer {
        Terminal.clearLines(1);
        ui.printMissingSemVer();
      } on PackageUpdateFailure catch (error) {
        Terminal.clearLines(1);
        ui.printUpdateFailure(error);
      } on PackageNotFound {
        Terminal.clearLines(1);

        try {
          await Terminal.showInfiniteLoader(
            ui.installing(),
            padding: "    ",
            task: installPackage(package),
          );
          Terminal.clearLines(1);
          ui.printInstalled();
        } on PackageInstallFailure catch (error) {
          ui.printNotFound();
          ui.printInstallFailure(error);
          issues++;
        }
      }
    }
    return issues == 0;
  }

  /// Whether [package] is installed in Python environment?
  ///
  /// Returns [SemVer] of package when installed.
  ///
  /// Throws a [PackageNotFound] when package is not detected.
  /// Throws a [PackageMissingSemVer] when version number is unknown.
  Future<SemVer> detectPackage(final PythonPackage package) async {
    try {
      final result = await program.run(pip, ["show", package.packageName]);
      final output = (result.stdout as String).split("\n");
      final line = output.firstWhere((item) => item.startsWith("Version: ")).trim();
      final version = line.substring("Version: ".length).trim();

      return SemVer.parse(version);
    } on ProgramNotFound {
      rethrow;
    } on ProgramFailure {
      throw PackageNotFound();
    } catch (_) {
      throw PackageMissingSemVer();
    }
  }

  /// Installs [package] in Python environment using the latest version.
  ///
  /// Throws a [PackageInstallFailure] when installation failed.
  Future<void> installPackage(final PythonPackage package) async {
    try {
      await program.run(pip, ["install", package.packageName]);
    } on ProgramFailure catch (error) {
      throw PackageInstallFailure(error.stderr);
    }
  }

  /// Whether [package] can be updated?
  Future<bool> hasPackageUpdate(final PythonPackage package) async {
    try {
      final result = await program.run(pip, ["list", "--outdated"]);
      final output = (result.stdout as String).split("\n");
      final packageLine = output.firstWhere((line) => line.startsWith(package.packageName), orElse: () => "");

      return packageLine.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  /// Updates [package] to the latest available version.
  ///
  /// Throws a [PackageUpdateFailure] when update failed.
  Future<void> updatePackage(final PythonPackage package) async {
    try {
      await program.run(pip, ["install", "--upgrade", package.packageName]);
    } on ProgramFailure catch (error) {
      throw PackageUpdateFailure(error.stderr);
    }
  }
}
