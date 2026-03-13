{ me, ... }:
{
  system.stateVersion = 6;
  home-manager.users.${me.userName} = {
    home.stateVersion = "26.05";
    programs.ssh.matchBlocks = {
      "9960x-4090x2" = {
        forwardAgent = true;
      };
      "9960x-5090x2" = {
        forwardAgent = true;
      };
      "vscode.9960x-4090x2" = {
        forwardAgent = true;
        hostname = "9960x-4090x2";
        extraOptions = {
          RemoteCommand = "/usr/bin/bash";
        };
      };
      "vscode.9960x-5090x2" = {
        forwardAgent = true;
        hostname = "9960x-5090x2";
        extraOptions = {
          RemoteCommand = "/usr/bin/bash";
        };
      };
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
