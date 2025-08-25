{ config, pkgs, inputs, username, system, ... }:

{
  home-manager.users.${username} =
    let
      homeDirectory = config.home-manager.users.${username}.home.homeDirectory;
    in
    {
      home.stateVersion = "25.05";
      home.packages = with inputs.nixpkgs.legacyPackages.${system}; [
        fzf
        git
        neovim
        tmux
        zsh
      ];

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        oh-my-zsh = {
          enable = true;

          # Setting the theme.
          # You can manage custom themes by putting them in your home-manager
          # configuration or by using home.file.
          theme = "ben";
          #
          # The oh-my-zsh.plugins option is a list of strings.
          # Home Manager will automatically handle the plugins for you.
          plugins = [
            "docker"
            "docker-compose"
            "docker-machine"
            "gcloud"
            "git"
            "gnu-utils"
            "nmap"
            "pip"
            "pipenv"
            "postgres"
            "python"
            "stack"
            "sudo"
            "terraform"
          ] ++ (
            if pkgs.stdenv.isDarwin then [ "brew" "macos" ]
            else if pkgs.stdenv.isLinux then [ "debian" "dircycle" "systemd" "ubuntu" "ufw" ]
            else [ ]
          );
        };

        setOptions = [
          "EXTENDED_HISTORY"
          "HIST_EXPIRE_DUPS_FIRST"
          "HIST_FIND_NO_DUPS"
          "HIST_IGNORE_ALL_DUPS"
          "HIST_IGNORE_DUPS"
          "HIST_IGNORE_SPACE"
          "HIST_REDUCE_BLANKS"
          "HIST_SAVE_NO_DUPS"
          "HIST_VERIFY"
          "INC_APPEND_HISTORY"
          "SHARE_HISTORY"
        ];

        # For `~/.functions`, you could place its content inside initExtra or create
        # a separate file and symlink it.
        #home.file.".functions".source = ./functions.sh; # Assuming you have a file named functions.sh in the same directory as your home.nix
        #home.file.".ben-zsh".source = ./ben-zsh; # Assuming this is a custom directory for your theme

        initContent = ''
          bindkey \^U backward-kill-line
          bindkey \^B backward-word
          bindkey \^F forward-word

          # Your custom functions
          source ${homeDirectory}/.functions

          # Fzf config
          [ -f ${homeDirectory}/.fzf.zsh ] && source ${homeDirectory}/.fzf.zsh

          # User configuration
          source ${homeDirectory}/.profile
        '';

        # Any custom environment variables or path modifications.
        # The `programs.zsh.sessionVariables` and `programs.zsh.localVariables`
        # options are the declarative way to manage these.
        sessionVariables = {
          # This is the equivalent of `export ZSH=~/.oh-my-zsh`
          # but Home Manager manages the location for you.
          #ZSH = "${config.programs.zsh.oh-my-zsh.package}";
          # This is for your custom theme directory.
          ZSH_CUSTOM = "${homeDirectory}/.ben-zsh";
          # This line is not needed as oh-my-zsh is managed by home-manager
          # but if you need other env vars, this is where you put them.
          # COMPLETION_WAITING_DOTS = "";
        };

        # You can also use `programs.zsh.sessionVariables` for path manipulation.
        # The `path_append_front` function is not standard, so you'd do it like this:
        # `programs.zsh.sessionVariables.PATH = "/usr/local/bin:$PATH";`
        # However, Home Manager also has a more idiomatic way to add to your PATH.
      };
    };
}
