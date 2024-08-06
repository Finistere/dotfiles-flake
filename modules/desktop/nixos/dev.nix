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
  environment.systemPackages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/issues/282983
    # (linuxKernel.packagesFor (linuxKernel.kernels.linux_6_7.override {stdenv = gcc12Stdenv; buildPackages = pkgs.buildPackages // { stdenv = gcc12Stdenv;};})).perf
    config.boot.kernelPackages.perf
    kcachegrind
    valgrind
    graphviz
    virt-manager # kvm
    imagemagick # used for kitten icat
  ];

  # KVM
  virtualisation.libvirtd.enable = true;
  users.users.${me.userName}.extraGroups = ["libvirtd"];
  programs.dconf.enable = true;
  home-manager.users.${me.userName} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
