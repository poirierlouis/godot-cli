import 'dart:convert';
import 'dart:io';

class BuildFailure {
  const BuildFailure(this.target, this.stderr);

  final String target;
  final String stderr;
}

class SConsService {
  static final SConsService instance = SConsService._();

  SConsService._();

  /// Executes `scons target=<target>` to build sources within [path] directory.
  ///
  /// [target] accepts `editor`, `template_debug` (default) and `template_release`.
  ///
  /// Throws a [BuildFailure] when building failed.
  Future<void> build(final String path, {final String target = "template_debug"}) async {
    final result = await Process.run("scons", ["target=$target"], workingDirectory: path, stderrEncoding: utf8);

    if (result.exitCode != 0) {
      throw BuildFailure(target, result.stderr);
    }
  }
}
