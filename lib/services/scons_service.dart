import 'package:gd/services/program_service.dart';

class BuildFailure {
  const BuildFailure(this.target, this.stderr);

  final String target;
  final String stderr;
}

class SConsService {
  static final SConsService instance = SConsService._();

  ProgramService get program => ProgramService.instance;

  SConsService._();

  /// Executes `scons target=<target>` to build sources within [path] directory.
  ///
  /// [target] accepts `editor`, `template_debug` (default) and `template_release`.
  ///
  /// Throws a [BuildFailure] when building failed.
  Future<void> build(final String path, {final String target = "template_debug"}) async {
    try {
      await program.run("scons", ["target=$target"], workingDirectory: path);
    } on ProgramFailure catch (error) {
      throw BuildFailure(target, error.stderr);
    }
  }
}
