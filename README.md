# Godot CLI

![Platform Windows](https://img.shields.io/badge/platform-Windows-blue)
[![License MIT](https://img.shields.io/github/license/poirierlouis/godot_cli)](https://github.com/poirierlouis/godot_cli/blob/master/LICENSE)
[![Donate](https://img.shields.io/badge/donate-buy%20me%20a%20coffee-yellow)](https://www.buymeacoffee.com/lpfreelance)

A command line interface to setup your environment to work with Godot sources and GDExtensions.

## Features

- Test that your system is well-configured to compile sources.
- Install Godot sources.
- Build Godot sources.
- Create a GDExtension from an example template.
- ...

## Getting started

- Download the latest [release](https://github.com/poirierlouis/godot_cli/releases).
- Extract binary somewhere on your system.
- Add path to the binary in your PATH environment variable.

You can prepare your environment using this command:
```shell
$ gd doctor
```

> You must run this command without any issues in order to use all other features.

## Usage

### help command

```shell
$ gd help
```

Show usage of this program with all commands you can use.

### doctor command

```shell
$ gd doctor
```

Use it to detect all required tools on your system. It will run an analysis and report to you whenever
a tool is detected and ready or not.
