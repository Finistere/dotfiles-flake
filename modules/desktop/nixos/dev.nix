{
  pkgs,
  config,
  me,
  ...
}: {
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = 1;
    "kernel.kptr_restrict" = 0;
  };
  environment.systemPackages = [
    # https://github.com/NixOS/nixpkgs/issues/282983
    # (linuxKernel.packagesFor (linuxKernel.kernels.linux_6_7.override {stdenv = gcc12Stdenv; buildPackages = pkgs.buildPackages // { stdenv = gcc12Stdenv;};})).perf
    config.boot.kernelPackages.perf
  ];

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    host = "0.0.0.0";
    openFirewall = true;
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1100"; # used to be necessary, but doesn't seem to anymore
    };
    rocmOverrideGfx = "11.0.0";
  };

  # KVM
  virtualisation.libvirtd.enable = true;
  users.users.${me.userName}.extraGroups = ["libvirtd" "wireshark"];

  programs = {
    dconf.enable = true;
    nix-ld.enable = true;

    wireshark.enable = true;
    wireshark.package = pkgs.wireshark;
  };

  home-manager.users.${me.userName} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
    home.packages = with pkgs; [
      kdePackages.kcachegrind
      valgrind
      graphviz
      virt-manager # kvm
      imagemagick # used for kitten icat
      code-server
    ];
  };
}
