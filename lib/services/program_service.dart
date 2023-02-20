import 'dart:convert';
import 'dart:io';

import 'package:gd/sem_ver.dart';

abstract class ProgramError {
  const ProgramError();
}

/// Throws when an executable is not found.
class ProgramNotFound extends ProgramError {}

/// Throws when an executable stops with an error code ([errno]).
class ProgramFailure extends ProgramError {
  const ProgramFailure(this.errno);

  final int errno;
}

class ProgramService {
  /// Runs [executable] in a [Process] with [arguments], optionally from [workingDirectory].
  ///
  /// Returns [ProcessResult] with stdout / stderr as String using UTF-8 encoding.
  ///
  /// Throws a [ProgramFailure] when [executable] stops with an error code (exitCode != 0).
  /// Throws a [ProgramNotFound] when [executable] is not found.
  static Future<ProcessResult> run(
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
        throw ProgramFailure(result.exitCode);
      }
      return result;
    } on ProcessException {
      throw ProgramNotFound();
    }
  }

  /// Gets [SemVer] from [content] expecting format "X.Y.Z".
  static SemVer? getVersion(final String content) {
    final match = SemVer.regexp.stringMatch(content);

    if (match == null) {
      return null;
    }
    return SemVer.parse(match);
  }
}