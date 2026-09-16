# xtool setup

Run xtool commands from `/home/runner/work/deltachat-ios/deltachat-ios/xtool`.

## Refresh the mirrored target layout

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/xtool
./sync-xcode-layout.rb
```

This recreates the symlinked SwiftPM target layout from `/home/runner/work/deltachat-ios/deltachat-ios/deltachat-ios.xcodeproj/project.pbxproj` and keeps the existing Xcode project as the source of truth for file membership.

## Build the Rust core first

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/scripts
./build-core.sh
```

`xtool` links against `/home/runner/work/deltachat-ios/deltachat-ios/deltachat-ios/libraries/libdeltachat.a`, so that archive must exist before building from `xtool`.

## Build with xtool

```bash
cd /home/runner/work/deltachat-ios/deltachat-ios/xtool
xtool dev build
```

Notes:
- App Clip is intentionally not part of the xtool package.
- The xtool package mirrors the current multi-target Xcode source membership with per-target symlinks, so shared files can stay shared without changing the Xcode project.
