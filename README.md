# NixOS Config

** What is this repository?
These are my dotfiles (configuration files) for my NixOS setup(s).
These are based heavily on librephoenix and others.


## Modules
Separate Nix files can be imported as modules using an import block:
``` nix
imports = [ ./import1.nix
            ./import2.nix
            ...
          ];
```

I have my modules separated into two groups:
- System-level - stored in the [system directory](./system)
  - System-level modules are imported into configuration.nix, which is what is sourced into [my flake (flake.nix)](./flake.nix)
- User-level - stored in the [user directory](./user) (managed by home-manager)
  - User-level modules are imported into home.nix, which is also sourced into [my flake (flake.nix)](./flake.nix)

More detailed information on these specific modules are in the system directory and user directory respectively.

** Profiles
I separate my configurations into [profiles](./profiles) (essentially system templates), i.e:
- [desktop](./profiles/desktop) - What I would run on a personal desktop
- [laptop](./profiles/laptop) - What I would run on a personal laptop

My profile can be conveniently selected in [my flake (flake.nix)](./flake.nix) by setting the `profile` variable.

More detailed information on these profiles is in the `profiles` directory.

