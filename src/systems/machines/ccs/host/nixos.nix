{ pkgs, flakeRoot, ... }:

{
  imports = [
    (flakeRoot + "/nixos/packages.nix")
    (flakeRoot + "/nixos/modules/all.nix")
  ];

  # auto delete builds
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # man pages and docs
  documentation.enable = true;
  documentation.dev.enable = true;
  documentation.man.enable = true;

  # bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # rtl sdr (infor from dmesg)
  boot.blacklistedKernelModules = [ "dvb_usb_rtl28xxu" "rtl2832" "r820t" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="2838", GROUP="plugdev", MODE="0666"
  '';

  # Better scheduling for CPU cycles - thanks System76!!!
  services.system76-scheduler.settings.cfsProfiles.enable = true;

  # Enable TLP (better than gnomes internal power manager)
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  # Disable GNOMEs power management
  services.power-profiles-daemon.enable = false;

  # Enable powertop
  powerManagement.powertop.enable = true;

  # Enable thermald (only necessary if on Intel CPUs)
  services.thermald.enable = true;

  # services 
  services = {
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "bluecosmo";
      defaultSession = "none+i3";
    };

    xserver = {
      enable = true;

      displayManager.lightdm.enable = true;
      desktopManager.cinnamon.enable = true; # disable for auto i3
      windowManager.i3.enable = true;

      # displayManager = {
      #   lightdm.enable = true;
      #   lightdm.greeter = {
      #     enable = true;
      #     allow-session-switching = false;
      #   };
      #   defaultSession = "none+i3";
      # };
    };
  };


  services.tailscale.enable = true;
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ];
  };

  # bluetooth
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  disabledModules = [
    ./modules/xserver.nix
  ];

  networking.hostName = "ccs";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  custom = {
    nixvim.enable = true;
  };
}
