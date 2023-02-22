import 'package:gd/templates/gdtemplate_class_data.dart';

class GDTemplateClassH {
  const GDTemplateClassH({required this.fileName, required this.data, this.path = "src"});

  final String fileName;
  final String path;
  final GDTemplateClassData data;

  String generate() {
    return """
#ifndef ${data.headerName}_CLASS_H
#define ${data.headerName}_CLASS_H

// We don't need windows.h in this example plugin but many others do, and it can
// lead to annoying situations due to the ton of macros it defines.
// So we include it and make sure CI warns us if we use something that conflicts
// with a Windows define.
#ifdef WIN32
#include <windows.h>
#endif

#include <godot_cpp/classes/object.hpp>
#include <godot_cpp/core/binder_common.hpp>

using namespace godot;

class ${data.className} : public Object {
  GDCLASS(${data.className}, Object);

protected:
  static void _bind_methods();

  String _to_string() const;

private:
  Vector3 dummy;

public:
  ${data.className}();
  ~${data.className}();

  //
  // Functions
  //
  void dummy_func() const;

  //
  // Signals
  //
  void emit_dummy_signal(const Vector3 &value);

  //
  // Properties
  //
  void set_dummy(const Vector3 &value);
  Vector3 get_dummy() const;
};

#endif // ${data.headerName}_CLASS_H
""";
  }
}
