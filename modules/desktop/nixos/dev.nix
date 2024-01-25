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
    config.boot.kernelPackages.perf
    kcachegrind
    valgrind
    graphviz
    virt-manager # kvm
    rustdesk-server
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
