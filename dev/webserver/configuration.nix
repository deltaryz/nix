# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  networking.hostName = "webserver"; # Define your hostname.

  imports =
  [ # Include the results of the hardware scan.
    ../mbp/hardware-configuration.nix #fix this!!!
    ../../default.nix
    ../../remote.nix
  ];

}