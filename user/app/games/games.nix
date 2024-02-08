{ config, pkgs, pkgs-stable, ... }:
let
in
{
  home.packages = with pkgs; [
    # Games
    steam
  ];
  programs.steam = {
    enable = true;
    #remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    #dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  # To get steam to import into gamehub, first install it as a flatpak, then
  # Set steam directory to ~/.var/app/com.valvesoftware.Steam/.steam

  #services.flatpak.packages = [
  #  "com.discordapp.Discord"
  #  "com.jaquadro.NBTExplorer"
  #];
}
