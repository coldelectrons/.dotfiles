{ config, pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.consoleLogLevel = 0;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];
  boot.kernelParams = [ 
    "amd_iommu=pt"
    "iommu=soft"
    # "vfio-pci.ids=1002:0b36,1002:aae8" # passthrough R9 Nano
  ];                                                                                                                                   
}
