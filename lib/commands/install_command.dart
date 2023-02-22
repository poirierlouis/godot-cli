import 'dart:io';

import 'package:args/args.dart';
import 'package:gd/commands/guard_command.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/platform_path.dart';
import 'package:gd/services/git_service.dart';
import 'package:gd/services/scons_service.dart';
import 'package:gd/terminal.dart';
import 'package:gd/ui/core_ui.dart';
import 'package:gd/ui/install_ui.dart';
import 'package:path/path.dart' as p;

class Repository {
  const Repository({required this.user, required this.name});

  final String user;
  final String name;

  String get url => "https://github.com/$user/$name.git";
  String get domain => "$user/$name";
}

class InstallCommand extends GuardCommand {
  static const godotEngineGodot = Repository(user: "godotengine", name: "godot");
  static const godotEngineGodotCpp = Repository(user: "godotengine", name: "godot-cpp");
  static const godotEngineGodotCppTest = Repository(user: "godotengine", name: "godot-cpp/test");

  InstallCommand(final CoreUi ui) : super(ui) {
    argParser.addOption(
      "target",
      defaultsTo: "master",
      help: "Version of Godot to target. It will fetch and pull the latest commit when targeting 'master':",
      allowedHelp: {
        "master": "Pull from HEAD of 'master' branch.",
        "commit-hash": "Pull at 'commit-hash' (from godotengine/godot). "
            "It will look for synchronous upstream within godotengine/godot-cpp for you.",
      },
    );
    argParser.addOption(
      "mode",
      defaultsTo: "template_debug",
      help: "Mode to build sources, equivalent to 'target' with scons's command line.",
      allowed: ["editor", "template_debug", "template_release"],
    );
  }

  @override
  final name = "install";
  @override
  final description = "Setup your environment with Godot sources required to develop GDExtensions.";
  @override
  final argParser = ArgParser(usageLineLength: 80);

  final GitService git = GitService.instance;
  final SConsService scons = SConsService.instance;
  final InstallUi ui = InstallUi();
  late final Directory appData;

  @override
  Future<void> run() async {
    if (!await canActivate()) {
      return;
    }
    if (argResults == null) {
      return;
    }
    appData = await getAppData();

    final target = argResults!["target"] as String;
    final mode = argResults!["mode"] as String;
    final repository = godotEngineGodotCpp;
    final destination = Directory(p.join(appData.path, "godot-cpp"));
    final hasRepository = await destination.exists();
    bool isHeadDetached = false;

    ui.withRepository(repository);
    try {
      if (!hasRepository) {
        await cloneRepository(repository, destination);
      } else {
        await resolveRepository(repository, destination);
        await pullRepository(repository, destination);
      }
      if (target != "master") {
        isHeadDetached = await setupTargetRepository(repository, destination, target);
        if (!isHeadDetached) {
          Terminal.clearLines(1);
          ui.printCommitNotFound(target);
          return;
        }
      }
      await build(destination, mode);
      ui.withRepository(godotEngineGodotCppTest);
      if (Terminal.promptQuestion("${"[?]".blue} ${"Do you want to compile /test directory (Y/n):".bold}")) {
        await build(Directory(p.join(destination.path, "test")), mode);
      } else {
        Terminal.clearLines(1);
        ui.printIgnored();
      }
      ui.withRepository(repository);
    } catch (_) {}
    try {
      if (isHeadDetached) {
        await git.reverseCheckout(destination.path);
      }
    } catch (_) {}
  }

  /// Clones [repository] at [destination] directory.
  Future<void> cloneRepository(final Repository repository, final Directory destination) async {
    try {
      await Terminal.showInfiniteLoader(
        ui.cloning(),
        task: git.clone(repository.url, path: destination.path),
      );
      Terminal.clearLines(1);
      ui.printCloned();
    } on GitCloneFailure catch (error) {
      Terminal.clearLines(1);
      ui.printCloningFailure(error);
      rethrow;
    }
  }

  /// Tests that repository's working tree is clean to be updated from remote branch.
  /// Restores repository when there is modifications.
  Future<void> resolveRepository(final Repository repository, final Directory destination) async {
    try {
      final status = await Terminal.showInfiniteLoader(
        ui.checkingStatus(),
        task: git.status(destination.path),
      );

      if (status) {
        Terminal.clearLines(1);
        ui.printCheckedStatus();
        return;
      }
      await Terminal.showInfiniteLoader(
        ui.restoring(),
        task: git.restore(destination.path),
      );
      ui.printRestored();
    } on GitRestoreFailure catch (error) {
      Terminal.clearLines(1);
      ui.printRestoringFailure(error);
      rethrow;
    }
  }

  /// Pulls [repository] at [destination] directory.
  Future<void> pullRepository(final Repository repository, final Directory destination) async {
    try {
      await Terminal.showInfiniteLoader(
        ui.pulling(),
        task: git.pull(destination.path),
      );
      Terminal.clearLines(1);
      ui.printPulled();
    } on GitPullFailure catch (error) {
      Terminal.clearLines(1);
      ui.printPullingFailure(error);
      rethrow;
    }
  }

  /// Checkouts commit of [repository] at [destination] directory, based on commit [target] from `godotengine/godot`.
  ///
  /// Returns true when checkout succeeded (meaning HEAD is detached).
  Future<bool> setupTargetRepository(
    final Repository repository,
    final Directory destination,
    final String target,
  ) async {
    final commitLog = await Terminal.showInfiniteLoader(
      ui.searching(),
      task: git.findCommit(
        "gdextension: Sync with upstream commit $target",
        path: destination.path,
        file: "gdextension/extension_api.json",
      ),
    );

    if (commitLog == null) {
      Terminal.clearLines(1);
      ui.printCommitNotFound(target);
      return false;
    }
    final commit = commitLog.substring(0, commitLog.indexOf(" "));

    await checkoutRepository(repository, destination, commit);
    return true;
  }

  /// Checkouts [commit] of [repository] at [destination] directory.
  Future<void> checkoutRepository(
    final Repository repository,
    final Directory destination,
    final String commit,
  ) async {
    try {
      Terminal.clearLines(1);
      await Terminal.showInfiniteLoader(
        ui.checkingOut(),
        task: git.checkout(commit, path: destination.path),
      );
      Terminal.clearLines(1);
      ui.printCheckedOut();
    } on GitCheckoutFailure catch (error) {
      Terminal.clearLines(1);
      ui.printCheckingOutFailure(commit, error);
      rethrow;
    }
  }

  /// Builds sources at [destination] directory with [mode].
  ///
  /// [mode] can be `editor`, `template_debug` or `template_release`.
  ///
  /// Throws a [BuildFailure] when it failed.
  Future<void> build(
    final Directory destination, [
    final String mode = "editor",
  ]) async {
    try {
      await Terminal.showInfiniteLoader(
        ui.building(),
        task: scons.build(destination.path, target: mode),
      );
      Terminal.clearLines(1);
      ui.printBuilt();
    } on BuildFailure catch (error) {
      Terminal.clearLines(1);
      ui.printBuildingFailure(error);
      rethrow;
    }
  }
}
