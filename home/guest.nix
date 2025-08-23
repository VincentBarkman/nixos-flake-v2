{ config, pkgs, lib, osConfig, ... }:

let
  desktopHosts = [ "atlas" "tower" ];
  laptopHosts  = [ "polaris" "wifi-1-user-1" ];

  host = osConfig.networking.hostName or "unknown";
  isLaptop = builtins.elem host laptopHosts;

  dotDesktop = ../dotfiles/desktop;
  dotLaptop  = ../dotfiles/laptop;
  dot = if isLaptop then dotLaptop else dotDesktop;
in
{
  home.username = "guest";
  home.homeDirectory = "/home/guest";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xsession.enable = true;

  xsession.windowManager.i3.enable = false;

  programs.alacritty.enable = true;
  programs.i3status.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig.projects = "${config.home.homeDirectory}/Documents/projects";
  };

  home.packages = with pkgs; [
    neovim
    git
    firefox
    fzf
    jq
    curl
    wget
    xclip
    maim
  ];

  xdg.configFile = {
    "alacritty".source = dot + /alacritty;
    "i3".source        = dot + /i3;
    "nvim".source      = dot + /nvim;
  };
}
