{userName, ...}: {
  system.stateVersion = 4;
  home-manager.users.${userName}.home.stateVersion = "22.11";
}
