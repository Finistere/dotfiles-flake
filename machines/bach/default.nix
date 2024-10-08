{
  pkgs,
  config,
  inputs,
  me,
  ...
}: {
  system.stateVersion = "20.09";
  home-manager.users.${me.userName}.home.stateVersion = "21.11";

  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t14s-amd-gen1
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./htpc.nix
  ];

  boot = {
    supportedFilesystems = ["ntfs"];
    # kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        enableCryptodisk = true;
      };
    };
    initrd = {
      secrets = {
        "cryptroot" = "/etc/secrets/initrd/cryptroot.keyfile";
      };
      luks.devices = {
        cryptroot = {
          device = "/dev/disk/by-partlabel/cryptroot";
          keyFile = "cryptroot";
          preLVM = true;
        };
      };
    };
    kernel.sysctl = {
      # Allow JetBrains async profiler
      # https://www.jetbrains.com/help/idea/async-profiler.html#adjust-kernel
      "kernel.perf_event_paranoid" = 1;
      "kernel.kptr_restrict" = 0;
    };
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback.out];
    kernelModules = ["v4l2loopback"];
    extraModprobeConfig = ''
      # exclusive_caps: Skype, Zoom, Teams etc. will only show device when actually streaming
      # card_label: Name of virtual camera, how it'll show up in Skype, Zoom, Teams
      # https://github.com/umlaeute/v4l2loopback
      options v4l2loopback exclusive_caps=1 card_label="Elgato Facecam" video_nr=11
    '';
  };

  time.timeZone = "Europe/Paris";
  networking = {
    networkmanager = {
      enable = true;
    };
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces = {
      enp2s0f0.useDHCP = true;
      enp5s0.useDHCP = true;
      wlp3s0.useDHCP = true;
    };
  };
  services = {
    # For touchpad
    libinput.enable = true;

    thinkfan = {
      enable = true;
      levels = [
        [
          0
          0
          55
        ]
        [
          1
          48
          60
        ]
        [
          2
          50
          61
        ]
        [
          3
          52
          63
        ]
        [
          6
          56
          65
        ]
        [
          7
          60
          85
        ]
        [
          "level auto"
          80
          32767
        ]
      ];
    };

    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1bcf", ATTR{idProduct}=="2b95", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1bcf", ATTR{idProduct}=="0005", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", ATTR{idProduct}=="0002", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", ATTR{idProduct}=="0003", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04d9", ATTR{idProduct}=="0143", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="04f3", ATTR{idProduct}=="24a1", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05e3", ATTR{idProduct}=="0608", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05e3", ATTR{idProduct}=="0610", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="05e3", ATTR{idProduct}=="0620", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="06c4", ATTR{idProduct}=="c411", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", ATTR{idProduct}=="6006", TEST=="power/control", ATTR{power/control}="on"
    '';
    udev.packages = [pkgs.qmk-udev-rules];

    openssh.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
