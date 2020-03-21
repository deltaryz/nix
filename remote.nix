# Remote configuration (servers)
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    caddy
  ];
}