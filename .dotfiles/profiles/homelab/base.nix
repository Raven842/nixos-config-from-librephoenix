{ lib, pkgs, systemSettings, userSettings, ... }:

{
  imports =
    [ ../../system/hardware-configuration.nix
      ../../system/hardware/time.nix # Network time sync
      ../../system/security/firewall.nix
      ../../system/security/doas.nix
      ../../system/security/gpg.nix
      ../../system/hardware/opengl.nix
      ( import ../../system/app/docker.nix {storageDriver = null; inherit pkgs userSettings lib;} )
    ];

  # Fix nix path
  nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                  "nixos-config=$HOME/dotfiles/system/configuration.nix"
                  "/nix/var/nix/profiles/per-user/root/channels"
                ];

  # Ensure nix flakes are enabled
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # I'm sorry Stallman-taichou
  nixpkgs.config.allowUnfree = true;
  
  # xserver
  services.xserver.displayManager.startx.enable = true;

  # Kernel modules
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" "hugetlbfs" "amdgpu"];
  boot.initrd.kernelModules = ["amdgpu"];
  # kernel params
  boot.kernelParams = [
    "default_hugepagesz=1G"
    "hugepagesz=1G"
    "hugepages=4"
  ];
  # Bootloader
  # Use systemd-boot if uefi, default to grub otherwise
  boot.loader.systemd-boot.enable = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.canTouchEfiVariables = if (systemSettings.bootMode == "uefi") then true else false;
  boot.loader.efi.efiSysMountPoint = systemSettings.bootMountPath; # does nothing if running bios rather than uefi
  boot.loader.grub.enable = if (systemSettings.bootMode == "uefi") then false else true;
  boot.loader.grub.device = systemSettings.grubDevice; # does nothing if running uefi rather than bios

  # Networking
  networking.hostName = systemSettings.hostname; # Define your hostname.
  networking.networkmanager.enable = true; # Use networkmanager

  # Timezone and locale
  time.timeZone = systemSettings.timezone; # time zone
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # User account
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    uid = 1000;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    zsh
    git
    rclone
    rdiff-backup
    rsnapshot
    cryptsetup
    radeontop
    xmrig-mo
    nix-ld
    gocryptfs
    # amdgpu-pro
    # amd-gpu
    opencl-headers  
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
       alsa-lib
       at-spi2-atk
       at-spi2-core
       atk
       cairo
       cups
       curl
       dbus
       expat
       fontconfig
       freetype
       fuse3
       gdk-pixbuf
       glib
       gtk3
       hwloc
       icu
       libGL
       libappindicator-gtk3
       libdrm
       libglvnd
       libnotify
       libpulseaudio
       libunwind
       libusb1
       libuuid
       libxkbcommon
       libxml2
       libuv
       mesa
       nspr
       nss
       openssl pango
       opencl-headers
       pipewire
       stdenv.cc.cc
       systemd
       vulkan-loader
       xorg.libX11
       xorg.libXScrnSaver
       xorg.libXcomposite
       xorg.libXcursor
       xorg.libXdamage
       xorg.libXext
       xorg.libXfixes
       xorg.libXi
       xorg.libXrandr
       xorg.libXrender
       xorg.libXtst
       xorg.libxcb
       xorg.libxkbfile
       xorg.libxshmfence
       zlib
     ];
  };
  programs.fuse.userAllowOther = true;

  services.haveged.enable = true;

  # I use zsh btw
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # It is ok to leave this unchanged for compatibility purposes
  system.stateVersion = "22.11";

  # news.display = "silent";
# More sad crypto shit for raven and its E
  systemd.services.xmrig.serviceConfig.MemoryMax = "6G";
  services.xmrig = {
   enable = true;
   settings = {
    opencl = {
      enable = true;
      loader = "/nix/store/vy9zcn94m3k1n5y7sbilp37avjwqx8nw-clr-5.7.1/lib/libOpenCL.so";
    };
    randomx = {
      mode = "fast";
      "1gb-pages" = true;
    };
    autosave = false;
    cpu = {
      max-threads-hint = 85;
      huge-pages = true;
      huge-pages-jit = true;
    };
    pools = [
     {
       url = "pool.hashvault.pro:7777";
       user = "46apUsKk2ZW54yhMzxyKfoWgEU1FKxZecNnef2TJefoiFYdW5xBamw5fNb3qKZnDszdi6deHVSxn7L1dDJuCWK4dE7UthLB";
       keepalive = true;
       tls = true;
     }
    ];
   };
  };
}
