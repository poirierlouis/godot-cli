import 'dart:convert';
import 'dart:io';

import 'package:gd/platform_path.dart';
import 'package:gd/services/detect_service.dart';

abstract class GitError {
  const GitError._(this.stderr);

  final String stderr;
}

class GitCloneError extends GitError {
  const GitCloneError(final String stderr) : super._(stderr);
}

class GitCheckoutError extends GitError {
  const GitCheckoutError(final String stderr) : super._(stderr);
}

class GitReverseCheckoutError extends GitError {
  const GitReverseCheckoutError(final String stderr) : super._(stderr);
}

class GitService extends DetectService {
  static const String godotEngineGodotCpp = "https://github.com/godotengine/godot-cpp.git";

  static final GitService instance = GitService._();

  GitService._();

  @override
  String get executable {
    final path = app.getProgram("Git");

    if (path == null) {
      return "git";
    }
    return "$path${sep}git";
  }

  Future<void> clone(final String repositoryUrl, {required final String path}) async {
    ProcessResult result = await Process.run(executable, ["clone", repositoryUrl, path], stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitCloneError(result.stderr);
    }
  }

  Future<void> checkout(final String commit, {required final String path}) async {
    ProcessResult result = await Process.run(
      executable,
      ["checkout", commit],
      workingDirectory: path,
      stderrEncoding: utf8,
    );

    if (result.exitCode != 0) {
      throw GitCheckoutError(result.stderr);
    }
  }

  Future<void> reverseCheckout(final String path) async {
    ProcessResult result = await Process.run(executable, ["switch", "-"], workingDirectory: path, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitReverseCheckoutError(result.stderr);
    }
  }
}
