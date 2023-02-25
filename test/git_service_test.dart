import 'dart:io';

import 'package:gd/services/app_service.dart';
import 'package:gd/services/git_service.dart';
import 'package:gd/services/program_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'mock_services.dart';

void main() {
  group("GitService", () {
    ProgramService.instance = MockProgramService();
    AppService.instance = MockAppService();

    final program = ProgramService.instance;
    final app = AppService.instance;
    final git = GitService.instance;

    tearDown(() {
      reset(program);
    });

    test(".executable while using PATH environment variable should return 'git'.", () {
      expect(git.executable, "git");
    });

    test(".executable while using Git program at <path> should return '<path>${Platform.pathSeparator}git'.", () {
      final path = p.join("absolute", "path", "to", "program");

      when(() => app.getProgram("Git")).thenReturn(path);

      expect(git.executable, p.join(path, "git"));
    });

    test(".clone() while execution fails should throw GitCloneFailure.", () async {
      when(() => program.run(any(), any())).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        git.clone("https://github.com/user/repo.git", path: ""),
        throwsA(const TypeMatcher<GitCloneFailure>()),
      );
    });

    test(".status() while execution fails should return false.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramFailure(42, "stderr"));

      final isClean = await git.status("<path>");

      expect(isClean, false);
    });

    test(".status() while working tree is modified should return false.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>"))
          .thenAnswer((_) async => ProcessResult(42, 0, "Working tree contains modified files.", ""));

      final isClean = await git.status("");

      expect(isClean, false);
    });

    test(".status() while working tree is clean should return true.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenAnswer((_) async => ProcessResult(
          42,
          0,
          """
On branch master
Your branch is up to date with 'origin/master'.

nothing to commit, working tree clean
""",
          ""));

      final isClean = await git.status("<path>");

      expect(isClean, true);
    });

    test(".pull() while execution fails should throw GitPullFailure.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        git.pull("<path>"),
        throwsA(const TypeMatcher<GitPullFailure>()),
      );
    });

    test(".checkout() while execution fails should throw GitCheckoutFailure.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        git.checkout("", path: "<path>"),
        throwsA(const TypeMatcher<GitCheckoutFailure>()),
      );
    });

    test(".reverseCheckout() while execution fails should throw GitReverseCheckoutFailure.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        git.reverseCheckout("<path>"),
        throwsA(const TypeMatcher<GitReverseCheckoutFailure>()),
      );
    });

    test(".restore() while execution fails should throw GitRestoreFailure.", () async {
      when(() => program.run(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramFailure(42, ""));

      await expectLater(
        git.restore("<path>"),
        throwsA(const TypeMatcher<GitRestoreFailure>()),
      );
    });

    test(".findCommit() while executable does not exist should return null.", () async {
      when(() => program.start(any(), any(), workingDirectory: "<path>")).thenThrow(ProgramNotFound());

      final line = await git.findCommit("6296b4600", path: "<path>");

      expect(line, null);
    });

    test(".findCommit(message) while message is not found and executable fails should throw GitLogFailure.", () async {
      final process = MockProcess();

      when(() => process.stdout).thenAnswer((_) => Stream<List<int>>.empty());
      when(() => process.stderr).thenAnswer((_) => Stream<List<int>>.empty());
      when(() => process.kill()).thenAnswer((_) => true);
      when(() => process.exitCode).thenAnswer((_) async => 42);
      when(() => program.start(any(), any(), workingDirectory: "<path>")).thenAnswer((_) async => process);

      await expectLater(
        git.findCommit("6296b4600", path: "<path>"),
        throwsA(const TypeMatcher<GitLogFailure>()),
      );
    });

    test(".findCommit(message) while operation takes longer than 20 seconds should stop and return null.", () async {
      final process = MockProcess();

      when(() => process.stdout)
          .thenAnswer((_) => Stream<List<int>>.fromFuture(Future.delayed(const Duration(seconds: 21), () => [])));
      when(() => process.stderr).thenAnswer((_) => Stream<List<int>>.empty());
      when(() => process.kill()).thenAnswer((_) => false);
      when(() => process.exitCode).thenAnswer((_) async => 0);
      when(() => program.start(any(), any(), workingDirectory: "<path>")).thenAnswer((_) async => process);

      final line = await git.findCommit("6296b4600", path: "<path>");

      expect(line, null);
    }, timeout: Timeout(Duration(seconds: 20 + 10)));

    test(".findCommit(message) while message is not in output should return null.", () async {
      final process = MockProcess();

      when(() => process.stdout).thenAnswer(
          (_) => Stream<List<int>>.value("This is a test where there is no commit-hash to be found".codeUnits));
      when(() => process.stderr).thenAnswer((_) => Stream<List<int>>.empty());
      when(() => process.kill()).thenAnswer((_) => false);
      when(() => process.exitCode).thenAnswer((_) async => 0);
      when(() => program.start(any(), any(), workingDirectory: "<path>")).thenAnswer((_) async => process);

      final line = await git.findCommit("6296b4600", path: "<path>");

      expect(line, null);
    });

    test(".findCommit(message) while message is in output should return line containing message.", () async {
      final process = MockProcess();

      when(() => process.stdout).thenAnswer((_) => Stream<List<int>>.value(
          "Some line 7e79aead9\nSome other line e0de3573f\nThe one line 6296b4600\n".codeUnits));
      when(() => process.stderr).thenAnswer((_) => Stream<List<int>>.empty());
      when(() => process.kill()).thenAnswer((_) => false);
      when(() => process.exitCode).thenAnswer((_) async => 0);
      when(() => program.start(any(), any(), workingDirectory: "<path>")).thenAnswer((_) async => process);

      final line = await git.findCommit("6296b4600", path: "<path>");

      expect(line, "The one line 6296b4600");
    });
  });
}
