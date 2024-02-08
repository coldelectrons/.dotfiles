These are just some simple install notes for myself (in-case I have to reinstall unexpectedly).

## Install Notes for Myself
To get this running on a NixOS system, start by cloning the repo:
``` sh
git clone https://gitlab.com/librephoenix/nixos-config.git ~/.dotfiles
```

To get the hardware configuration on a new system, either copy from =/etc/nixos/hardware-configuration.nix= or run:
``` sh
cd ~/.dotfiles
sudo nixos-generate-config --show-hardware-config > system/hardware-configuration.nix
```

Also, if you have a differently named user account than my default (=emmet=), you /must/ update the following lines in the let binding near the top of the [[./flake.nix][flake.nix]]:
``` nix
...
let
  ...
  # ----- USER SETTINGS ----- #
  username = "YOURUSERNAME"; # username
  name = "YOURNAME"; # name/identifier
...
```

There are many more config options there that you may also want to change as well.

Once the variables are set, then switch into the system configuration by running:
``` sh
cd ~/.dotfiles
sudo nixos-rebuild switch --flake .#system
```

Home manager can be installed with:
``` sh
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

If home-manager starts to not cooperate, it may be because the unstable branch of nixpkgs is in the Nix channel list.  This can be fixed via:
``` sh
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
```

Home-manager may also not work without re-logging back in after it has been installed.

Once home-manager is running, my home-manager configuration can be installed with:
``` sh
cd ~/.dotfiles
home-manager switch --flake .#user
```

