{
  pkgs,
  userName,
  hostName,
  inputs,
  system,
  ...
}: {
  networking = {inherit hostName;};
  environment.shells = [pkgs.fish];
  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  programs.fish.enable = true;
  users.users.${userName}.shell = pkgs.fish;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      jetbrains-mono
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
  };

  age.secrets.git = {
    file = ../../secrets/git.age;
    owner = userName;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs system;
    };
  };
}
