{ config, lib, ... }:

let
  inherit (lib) mkDefault;
in
{
  # english locales
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  # german keyboard layout
  #console = {
  #  keyMap = "en";
  #  font = "Lat2-Terminus16";
  #};

  #services.xserver.layout = "en";
  #services.xserver.xkbOptions = "eurosign:e";

  #time.timeZone = "Europe/Berlin";
}
