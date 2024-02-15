{ ... }:

{
  environment.systemPackages = with pkgs; [
    spacenavd
    spacenav-cube-example
    io-spacenav
    usbutils
    usbview
  ];

  hardware.spacenavd.enable = true;
}
