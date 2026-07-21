{
  description = "m3l6h's custom tmux configuration packaged as a flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    sessionx = {
      url = "github:m3l6h/tmux-sessionx?ref=tmuxinator-args";
      # url = "/home/m3l6h/files/dev/omerxx/tmux-sessionx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      home-manager,
      impermanence,
      ...
    }@inputs:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      pname = "tmux";
      version = "0.2.1";

      homeModule = import ./modules {
        inherit inputs pname;
      };

      impermanenceModule = impermanence.nixosModules.impermanence;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      inherit systems;

      perSystem =
        {
          pkgs,
          ...
        }@args:
        rec {
          packages."m3l6h-${pname}-build-dotfiles" =
            let
              module = homeModule;
              test = import ./tests/default.test.nix (
                args
                // {
                  inherit
                    pname
                    home-manager
                    module
                    impermanenceModule
                    ;
                }
              );
            in
            test.driver;

          checks."m3l6h-${pname}-test" =
            pkgs.runCommand "m3l6h-${pname}-test-run"
              {
                nativeBuildInputs = [ packages."m3l6h-${pname}-build-dotfiles" ];
              }
              ''
                touch $out  # Create an empty output file to satisfy Nix
                ${packages."m3l6h-${pname}-build-dotfiles"}/bin/nixos-test-driver
              '';
        };

      flake = {
        inherit homeModule version;
        homeModules.default = homeModule;
      };
    };
}
