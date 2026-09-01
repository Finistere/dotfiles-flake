{ me, ... }:
let
  settings =
    builtins.listToAttrs (
      map
        (name: {
          inherit name;
          value = {
            ForwardAgent = true;
          };
        })
        [
          "9960x-4090x2"
          "9960x-5090x2"
          "9960x-b70x2"
          "9985wx-5090x4"
          "mi300"
          "9950x-tt"
          "9950x-radeon-pro"
        ]
    )
    // builtins.listToAttrs (
      map
        (name: {
          inherit name;
          value = {
            ForwardAgent = true;
            User = "benjamin";
          };
        })
        [
          "gb300-1"
          "gb300-2"
        ]
    );
in
{
  system.stateVersion = 6;
  home-manager.users.${me.userName} = {
    home = {
      stateVersion = "26.05";
      file.".colima/nvim-builder/colima.yaml".text = ''
        cpu: 4
        memory: 4
        disk: 30
        arch: aarch64
        runtime: docker
        autoActivate: false

        kubernetes:
          enabled: false

        network:
          address: false
          mode: shared

        forwardAgent: false
        vmType: vz
        rosetta: true
        binfmt: true
        mountType: virtiofs
        sshConfig: false
      '';
    };
    programs.ssh = {
      includes = [ "~/.sky/generated/ssh/*" ];
      inherit settings;
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
