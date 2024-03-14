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

  fonts = let
    packages = with pkgs; [
      jetbrains-mono
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  in
    me.lib.matchOs {
      darwin = {
        fontDir.enable = true;
        fonts = packages;
      };
      linux = {
        inherit packages;
        fontDir.enable = true;
      };
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
            jetbrains.clion
            bashInteractive
          ]
          ++ me.lib.ifLinux (with pkgs; [cryptomator]);
      };

      programs.kitty = let
        themes = {
          tokyonight_moon = builtins.readFile (inputs.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
          catppuccin_frappe = builtins.readFile (inputs.catppuccin-kitty + "/themes/frappe.conf");
          catppuccin_mocha = builtins.readFile (inputs.catppuccin-kitty + "/themes/mocha.conf");
          catppuccin_macchiato = builtins.readFile (inputs.catppuccin-kitty + "/themes/macchiato.conf");
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
// me.lib.ifDarwinAttrs {
  homebrew.casks = ["cryptomator"];
}
