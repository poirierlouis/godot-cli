import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';

class GDTemplateRegisterTypesCpp extends GDTemplateFile {
  @override
  String get fileName => "register_types.cpp";

  @override
  String get path => "src";

  @override
  String generate(final GDTemplateData data) {
    return """
#include "register_types.h"

#include <gdextension_interface.h>

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

#include "${data.libraryName}.h"

using namespace godot;

void initialize_${data.libraryName}_module(ModuleInitializationLevel p_level) {
  if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
    return;
  }

  ClassDB::register_class<${data.className}>();
}

void uninitialize_${data.libraryName}_module(ModuleInitializationLevel p_level) {
  if (p_level != MODULE_INITIALIZATION_LEVEL_SCENE) {
    return;
  }
}

extern "C" {
// Initialization.
GDExtensionBool GDE_EXPORT ${data.libraryName}_library_init(const GDExtensionInterface *p_interface, GDExtensionClassLibraryPtr p_library, GDExtensionInitialization *r_initialization) {
  godot::GDExtensionBinding::InitObject init_obj(p_interface, p_library, r_initialization);

  init_obj.register_initializer(initialize_${data.libraryName}_module);
  init_obj.register_terminator(uninitialize_${data.libraryName}_module);
  init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);

  return init_obj.init();
}
}
""";
  }
}
