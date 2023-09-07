{
  pkgs,
  userName,
  publicKeys,
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
    users.${userName} = {
      isNormalUser = true;
      uid = 1000;
      hashedPassword = "$6$1CKpJvvp$abK6WGrXVqnwAxD7/7yXZnmQ57o2m7gfON9fBjVpsmzFeiUCg2a7Xir2fhZJ7qzJP8ppALIKL6cPlrGcZVr530";
      home = "/home/${userName}";
      extraGroups = ["wheel" "networkmanager" "audio" "input" "docker"];
      openssh.authorizedKeys.keys = [
        publicKeys.stravinsky.${userName}
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
  ];
  services.fwupd.enable = true;

  home-manager.users.${userName} = {
    imports = [
      ../../home/shell.nix
    ];
    home = {
      packages = with pkgs; [google-chrome];
    };
    programs.firefox.enable = true;
    programs.kitty = {
      enable = true;
      extraConfig =
        builtins.readFile ../../home/files/kitty.conf
        + builtins.readFile (pkgs.vimPlugins.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
    };
    programs.keychain = {
      enable = true;
      keys = ["id_ed25519"];
      extraFlags = ["--quiet" "--nogui"];
    };
  };
}