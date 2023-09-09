# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-amd" "amd-pstate" "amdgpu"];
    kernelParams = [
      "amd_pstate=guided"
    ];
    extraModulePackages = [];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["dm-snapshot"];
      luks.devices = {
        cryptroot0 = {
          device = "/dev/disk/by-uuid/521e7e2e-526e-4923-939d-55464c260311";
          allowDiscards = true;
        };
      };
    };
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.cpu.amd.updateMicrocode = true;
  # powerManagement.cpuFreqGovernor = "schedutil";

  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl = {
    enable = true;
    # Vulkan
    driSupport = true;
    extraPackages = with pkgs; [
      # OpenCL
      rocm-opencl-icd
      # Vulkan
      amdvlk
      # VA-API
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2b621b31-d58c-4299-91f5-94c3bc7c6ed5";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5508-3AD3";
    fsType = "vfat";
  };

  # Installing Windows in there for now.
  # environment.etc.crypttab = {
  #   enable = true;
  #   text = ''
  #     cryptroot1 UUID=63c393d9-e909-44da-939a-04585943b7ee /etc/secrets/initrd/cryptroot1.keyfile luks discard
  #   '';
  # };
  #
  # fileSystems."/data" = {
  #   device = "/dev/vg-data/data";
  #   fsType = "ext4";
  # };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp10s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp7s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
