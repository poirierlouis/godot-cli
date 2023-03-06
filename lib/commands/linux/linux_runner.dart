import 'package:args/command_runner.dart';
import 'package:gd/commands/linux/linux_config_command.dart';
import 'package:gd/commands/linux/linux_doctor_command.dart';
import 'package:gd/ui/core_ui.dart';

Future<CommandRunner> createLinuxRunner(final CoreUi ui, final CommandRunner runner) async {
  runner
    ..addCommand(LinuxConfigCommand())
    ..addCommand(LinuxDoctorCommand());
  return runner;
}
