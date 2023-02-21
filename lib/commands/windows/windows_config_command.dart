import 'package:gd/commands/config_command.dart';

/// Command to configure global application's variables, such as paths to binary of programs.
class WindowsConfigCommand extends ConfigCommand {
  WindowsConfigCommand() : super(["Git", "Python", "VisualStudio", "MinGW"]);
}
