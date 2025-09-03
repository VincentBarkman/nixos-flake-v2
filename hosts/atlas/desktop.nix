{ config, pkgs, lib, ... } : {
  services.goxlr-utility = {
    enable = true;
    autoStart.xdg = true;
    package = pkgs.goxlr-utility;
  };

    services.xserver.videoDrivers = [ "nvidia" ];

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    powerManagement.enable = false;
  };

  environment.etc."xdg/autostart/99-lxqt-monitor-layout.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=Monitor Layout (LXQt)
    Comment=Apply preferred monitor arrangement at LXQt login
    Exec=${pkgs.xorg.xrandr}/bin/xrandr --output DP-2 --auto --primary --output DP-3 --auto --left-of DP-2 --output HDMI-1 --auto --right-of DP-2
    OnlyShowIn=LXQt;
    X-GNOME-Autostart-enabled=true
  '';
}
