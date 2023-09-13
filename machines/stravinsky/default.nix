{me, ...}: {
  system.stateVersion = 4;
  home-manager.users.${me.userName}.home.stateVersion = "22.11";
}
