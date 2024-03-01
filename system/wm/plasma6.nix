{ pkgs, ... }:

{
  # Import wayland config
  imports = [ 
              # ./wayland.nix
              ./pipewire.nix
              ./dbus.nix
            ];

  # Security
  security = {
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
#    pam.services.gtklock = {};
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6 = {
    enable = true;
    # enableQt5Integration = false;
  };

  # environment.plasma6.excludePackages = with pkgs; {
  #   
  # };
}
