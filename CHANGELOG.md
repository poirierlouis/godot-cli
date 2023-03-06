# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- check on 'pip' installation to abort and prevent user when program is not found.

### Fixed
- terminal with a reset of ANSI escape sequences when aborting.

------------------------

## [0.1.2] - 2023-02-25
### Fixed
- path to 'godot-cpp' using GODOT_CLI_HOME in template file CMakeLists.

------------------------

## [0.1.1] - 2023-02-23
### Changed
- output of error logs to stderr and warning logs to stdout.

### Fixed
- template file CMakeLists to define path using GODOT_CLI_HOME environment variable.
- template file SConstruct to always fix path with Windows-style.

------------------------

## [0.1.0] - 2023-02-23
### Added
- command 'doctor' on Windows to detect required tools.
- command 'config' on Windows to configure custom path instead of PATH environment variable.
- command 'install' to setup repository 'godot-cpp' and build sources.
- command 'create' to generate a GDExtension using a minimal C++ template.
- global option '--version' to show version number of this tool.

<!-- New release template -->
<!--

------------------------

## [X.Y.Z] - YYYY-MM-DD
### Added
- for new features.

### Changed
- for changes in existing functionality.

### Deprecated
- for soon-to-be removed features. 

### Removed
- for now removed features. 

### Fixed
- for any bug fixes.

### Security
- in case of vulnerabilities.

-->

<!-- Table of releases -->
[Unreleased]: https://github.com/poirierlouis/godot-cli/compare/v0.1.2...HEAD
[0.1.2]: https://github.com/poirierlouis/godot-cli/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/poirierlouis/godot-cli/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/poirierlouis/godot-cli/releases/tag/v0.1.0

<!-- Table of issues -->
<!-- [issue #1]: https://github.com/poirierlouis/godot-cli/issues/1 -->
