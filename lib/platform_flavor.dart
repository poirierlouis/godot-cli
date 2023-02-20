/// Defines environment configuration to build / run application.
///
/// Add environment variable `FLAVOR=<value>` to select flavor to run application with.
///
/// Accepts TEST, DEV (default) and PROD.
const String _kFlavor = String.fromEnvironment("FLAVOR", defaultValue: "DEV");

/// Whether application is running in test environment (used with `dart test`).
const bool kTestMode = _kFlavor == "TEST";

/// Whether application is running in development environment (used with `dart run`).
const bool kDebugMode = _kFlavor == "DEV";

/// Whether application is running in production environment (used with `dart compile exe`).
const bool kReleaseMode = _kFlavor == "PROD";
