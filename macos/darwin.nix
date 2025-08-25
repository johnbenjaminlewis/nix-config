# ./macos/darwin.nix
{ pkgs, nixRevision, system, username, ... }:
{
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
    coreutils
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    casks = [
      "amethyst"
      "docker"
      "firefox"
      "google-drive"
      "google-earth-pro"
      "iterm2"
      "obsidian"
      "slack"
      "spotify"
      "visual-studio-code"
      "winbox"
    ];
  };

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = nixRevision;
  system.primaryUser = username;
  system.stateVersion = 6;
  security.pam.services.sudo_local.touchIdAuth = true;
  nixpkgs.hostPlatform = system;
}

