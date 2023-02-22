import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';

class GDTemplateRegisterTypesH extends GDTemplateFile {
  @override
  String get fileName => "register_types.h";

  @override
  String get path => "src";

  @override
  String generate(final GDTemplateData data) {
    final header = data.libraryName.toUpperCase();

    return """
#ifndef ${header}_REGISTER_TYPES_H
#define ${header}_REGISTER_TYPES_H

#include <godot_cpp/core/class_db.hpp>

using namespace godot;

void initialize_${data.libraryName}_module(ModuleInitializationLevel p_level);
void uninitialize_${data.libraryName}_module(ModuleInitializationLevel p_level);

#endif // ${header}_REGISTER_TYPES_H
""";
  }
}
