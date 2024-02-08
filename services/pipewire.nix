{ config, pkgs, ... }:

{
  # https://nixos.wiki/wiki/PipeWire
  # https://wiki.archlinux.org/title/PipeWire
  hardware.pulseaudio.enable = false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    #package = unstable.pipewire;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    #jack.enable = true;
  };

  # Bluetooth Audio
  environment.etc = {
  	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
  		bluez_monitor.properties = {
  			["bluez5.enable-sbc-xq"] = true,
  			["bluez5.enable-msbc"] = true,
  			["bluez5.enable-hw-volume"] = true,
  			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  		}
  	'';
  };

  # Install packages
  environment.systemPackages = with pkgs; [
    helvum
    easyeffects
  ];
}
