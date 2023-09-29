{
  pkgs,
  me,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  users.users.${me.userName}.extraGroups = ["libvirtd"];

  environment.systemPackages = with pkgs; [virt-manager];
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
