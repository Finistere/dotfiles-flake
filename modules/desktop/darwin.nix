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
      file."kitty" = {
        target = ".config/kitty/kitty.conf";
        text =
          builtins.readFile ../home/files/kitty.conf
          + builtins.readFile (pkgs.vimPlugins.tokyonight-nvim + "/extras/kitty/tokyonight_moon.conf");
      };
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
    ];
    casks = [
      "google-chrome"
      "firefox"
      "keepassxc"
      "raycast" # Better Spotlight, it detects apps installed by nix-darwin
      "kitty" # Terminal emulator
      "lunar" # Luminosity control
      "doll" # Slack notification
      "mullvadvpn"
      "roon"
      "joplin" # Notes
      "obsidian" # Notes
      "Rectangle" # window snapping

      # Work
      "notion"
      "around"
      "linear-linear"
      "intellij-idea"
      "clion"
      "datagrip"
      "aws-vpn-client"
      "insomnia"
      "docker"

      # People
      "slack"
      "whatsapp"
      "discord"
      "telegram"
      "zoom"
      "element"

      # Apps
      "adobe-creative-cloud"
      "steam"
    ];
  };
}
