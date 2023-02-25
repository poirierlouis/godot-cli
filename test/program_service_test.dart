import 'package:gd/sem_ver.dart';
import 'package:gd/services/program_service.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group("ProgramService", () {
    test(".run(executable) while executable does not exist should throw ProgramNotFound.", () async {
      await expectLater(
        ProgramService.instance.run("unknown-program", []),
        throwsA(const TypeMatcher<ProgramNotFound>()),
      );
    });

    test(".run(executable) while executable exits with an error code should throw ProgramFailure.", () async {
      await expectLater(
        ProgramService.instance.run("dart", ["--unknown-command"]),
        throwsA(const TypeMatcher<ProgramFailure>()),
      );
    });

    test(".getVersion(content) while content contains no version number should return <null>.", () {
      final version =
          ProgramService.instance.getVersion("Generated 5 paragraphs, 448 words, 3019 bytes of Lorem Ipsum");

      expect(version, null);
    });

    test(".getVersion(content) while content contains '2.19.1' should return SemVer(2, 19, 1).", () {
      // Mock Dart SDK version
      final output = "Dart SDK version: 2.19.1 (stable) (Tue Jan 31 12:25:35 2023 +0000) on 'windows_x64'";
      final version = ProgramService.instance.getVersion(output);

      expect(version, SemVer(2, 19, 1));
    });

    test(".start(executable) while executable does not exist should throw ProgramNotFound.", () async {
      await expectLater(
        ProgramService.instance.start("unknown-program", ["--unknown-command"]),
        throwsA(const TypeMatcher<ProgramNotFound>()),
      );
    });

    test(".start(executable) while executable does exist should return Process and gracefully stop.", () async {
      final process = await ProgramService.instance.start("dart", ["--version"]);
      final exitCode = await process.exitCode;

      expect(exitCode, 0);
    });
  });
}
