{ config, pkgs, lib, ... }:

let
  pubkey = import ./pubkey.nix;
in
{
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = lib.mkDefault false;
    };
  };
  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
    unset -V GIT_ASKPASS
  '';

  users.extraUsers.root.openssh.authorizedKeys.keys = lib.mkDefault [ pubkey.thomas ];
}
