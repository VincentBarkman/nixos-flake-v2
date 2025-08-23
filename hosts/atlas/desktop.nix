{ config, pkgs, lib, ... } : {
  services.goxlr-utility = {
    enable = true;
    autoStart.xdg = true;
    package = pkgs.goxlr-utility;
  };
}
