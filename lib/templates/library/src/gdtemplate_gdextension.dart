import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';

class GDTemplateGDExtension extends GDTemplateFile {
  GDTemplateGDExtension(final String libraryName) {
    fileName = "$libraryName.gdextension";
  }

  @override
  late final String fileName;

  @override
  String get path => "";

  @override
  String generate(GDTemplateData data) {
    return """
[configuration]

entry_symbol = "${data.libraryName}_library_init"

[libraries]

macos.debug = "res://bin/libgd${data.libraryName}.macos.template_debug.framework"
macos.release = "res://bin/libgd${data.libraryName}.macos.template_release.framework"
windows.debug.x86_32 = "res://bin/libgd${data.libraryName}.windows.template_debug.x86_32.dll"
windows.release.x86_32 = "res://bin/libgd${data.libraryName}.windows.template_release.x86_32.dll"
windows.debug.x86_64 = "res://bin/libgd${data.libraryName}.windows.template_debug.x86_64.dll"
windows.release.x86_64 = "res://bin/libgd${data.libraryName}.windows.template_release.x86_64.dll"
linux.debug.x86_64 = "res://bin/libgd${data.libraryName}.linux.template_debug.x86_64.so"
linux.release.x86_64 = "res://bin/libgd${data.libraryName}.linux.template_release.x86_64.so"
linux.debug.arm64 = "res://bin/libgd${data.libraryName}.linux.template_debug.arm64.so"
linux.release.arm64 = "res://bin/libgd${data.libraryName}.linux.template_release.arm64.so"
linux.debug.rv64 = "res://bin/libgd${data.libraryName}.linux.template_debug.rv64.so"
linux.release.rv64 = "res://bin/libgd${data.libraryName}.linux.template_release.rv64.so"
android.debug.x86_64 = "res://bin/libgd${data.libraryName}.android.template_debug.x86_64.so"
android.release.x86_64 = "res://bin/libgd${data.libraryName}.android.template_release.x86_64.so"
android.debug.arm64 = "res://bin/libgd${data.libraryName}.android.template_debug.arm64.so"
android.release.arm64 = "res://bin/libgd${data.libraryName}.android.template_release.arm64.so"
""";
  }
}
