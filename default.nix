# Default configuration (applied to all machines)
{ config, pkgs, lib, ... }:

{
  imports =
    [ 
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;

  services.lorri.enable = true;

  time.timeZone = "America/Chicago";

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    wget
    vim
    git
    emacs
    rsync
    tmux
    openssh
    zsh
    curl
    abduco
    mosh
    neofetch
    bash
    gcc
    cmake
    direnv
    unzip
    #wine
    #winetricks
  ];

  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  services.openssh.enable = true;

  # Don't forget to set a password with ‘passwd’.
  users.users.delta = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    password = "password"; # don't forget to change this!
  };

  
  home-manager.users.delta = {
    programs.git = {
      enable = true;
      userName = "techniponi";
      userEmail = "wincam97@gmail.com";
    };

    home.file = {
      ".tmux.conf".source = ./dotfiles/tmux.conf;
      ".tmux".source = ./dotfiles/tmux;
      ".vimrc".source = ./dotfiles/vimrc;
      "bin/getip".source = ./dotfiles/getip;
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "19.09";

}

