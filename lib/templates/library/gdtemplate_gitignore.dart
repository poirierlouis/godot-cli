import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';

class GDTemplateGitIgnore extends GDTemplateFile {
  @override
  String get fileName => ".gitignore";

  @override
  String get path => "";

  @override
  String generate(final GDTemplateData data) {
    return """
# Generated directories with binaries
build
bin

# Godot 4+ specific ignores
.godot/

# Godot-specific ignores
.import/
export.cfg
export_presets.cfg
# Dummy HTML5 export presets file for continuous integration
!.github/dist/export_presets.cfg

# Imported translations (automatically generated from CSV files)
*.translation

# Mono-specific ignores
.mono/
data_*/
mono_crash.*.json

# System/tool-specific ignores
.directory
*~
""";
  }
}
