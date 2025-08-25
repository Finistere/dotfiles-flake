{me, ...}: {
  system.stateVersion = 6;
  home-manager.users.${me.userName}.home.stateVersion = "25.05";
}
