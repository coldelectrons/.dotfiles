{ config, pkgs, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [ ../laptop/home.nix # Personal is essentially work system + games
              ../../user/app/games/games.nix # Various videogame apps
              ../../user/app/cad/cad.nix # Various CAD apps
            ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh
    alacritty
    librewolf
    firefox
    thunderbird
    dmenu
    rofi
    syncthing
    lvim
    neovim-unwrapped
    neovide

    # dev
    cargo rustup 

    # Media
    smtube
  ];

  xdg.enable = true;
  xdg.userDirs = {
    extraConfig = {
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
    };
  };

}
