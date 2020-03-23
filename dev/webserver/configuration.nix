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
          // {device = "ens3"; hostname = "webserver";}
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
        log caddy.log
      }

      eevee.email {
        import common

        root /srv/eevee.email
      }

      #cameronseid.com {
      :9000 {
        import common

        browse
        root /srv/cameronseid.com
      }

      #blog.cameronseid.com {
      :8070 {
        import common

        root /srv/blog.cameronseid.com
        proxy / localhost:8069
      }

      #horsecock.party {
      :9001 {
        import common
        
        root /srv/horsecock.party
      }

      #floof.zone {
      :9002 {
        import common

        browse
        redir /pvfm https://discord.gg/6WCgzHm
        redir /streamlabs https://streamlabs.com/slobs/d/3177955
        root /srv/floof.zone
      }

      #e669.fun {
      :9003 {
        import common

        #git {
        #  repo https://github.com/techniponi/e669
        #  interval 300
        #}
        root /srv/e669.fun
      }

      #snuggle.monster {
      :9004 {
        import common

        #git {
        #  repo https://github.com/techniponi/tsgame
        #  path ..
        #  interval 60
        #}
        root /srv/snuggle.monster
      }

      #floof.monster{
      #figure out how to do this
      #}

    '';
  };

  systemd.services.caddy.serviceConfig = {
    user = "root";
  };

}