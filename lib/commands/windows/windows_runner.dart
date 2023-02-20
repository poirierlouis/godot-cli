import 'package:args/command_runner.dart';
import 'package:gd/commands/windows/windows_doctor_command.dart';
import 'package:gd/platform_path.dart';
import 'package:gd/ui/core_ui.dart';

Future<CommandRunner> createWindowsRunner(final CoreUi ui, final CommandRunner runner) async {
  final appData = await getAppData();

  runner..addCommand(WindowsDoctorCommand());
  return runner;
}
