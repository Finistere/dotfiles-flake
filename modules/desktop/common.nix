{
  pkgs,
  inputs,
  me,
  ...
}: {
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

  age.secrets.git = {
    file = ../../secrets/git.age;
    owner = me.userName;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs me;
      inherit (me) system;
    };
  };
}
