{
  pkgs,
  userName,
  config,
  inputs,
  ...
}: {
  home-manager.users.${userName}.home.stateVersion = "23.05";
  system.stateVersion = "23.05";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [];

  services.openssh.enable = true;

  programs.steam = {
    enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;
  };
}
