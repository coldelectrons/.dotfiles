{ pkgs,  ... }:

{
  home.packages = with pkgs; [
    #lepton-eda
    #pcb
    #librepcb
    pcb2gcode
    gerbv
    #pcb-rnd??
    kicad
    kikit
    #flatcam # broken bc of python39 and ipython
  ];

}
