_: {
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasmawayland";
  };
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };
}
