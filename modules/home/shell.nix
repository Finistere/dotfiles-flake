{
  pkgs,
  osConfig,
  inputs,
  system,
  ...
}: {
  home = {
    sessionVariables = {
      EDITOR = "vi";
      VISUAL = "vi";
    };
    packages = with pkgs; [
      ripgrep
      tokei
      htop
      fd
      dig
      whois
      tig
      erdtree
      inputs.neovim.packages.${system}.default
    ];
    file."erdtree" = {
      target = ".config/erdtree/.erdtree.toml";
      text = builtins.readFile ../home/files/.erdtree.toml;
    };
  };

  programs.eza.enable = true;
  programs.skim.enable = true;

  programs.atuin = {
    enable = true;
    settings = {
      style = "compact";
      search_mode = "skim";
    };
    flags = ["--disable-up-arrow"];
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "tokyonight_moon";
      editor = {
        bufferline = "multiple";
        "line-number" = "relative";
        "color-modes" = true;
        "cursorline" = true;
        lsp = {
          display-inlay-hints = true;
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "bach" = {
        extraOptions = {
          HostName = "192.168.1.17";
        };
      };
      "bruckner" = {
        extraOptions = {
          HostName = "192.168.1.16";
        };
      };
      "*compute.amazonaws.com" = {
        extraOptions = {
          User = "ec2-user";
          SetEnv = "TERM=vt100";
        };
      };
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      git_status = {
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
      };
      nodejs.disabled = true;
      nix_shell.disabled = true;
    };
  };
  programs.bash.enable = true;
  programs.fish = {
    enable = true;
    shellAliases = {
      s = "kitty +kitten ssh";
      gs = "git status";
      gca = "git commit --amend";
      ll = "eza -lga --group-directories-first";
      vimdiff = "nvim -d";
      vi = "nvim";
    };
    shellInit = builtins.readFile ./files/config.fish;
    plugins = [
      {
        name = "fish-colored-man";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-colored-man";
          rev = "1ad8fff696d48c8bf173aa98f9dff39d7916de0e";
          sha256 = "0l32a5bq3zqndl4ksy5iv988z2nv56a91244gh8mnrjv45wpi1ms";
        };
      }
      {
        name = "fish-plugin-git";
        src = pkgs.fetchFromGitHub {
          owner = "jhillyerd";
          repo = "plugin-git";
          rev = "cc5999fa296c18105fb62f1637deec1d12454129";
          sha256 = "1x2pzhvhkx5c87vddjwniw8ippw19a2hxw0wqxc0kfrdd4pdk81m";
        };
      }
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide.enable = true;
  programs.fzf.enable = true;
  programs.tealdeer = {
    enable = true;
    settings = {
      display.use_pager = true;
      # Updates by default every month.
      updates.auto_update = true;
    };
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "tokyonight";
    };
    themes = {
      tokyonight = builtins.readFile (pkgs.vimPlugins.tokyonight-nvim + "/extras/sublime/tokyonight_moon.tmTheme");
    };
  };

  programs.gh.enable = true;
  programs.git = {
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
    };

    ignores = [".envrc" ".ignore" ".direnv"];
  };
}
