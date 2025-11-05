{
  description = "Development shell using customized Flutter SDK (pinned to 3.22.1-ohos-1.0.1)";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };
  
  outputs = { self, nixpkgs, flake-utils, android-nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };

        android-sdk = android-nixpkgs.sdk.${system} (sdkPkgs: with sdkPkgs; [
          cmdline-tools-latest
          build-tools-30-0-3
          platform-tools
          platforms-android-34
          platforms-android-32
          platforms-android-33
          platforms-android-31
          platforms-android-29
          platforms-android-28
          platforms-android-30
          emulator
        ] ++ pkgs.lib.optionals (system == "aarch64-darwin") [
          system-images-android-34-default-arm64-v8a
        ]);

        # Flutter will be downloaded to a writable location in shellHook
        # No need to fetch it during build time since it's stored outside Nix store

      in {
        devShells.default = pkgs.mkShellNoCC {
          name = "ohos-flutter-dev";

          buildInputs = with pkgs; [
              jdk17
              git
              android-sdk
              cocoapods
          ];

          ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
          ANDROID_HOME = "${android-sdk}/share/android-sdk";
          ANDROID_AVD_HOME = "${android-sdk}/share/android-sdk/.android/avd";
          ANDROID_EMULATOR_HOME = "${android-sdk}/share/android-sdk/.android";

          shellHook = ''
            # Download Flutter to a writable location outside Nix store
            FLUTTER_DIR="$PWD/.cache/flutter_sdk"
            FLUTTER_REV="e3905a2a5f87102abe733f8a5970c213ccc3825e"
            FLUTTER_URL="https://gitcode.com/openharmony-tpc/flutter_flutter.git"
            
            # Clone Flutter if it doesn't exist or update it if needed
            if [ ! -d "$FLUTTER_DIR" ]; then
              echo "📥 Cloning Flutter SDK to $FLUTTER_DIR..."
              git clone "$FLUTTER_URL" "$FLUTTER_DIR"
              cd "$FLUTTER_DIR"
              git checkout "$FLUTTER_REV"
              cd - > /dev/null
            else
              # Check if we're on the correct revision
              cd "$FLUTTER_DIR"
              CURRENT_REV=$(git rev-parse HEAD 2>/dev/null || echo "")
              if [ "$CURRENT_REV" != "$FLUTTER_REV" ]; then
                echo "🔄 Updating Flutter SDK to correct revision..."
                git fetch origin
                git checkout "$FLUTTER_REV"
              fi
              cd - > /dev/null
            fi
            
            # Set Flutter environment
            export FLUTTER_ROOT="$FLUTTER_DIR"
            export PATH="$FLUTTER_DIR/bin:$PATH"
            
            # Set cache directories
            export FLUTTER_CACHE_DIR="$PWD/.cache/flutter_sdk_cache"
            mkdir -p "$FLUTTER_CACHE_DIR"
            
            export PUB_CACHE="$PWD/.cache/pub_cache"
            mkdir -p "$PUB_CACHE"

            export PUB_HOSTED_URL=https://pub.flutter-io.cn
            export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

            export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac环境
            export DEVECO_SDK_HOME=$TOOL_HOME/sdk # command-line-tools/sdk
            export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH # command-line-tools/ohpm/bin
            export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH # command-line-tools/hvigor/bin
            export PATH=$TOOL_HOME/tools/node/bin:$PATH # command-line-tools/tool/node/bin

            echo "✅ Custom Flutter SDK and Caches initialized. Flutter will now download Dart SDK."
            flutter --version
          '';
        };
      }
    );
}