import 'package:path/path.dart' as p;

/// Sets of data used to generate template files.
class GDTemplateData {
  const GDTemplateData({
    required this.libraryName,
    required this.godotCppDir,
  });

  /// Lower-case name of the library (e.g. "example").
  final String libraryName;

  /// Absolute path to godot-cpp directory.
  final String godotCppDir;

  /// Absolute path to godot-cpp gdextension directory.
  String get gdExtensionDir => p.join(godotCppDir, "gdextension");

  /// Absolute path to godot-cpp bindings directory.
  String get bindingsDir => godotCppDir;

  /// Class name of the library (e.g. "Example").
  String get className => "${libraryName[0].toUpperCase()}${libraryName.substring(1).toLowerCase()}";
}
