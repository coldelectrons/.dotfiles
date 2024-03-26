{ pkgs, pkgs-ce, ... }:
# TODO XXX WTF current problems with spacenavd
# * it runs as a systemd user unit
#   * the nixpkg ties it to 'graphical.target', which isn't a user target
#     It should be 'graphical-session.target'
#   * spacenavd doesn't have read permissions for ANYTHING in /dev/input/
#     So I added some udev extraRules.
#   * I'm currently using a Wayland, so there might still need to be a
#     workaround for xauth or whatever
{
  environment.systemPackages = with pkgs; [
    # pkgs-ce.spacenavd
    # pkgs-ce.spacenav-cube-example
    spacenavd
    spacenav-cube-example
  ];

  # currently, does nothing because the nixpkg makes the systemd
  # unit depend on graphical.target, which doesn't exist for users
  hardware.spacenavd.enable = true;

  # I've merged that languishing spacenav PR into my own nixpkgs
  systemd.user.services.spacenavd-user = {
    description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d -l syslog";
    };
  };

  # because this is supposed to be a USER unit, and the default permissions are 660
  services.udev.extraRules = ''
    #3D Connexion vendor devices
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c603", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c605", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c606", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c621", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c623", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c625", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c626", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c627", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c628", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c629", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62b", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62e", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c62f", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c631", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c632", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c633", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c635", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c636", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c640", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="256f", ATTRS{idProduct}=="c652", MODE="0666"
  '';
}
