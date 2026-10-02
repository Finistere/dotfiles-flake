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
    # Use the native app: Nix's Kitty launcher breaks macOS app registration.
    programs.kitty.package = null;
    home = {
      packages = with pkgs; [
        colima
        rsync
      ];
      file.".aerospace" = {
        source = ../home/.aerospace.toml;
        target = ".aerospace.toml";
      };
    };
    programs.ssh.settings."*" = {
      ServerAliveInterval = 60;
      ServerAliveCountMax = 5;
      # For mosh
      IgnoreUnknown = "UseKeychain";
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
      extraFlags = [
        "--force-cleanup"
      ];
    };
    masApps = {
      Xcode = 497799835;
    };
    brews = [
      "coreutils"
      "gnu-sed" # for neovim plugin
      # https://github.com/FelixKratz/JankyBorders
      {
        name = "felixkratz/formulae/borders";
        trusted = true;
      }
      "huggingface-cli"
    ];
    casks = [
      "kitty"
      "google-chrome"
      "google-drive"
      "firefox"
      "keepassxc"
      "qobuz"
      # "raycast" # Better Spotlight, it detects apps installed by nix-darwin
      "lunar" # Luminosity control
      "flux-app" # Blue light filter
      "doll" # Slack notification

      # Window manager
      "nikitabobko/tap/aerospace"

      # Work
      # "datagrip"
      # "aws-vpn-client"
      "docker-desktop"
      "notion"
      "1password"
      "tailscale-app"
      "wireshark-app"
      "codex-app"
      "claude"
      "claude-code@latest"
      "codex"
      "linear"

      # People
      "slack"
      "whatsapp"
      "discord"
      "telegram"
      "zoom"
      "signal"
      "microsoft-teams"

      # Virtualization
      "utm"

      "logseq"
      "zotero@beta"
    ];
    taps = [
      # Aerospace
      "nikitabobko/tap"
      # for JankyBorders
      "FelixKratz/formulae"
    ];
  };
}
