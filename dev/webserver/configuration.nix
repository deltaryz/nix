# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, lib, ... }:

{

  networking.hostName = "webserver"; # Define your hostname.

  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
      (
        import ../../default.nix (
          args
          // {device = "ens3";}
        )
      )
      ../../remote.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/vda";
  networking.interfaces.ens3.useDHCP = true;

  services.caddy = {
    enable = true;
    email = "me@cameronseid.com";
    agree = true;
    config = ''
      (common) {
        gzip
      }
      eevee.email {
        import common

        root /srv/test
        log syslog
      }
    '';
  };

  systemd.services.caddy = {
    user = "root";
  }

}