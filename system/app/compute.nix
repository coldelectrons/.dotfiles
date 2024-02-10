{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    cudatoolkit
    cudaPackages.cudnn
    cudaPackages.cutensor
    #python311Packages.torchWithCuda
    #python311Packages.transformers
    llama-cpp ollama
    colmapWithCuda
  ];
  nix.settings.trusted-substituters = ["https://ai.cachix.org"];
  nix.settings.trusted-public-keys = ["ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="];
  boot.extraModulePackages = with config.boot.kernelPackages; [ nvidia ];
}
