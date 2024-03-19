{ pkgs, pkgs-ce, ... }:

{
  environment.systemPackages = with pkgs; [
    pkgs-ce.spacenavd
    pkgs-ce.spacenav-cube-example
  ];

  # currently, does nothing because the nixpkg makes the systemd
  # unit depend on graphical.target, which doesn't exist for users
  # hardware.spacenavd.enable = true;

  # TODO merge that languishing spacenav PR into my own nixpkgs
  systemd.user.services.spacenavd-user = {
    description = "Daemon for the Spacenavigator 6DOF mice by 3Dconnexion";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${pkgs-ce.spacenavd}/bin/spacenavd -d -l syslog";
    };
  };
}
