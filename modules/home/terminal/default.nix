{
  pkgs,
  me,
  inputs,
  ...
}: {
  home = {
    packages = with pkgs; [
      ripgrep
      tokei
      htop
      fd
      dig
      whois
      erdtree
      sd
    ];
    file."erdtree" = {
      target = ".config/erdtree/.erdtree.toml";
      text = builtins.readFile ./.erdtree.toml;
    };
  };

  programs = {
    eza.enable = true;
    skim.enable = true;
    fzf.enable = true;

    atuin = {
      enable = true;
      settings = {
        style = "compact";
        search_mode = "skim";
      };
      flags = ["--disable-up-arrow"];
    };

    ssh = {
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
    starship = {
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
    bash.enable = true;
    fish = {
      enable = true;
      shellAliases = {
        s = "kitty +kitten ssh";
        ll = "eza -lga --group-directories-first";
      };
      shellInit = builtins.readFile ./config.fish;
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide.enable = true;
    tealdeer = {
      enable = true;
      settings = {
        display.use_pager = true;
        # Updates by default every month.
        updates.auto_update = true;
      };
    };
    bat = {
      enable = true;
      config = {
        inherit (me) theme;
        style = "plain";
      };
      themes = {
        tokyonight_moon = builtins.readFile (inputs.tokyonight-nvim + "/extras/sublime/tokyonight_moon.tmTheme");
        catppuccin_mocha = builtins.readFile (inputs.catppuccin-bat + "/Catppuccin-mocha.tmTheme");
        catppuccin_frappe = builtins.readFile (inputs.catppuccin-bat + "/Catppuccin-frappe.tmTheme");
        catppuccin_macchiato = builtins.readFile (inputs.catppuccin-bat + "/Catppuccin-macchiato.tmTheme");
      };
    };
  };
}
