{pkgs, ...}: {
  environment.systemPackages = with pkgs; [discord];
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
