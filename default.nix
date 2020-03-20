{ config, pkgs, lib, ... }:

let
  src = builtins.fetchurl { url = https://www.warmplace.ru/soft/sunvox/sunvox-1.9.5d.zip; };
  sunvox = pkgs.sunvox.overrideAttrs (old: rec {
    version = "1.9.5d";
    inherit src;
  });
in
{
  imports =
    [ 
      (import "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/release-19.09.tar.gz}/nixos")
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.networkmanager.packages = [ pkgs.networkmanager_openvpn ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.lorri.enable = true;

  hardware.bluetooth.enable = true;
  # allow headsets
  
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      resample-method = "speex-float-10";
    };
  };

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    firefox-devedition-bin
    neofetch
    bash
    discord
    vscode
    maim
    xclip
    terminator
    gcc
    cmake
    direnv
    steam
    #wine
    #winetricks
    unzip
    sunvox
  ];

  # virtualbox and docker
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "delta" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.docker.enable = true;

  fonts.fonts = with pkgs; [
    noto-fonts noto-fonts-emoji liberation_ttf fira-code fira-code-symbols corefonts roboto roboto-mono terminus_font
  ];

  nixpkgs.config.allowUnfree = true;

  # this makes steam actually work
  hardware.opengl.driSupport32Bit = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  #hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
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
  };

  security.sudo.wheelNeedsPassword = false;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?

}

