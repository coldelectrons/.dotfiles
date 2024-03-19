{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kitty
    mdcat
    termpdfpy
    presenterm
    slides
    mdp
    termimage
    viu
    kitty-img
    pixcat
    nb
    neofetch
    wl-clipboard
    glow
  ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background_opacity = lib.mkForce "0.85";
    font_family = "JetBrainsMono";
  };
  programs.kitty.shellIntegration.mode = "nosudo";
}
