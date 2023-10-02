{
  pkgs,
  me,
  inputs,
  ...
}: {
  home = {
    packages = with pkgs; [
      jetbrains.clion
    ];
  };
  programs.kitty = let
    themes = {
      tokyonight_moon = builtins.readFile (inputs.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
      catpuccin_frappe = builtins.readFile (inputs.catppuccin-kitty + "/themes/frappe.conf");
      catpuccin_mocha = builtins.readFile (inputs.catppuccin-kitty + "/themes/mocha.conf");
      catpuccin_macchiato = builtins.readFile (inputs.catppuccin-kitty + "/themes/macchiato.conf");
    };
  in {
    enable = true;
    extraConfig =
      builtins.readFile ./kitty.conf
      + themes.${me.theme};
  };
}
