{
  description = "xdg-open replacement for WSL";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    flake-utils,
    nixpkgs,
    poetry2nix,
  }: let
    supportedSystems = ["x86_64-linux"];
    projectDir = ./.;
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          poetry2nix.overlay
        ];
      };
      pythonEnv = pkgs.poetry2nix.mkPoetryEnv {
        inherit projectDir;
        editablePackageSources.xdg_open_wsl = ./xdg_open_wsl;
      };
    in rec {
      devShells.default = pythonEnv;
    });
}
