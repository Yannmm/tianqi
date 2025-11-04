{
  description = "Insight Revamp";
  inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    android-nixpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, android-nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        flutterVersion = "3.22.1-ohos-1.0.1";

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };

        flutter-wrapper = pkgs.callPackage ./flutter-wrapper.nix { version = flutterVersion; };

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

        build_runner = pkgs.writeShellScriptBin "build_runner" ''
          flutter pub run build_runner build --delete-conflicting-outputs
        '';

        clean_flutter = pkgs.writeShellScriptBin "clean_flutter" ''
          flutter clean && flutter pub get
        '';

        generate_l10n = pkgs.writeShellScriptBin "generate_l10n" ''
          flutter gen-l10n
        '';
      in
      {
        devShells.default = with pkgs;
          mkShellNoCC rec {
            buildInputs = [
              jdk17
              git

              build_runner
              generate_l10n
              android-sdk
              cocoapods
              clean_flutter
            ];

            ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";
            ANDROID_HOME = "${android-sdk}/share/android-sdk";
            ANDROID_AVD_HOME = "${android-sdk}/share/android-sdk/.android/avd";
            ANDROID_EMULATOR_HOME = "${android-sdk}/share/android-sdk/.android";

            shellHook = ''
              ${flutter-wrapper.updateCache}

              export TOOL_HOME=/Applications/DevEco-Studio.app/Contents # mac环境
              export DEVECO_SDK_HOME=$TOOL_HOME/sdk # command-line-tools/sdk
              export PATH=$TOOL_HOME/tools/ohpm/bin:$PATH # command-line-tools/ohpm/bin
              export PATH=$TOOL_HOME/tools/hvigor/bin:$PATH # command-line-tools/hvigor/bin
              export PATH=$TOOL_HOME/tools/node/bin:$PATH # command-line-tools/tool/node/bin
            '';
          };

        devShells.simulator_web = import ./nix/simulator_web_shell.nix { pkgs = pkgs; };

      }
    );
}
