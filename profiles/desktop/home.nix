{ config, pkgs, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

  programs.home-manager.enable = true;

  imports = [ 
              (./. + "../../../user/wm"+("/"+userSettings.wm+"/"+userSettings.wm)+".nix") # My window manager selected from flake
              ../../user/shell/sh.nix # My zsh and bash config
              ../../user/shell/cli-collection.nix # Useful CLI apps
              ../../user/app/ranger/ranger.nix # My ranger file manager config
              (./. + "../../../user/app/browser"+("/"+userSettings.browser)+".nix") # My default browser selected from flake
              ../../user/app/git/git.nix
              ../../user/app/flatpak/flatpak.nix # Flatpaks
              ../../user/lang/cc/cc.nix # C and C++ tools
              ../../user/lang/python/python.nix
              ../../user/lang/python/python-packages.nix
              # ../../user/lang/rust/rust.nix
              # ../../user/lang/godot/godot.nix # Game development
              ../../user/hardware/bluetooth.nix # Bluetooth
              ../../user/app/terminal/kitty.nix
              ../../user/app/browser/librewolf.nix
              ../../user/app/virtualization/virtualization.nix
              ../../user/app/cadcam/freecad-realthunder.nix
              ../../user/app/lunarvim/lunarvim.nix
              # ../../user/app/cadcam/eda.nix
              ../../user/hardware/bluetooth.nix # Bluetooth
            ];


  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # Core
    zsh zellij
    # bat
    # bat-extras.batman
    # bat-extras.batpipe
    # bat-extras.batgrep
    # bat-extras.batdiff
    # bat-extras.batwatch
    # bat-extras.prettybat
    alacritty
    kitty
    # yazi
    eza
    pipx
    thunderbird
    neomutt
    dmenu
    rofi
    syncthing
    neovim-unwrapped

    # Media
    krita
    inkscape
    yt-dlp
    youtube-tui
    vlc
    mpv
    ffmpeg
    mediainfo
    libmediainfo
    soundconverter

    # dev packages
    libffi zlib

    # games
    # playonlinux

    # cadcam
    # freecad
    prusa-slicer
    lightburn
    meshlab
    fstl

    # embedded
    # stlink
    # stlink-gui

  ];

  # services.syncthing.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
    extraConfig = {
      XDG_GAME_DIR = "${config.home.homeDirectory}/Media/Games";
      XDG_GAME_SAVE_DIR = "${config.home.homeDirectory}/Media/Game Saves";
      XDG_DOTFILES_DIR = "${config.home.homeDirectory}/.dotfiles";
      XDG_ARCHIVE_DIR = "${config.home.homeDirectory}/Archive";
      XDG_VM_DIR = "${config.home.homeDirectory}/Machines";
      XDG_ORG_DIR = "${config.home.homeDirectory}/Org";
      XDG_PODCAST_DIR = "${config.home.homeDirectory}/Media/Podcasts";
      XDG_BOOK_DIR = "${config.home.homeDirectory}/Media/Books";
    };
  };
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.mimeApps.associations.added = {
    # "application/octet-stream" = "flstudio.desktop;";
  };

  home.sessionVariables = {
    EDITOR = userSettings.editor;
    SPAWNEDITOR = userSettings.spawnEditor;
    TERM = userSettings.term;
    BROWSER = userSettings.browser;
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

}
