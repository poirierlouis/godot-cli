import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/terminal.dart';
import 'package:gd/ui/python_ui.dart';

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
  final String executable = "python";

  @override
  final SemVer? requiredVersion = SemVer(3, 6, 0);

  final PythonUi ui = PythonUi();

  @override
  Future<bool> delegate(final List<dynamic> data) async {
    var loading = Completer<void>();
    final packages = data.cast<PythonPackage>();
    int issues = 0;

    for (final package in packages) {
      ui.withPackage(package);

      Terminal.showInfiniteLoader(loading, ui.detecting(), "    ");
      try {
        final version = await detectPackage(package);

        loading.complete();
        Terminal.clearLines(1);
        ui.printDetected(version);

        loading = Completer();
        Terminal.clearLines(1);
        Terminal.showInfiniteLoader(loading, ui.checkingUpdate(), "    ");
        final hasUpdate = await hasPackageUpdate(package);

        loading.complete();
        if (hasUpdate) {
          loading = Completer();
          Terminal.clearLines(1);
          Terminal.showInfiniteLoader(loading, ui.updating(), "    ");
          await updatePackage(package);
          loading.complete();
          Terminal.clearLines(1);
          ui.printUpdated();
        } else {
          Terminal.clearLines(1);
          ui.printDetected(version);
        }
      } on PackageMissingSemVer {
        loading.complete();
        Terminal.clearLines(1);
        ui.printMissingSemVer();
      } on PackageUpdateFailure catch (error) {
        loading.complete();
        Terminal.clearLines(1);
        ui.printUpdateFailure(error);
      } on PackageNotFound {
        loading.complete();
        loading = Completer();
        Terminal.clearLines(1);
        Terminal.showInfiniteLoader(loading, ui.installing(), "    ");
        try {
          await Future.delayed(const Duration(seconds: 5));
          await installPackage(package);
          loading.complete();
          Terminal.clearLines(1);
          ui.printInstalled();
        } on PackageInstallFailure catch (error) {
          loading.complete();
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
    ProcessResult result;

    try {
      result = await Process.run("pip", ["show", package.packageName], stdoutEncoding: utf8);
      if (result.exitCode != 0) {
        throw ProcessException("pip", ["show", package.packageName]);
      }
    } on ProcessException {
      throw PackageNotFound();
    }
    final output = (result.stdout as String).split("\n");

    try {
      final line = output.firstWhere((item) => item.startsWith("Version: ")).trim();
      final version = line.substring("Version: ".length).trim();

      return SemVer.parse(version);
    } catch (error) {
      throw PackageMissingSemVer();
    }
  }

  /// Installs [package] in Python environment using the latest version.
  ///
  /// Throws a [PackageInstallFailure] when installation failed.
  Future<void> installPackage(final PythonPackage package) async {
    final result = await Process.run("pip", ["install", package.packageName], stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw PackageInstallFailure(result.stderr as String);
    }
  }

  /// Whether [package] can be updated?
  Future<bool> hasPackageUpdate(final PythonPackage package) async {
    try {
      final result = await Process.run("pip", ["list", "--outdated"], stdoutEncoding: utf8);

      if (result.exitCode != 0) {
        return false;
      }
      final output = (result.stdout as String).split("\n");
      final packageLine = output.firstWhere((line) => line.startsWith(package.packageName), orElse: () => "");

      return packageLine.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Updates [package] to the latest available version.
  ///
  /// Throws a [PackageUpdateFailure] when update failed.
  Future<void> updatePackage(final PythonPackage package) async {
    final result = await Process.run("pip", ["install", "--upgrade", package.packageName], stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw PackageUpdateFailure(result.stderr as String);
    }
  }
}
