{
  description = "Flake of coldelectrons";

  outputs = { self, nixpkgs, nixpkgs-stable,
              home-manager, 
      	      blocklist-hosts,
              rust-overlay,
              freecad-realthunder,
              chaotic,
              ... }@inputs:
  let
    # ---- SYSTEM SETTINGS ---- #
    systemSettings = {
      system = "x86_64-linux"; # system arch
      hostname = "nixos"; # hostname
      profile = "desktop"; # select a profile defined from my profiles directory
      timezone = "America/New_York"; # select timezone
      locale = "en_US.UTF-8"; # select locale
    };

    # ----- USER SETTINGS ----- #
    userSettings = rec {
      username = "thomas"; # username
      name = "thomas"; # name/identifier
      email = "frithomas@gmail.com"; # email (used for certain configurations)
      dotfilesDir = "~/.dotfiles"; # absolute path of the local repo
      wm = "plasma6"; # Selected window manager or desktop environment; must select one in both ./user/wm/ and ./system/wm/
      wmType = "wayland";
      browser = "librewolf"; # Default browser; must select one from ./user/app/browser/
      term = "kitty"; # Default terminal command;
      font = "JetBrainsMono"; # Selected font
      fontPkg = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "Inconsolata" "NerdFontsSymbolsOnly" "Hack" "SourceCodePro"]; }); # Font package
      editor = "nvim"; # Default editor;
      # editor spawning translator
      # generates a command that can be used to spawn editor inside a gui
      # EDITOR and TERM session variables must be set in home.nix or other module
      # I set the session variable SPAWNEDITOR to this in my home.nix for convenience
      spawnEditor = if (editor == "emacsclient") then "emacsclient -c -a 'emacs'"
                    else (if ((editor == "vim") || (editor == "nvim") || (editor == "nano")) then "exec " + term + " -e " + editor else editor);
    };


    # create patched nixpkgs
    nixpkgs-patched = (import nixpkgs { system = systemSettings.system; }).applyPatches {
      name = "nixpkgs-patched";
      src = nixpkgs;
      patches = [
                  # ./patches/emacs-no-version-check.patch
                  # ./patches/nixos-nixpkgs-268027.patch
                ];
    };


    # configure pkgs
    pkgs = import nixpkgs-patched {
      system = systemSettings.system;
      config = { allowUnfree = true;
                 allowUnfreePredicate = (_: true);
                 permittedInsecurePackages = [
                   "qtwebkit-5.212.0-alpha4" # needed by smtube, but doesn't even compile???
                 ];
        };
      overlays = [ rust-overlay.overlays.default ];
    };

    pkgs-stable = import nixpkgs-stable {
      system = systemSettings.system;
      config = { allowUnfree = true;
                 allowUnfreePredicate = (_: true);
                 permittedInsecurePackages = [
                   # "qtwebkit-5.212.0-alpha4"
                 ];
        };
      overlays = [ rust-overlay.overlays.default ];
    };

    # configure lib
    lib = nixpkgs.lib;

    pkgs-local = import (/home/thomas/.nixpkgs-local) {
      config.allowUnfree = true;
    };

  in {
    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ (./. + "/profiles"+("/"+systemSettings.profile)+"/home.nix") # load home.nix from selected PROFILE
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak # Declarative flatpaks
                  ];
        extraSpecialArgs = {
          # pass config variables from above
          inherit pkgs-stable;
          inherit pkgs-local;
          inherit systemSettings;
          inherit userSettings;
          inherit (inputs) nix-flatpak;
          inherit (inputs) freecad-realthunder;
        };
      };
    };
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [ 
          (./. + "/profiles"+("/"+systemSettings.profile)+"/configuration.nix") # load configuration.nix from selected PROFILE
          chaotic.nixosModules.default
        ];
        specialArgs = {
          # pass config variables from above
          inherit systemSettings;
          inherit userSettings;
          inherit (inputs) blocklist-hosts;
        };
      };
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.2.0";

    blocklist-hosts = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };

    freecad-realthunder = {
      url = "github:coldelectrons/freecad-realthunder-nix-flake";
      flake = true;
    };
  };

