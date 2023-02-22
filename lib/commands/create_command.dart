import 'dart:io';

import 'package:args/args.dart';
import 'package:gd/commands/guard_command.dart';
import 'package:gd/services/gdtemplate_service.dart';
import 'package:gd/ui/core_ui.dart';
import 'package:path/path.dart' as p;

class CreateCommand extends GuardCommand {
  CreateCommand(final CoreUi ui) : super(ui) {
    argParser.addOption(
      "name",
      mandatory: true,
      help: "Name of your GDExtension.",
    );
    argParser.addOption(
      "output",
      mandatory: true,
      help: "Path where to create your GDExtension. "
          "A directory will be created for you with the <name> of your GDExtension.",
    );
  }

  @override
  final name = "create";
  @override
  final description = "Create a new GDExtension using a minimal template.";
  @override
  final argParser = ArgParser(usageLineLength: 80);

  final GDTemplateService templateBuilder = GDTemplateService.instance;

  @override
  Future<void> run() async {
    if (!await canActivate()) {
      return;
    }
    if (argResults == null) {
      return;
    }
    String name = argResults!["name"] as String;
    final path = argResults!["output"] as String;

    if (name.isEmpty) {
      return;
    }
    name = name.toLowerCase();
    final output = Directory(p.join(path, name));

    await templateBuilder.generateLibrary(output: output, libraryName: name);
  }
}
