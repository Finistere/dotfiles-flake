{
  pkgs,
  adminUser,
  ...
}: {
  imports = [
    ./common.nix
  ];

  users.users.${adminUser}.home = "/Users/${adminUser}";

  home-manager.users.${adminUser} = {
    imports = [
      ../home/shell.nix
    ];
    home = {
      packages = with pkgs; [];
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

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
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

      # Work
      "notion"
      "around"
      "linear-linear"
      "intellij-idea"
      "clion"
      "datagrip"
      "aws-vpn-client"

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
