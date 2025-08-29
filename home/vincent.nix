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
  home.username = "vincent";
  home.homeDirectory = "/home/vincent";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  xsession.enable = true;
  home.sessionVariables.PKG_CONFIG_PATH = "${pkgs.sdl3.dev}/lib/pkgconfig";


  xsession.windowManager.i3 = {
    enable = false;
  };

  programs.alacritty.enable = true;
  programs.i3status.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    extraConfig = {
      projects = "${config.home.homeDirectory}/Documents/projects";
    };
  };

 
  home.packages = (
    (with pkgs; [
      # Development tools
      neovim
      git
      gnumake
      docker
      gdb
      valgrind
      jq
      sqlite
      tmux
      jetbrains.goland
      jetbrains.clion
      openshift
      cmake
      pkg-config
      clang-tools

      # Languages
      go
      python314
      clang
      nodejs_24
      rustup

      # packages
      sdl3

      # General
      neofetch
      fzf
      openssl
      keymapp
      cheese
      calc

      # network 
      networkmanagerapplet

      # Web
      firefox
      curl
      wget
      nmap

      # helpers
      maim
      xclip
      zip
      unzip

      # text
      plantuml
    ])
    ++ lib.optionals (!isLaptop) [ pkgs.goxlr-utility ]
    ++ lib.optionals isLaptop [ pkgs.brightnessctl pkgs.tlp ]
  );

  xdg.configFile = {
    "alacritty".source = dot + /alacritty;
    "i3".source        = dot + /i3;
    "nvim".source      = dot + /nvim;
  };
}

