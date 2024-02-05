{
pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
   rustdesk-server
   rustdesk
  ];
  networking.firewall = {
    enable = true;
    # allowedTCPPorts = [ 8000 ];
    allowedTCPPortRanges = [
      { from = 21115; to = 21119; }
    ];
    allowedUDPPorts = [ 21116 ];
  };
}

