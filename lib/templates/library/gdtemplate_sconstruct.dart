import 'dart:io';

import 'package:gd/platform_flavor.dart';
import 'package:gd/templates/gdtemplate_data.dart';
import 'package:gd/templates/gdtemplate_file.dart';

class GDTemplateSConstruct extends GDTemplateFile {
  @override
  String get fileName => "SConstruct";

  @override
  String get path => "";

  @override
  String generate(final GDTemplateData data) {
    String platformFix = "";

    if (Platform.isWindows) {
      platformFix = "GODOT_CLI_HOME = GODOT_CLI_HOME.replace('\\\\', '\\\\\\\\')";
    }
    return """
#!/usr/bin/env python
import os
import sys

GODOT_CLI_HOME = os.environ["$kHome"]
$platformFix
GODOT_CLI_SCONS = os.path.join(GODOT_CLI_HOME, "godot-cpp", "SConstruct")

env = SConscript(GODOT_CLI_SCONS)

# For the reference:
# - CCFLAGS are compilation flags shared between C and C++
# - CFLAGS are for C-specific compilation flags
# - CXXFLAGS are for C++-specific compilation flags
# - CPPFLAGS are for pre-processor flags
# - CPPDEFINES are for pre-processor defines
# - LINKFLAGS are for linking flags

# tweak this if you want to use different folders, or more folders, to store your source code in.
env.Append(CPPPATH=["src/"])
sources = Glob("src/*.cpp")

if env["platform"] == "macos":
    library = env.SharedLibrary(
        "bin/libgd${data.libraryName}.{}.{}.framework/libgd${data.libraryName}.{}.{}".format(
            env["platform"], env["target"], env["platform"], env["target"]
        ),
        source=sources,
    )
else:
    library = env.SharedLibrary(
        "bin/libgd${data.libraryName}{}{}".format(env["suffix"], env["SHLIBSUFFIX"]),
        source=sources,
    )

Default(library)
""";
  }
}
