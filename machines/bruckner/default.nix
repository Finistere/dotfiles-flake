{pkgs, ...}: {
  home-manager.users.${me.userName}.home.stateVersion = "23.05";
  system.stateVersion = "23.05";
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs; [discord];

  services.openssh.enable = true;

  programs.gamemode.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      steam = prev.steam.override ({extraPkgs ? pkgs': [], ...}: {
        extraPkgs = pkgs':
          (extraPkgs pkgs')
          ++ (with pkgs'; [
            # gamescope
            # xorg.libXcursor
            # xorg.libXi
            # xorg.libXinerama
            # xorg.libXScrnSaver
            # libpng
            # libpulseaudio
            # libvorbis
            # stdenv.cc.cc.lib
            # libkrb5
            # keyutils
          ]);
      });
    })
  ];
  programs.steam = {
    enable = true;
    # Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;
  };
}
