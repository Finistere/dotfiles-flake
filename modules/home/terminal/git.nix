{
  pkgs,
  inputs,
  system,
  ...
}:
{
  home = {
    packages = with pkgs; [
      tig
    ];
    file."jj-zml" = {
      target = ".config/jj/conf.d/zml.toml";
      text = ''
        --when.repositories = ["~/github/zml", "~/github/zml2", "~/github/iree-org"]

        [user]
        email = "benjamin@zml.ai"
      '';
    };
  };

  programs = {
    fish.shellAliases = {
      gs = "git status";
    };

    mergiraf.enable = true;

    gh.enable = true;

    difftastic = {
      enable = true;
      git.enable = true;
    };

    delta = {
      enable = false;
      options = {
        features = "decorations navigate";
      };
    };

    git = {
      enable = true;
      settings = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin@rabier.dev";
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

      includes = [
        {
          condition = "gitdir:~/github/zml/";
          contents = {
            user.email = "benjamin@zml.ai";
          };
        }
        {
          condition = "gitdir:~/github/iree-org/";
          contents = {
            user.email = "benjamin@zml.ai";
          };
        }
        {
          condition = "gitdir:~/github/zml2/";
          contents = {
            user.email = "benjamin@zml.ai";
          };
        }
      ];

      ignores = [
        ".envrc"
        ".ignore"
        ".direnv"
        ".jj"
        "opencode.json"
      ];
    };

    jujutsu = {
      enable = true;
      settings = {
        user.name = "Benjamin Rabier";
        user.email = "benjamin@rabier.dev";
        templates.git_push_bookmark = "\"brabier/\" ++ change_id.short()";
        ui = {
          diff-formatter = [
            "difft"
            "--color=always"
            "$left"
            "$right"
          ];
          editor = "vi";
          diff-editor = "diffview";
        };
        revsets.bookmark-advance-to = "@-";
        aliases = {
          d = [ "diff" ];
          s = [ "show" ];
          f = [
            "git"
            "fetch"
          ];
          a = [
            "bookmark"
            "advance"
          ];
        };
        merge-tools = {
          # See https://github.com/sindrets/diffview.nvim/issues/562#issuecomment-2867142680
          diffview = {
            program = "sh";
            edit-args = [
              "-c"
              ''
                set -eu
                rm -f "$right/JJ-INSTRUCTIONS"
                git -C "$left" init -q
                git -C "$left" add -A
                git -C "$left" commit -q -m baseline --allow-empty
                mv "$left/.git" "$right"
                (cd "$right"; vi -c DiffviewOpen)
                git -C "$right" add -p
                git -C "$right" diff-index --quiet --cached HEAD && { echo "No changes done, aborting split."; exit 1; }
                git -C "$right" commit -q -m split
                git -C "$right" restore . # undo changes in modified files
                git -C "$right" reset .   # undo --intent-to-add
                git -C "$right" clean -q -df # remove untracked files
              ''
            ];
          };
          mergiraf = {
            program = "mergiraf";
            merge-args = [
              "merge"
              "$base"
              "$left"
              "$right"
              "-o"
              "$output"
              "--fast"
            ];
            merge-conflict-exit-codes = [ 1 ];
            conflict-marker-style = "git";
          };
        };
      };
    };
  };
}
