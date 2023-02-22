import 'package:gd/templates/gdtemplate_class_data.dart';

class GDTemplateClassCpp {
  const GDTemplateClassCpp({required this.fileName, required this.data, this.path = "src"});

  final String fileName;
  final String path;
  final GDTemplateClassData data;

  String generate() {
    return """
#include "${data.includeName}.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>

using namespace godot;

String ${data.className}::_to_string() const {
  return "[ GDExtension::${data.className} <--> Instance ID:" + uitos(get_instance_id()) + " ]";
}

void ${data.className}::_bind_methods() {
  //
  // Functions
  //
  ClassDB::bind_method(D_METHOD("dummy_func"), &${data.className}::dummy_func);

  //
  // Signals
  //
  ADD_SIGNAL(MethodInfo("dummy_signal", PropertyInfo(Variant::VECTOR3, "value")));
  ClassDB::bind_method(D_METHOD("emit_dummy_signal", "value"), &${data.className}::emit_dummy_signal);

  //
  // Properties
  //
  ClassDB::bind_method(D_METHOD("get_dummy"), &${data.className}::get_dummy);
  ClassDB::bind_method(D_METHOD("set_dummy", "value"), &${data.className}::set_dummy);

  ADD_PROPERTY(PropertyInfo(Variant::VECTOR3, "dummy"), "set_dummy", "get_dummy");
}

${data.className}::${data.className}() {
  UtilityFunctions::print("${data.className}()");
}

${data.className}::~${data.className}() {
  UtilityFunctions::print("~${data.className}()");
}

//
// Functions
//
void ${data.className}::dummy_func() const {
  UtilityFunctions::print("  Dummy func called.");
}

//
// Signals
//
void ${data.className}::emit_dummy_signal(const Vector3 &value) {
	emit_signal("dummy_signal", value);
}

//
// Properties
//
void ${data.className}::set_dummy(const Vector3 &value) {
  dummy = value;
}

Vector3 ${data.className}::get_dummy() const {
  return dummy;
}
""";
  }
}
