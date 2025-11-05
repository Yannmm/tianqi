{
pkgs
, stdenv
, fetchgit
, version
, makeWrapper
}:
let
  sha256Map = {
    "3.16.6" = "sha256-0d3rwyqW3kxaQNMcT3la/fYh+151lCSHAW8kHJg98r8=";
    "3.22.1-ohos-1.0.1" = "sha256-jZAoHTC6uHZyFvguQmUH5n26Up5pduF753LCvEMmHVc=";
  };

  flutter = stdenv.mkDerivation {
    pname = "flutter-ohos";
    version = version;
    src = fetchgit {
      # https://gitcode.com/openharmony-tpc/flutter_flutter
      url = "https://gitcode.com/openharmony-tpc/flutter_flutter.git";
      rev = version;
      sha256 = sha256Map."${version}";
    };

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      mkdir -p $out
      cp -r . $out
    '';
  };
in {
    sdk = flutter;
    version = version;
    updateCache = ''
              flutter_dir=~/.cache/flutter/${version}
              if [ ! -d $flutter_dir ]; then
                mkdir -p $flutter_dir
                # Use git clone to preserve Git history instead of copying
                git clone --depth 1 --branch ${version} https://gitcode.com/openharmony-tpc/flutter_flutter.git $flutter_dir
                chmod -R +w $flutter_dir
              fi

              export FLUTTER_ROOT=$flutter_dir
              export PATH=$flutter_dir/bin:$PATH
              export PUB_CACHE=./.cache/pub_cache
              export PUB_HOSTED_URL=https://pub.flutter-io.cn
              export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
            '';
  }


