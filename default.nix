# Default configuration (applied to all machines)
{ pkgs, lib, device ? "none", ... }:

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
    git-secret
    emacs
    rsync
    tmux
    openssh
    fish
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
    shell = pkgs.fish;
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
      "bin/getip".text =
      ''
        #!/bin/sh
        ifconfig ${device} | grep 'inet ' | awk '{print $2}'
      '';
      "bin/getip".executable = true;
    };
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit =
  ''
    # Start tmux
    if [ -n "$TMUX" ]; then
      # set correct terminal
      if test -n "$STY"; then
        export TERM=screen-256color
      else
        export TERM=tmux-256color
      end
    else
      # only if we set USE_TMUX
      if [ -n "$USE_TMUX" ]; then
        start tmux
        tmux -u attach || tmux -u new
      end
    end

    # install fisher
    if not functions -q fisher
      set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
      curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
      fish -c fisher
    end

    # check if we have the theme or not
    if test -e ~/.config/fish/functions/fish_prompt.fish
      # it does
    else
      fisher add matchai/spacefish
    end

    # makes lorri/direnv work
    eval (direnv hook fish)

    # no greeting pls
    function fish_greeting
    end

    # start with neofetch
    clear && neofetch
  '';

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "19.09";

}

