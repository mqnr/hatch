{
  description = "Hatch: Project management software";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

  forEachSystem = f:
    nixpkgs.lib.genAttrs supportedSystems (system:
      f { pkgs = import nixpkgs { inherit system; }; }
    );
  in
  {
    devShells = forEachSystem ({ pkgs }: {
      default = pkgs.mkShell {
        buildInputs = [
          pkgs.rustc
          pkgs.cargo
          pkgs.rust-analyzer
          pkgs.zlib
          pkgs.openssl
        ];
      };
    });

    packages = forEachSystem ({ pkgs }: {
      default = pkgs.rustPlatform.buildRustPackage {
        pname = "hatch";
        version = "0.1.0";
        src = ./.;

        cargoLock.lockFile = ./Cargo.lock;

        meta = with pkgs.lib; {
          description = "Hatch project management software";
          license = licenses.asl20;
          homepage = "https://github.com/mqnr/hatch";
        };
      };
    });
  };
}
