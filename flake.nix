{
  description = "Custom QMK keymaps for Framework 16 keyboard";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Fetch QMK with submodules
      framework-qmk = pkgs.fetchgit {
        url = "https://github.com/FrameworkComputer/qmk_firmware";
        rev = "v0.2.9";
        hash = "sha256-L0n/MyKIeo1f8FlrJnyPgi7BebnF1ky+2IFQxQB/JE0=";
        fetchSubmodules = true;
      };

      # QMK CLI packaged from PyPI
      qmk-cli = pkgs.python3Packages.buildPythonApplication rec {
        pname = "qmk";
        version = "1.1.6";
        pyproject = true;

        src = pkgs.fetchPypi {
          inherit pname version;
          hash = "sha256-3ENs26vy+M7G261FPeODK+AbrI5+nBkHXCmGbuIqi1A=";
        };

        build-system = [ pkgs.python3Packages.setuptools ];

        dependencies = with pkgs.python3Packages; [
          appdirs
          argcomplete
          colorama
          dotty-dict
          hid
          hjson
          jsonschema
          milc
          pillow
          pygments
          pyserial
          pyusb
        ];

        # Don't run tests (they need hardware)
        doCheck = false;

        meta = {
          description = "QMK CLI";
          homepage = "https://qmk.fm";
        };
      };

      # Python environment for QMK build
      pythonEnv = pkgs.python3.withPackages (ps: with ps; [
        pillow
        pygments
        hjson
        jsonschema
        hid
        setuptools
      ]);

      # Build inputs for ARM-based Framework 16 keyboard (RP2040)
      buildDeps = [
        pkgs.gcc-arm-embedded
        pkgs.gnumake
        pkgs.git
        pkgs.diffutils
        pythonEnv
        qmk-cli
      ];
    in
    {
      # Development shell - use ./build.sh to build firmware
      devShells.${system}.default = pkgs.mkShell {
        name = "framework-qmk-7mind";
        buildInputs = buildDeps;

        shellHook = ''
          export QMK_SOURCE="${framework-qmk}"
          export KEYMAP_DIR="${self}/keymaps"

          echo ""
          echo "Framework QMK build environment"
          echo "================================"
          echo ""
          echo "Build firmware:  ./build.sh"
          echo "Output:          ./framework_ansi_finger_zones.uf2"
          echo ""
        '';
      };

      # Expose source for reference
      packages.${system}.qmk-source = pkgs.stdenv.mkDerivation {
        name = "framework-qmk-source";
        src = framework-qmk;
        dontBuild = true;
        installPhase = ''
          cp -r . $out
          chmod -R u+w $out
          mkdir -p $out/keyboards/framework/ansi/keymaps/finger_zones
          cp ${./keymaps/finger_zones}/* $out/keyboards/framework/ansi/keymaps/finger_zones/
        '';
      };
    };
}
