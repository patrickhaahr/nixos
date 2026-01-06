{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";
  
  console.keyMap = "dk";
  boot.initrd.preLVMCommands = ''
    ${pkgs.kbd}/bin/loadkeys dk
   '';

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "ph" "patrickhaahr" ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.xserver = {
    enable = true;
    xkb.layout = "dk";
  };

   services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    extraDaemonFlags = [ "--no-logs-no-support" ];
  };
 
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.ph = {
    isNormalUser = true;
    extraGroups = [ "wheel" "adbusers" "kvm" ];
    packages = with pkgs; [
      tree
    ];
  };

  programs.hyprland.enable = true;
  programs.fish.enable = true;
  programs.adb.enable = true;
  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "android-studio-stable"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    ghostty
  ];
  
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono 
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "25.11";
}

