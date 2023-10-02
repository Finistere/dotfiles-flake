{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      jetbrains.clion
    ];
  };
  programs.kitty = {
    enable = true;
    extraConfig =
      builtins.readFile ./kitty.conf
      + builtins.readFile (pkgs.vimPlugins.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
  };
}
