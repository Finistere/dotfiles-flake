{
  pkgs,
  ...
}: {
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
      settings.verison = 1;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
        options = {
          features = "decorations navigate";
        };
      };

      extraConfig = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin+git@rabier.dev";
        push.default = "simple";
        pull.ff = "only";
        rebase.autosquash = true;
        alias.fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        init.defaultBranch = "main";
      };

      ignores = [".envrc" ".ignore" ".direnv"];
    };

    jujutsu = {
      enable = true;
      settings = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin+git@rabier.dev";
      };
    };
  };
}
