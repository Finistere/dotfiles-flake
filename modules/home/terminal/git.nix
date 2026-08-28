{
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      tig
      lazyjj
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

    gh.enable = true;

    delta = {
      enable = true;
      enableGitIntegration = true;
      enableJujutsuIntegration = true;
      options = {
        features = "decorations navigate";
        true-color = "always";
        pager = "less -R -+F";

        max-line-distance = "0.8";
        line-buffer-size = "64";
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
        diff = {
          algorithm = "histogram";
        };
        fetch = {
          prune = true;
          pruneTags = true;
        };

        difftool = {
          prompt = false;
          trustExitCode = true;
        };
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
          editor = "vi";
          diff-editor = "diffview";
        };
        lazyjj = {
          diff-tool = "delta-b";
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
          "delta-b" = {
            program = "bash";
            diff-args = [
              "-o"
              "pipefail"
              "-c"
              ''
                git --no-pager diff --no-index \
                  --ignore-space-change \
                  --color=always \
                  -- "$1" "$2" |
                  delta --paging=never
              ''
              "delta-b"
              "$left"
              "$right"
            ];
            diff-expected-exit-codes = [
              0
              1
            ];
          };
        };
      };
    };
  };
}
