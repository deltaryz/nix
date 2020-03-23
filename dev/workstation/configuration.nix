# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, lib, ... }:

{

  networking.hostName = "workstation"; # Define your hostname.
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;

  imports =
  [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
      (
        import ../../default.nix (
          args
          // {device = "enp2s0"; hostname = "workstation";}
        )
      )
      ../../local.nix
    ];

}