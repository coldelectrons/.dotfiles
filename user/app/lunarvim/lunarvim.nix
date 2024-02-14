{ config, pkgs, pkgs-stable, ... }:
let
in
{
  home.packages = with pkgs; [
    # Games
    lunarvim
    neovim-unwrapped
    neovide
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home.file = {
    ".config/lvim/config.lua" = {
      source = ./config.lua;
    };
    ".local/bin/lvimide" = {
      source = ./lvim-ide;
    };
  };
}
