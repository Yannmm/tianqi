{
  description = "Development shell using customized Flutter SDK (pinned to 3.22.1-ohos-1.0.1)";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
    custom-flutter = {
      url = "git+https://gitcode.com/openharmony-tpc/flutter_flutter.git?rev=e3905a2a5f87102abe733f8a5970c213ccc3825e";
      flake = false;
    };
  };
  
  outputs = { self, nixpkgs, flake-utils, android-nixpkgs, custom-flutter, ... }:
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

        flutterSdk = pkgs.runCommand "custom-flutter-sdk" { } ''
          cp -r ${custom-flutter} $out
        '';
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
            export FLUTTER_ROOT=${flutterSdk}
            export PATH=${flutterSdk}/bin:$PATH
            export PUB_CACHE=./.cache/pub_cache
            export PUB_HOSTED_URL=https://pub.flutter-io.cn
            export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

            export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac环境
            export DEVECO_SDK_HOME=$TOOL_HOME/sdk # command-line-tools/sdk
            export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH # command-line-tools/ohpm/bin
            export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH # command-line-tools/hvigor/bin
            export PATH=$TOOL_HOME/tools/node/bin:$PATH # command-line-tools/tool/node/bin

            echo "✅ Using custom Flutter SDK (3.22.1-ohos-1.0.1) from: ${flutterSdk}"
            flutter --version || true
          '';
        };
      }
    );
}
