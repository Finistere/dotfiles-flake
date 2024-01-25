{
  pkgs,
  me,
  config,
  ...
}: {
  imports = [
    ../common.nix
    ./sound.nix
    ./kde.nix
  ];

  virtualisation.docker.enable = true;
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    users.${me.userName} = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = "$6$1CKpJvvp$abK6WGrXVqnwAxD7/7yXZnmQ57o2m7gfON9fBjVpsmzFeiUCg2a7Xir2fhZJ7qzJP8ppALIKL6cPlrGcZVr530";
      home = "/home/${me.userName}";
      extraGroups = [
        # sudo
        "wheel"
        "networkmanager"
        "audio"
        "input"
        "docker"
        # for qmk flash
        "tty"
        "dialout"
      ];
      openssh.authorizedKeys.keys = [
        me.publicKeys.stravinsky.${me.userName}
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    lsof
    lshw
    htop
    coreutils
    parted
    openssl
    xclip
    lm_sensors
    slack
    docker-compose
    config.boot.kernelPackages.perf
  ];
  services.fwupd.enable = true;
  security.sudo.extraConfig = ''
    Defaults        lecture = never
  '';

  home-manager.users.${me.userName} = {
    home = {
      packages = with pkgs; [google-chrome];
    };
    programs.firefox.enable = true;
    programs.keychain = {
      enable = true;
      keys = ["id_ed25519"];
      extraFlags = ["--quiet" "--nogui"];
    };
  };
}
