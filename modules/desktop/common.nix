{
  pkgs,
  inputs,
  me,
  ...
}:
{
  networking = {inherit (me) hostName;};
  environment.shells = [pkgs.fish];
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  programs.fish.enable = true;
  users.users.${me.userName}.shell = pkgs.fish;

  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs me;
      inherit (me) system;
    };
    users.${me.userName} = {
      imports = [
        ../home/terminal
        ../home/terminal/git.nix
        ../home/terminal/editor.nix
      ];
      home = {
        packages = with pkgs;
          [
            vale
            graphviz
            btop
          ]
          ++ me.lib.ifLinuxOr [] (with pkgs; [cryptomator]);
        # Used for neovim
        file.".vale.ini".text = ''
          StylesPath = .vale-styles

          MinAlertLevel = suggestion

          Packages = Microsoft, proselint, write-good, alex, Readability, Joblint

          [*]
          BasedOnStyles = Vale, Microsoft, proselint, write-good, alex, Readability, Joblint
        '';
        activation = {
          # Doesn't work for linux, service seems isolated?
          # vale = inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
          #   run ${pkgs.vale}/bin/vale sync
          # '';
        };
      };

      programs.kitty = let
        themes = {
          tokyonight_moon = builtins.readFile (pkgs.vimPlugins.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
        };
      in {
        enable = true;
        extraConfig =
          builtins.readFile ../home/kitty.conf
          + themes.${me.theme};
      };
    };
  };
}
// me.lib.ifDarwinOr {} {
  homebrew.casks = ["cryptomator" "logseq" "zotero@beta"];
}
