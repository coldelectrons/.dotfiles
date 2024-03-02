{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background_opacity = lib.mkForce "0.85";
    font_family = "JetBrainsMono";
  };
  programs.kitty.shellIntegration.mode = "nosudo";
}
