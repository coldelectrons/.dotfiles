# Themes

Inside this directory are (some) themes, and almost certainly not by me.
Borrowed from LibrePhoenix, I've taken to storing the images I use here
because I really, really dislike a 403 error stopping my nix build.

I do not have many themes, because I'm just starting on my NixOS config
and also because I generally don't need them.

Each theme directory stores a few relevant files:
- `${theme-name}.yaml` - This stores all 16 colors for the theme
- `some-name.png` - background image of your choice
- `theme.nix` - contains the variables such as polarity, and points to the yaml colors and background image

Look at any of the directories here for more info.
