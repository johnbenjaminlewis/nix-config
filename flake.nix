# ./flake.nix
{
  description = "My Nix Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ self, ... }:
    let
      hostname = "leopold";
      username = "b";
      system = "aarch64-darwin";
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { pkgs, ... }: {
        formatter = pkgs.nixpkgs-fmt;
      };

      flake = {
        # Reusable modules are defined here
        darwinModules.default = import ./macos/flake.nix { inherit self inputs; };

        # Define the actual host configurations here
        darwinConfigurations.${hostname} = self.darwinModules.default {
          inherit hostname username system inputs;
        };
      };
    };
}
