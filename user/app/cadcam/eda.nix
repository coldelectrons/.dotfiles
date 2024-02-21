{ pkgs,  ... }:

{
  home.packages = with pkgs; [
    lepton-eda
    pcb
    librepcb
    pcb2gcode
    gerbv
    #pcb-rnd??
    kicad
    kicadAddons.kikit
    flatcam
  ];

}
