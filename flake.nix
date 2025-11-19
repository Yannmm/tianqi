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

      in {
        devShells.default = pkgs.mkShellNoCC {
          name = "ohos-flutter-dev";

          buildInputs = with pkgs; [
              jdk17
              git # Needed for the shellHook to clone the SDK
              android-sdk
              cocoapods
          ];

          ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
          ANDROID_HOME = "${android-sdk}/share/android-sdk";
          ANDROID_AVD_HOME = "${android-sdk}/share/android-sdk/.android/avd";
          ANDROID_EMULATOR_HOME = "${android-sdk}/share/android-sdk/.android";

          shellHook = ''
            # Source the setup script to manage the custom Flutter SDK.
            # This will export FLUTTER_ROOT and add the correct SDK to the PATH.
            # 3.22.1-ohos-1.0.2
            # 3.27.5-ohos-1.0.0
            source ./setup-flutter.sh 3.27.5-ohos-1.0.0

            # --- OpenHarmony/DevEco Studio Environment ---
            export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac environment
            export DEVECO_SDK_HOME=$TOOL_HOME/sdk # command-line-tools/sdk
            export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH
            export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH
            export PATH=$TOOL_HOME/tools/node/bin:$PATH

            # Verify flutter version
            flutter --version
          '';
        };
      }
    );
}