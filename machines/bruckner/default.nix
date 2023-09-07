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

  environment.systemPackages = with pkgs; [lm_sensors];

  # Use the systemd-boot EFI boot loader.
  services.openssh.enable = true;
  time.timeZone = "Europe/Paris";
}
