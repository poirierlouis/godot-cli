import 'package:gd/commands/config_command.dart';

/// Command to configure global application's variables, such as paths to binary of programs.
class LinuxConfigCommand extends ConfigCommand {
  LinuxConfigCommand() : super(["Git", "Python", "GCC", "Clang"]);
}
