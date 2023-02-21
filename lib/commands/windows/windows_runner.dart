import 'package:args/command_runner.dart';
import 'package:gd/commands/windows/windows_config_command.dart';
import 'package:gd/commands/windows/windows_doctor_command.dart';
import 'package:gd/ui/core_ui.dart';

Future<CommandRunner> createWindowsRunner(final CoreUi ui, final CommandRunner runner) async {
  runner
    ..addCommand(WindowsConfigCommand())
    ..addCommand(WindowsDoctorCommand());
  return runner;
}
