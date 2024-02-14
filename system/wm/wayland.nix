{ pkgs, ... }:

{
  imports = [ ./pipewire.nix
              ./dbus.nix
              ./gnome-keyring.nix
              ./fonts.nix
            ];

  environment.systemPackages = with pkgs; [
    wayland
    # waydroid
  ];

  # Configure xwayland
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    xkb.options = "caps:escape";
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
