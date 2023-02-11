{adminUser, ...}: {
  system.stateVersion = 4;
  home-manager.users.${adminUser}.home.stateVersion = "22.11";
}
