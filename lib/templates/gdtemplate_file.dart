import 'package:gd/templates/gdtemplate_data.dart';

/// Abstract class of a Godot Template file to implement.
abstract class GDTemplateFile {
  const GDTemplateFile();

  /// Name of the file with extension.
  String get fileName;

  /// Relative path of [this] file.
  String get path;

  /// Returns content of file using [data].
  String generate(final GDTemplateData data);
}
