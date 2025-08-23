{
  description = "Reproducible NixOS + Home Manager setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    mkHost = { hostname, modules }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = modules ++ [
          ({ ... }: { networking.hostName = hostname; })
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vincent = import ./home/vincent.nix;
          }
        ];
      };
  in {
    nixosConfigurations = {
      atlas = mkHost {
        hostname = "atlas"; # desktop
        modules = [
          ./modules/common.nix
          /etc/nixos/hardware-configuration.nix
          ./hosts/atlas/desktop.nix
        ];
      };

      polaris = mkHost {
        hostname = "polaris"; # laptop
        modules = [
          ./modules/common.nix
          /etc/nixos/hardware-configuration.nix
          ./hosts/polaris/laptop.nix
        ];
      };
    };
  };
}

