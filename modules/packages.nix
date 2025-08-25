# ./common/packages.nix
{ pkgs, username, ... }:

{
  home-manager.users.${username}.home.packages = with pkgs; [
    fzf
    git
    neovim
    tmux
    zsh
  ];
}
