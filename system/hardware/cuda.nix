{ ... }:

{
  # OpenGL
  hardware.opengl.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    pciutils
    cudatoolkit
    cudnn
    cutensor
  ];
}
