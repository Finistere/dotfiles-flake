{
  pkgs,
  me,
  ...
}: {
  home-manager.users.${me.userName}.home.stateVersion = "23.05";
  system.stateVersion = "23.05";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./gaming.nix
    ./kvm.nix
  ];
  time = {
    timeZone = "Europe/Paris";
    # For Windows
    hardwareClockInLocalTime = true;
  };

  boot.tmp.useTmpfs = true;
  services.openssh.enable = true;
}
