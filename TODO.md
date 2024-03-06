# TODO
- system/security/sshd.nix - see if there is a way to / need for keeping secrets secret.
  I know 'authorized keys' are public keys, but the notion still gives me pause.
- profiles/cuda - make a profile for a CUDA workstation. Add more apps:
  - photogrammetry - colmap, ODM, etc
  - textgen API server - maybe? Are these proven useful?
- freecad-realthunder - I have a flake as an input, but it seems I don't yet understand how to make it build as part of the system.
  Also, check the current state of vanilla freecad to see if I still need realthunder's branch.
- apps
  - steamvr?
  - Visicut?
  - PrusaSlicer - personal configs?
  - Steam - install some heavyweight modern games and see how it does - maybe Cyberpunk2077?
  - usb-modeswitch?
  - amaranth fpga?
  - RCU for Remarkable
  - Calibre with Kindle?
- hardware
  - non-free firmware?
  - flatbed scanner
  - hp 1100W printer - direct or network?
  - audio - confirm
- 'profiles' vs git branches
  It seems like overcomplication to make 'profiles', and to have to make this flake dirty
  in order to change between them. It seems better to make branches for each machine, and
  use the main branch to hold the base profile.
