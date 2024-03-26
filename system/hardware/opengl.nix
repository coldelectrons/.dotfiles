{ pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];  
  hardware.opengl = {
    enable = true;                                                                                                                                                                                   
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };
}

