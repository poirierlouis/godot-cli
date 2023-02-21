import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:gd/extensions/string_utils.dart';
import 'package:gd/services/app_service.dart';

/// Abstract class with common features to execute 'config' command.
abstract class ConfigCommand extends Command {
  ConfigCommand(final List<String> allowedPrograms) {
    argParser.addOption(
      "program",
      mandatory: true,
      help: "Name of program to configure.",
      allowed: allowedPrograms,
    );
    argParser.addOption(
      "path",
      help: "Absolute path where to find binary of the program.",
    );
    argParser.addFlag(
      "remove",
      help: "Remove path of program from configuration.",
      negatable: false,
    );
  }

  @override
  final name = "config";
  @override
  final description = "Configure path of programs.";
  @override
  final argParser = ArgParser(usageLineLength: 80);

  final AppService app = AppService.instance;

  @override
  Future<void> run() async {
    if (argResults == null) {
      return;
    }
    final program = argResults!["program"] as String;
    final path = argResults!["path"] as String?;
    final remove = argResults!["remove"] as bool;

    if (remove) {
      final isRemoved = await app.removeProgram(program);

      if (isRemoved) {
        print("${"[√]".green} $program (Path removed)");
      } else {
        print("${"[!]".yellow} $program (Path not configured)");
      }
      return;
    }
    if (path == null || path.isEmpty) {
      throw UsageException("Option path is mandatory.", argParser.usage);
    }
    await app.defineProgram(program, path);
    print("${"[√]".green} $program (Path is $path)");
  }
}
