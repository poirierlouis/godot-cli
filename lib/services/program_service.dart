import 'dart:convert';
import 'dart:io';

import 'package:gd/sem_ver.dart';
import 'package:meta/meta.dart';

abstract class ProgramError {
  const ProgramError();
}

/// Throws when an executable is not found.
class ProgramNotFound extends ProgramError {}

/// Throws when an executable stops with an error code and stderr.
class ProgramFailure extends ProgramError {
  const ProgramFailure(this.errno, this.stderr);

  final int errno;
  final String stderr;
}

class ProgramService {
  static ProgramService get instance => _instance;

  @visibleForTesting
  static set instance(ProgramService value) => _instance = value;

  static ProgramService _instance = ProgramService._();

  ProgramService._();

  /// Runs [executable] in a [Process] with [arguments], optionally from [workingDirectory].
  ///
  /// Returns [ProcessResult] with stdout / stderr as String using UTF-8 encoding.
  ///
  /// Throws a [ProgramFailure] when [executable] stops with an error code (exitCode != 0).
  /// Throws a [ProgramNotFound] when [executable] is not found.
  Future<ProcessResult> run(
    final String executable,
    final List<String> arguments, {
    final String? workingDirectory,
  }) async {
    try {
      ProcessResult result = await Process.run(
        executable,
        arguments,
        workingDirectory: workingDirectory,
        stdoutEncoding: utf8,
        stderrEncoding: utf8,
      );

      if (result.exitCode != 0) {
        throw ProgramFailure(result.exitCode, result.stderr);
      }
      return result;
    } on ProcessException {
      throw ProgramNotFound();
    }
  }

  /// Starts [executable] with [arguments], optionally from [workingDirectory] and with a custom start [mode].
  ///
  /// Returns a [Process] to interact with, when it has been successfully started.
  ///
  /// Throws a [ProgramNotFound] when [executable] is not found.
  Future<Process> start(
    final String executable,
    final List<String> arguments, {
    final String? workingDirectory,
    final ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    try {
      return await Process.start(executable, arguments, workingDirectory: workingDirectory, mode: mode);
    } catch (error) {
      throw ProgramNotFound();
    }
  }

  /// Gets [SemVer] from [content] expecting format "X.Y.Z".
  SemVer? getVersion(final String content) {
    final match = SemVer.regexp.stringMatch(content);

    if (match == null) {
      return null;
    }
    return SemVer.parse(match);
  }
}
