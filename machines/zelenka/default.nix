{me, ...}: {
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
    };
  };

  homebrew = {
    casks = [
      "nvidia-nsight-systems"
      "chatwise"
    ];
  };

  # nix darwin cannot manage nix with Determinate System installer
  nix.enable = false;
}
