#!/bin/sh
set -eu

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

cd "$ROOT"
git submodule update --init --recursive -- deltachat-ios/libraries/deltachat-core-rust

cd "$ROOT/xtool"
ruby ./sync-xcode-layout.rb
