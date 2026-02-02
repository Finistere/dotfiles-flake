{me, ...}: {
  system.stateVersion = 6;
  home-manager.users.${me.userName}.home.stateVersion = "26.05";
  # nix darwin cannot manage nix with Determinate System installer
  nix.enable = false; 
}
