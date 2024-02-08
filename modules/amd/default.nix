{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.gpu.amd;
in
{
  options.hardware.gpu.amd = {
    enable = mkEnableOption "AMD GPU";
  };

  config = mkIf cfg.enable {
    # use open source driver
    services.xserver.videoDrivers = [ "amdgpu" ];

    # OpenCL support for BOINC
    services.boinc.extraEnvPackages = with pkgs; [ ocl-icd ];

    # Fix OpenCL https://github.com/NixOS/nixpkgs/pull/82729
    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = [ pkgs.amdvlk ];
        extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    #meta = with lib; {
      #maintainers = with maintainers; [ coldelectrons ];
    #};
  };
}
