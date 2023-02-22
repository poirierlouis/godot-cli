import 'dart:io';

import 'package:gd/services/app_service.dart';
import 'package:gd/templates/gdtemplate_class_data.dart';
import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';
import 'package:gd/templates/library/gdtemplate_cmakelists.dart';
import 'package:gd/templates/library/gdtemplate_gitignore.dart';
import 'package:gd/templates/library/gdtemplate_sconstruct.dart';
import 'package:gd/templates/library/src/gdtemplate_class_cpp.dart';
import 'package:gd/templates/library/src/gdtemplate_class_h.dart';
import 'package:gd/templates/library/src/gdtemplate_gdextension.dart';
import 'package:gd/templates/library/src/gdtemplate_register_types_cpp.dart';
import 'package:gd/templates/library/src/gdtemplate_register_types_h.dart';
import 'package:gd/terminal.dart';
import 'package:gd/ui/gdtemplate_ui.dart';
import 'package:path/path.dart' as p;

class WriteFileFailure {
  const WriteFileFailure(this.file);

  final File file;
}

/// Generates a GDExtension based on a template.
class GDTemplateService {
  static final GDTemplateService instance = GDTemplateService._();

  GDTemplateService._();

  final AppService app = AppService.instance;
  final GDTemplateUi ui = GDTemplateUi();
  final List<GDTemplateFile> files = [
    GDTemplateGitIgnore(),
    GDTemplateCMakeLists(),
    GDTemplateSConstruct(),
    //
    GDTemplateRegisterTypesH(),
    GDTemplateRegisterTypesCpp(),
  ];

  /// Generates a project's directory at [output] with [libraryName].
  Future<void> generateLibrary({required final Directory output, required final String libraryName}) async {
    if (!await output.exists()) {
      await output.create();
    }
    final src = Directory(p.join(output.path, "src"));

    if (!await src.exists()) {
      await src.create();
    }
    final data = GDTemplateData(
      libraryName: libraryName,
      godotCppDir: app.godotCpp.path,
    );
    final entryPoint = GDTemplateClassData(className: data.className);
    final header = GDTemplateClassH(fileName: "$libraryName.h", data: entryPoint);
    final source = GDTemplateClassCpp(fileName: "$libraryName.cpp", data: entryPoint);

    try {
      await Terminal.showInfiniteLoader("Generating declaration files", task: generateDeclarationFiles(output, data));
      Terminal.clearLines(1);
      ui.printDeclarationGenerated(libraryName);

      await Terminal.showInfiniteLoader("Generating class file", task: generateClassFile(output, header, source));
      Terminal.clearLines(1);
      ui.printClassGenerated(libraryName);
    } on WriteFileFailure catch (error) {
      Terminal.clearLines(1);
      ui.printWriteFileFailure(error);
    }
  }

  /// Generates files to declare a GDExtension at [output] using [data] of template.
  Future<void> generateDeclarationFiles(final Directory output, final GDTemplateData data) async {
    final extension = GDTemplateGDExtension(data.libraryName);
    final templateFiles = [...files, extension];

    for (final templateFile in templateFiles) {
      final file = File(p.join(output.path, templateFile.path, templateFile.fileName));
      final body = templateFile.generate(data);

      try {
        await file.writeAsString(body);
      } catch (_) {
        throw WriteFileFailure(file);
      }
    }
  }

  /// Generates header (.h) and source (.cpp) file of a C++ class at [output] using [header] and [source].
  Future<void> generateClassFile(
    final Directory output,
    final GDTemplateClassH header,
    final GDTemplateClassCpp source,
  ) async {
    final headerFile = File(p.join(output.path, header.path, header.fileName));
    final sourceFile = File(p.join(output.path, source.path, source.fileName));

    try {
      await headerFile.writeAsString(header.generate());
      await sourceFile.writeAsString(source.generate());
    } catch (_) {
      throw WriteFileFailure(headerFile);
    }
  }
}
