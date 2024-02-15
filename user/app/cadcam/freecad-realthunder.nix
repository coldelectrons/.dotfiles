{pkgs, freecad-realthunder, ...}:
{
  home.packages = [ 
    freecad-realthunder.packages.${pkgs.system}.freecad-realthunder
    freecad-realthunder.packages.${pkgs.system}.py-slvs
  ];
}
