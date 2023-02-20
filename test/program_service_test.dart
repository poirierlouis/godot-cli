import 'package:gd/sem_ver.dart';
import 'package:gd/services/program_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("ProgramService", () {
    test(".run('unknown-program', []) should throw ProgramNotFound", () {
      expect(
        () => ProgramService.run("unknown-program", []),
        throwsA(const TypeMatcher<ProgramNotFound>()),
      );
    });

    test(".run('dart', ['--unknown-command']) should throw ProgramFailure", () {
      expect(
        () => ProgramService.run("dart", ["--unknown-command"]),
        throwsA(const TypeMatcher<ProgramFailure>()),
      );
    });

    test(".getVersion(content) while content contains no version number should return <null>.", () {
      final version = ProgramService.getVersion("Generated 5 paragraphs, 448 words, 3019 bytes of Lorem Ipsum");

      expect(version, null);
    });

    test(".getVersion(content) while content contains '2.19.1' should return SemVer(2, 19, 1).", () {
      // Mock Dart SDK version
      final output = "Dart SDK version: 2.19.1 (stable) (Tue Jan 31 12:25:35 2023 +0000) on 'windows_x64'";
      final version = ProgramService.getVersion(output);

      expect(version, SemVer(2, 19, 1));
    });
  });
}
