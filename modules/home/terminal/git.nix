{
  pkgs,
  osConfig,
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

    gh.enable = true;
    git = {
      enable = true;
      includes = [
        {inherit (osConfig.age.secrets.git) path;}
      ];
      delta = {
        enable = true;
        options = {
          features = "decorations navigate";
        };
      };

      extraConfig = {
        push.default = "simple";
        pull.ff = "only";
        rebase.autosquash = true;
        alias.fixup = "!git log -n 50 --pretty=format:'%h %s' --no-merges | fzf | cut -c -7 | xargs -o git commit --fixup";
        init.defaultBranch = "main";
      };

      ignores = [".envrc" ".ignore" ".direnv"];
    };
  };
}
