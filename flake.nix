# Author: Peter Dragos
# Repository: https://github.com/dragospe/python-flake-template
{
  description = "Flake to manage python workspace";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
      in
      {
        packages = {
          app = mkPoetryApplication { projectDir = self; };
          default = self.packages.${system}.app;
        };
        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.app ];
          packages = with pkgs; [
            poetry
            nixpkgs-fmt
            ruff
          ];
        };
      });
}
