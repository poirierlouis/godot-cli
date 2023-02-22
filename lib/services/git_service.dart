import 'dart:convert';
import 'dart:io';

import 'package:gd/services/detect_service.dart';
import 'package:path/path.dart' as p;

abstract class GitError {
  const GitError._(this.stderr);

  final String stderr;
}

class GitCloneFailure extends GitError {
  const GitCloneFailure(final String stderr) : super._(stderr);
}

class GitStatusFailure extends GitError {
  const GitStatusFailure(final String stderr) : super._(stderr);
}

class GitPullFailure extends GitError {
  const GitPullFailure(final String stderr) : super._(stderr);
}

class GitCheckoutFailure extends GitError {
  const GitCheckoutFailure(final String stderr) : super._(stderr);
}

class GitReverseCheckoutFailure extends GitError {
  const GitReverseCheckoutFailure(final String stderr) : super._(stderr);
}

class GitRestoreFailure extends GitError {
  const GitRestoreFailure(final String stderr) : super._(stderr);
}

class GitLogFailure extends GitError {
  const GitLogFailure(final String stderr) : super._(stderr);
}

class GitService extends DetectService {
  static final GitService instance = GitService._();

  GitService._();

  @override
  String get executable {
    final path = app.getProgram("Git");

    if (path == null) {
      return "git";
    }
    return p.join(path, "git");
  }

  /// Executes `git clone [url]`, optionally from [path] working directory.
  ///
  /// Throws a [GitCloneFailure] when cloning failed.
  Future<void> clone(final String url, {required final String path}) async {
    ProcessResult result = await Process.run(executable, ["clone", url, path], stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitCloneFailure(result.stderr);
    }
  }

  /// Executes `git status` to test whether working tree is modified or untouched, within [path] of repository.
  ///
  /// Returns true when tree is clean.
  Future<bool> status(final String path) async {
    ProcessResult result = await Process.run(executable, ["status", path], stdoutEncoding: utf8, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      print(result.stderr as String);
      return false;
    }
    final output = result.stdout as String;

    return output.contains("nothing to commit") && output.contains("working tree clean");
  }

  /// Executes `git pull` within [path] of repository.
  ///
  /// Throws a [GitPullFailure] when pulling failed.
  Future<void> pull(final String path) async {
    ProcessResult result = await Process.run(executable, ["pull"], workingDirectory: path, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitPullFailure(result.stderr);
    }
  }

  /// Executes `git checkout [commit]` within [path] of repository.
  ///
  /// Throws a [GitCheckoutFailure] when checkout failed.
  Future<void> checkout(final String commit, {required final String path}) async {
    ProcessResult result = await Process.run(
      executable,
      ["checkout", commit],
      workingDirectory: path,
      stderrEncoding: utf8,
    );

    if (result.exitCode != 0) {
      throw GitCheckoutFailure(result.stderr);
    }
  }

  /// Executes `git switch -` to reverse any commits checkout within [path] of repository.
  ///
  /// Throws a [GitReverseCheckoutFailure] when reverse checkout failed.
  Future<void> reverseCheckout(final String path) async {
    ProcessResult result = await Process.run(executable, ["switch", "-"], workingDirectory: path, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitReverseCheckoutFailure(result.stderr);
    }
  }

  /// Executes `git restore *` to restore all modified files to their original state, within [path] of repository.
  ///
  /// Throws a [GitRestoreFailure] when restore failed.
  Future<void> restore(final String path) async {
    ProcessResult result =
        await Process.run(executable, ["restore", "*"], workingDirectory: path, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw GitRestoreFailure(result.stderr);
    }
  }

  /// Finds line of a commit which starts with [message] or contains [message] within [path] of repository. Optionally
  /// filter logs on [file].
  ///
  /// Returns one-line message of commit when found. Timeout with a null return after 20 seconds.
  Future<String?> findCommit(final String message, {required final String path, final String? file}) async {
    final List<String> arguments = [
      "log",
      "--pretty=oneline",
      if (file != null) ...["--", file],
    ];
    final process = await Process.start(executable, arguments, workingDirectory: path);
    final output = process.stdout.transform(utf8.decoder).map((text) {
      final lines = text.split("\n");

      return lines.where((line) => line.isNotEmpty);
    });
    String? commit;

    await output.firstWhere((lines) {
      for (final line in lines) {
        final description = line.substring(line.indexOf(" ") + 1);

        if (description.startsWith(message) || description.contains(message)) {
          commit = line;
          return true;
        }
      }
      return false;
    }).timeout(
      const Duration(seconds: 20),
      onTimeout: () => const Iterable.empty(),
    );
    process.kill();
    if (commit == null && await process.exitCode != 0) {
      final stderr = await process.stderr.join();

      throw GitLogFailure(stderr);
    }
    return commit;
  }
}
