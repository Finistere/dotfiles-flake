{me, ...}: {
  home-manager.users.${me.userName}.home.stateVersion = "23.05";
  system.stateVersion = "23.05";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  time = {
    timeZone = "Europe/Paris";
    # For Windows
    hardwareClockInLocalTime = true;
  };

  boot.tmp.useTmpfs = true;
  services.openssh.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [8008];
  };
  services.rustdesk-server = {
    enable = true;
    signal = {
      relayHosts = ["127.0.0.1"];
      extraArgs = [
        "-k"
        "_" # Disable key verification (for easier setup)
      ];
    };
    relay = {
      enable = true;
      extraArgs = [
        "-k"
        "_" # Disable key verification (for easier setup)
      ];
    };
    openFirewall = true;
  };
}
