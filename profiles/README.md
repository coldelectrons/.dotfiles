# System Profiles

This directory contains various system profiles which can easily be set in my flake.nix by setting the `profile` variable.
Each profile directory contains a `configuration.nix` for system-level configuration and a `home.nix` for user-level configuration. 
Setting the `profile` variable in my flake will automatically source the correct `configuration.nix` and `home.nix`.

Current profiles I have available are:
- desktop - What I would run on a personal desktop - wm, messaging, cad, games, dev

I do not plan on making heirarchal profiles, because currently the complexity isn't worth it.
For now, copy an existing profile to a new name and edit it.
