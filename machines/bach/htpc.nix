{
  pkgs,
  config,
  me,
  ...
}: let
  htpcUser = "bach";
in {
  services.displayManager.autoLogin = {
    enable = true;
    user = htpcUser;
  };
  users.users.bach = {
    isNormalUser = true;
    uid = 1001;
    home = "/home/${htpcUser}";
    hashedPassword = "";
    extraGroups = ["audio"];
    shell = pkgs.fish;
  };
  home-manager.users.${htpcUser} = {
    home.stateVersion = "22.11";
    programs.firefox.enable = true;
    programs.kitty = config.home-manager.users.${me.userName}.programs.kitty;
  };
}
