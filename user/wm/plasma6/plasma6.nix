{ config, lib, pkgs, userSettings, ... }:

{
  imports = [
    ../../app/terminal/alacritty.nix
    ../../app/terminal/kitty.nix
  ];

  # gtk.cursorTheme = {
  #   package = pkgs.quintom-cursor-theme;
  #   name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
  #   size = 36;
  # };


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
      color = "#"+config.lib.stylix.colors.base00;
      inside-color = "#"+config.lib.stylix.colors.base00+"cc";
      inside-caps-lock-color = "#"+config.lib.stylix.colors.base09;
      inside-clear-color = "#"+config.lib.stylix.colors.base0A;
      inside-wrong-color = "#"+config.lib.stylix.colors.base08;
      inside-ver-color = "#"+config.lib.stylix.colors.base0D;
      line-color = "#"+config.lib.stylix.colors.base00;
      line-caps-lock-color = "#"+config.lib.stylix.colors.base00;
      line-clear-color = "#"+config.lib.stylix.colors.base00;
      line-wrong-color = "#"+config.lib.stylix.colors.base00;
      line-ver-color = "#"+config.lib.stylix.colors.base00;
      ring-color = "#"+config.lib.stylix.colors.base00;
      ring-caps-lock-color = "#"+config.lib.stylix.colors.base09;
      ring-clear-color = "#"+config.lib.stylix.colors.base0A;
      ring-wrong-color = "#"+config.lib.stylix.colors.base08;
      ring-ver-color = "#"+config.lib.stylix.colors.base0D;
      text-color = "#"+config.lib.stylix.colors.base00;
      key-hl-color = "#"+config.lib.stylix.colors.base0B;
      font = config.stylix.fonts.monospace.name;
      font-size = 20;
      fade-in = 0.5;
      grace = 5;
      indicator-radius = 100;
      screenshots = true;
      effect-blur = "10x10";
    };
  };
}
