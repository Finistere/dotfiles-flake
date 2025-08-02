{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      tig
    ];
  };

  programs = {
    fish.shellAliases = {
      gs = "git status";
      gca = "git commit --amend";
    };

    gh = {
      enable = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/4744
      settings.version = 1;
    };
    git = {
      enable = true;
      difftastic = {
        enable = true;
      };
      delta = {
        enable = false;
        options = {
          features = "decorations navigate";
        };
      };

      extraConfig = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin+git@rabier.dev";
        push.default = "current";
        pull.ff = "only";
        merge.conflictstyle = "zdiff3";
        rebase.autosquash = true;
        rebase.autostash = true;
        alias.fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        init.defaultBranch = "main";
        rerere.enabled = true;
        diff.algorithm = "histogram";
        feth.prune = true;
        fetch.pruneTags = true;
      };

      ignores = [
        ".envrc"
        ".ignore"
        ".direnv"
        ".jj"
        ".github"
      ];
    };

    jujutsu = {
      enable = true;
      settings = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin+git@rabier.dev";
        ui.diff-formatter = [
          "difft"
          "--color=always"
          "$left"
          "$right"
        ];
      };
    };
  };
}
