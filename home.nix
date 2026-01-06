{ config, pkgs, opencodePkg, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    nvim = "nvim";
    hypr = "hypr";
    tmux = "tmux";
    ghostty = "ghostty";
    rofi = "rofi";
    waybar = "waybar";
  };
in

{
  home.username = "ph";
  home.homeDirectory = "/home/ph";
  home.stateVersion = "25.11";

  programs.git.enable = true;
  programs.bash.enable = true; 
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
    ];
  };

  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    gcc
    tmux
    fish
    rofi
    bun
    opencodePkg
    bat
    fastfetch
    tailscale
    unzip
    hyprshot
    hyprsunset
    hyprlock
    hyprpaper
    waybar
    localsend
    bitwarden-cli
    tree-sitter
    nodejs
    python3
    fd
    android-studio
  ];
}
