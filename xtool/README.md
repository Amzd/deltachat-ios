# xtool setup

Run xtool commands from `/home/runner/work/deltachat-ios/deltachat-ios/xtool`.

## Create the generated link tree

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/xtool
./setup.sh
```

This initializes the core submodule if needed and recreates the generated symlinked SwiftPM layout from `/home/runner/work/deltachat-ios/deltachat-ios/deltachat-ios.xcodeproj/project.pbxproj`. The generated `Config`, `Support`, and `Targets` trees are intentionally untracked, and the Xcode project stays the source of truth for file membership.

## Build the Rust core first

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/scripts
./build-core.sh
```

`xtool` links against `/home/runner/work/deltachat-ios/deltachat-ios/deltachat-ios/libraries/libdeltachat.a`, so that archive must exist before building from `xtool`.

## Build with xtool

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/xtool
./setup.sh
xtool dev build
```

Notes:
- App Clip is intentionally not part of the xtool package.
- The xtool package mirrors the current multi-target Xcode source membership with generated per-target symlinks, so shared files can stay shared without changing the Xcode project.
- Run `./setup.sh` again after Xcode target membership or resource membership changes.
