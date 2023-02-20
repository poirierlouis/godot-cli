import 'package:args/command_runner.dart';
import 'package:gd/services/app_service.dart';
import 'package:gd/ui/core_ui.dart';

/// Prevents execution of any command until 'doctor' is executed without any issues.
abstract class GuardCommand extends Command {
  GuardCommand(this.ui);

  final AppService app = AppService.instance;
  final CoreUi ui;

  /// Whether this command can be executed?
  Future<bool> canActivate() async {
    if (app.config.isFirstRun) {
      ui.printFirstRun();
      return false;
    }
    if (app.config.issues > 0) {
      ui.printNeedFix();
      return false;
    }
    return true;
  }
}
