{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    spacenavd
    spacenav-cube-example
    usbutils
    usbview
  ];

  hardware.spacenavd.enable = true;
}
