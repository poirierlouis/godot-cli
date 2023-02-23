import 'dart:io';

import 'package:gd/sem_ver.dart';
import 'package:gd/services/detect_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mock_services.dart';

/// Fake implementation to test the base of [DetectService].
class _FakeDetectService extends DetectService {
  @override
  String get executable => "";
}

/// Fake implementation, with a required version 4.0.0, to test the base of [DetectService].
class _RequiredFakeDetectService extends DetectService {
  @override
  String get executable => "";

  @override
  SemVer? get requiredVersion => SemVer(4);
}

void main() {
  group("DetectService", () {
    final program = ProgramService.instance;
    final mockProgram = MockProgramService();

    ProgramService.instance = mockProgram;

    final detect = _RequiredFakeDetectService();

    tearDown(() {
      reset(mockProgram);
    });

    test(".hasRequiredVersion() while .requiredVersion is <null> should return true.", () {
      final hasVersion = _FakeDetectService().hasRequiredVersion();

      expect(hasVersion, true);
    });

    test(".hasRequiredVersion() while .requiredVersion is 4.0.0 and .version is <null> should return false.", () {
      final hasVersion = detect.hasRequiredVersion();

      expect(hasVersion, false);
    });

    test(".isInstalled() while program is not found should rethrow ProgramNotFound.", () async {
      when(() => mockProgram.run(any(), any())).thenThrow(ProgramNotFound());

      await expectLater(
        detect.isInstalled(),
        throwsA(const TypeMatcher<ProgramNotFound>()),
      );
    });

    test(".isInstalled() while program stops with an exit code should rethrow ProgramFailure.", () async {
      when(() => mockProgram.run(any(), any())).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        detect.isInstalled(),
        throwsA(const TypeMatcher<ProgramFailure>()),
      );
    });

    test(".isInstalled() while program output no version number should set .version = <null>.", () async {
      when(() => mockProgram.run(any(), any()))
          .thenAnswer((invocation) async => ProcessResult(42, 0, "some text", "without version number"));
      when(() => mockProgram.getVersion("some text" "without version number"))
          .thenReturn(program.getVersion("some text" "without version number"));

      try {
        await detect.isInstalled();
        expect(detect.version, null);
      } catch (_) {
        expect(true, false);
      }
    });

    test(".isInstalled() while program output \"Program version 3.42.1\" should set .version = SemVer(3, 42, 1).",
        () async {
      when(() => mockProgram.run(any(), any()))
          .thenAnswer((invocation) async => ProcessResult(42, 0, "Program version 3.42.1", ""));
      when(() => mockProgram.getVersion("Program version 3.42.1"))
          .thenReturn(program.getVersion("Program version 3.42.1"));

      try {
        await detect.isInstalled();
        expect(detect.version, SemVer(3, 42, 1));
      } catch (_) {
        expect(true, false);
      }
    });

    test(".hasRequiredVersion() while .requiredVersion is 4.0.0 and .version is 3.42.1 should return false.", () {
      final hasVersion = detect.hasRequiredVersion();

      expect(hasVersion, false);
    });

    test(".hasRequiredVersion() while .requiredVersion is 4.0.0 and .version is 4.0.1 should return true.", () async {
      when(() => mockProgram.run(any(), any()))
          .thenAnswer((invocation) async => ProcessResult(42, 0, "Program version 4.0.1", ""));
      when(() => mockProgram.getVersion("Program version 4.0.1"))
          .thenReturn(program.getVersion("Program version 4.0.1"));

      await detect.isInstalled();

      final hasVersion = detect.hasRequiredVersion();

      expect(hasVersion, true);
    });

    test(".delegate() with default behavior should return true.", () async {
      final result = await detect.delegate([]);

      expect(result, true);
    });
  });
}
