# System Profiles

This directory contains various system profiles which can easily be set in my flake.nix by setting the `profile` variable.
Each profile directory contains a `configuration.nix` for system-level configuration and a `home.nix` for user-level configuration. 
Setting the `profile` variable in my flake will automatically source the correct `configuration.nix` and `home.nix`.

Current profiles I have available are:
- laptop - What I would run on a personal laptop*
- desktop - What I would run on a personal desktop*
- compute - What I would run on a photogrammetry workstation.

*My laptop/desktop profiles are actually functionally identical (the laptop profile is actually imported into the desktop profile)!
The only difference between them is that my desktop profile has a few extra things like gaming and CAD apps.
