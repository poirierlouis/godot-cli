/// Defines environment configuration to build / run application.
///
/// Add environment variable `FLAVOR=<value>` to select flavor of application to run with.
///
/// *Note:* Dart VM while running tests does not support environment variables. Thus, FLAVOR default to TEST and any
/// execution during development MUST declare `FLAVOR=DEV` using VM options `-D`:
///
/// ```shell
/// $ dart -DFLAVOR=DEV run bin/gd.dart
/// ```
///
/// Option must be at the end of the command when compiling:
/// ```shell
/// $ dart compile exe bin/gd.dart -DFLAVOR=PROD
/// ```
///
/// Accepts TEST (default), DEV and PROD.
const String _kFlavor = String.fromEnvironment("FLAVOR", defaultValue: "TEST");

/// Whether application is running in test environment (used with `dart test`).
const bool kTestMode = _kFlavor == "TEST";

/// Whether application is running in development environment (used with `dart run`).
const bool kDebugMode = _kFlavor == "DEV";

/// Whether application is running in production environment (used with `dart compile exe`).
const bool kReleaseMode = _kFlavor == "PROD";

/// Gets environment variable `GODOT_CLI_HOME` depending on environment such as:
/// TEST: `GODOT_CLI_HOME_TEST`
/// DEV:  `GODOT_CLI_HOME_DEV`
/// PROD: `GODOT_CLI_HOME`
const String kHome = kTestMode ? "GODOT_CLI_HOME_TEST" : (kDebugMode ? "GODOT_CLI_HOME_DEV" : "GODOT_CLI_HOME");
