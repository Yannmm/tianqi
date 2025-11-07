#!/usr/bin/env bash

# This script ensures a specific version of a custom Flutter SDK is available
# in a local, writable directory. It's intended to be sourced by a Nix shell.

set -e # Exit immediately if a command exits with a non-zero status.

# --- Configuration ---
FLUTTER_VERSION="3.22.1-ohos-1.0.1"
FLUTTER_SDK_DIR="$HOME/.cache/flutter/$FLUTTER_VERSION"
FLUTTER_REPO="https://gitcode.com/openharmony-tpc/flutter_flutter.git"

# --- SDK Setup ---
# If the SDK directory with a .git folder doesn't exist, clone it.
if [ ! -d "$FLUTTER_SDK_DIR/.git" ]; then
  echo "INFO: Custom Flutter SDK not found locally. Cloning version $FLUTTER_VERSION..."
  # Remove potentially incomplete directory before cloning
  rm -rf "$FLUTTER_SDK_DIR"
  # Clone the specific tag/branch
  git clone --depth 1 --branch "$FLUTTER_VERSION" "$FLUTTER_REPO" "$FLUTTER_SDK_DIR"
fi

# --- Environment Export ---
# Set FLUTTER_ROOT to our writable SDK directory and add it to the PATH.
export FLUTTER_ROOT="$FLUTTER_SDK_DIR"
export PATH="$FLUTTER_ROOT/bin:$PATH"

# --- Pub Cache and Mirrors ---
export PUB_CACHE="$PWD/.cache/pub_cache"
mkdir -p "$PUB_CACHE"

export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo "✅ Flutter environment configured."
echo "   - SDK Root: $FLUTTER_ROOT"
