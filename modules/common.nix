{ config, pkgs, lib, ... } : {
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  console.keyMap = "sv-latin1";

  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;

  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.bigblue-terminal
  ];

  users.users.vincent = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bash;
  };

  users.users.guest = {
    isNormalUser = true;
    description = "Guest account";
    createHome = true;
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" ];
    initialPassword = "guest";
  };

  services.libinput.enable = true;

  services.xserver = {
    enable = true;
    xkb.layout = "se";

    desktopManager.lxqt.enable = true;
  };
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;

  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      i3status
      i3lock
      dmenu
      picom
      feh
    ];
  };


  services.displayManager.ly.enable = true;
  services.displayManager.defaultSession = "none+i3";

  services.picom =  {
    enable = true;
    vSync = true;
    fade = false;
    shadow = false;
  };

  home-manager.backupFileExtension = "hm-bak";

  system.stateVersion = "25.05";
}

