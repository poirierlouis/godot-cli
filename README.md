# Godot CLI

[![Version: 0.2.0](https://img.shields.io/github/v/release/poirierlouis/godot-cli?label=version&sort=semver)](https://github.com/poirierlouis/godot-cli/releases)
[![License: MIT](https://img.shields.io/github/license/poirierlouis/godot-cli)](https://github.com/poirierlouis/godot-cli/blob/master/LICENSE)
![Platforms: windows | linux](https://img.shields.io/badge/platforms-windows%20|%20linux-blue)
[![Donate](https://img.shields.io/badge/donate-buy%20me%20a%20coffee-yellow)](https://www.buymeacoffee.com/lpfreelance)

A command line interface to setup your environment to work with Godot sources and GDExtensions.

> Not production ready (alpha stage).
> 
> It has been tested and implemented on Windows and Linux (Ubuntu), macOS shall be supported later.
> 
> It is not endorsed nor supported by Godot.

## Features

This tool is inspired by `flutter doctor` which helps Flutter developers to configure their workspace. This tool should
provide a similar experience to improve and ease the creation of GDExtension with Godot.

- Test that your system is well-configured to compile sources.
- Install godot-cpp sources.
- Build godot-cpp sources.
- Create a GDExtension from a minimal C++ template.

## Roadmap

- add detection to build on Android
- add detection to build on iOS
- add detection to build on Web
- add alternative detection of MinGW on Windows.
- add alternative detection of Clang on Linux.
- add support for macOS
- add tests

## Getting started

- Download the latest [release](https://github.com/poirierlouis/godot-cli/releases).
- Extract binary somewhere on your system.
- Add path to the binary in your PATH environment variable.

This tool stores data in:
```
Windows: %APPDATA%\Roaming\gd-cli
Linux: $HOME/.gd-cli
```

## Usage

> Run the command 'doctor' as Administrator / root.

Start with this command to setup your workspace:
```shell
$ gd doctor
```

Once everything is well-configured (no issues), you can install a version of [godotengine/godot-cpp] (here v4.0-rc3).
This will take sometime to download repository and build sources.

```shell
$ gd install --target 7e79aead99a53ee7cdf383add9a6a2aea4f15beb
```
> **Note:** this commit is known from the official blog article for the release of the [v4.0-rc3].

Now you are ready to generate a GDExtension with:

```shell
$ gd create --name awesome --output gd-extensions/
```

Move into `gd-extensions/awesome/` and build your extension with:

```shell
$ scons target=template_debug
```
> **Note:** something like `gd build` from the GDExtension directory might be implemented in the future.

You can copy the `bin/` directory along with the `awesome.gdextension` to your Godot project and use your GDExtension.

See more about each commands below.

## Commands

### help command

```shell
$ gd help
```

Show usage of this program with all commands you can use.

### doctor command

> Need to be run as Administrator / root.

```shell
$ gd doctor
```

Use it to detect all required tools on your system. It will run an analysis and report to you whenever
a tool is detected and ready or not.

### config command

`gd doctor` will expect tools to be in your PATH environment variable to be executed. However, if you are using a tool 
at a specific path, it may not be detected by default. You can tell `gd` where to search for using the following 
command:

```shell
$ gd config --program <program> --path <absolute-path>
```

Define a `program` and an `absolute-path` to tell `gd` where to find the binary to execute.

```shell
$ gd config --program <program> --remove
```

Remove `program` and path value to fall back to default behavior with PATH environment variable.

**Note:** you can run `gd help config` to list allowed programs. It will be listed according to your OS.

### install command

```shell
$ gd install [--target <master|commit>] [--mode <editor|template_debug|template_release>]
```

It will install the repository [godotengine/godot-cpp] and pull the latest commit.
It will build the sources using `mode` as scons target.
You can optionally build the sources of the `/test` example when asked for.

Option `target` is used to checkout the HEAD of branch `master` (default) or to checkout a commit-hash of branch 
`master`.

When using a commit-hash, you MUST enter a hash from the repository [godotengine/godot]. It will look which commit in 
[godotengine/godot-cpp] has been sync with upstream. You should only use commit-hash as mentioned from [articles] when 
a build is released.

#### Example:
- you're using the build of `Godot v4.0-rc3`.
- this release is built from commit [7e79aead9].
- you need [godotengine/godot-cpp] to be in sync with commit [7e79aead9].
- you look for sync upstream within commit's message, here from commit [c1ff169bf]:
> gdextension: Sync with upstream commit **7e79aead99a53ee7cdf383add9a6a2aea4f15beb**
- you checkout commit [c1ff169bf] to be in sync with your version of Godot.
- you can finally compile sources of [godotengine/godot-cpp].

This example is what you DON'T have to do with `gd`. You only need to provide the commit-hash of the release you're 
using to prevent any errors and incompatibilities of different versions.

Below is the command you can run instead using the previous example:
```shell
$ gd install --target 7e79aead99a53ee7cdf383add9a6a2aea4f15beb
```

### create command

```shell
$ gd create --name <library-name> --output <path-output>
```

It will generate a GDExtension with a minimal C++ template. It will create the directory `<library-name>` inside the 
path `<path-output>` for you.

This template is based on [godotengine/godot-cpp/test] with less code. It has the advantage of renaming declarations
with `<library-name>` for you.

Here is an example of the output after running this command:

```shell
$ gd create --name awesome --output folder/
```

```
folder/
└── awesome/
    ├── src/
    │   ├── register_types.cpp
    │   ├── register_types.h
    │   ├── awesome.cpp
    │   └── awesome.h
    ├── .gitignore
    ├── CMakeLists.txt
    ├── SConstruct
    └── awesome.gdextension
```

This will include the following declaration:
- an `Awesome` Godot class inheriting from `Object`.
- `initialize_awesome_module` and `uninitialize_awesome_module`
- declaration of the file `.gdextension`.

It will output the binaries in the `bin/` directory:

```
folder/
└── awesome/
    ├── bin/
    │   └── libgdawesome.[os].[target].[arch].[ext]
    └── ...
```

<!-- Table of links -->
[godotengine/godot-cpp]: https://github.com/godotengine/godot-cpp
[godotengine/godot]: https://github.com/godotengine/godot
[godotengine/godot-cpp/test]: https://github.com/godotengine/godot-cpp/tree/master/test

[7e79aead9]: https://github.com/godotengine/godot/commit/7e79aead99a53ee7cdf383add9a6a2aea4f15beb
[c1ff169bf]: https://github.com/godotengine/godot/commit/c1ff169bf3ad5f13457eda7cd5a424b894adbb05

[articles]: https://godotengine.org/blog/
[v4.0-rc3]: https://godotengine.org/article/release-candidate-godot-4-0-rc-3/
