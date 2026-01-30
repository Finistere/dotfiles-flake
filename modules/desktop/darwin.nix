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
      file.".aerospace" = {
        source = ../home/.aerospace.toml;
        target = ".aerospace.toml";
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
    # Disable windows opening animations
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
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
      # https://github.com/FelixKratz/JankyBorders
      "borders"
    ];
    casks = [
      "google-chrome"
      "google-drive"
      "firefox"
      "keepassxc"
      "raycast" # Better Spotlight, it detects apps installed by nix-darwin
      "lunar" # Luminosity control
      "flux-app" # Blue light filter
      "doll" # Slack notification
      "mullvad-vpn"

      # Window manager
      "nikitabobko/tap/aerospace"

      # Work
      "linear-linear"
      "datagrip"
      # "aws-vpn-client"
      "docker-desktop"
      "microsoft-teams"
      "cursor"

      # People
      "slack"
      "whatsapp"
      "discord"
      "telegram"
      "zoom"
      "signal"

      # Virtualization
      "utm"

      # LLM
      # "ollamac"
      # "anythingllm"
    ];
    taps = [
      # Aerospace
      "nikitabobko/tap"
      # for JankyBorders
      "FelixKratz/formulae"
    ];
  };
}
