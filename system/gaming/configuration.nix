{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = config.nixpkgs.config; };

  nix-software-center = import (pkgs.fetchFromGitHub {
    owner = "vlinkz";
    repo = "nix-software-center";
    rev = "0.1.2";
    sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  }) { pkgs = unstable; };

  nixos-conf-editor = import (pkgs.fetchFromGitHub {
    owner = "vlinkz";
    repo = "nixos-conf-editor";
    #rev = "0.1.1";
    rev = "9be2ed1183ca1cdf9c3a7a437032f41241d7a3b5";
    sha256 = "sha256-QOigD8CaueznOKjjTpz1+lwiOX1o6qPTgZE6GmrCL/o=";
  }) { pkgs = unstable; };
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/hardware.nix
      ../../modules/amd
      ../../modules/nvidia
      ../../profiles/desktop.nix
      ../../profiles/personal.nix
      ../../profiles/workstation.nix
      ../../profiles/communication.nix
      ../../profiles/gaming.nix
      ../../services/backup
      /home/davidak/code/trustix/nixos
    ];

  boot.loader.grub.device = "/dev/sda";

  # no access time and continuous TRIM for SSD
  fileSystems."/".options = [ "noatime" "discard" ];

  hardware.cpu.intel.updateMicrocode = true;
  # use latest kernel to have best performance
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #boot.extraModulePackages = [ pkgs.linuxPackages_latest.v4l2loopback ];
  #boot.kernelModules = [ "v4l2loopback" ];
  #boot.extraModprobeConfig = ''
  #  options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS"
  #'';

  hardware.gpu.amd.enable = true;
  hardware.gpu.nvidia.enable = false;

  # prevent ping drop by increasing ARP table
  # neighbour: arp_cache: neighbor table overflow!
  boot.kernel.sysctl = {
    "net.ipv4.neigh.default.gc_thresh1" = 32768;
    "net.ipv4.neigh.default.gc_thresh2" = 65536;
    "net.ipv4.neigh.default.gc_thresh3" = 131072;
    # The number 4,294,967,295, equivalent to the hexadecimal value FFFF,FFFF16, is the maximum value for a 32-bit unsigned integer in computing.
    # https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
    # https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/core/neighbour.c?h=v5.7.19#n2326
  };

  networking = {
    hostName = "gaming";
    domain = "lan";

    firewall.enable = true;
  };

  # use local domain
  services.restic.backups.nas = {
    repository = "s3:http://nas.lan:9000/restic/restic";
  };

  # Sync additional folders
  services.syncthing = {
    folders = {
      "Sync" = { path = "/home/davidak/Sync"; devices = [ "nas" ]; };
      "klavaro-config" = { path = "/home/davidak/.config/klavaro"; devices = [ "nas" ]; };
      "klavaro-data" = { path = "/home/davidak/.local/share/klavaro"; devices = [ "nas" ]; };
    };
  };

  services.trustix = {
    enable = true;

    signers.davidak = {
      type = "ed25519";
      ed25519.private-key-path = "/var/lib/trustix/keys/private";
    };

    publishers = [
      {
        signer = "davidak";
        protocol = "nix";
        meta = {
          upstream = "https://cache.nixos.org";
        };
        publicKey = {
          type = "ed25519";
          key = builtins.readFile /var/lib/trustix/keys/public;
        };
      }
    ];

    subscribers = [
      # local
      {
        protocol = "nix";
        publicKey = {
          type = "ed25519";
          key = "APAu/WvYTnCQSIg+5OzWKC/D+JzWFJZmvNsPPBbfhcQ=";
        };
      }
      # fails https://github.com/nix-community/trustix/issues/86
      # demo.trustix.dev
#      {
#        protocol = "nix";
#        publicKey = {
#          type = "ed25519";
#          key = "2uy8gNIOYEewTiV7iB7cUxBGpXxQtdlFepFoRvJTCJo=";
#        };
#      }
    ];

    deciders."nix" = {
      engine = "percentage";
      #percentage.minimum = 66;
      percentage.minimum = 0;
    };

    # A remote can expose many logs and they are not necessarily created by the remote in question
    remotes = [
      #"grpc+http://127.0.0.1"
      #"https://cache.nixos.org"
      # fails https://github.com/nix-community/trustix/issues/86
      #"https://demo.trustix.dev"
      #"https://r13y.trustix.dev"
      #"unix:///run/trustix-daemon.socket"
    ];

  };

  # Push local builds via the post-build hook
  services.trustix-nix-build-hook = {
    enable = true;
    #publisher = "ccbfc3d79bc7c05ebb0655fb62e694ab3a69ae55ed16a86faede15f2b8b1e190"; # logID
    logID = "ccbfc3d79bc7c05ebb0655fb62e694ab3a69ae55ed16a86faede15f2b8b1e190";
  };

  # Enable the local binary cache server
  # crash https://github.com/nix-community/trustix/issues/36
  services.trustix-nix-cache = {
    enable = true;
    private-key = "/var/trustix-nix-cache/cache-private-key.pem";
    #listen = "0.0.0.0";
    #port = 9001;
    #openFirewall = true;
  };

  nix.settings = {
    substituters = [
      # does not work, see above
      #"http://localhost:9001"
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "binarycache.example.com:1jDBzpOkGMIXVWATNEGwL82knvvv4QTHEaPGCSAXuTA="
    ];
  };

  # install packages
  environment.systemPackages = with pkgs; [
    nix-software-center
    nixos-conf-editor
    klavaro
  ];

  # compatible NixOS release
  system.stateVersion = "19.03";
}
