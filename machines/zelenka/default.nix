{me, ...}: let
  matchBlocks = builtins.listToAttrs (
    map
    (name: {
      inherit name;
      value = {
        forwardAgent = true;
      };
    })
    [
      "9960x-4090x2"
      "9960x-5090x2"
      "9950x-tt"
      "9950x-radeon-pro"
    ]
  );

  vscodeMatchBlocks = builtins.listToAttrs (
    map (name: {
      name = "vscode.${name}";
      value =
        matchBlocks.${name}
        // {
          hostname = name;
          extraOptions = {
            RemoteCommand = "/usr/bin/bash";
          };
        };
    }) (builtins.attrNames matchBlocks)
  );
in {
  system.stateVersion = 6;
  home-manager.users.${me.userName} = {
    home.stateVersion = "26.05";
    programs.ssh = {
      includes = ["~/.sky/generated/ssh/*"];
      matchBlocks = matchBlocks // vscodeMatchBlocks;
    };
  };

  homebrew = {
    casks = [
      "visual-studio-code"
      "nvidia-nsight-systems"
      "chatwise"
    ];
  };

  # nix darwin cannot manage nix with Determinate System installer
  nix.enable = false;
}
