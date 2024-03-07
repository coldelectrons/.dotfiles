{ ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];  
  hardware.opengl.enable = true;                                                                                                                                                                                   
  hardware.opengl.driSupport = true;   
}
