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

  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
      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
      iR3EaCr5xRFuOVsWm1/HouWOfw==
      -----END CERTIFICATE-----
    ''
  ];
}
