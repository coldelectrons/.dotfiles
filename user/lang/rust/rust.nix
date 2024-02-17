{ pkgs, ... }:

{
  home.packages = with pkgs; [
      # Rust setup
      rustup
      evcxr
      cargo-info
      bacon
      
  ];
}
