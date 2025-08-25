# This file is a translation of your gitconfig for use with Nix home-manager.
# You can import this file into your main home.nix configuration.
{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Ben Lewis";
    userEmail = "johnbenjaminlewis@gmail.com";

    init.defaultBranch = "main";

    aliases = {
      amend = "commit --amend -C HEAD";
      br = "branch";
      ci = "commit";
      co = "checkout";
      d = "difftool";
      f = "fetch";
      hist = "log --graph --pretty=format:'%h %ad | %s%d [%an]' --date=short";
      last = "log -1 HEAD";
      # Using Nix's multiline strings ('') to handle the inner quotes correctly.
      lines = ''!f() { git log --numstat --pretty="%H" "$@" | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\\n", plus, minus)}'; }; f'';
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr, %cn)%Creset' --abbrev-commit --date=relative";
      lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr, %cn)%Creset'";
      m = "mergetool";
      st = "status";
      unstage = "reset HEAD --";
      old = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:red)%(objectname:short)%(color:reset) - %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
    };

    diff.tool = "vimdiff";
    difftool.prompt = false;

    merge.tool = "vimdiff";

    mergetools.sourcetree = {
      cmd = ''/Applications/SourceTree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"'';
      trustExitCode = true;
    };

    # Settings that don't have a direct option are placed in `extraConfig`.
    extraConfig = {
      diff = {
        renames = "copies";
        mnemonicprefix = true;
      };
      advice = {
        statusHints = false;
      };
      core = {
        # You can also manage the global gitignore file declaratively with home-manager.
        # For example, using home.file.".gitignore_global".text = ''
        #   .DS_Store
        # '';
        # And then you could set the path like this:
        # excludesfile = "${config.home.homeDirectory}/.gitignore_global";
        excludesfile = "/Users/b/.gitignore_global";
        whitespace = "trailing-space,space-before-tab";
      };
      color = {
        ui = true;
      };
      branch = {
        autosetupmerge = true;
      };
      push = {
        default = "current";
      };
      # NOTE: `pull.default` is not a standard git configuration option.
      # It is included here to exactly match your gitconfig, but it might not have any effect.
      pull = {
        default = "current";
      };
      credential = {
        helper = "!aws codecommit credential-helper $@";
        UseHttpPath = true;
      };
    };
  };
}

