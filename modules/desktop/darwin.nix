{
  pkgs,
  me,
  ...
}: {
  imports = [
    ./common.nix
  ];

  users.users.${me.userName}.home = "/Users/${me.userName}";

  home-manager.users.${me.userName} = {
    home = {
      packages = with pkgs; [
        colima
      ];
    };
    programs.ssh.matchBlocks."*".extraOptions = {
      AddKeysToAgent = "yes";
      UseKeychain = "yes";
    };
  };
  system.defaults = {
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
    };
    masApps = {
      Xcode = 497799835;
    };
    brews = [
      "coreutils"
      "gnu-sed" # for neovim plugin
    ];
    casks = [
      "google-chrome"
      "google-drive"
      "firefox"
      "keepassxc"
      "raycast" # Better Spotlight, it detects apps installed by nix-darwin
      "lunar" # Luminosity control
      "flux" # Blue light filter
      "doll" # Slack notification
      "mullvadvpn"
      "roon"
      "obsidian" # Notes
      "nikitabobko/tap/aerospace" # tiling window manager

      # Work
      "notion"
      "around"
      "linear-linear"
      "intellij-idea"
      "datagrip"
      "aws-vpn-client"
      "docker"
      "microsoft-teams"

      # People
      "slack"
      "whatsapp"
      "discord"
      "telegram"
      "zoom"

      # Apps
      "steam"
    ];
  };
}
