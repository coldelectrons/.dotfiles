{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    spacenavd
    spacenav-cube-example
    usbutils
    usbview
  ];

  # currently, does nothing because the nixpkg makes the systemd
  # unit depend on graphical.target, which doesn't exist for users
  hardware.spacenavd.enable = true;

  systemd.user.services.spacenavd = {
    description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${pkgs.spacenavd}/bin/spacenavd -d -l syslog";
    };
  };
}
