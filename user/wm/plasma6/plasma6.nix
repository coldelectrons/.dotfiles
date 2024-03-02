{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
  ];

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = "Quintom_Ink"; # light
    # name = "Quintom_Snow"; # dark?
    size = 36;
  };


  home.packages = with pkgs; [
    alacritty kitty
    feh
    killall
    libva-utils
    wev
    grim
    slurp
    pavucontrol
    pamixer
    termusic
  ];
  services.udiskie.enable = true;
  services.udiskie.tray = "always";
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      font-size = 20;
      fade-in = 0.5;
      grace = 5;
      indicator-radius = 100;
      screenshots = true;
      effect-blur = "10x10";
    };
  };
}
