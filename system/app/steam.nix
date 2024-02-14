{ config, pkgs, pkgs-stable, ... }:
let
in
{
  environment.systemPackages = with pkgs; [
    protontricks
    lighthouse-steamvr
    protonup-ng
    protonup-qt
    proton-caller
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  # To get steam to import into gamehub, first install it as a flatpak, then
  # Set steam directory to ~/.var/app/com.valvesoftware.Steam/.steam

  programs.steam.enable = true;

}
