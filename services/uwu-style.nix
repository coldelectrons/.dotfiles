{ config, pkgs, lib, ... }:

# UwU Style for NixOS

let
  nixowo = pkgs.fetchFromGitHub {
    owner = "TilCreator";
    repo = "NixOwO";
    rev = "d2bc0591d78f95d1659da9d9f5e2f07615075fd7";
    sha256 = "sha256-5H9PRSY77oMABvgNDZ/wBayEBXJTzE9sGeAjkFAqYIQ=";
  };

  nixowo-icons = pkgs.runCommandLocal "nixowo-icons" {  }
  ''
    install -m644 ${nixowo}/NixOwO_plain.svg -D $out/share/icons/hicolor/scalable/apps/nix-snowflake.svg
  '';
  meta.priority = 10;

  nixowo-icon = pkgs.runCommandLocal "nixowo-icon"
  { nativeBuildInputs = [ pkgs.imagemagick ]; }
  ''
    mkdir $out
    # convert logo to png
    convert -background none ${nixowo}/NixOwO_plain.svg logo.png
    # resize logo
    convert logo.png -resize 256x256 $out/logo.png
  '';
in
{
  boot.plymouth.logo = "${nixowo-icon}/logo.png";
  boot.plymouth.theme = "breeze"; # default is bgrt
  #boot.plymouth.themePackages = "";

  environment.systemPackages = [
    nixowo-icons
  ];
}
