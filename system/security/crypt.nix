{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    sshfs
    sftpman
    sirikali
    ctmg
    cryptomator
  ];
}
