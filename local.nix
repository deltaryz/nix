# Local configuration (desktops, laptops, anything with a screen)
{ config, pkgs, lib, ... }:

let
  src = builtins.fetchurl { url = https://www.warmplace.ru/soft/sunvox/sunvox-1.9.5d.zip; };
  sunvox = pkgs.sunvox.overrideAttrs (old: rec {
    version = "1.9.5d";
    inherit src;
  });
in
{
  environment.interactiveShellInit =
  ''
    export USE_TMUX=true
  '';

  boot.loader.grub.useOSProber = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ pkgs.networkmanager_openvpn ];

  hardware.bluetooth.enable = true;
  
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      resample-method = "speex-float-10"; # better audio quality
    };
  };

  environment.systemPackages = with pkgs; [
    discord
    firefox-devedition-bin
    vscode
    maim
    xclip
    terminator
    sunvox
    steam
    tilda
    gimp-with-plugins
    krita
    vlc
  ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "delta" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;

  fonts.fonts = with pkgs; [
    powerline-fonts noto-fonts noto-fonts-emoji liberation_ttf fira-code fira-code-symbols corefonts roboto roboto-mono terminus_font
  ];

  # this makes steam actually work
  hardware.opengl.driSupport32Bit = true;

  services.printing.enable = true;
  sound.enable = true;
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

}