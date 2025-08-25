{ self, inputs, ... }:
{ hostname, username, system, ... }:
let
  nixRevision = self.rev or self.dirtyRev or "default-revision";
in
inputs.nix-darwin.lib.darwinSystem {
  inherit system;
  specialArgs = {
    inherit username hostname system nixRevision inputs;
  };
  modules = [
    inputs.home-manager.darwinModules.home-manager
    ./darwin.nix
    ../modules/home.nix
    ../modules/packages.nix
  ];
}

