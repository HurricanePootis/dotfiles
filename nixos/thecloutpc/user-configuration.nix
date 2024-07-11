# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
# System Options
# AMD Microcode
hardware.cpu.amd.updateMicrocode = true;
# Enabled powerdevil on KDE
powerManagement.enable = true;
# Hard Links
nix.settings.auto-optimise-store = true;
# mt7921e fix cause mediatek
powerManagement.powerDownCommands = "${pkgs.kmod}/bin/rmmod mt7921e";
powerManagement.powerUpCommands = "${pkgs.kmod}/bin/modprobe mt7921e";
# Drive sutff
services.fstrim = {
	enable = true;
	interval = "monthly";
};
services.btrfs = {
	autoScrub = {
		interval = "monthly";
		enable = true;
	};
};
# AMD pstate
boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	kernelParams = [ "amd_pstate=active" ];
};

# Auto upgrades cause unstable
system.autoUpgrade = {
	enable = true;
	dates = "daily";
};

zramSwap = {
	enable = true;
	priority = 1;
	algorithm = "zstd";
};

# My audio card supports these clock rates
services.pipewire = {
	alsa.enable = true;
	extraConfig.pipewire."10-clock-rate" = {
		"context.properties" = {
			"default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
		};
	};
};

# Games drive
fileSystems."/run/media/hurricane/superssd" =
    { device = "/dev/disk/by-uuid/33545447-1e6f-4086-9ad0-aebefd88ce1c";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };


networking.nameservers = [ "2606:4700:4700::1111" "1.1.1.1" ];
services.resolved = {
	enable = true;
	dnsovertls = "opportunistic";
	dnssec = "true";
	extraConfig = "MulticastDNS=resolve";
};
services.avahi = {
	enable = true;
};
hardware.bluetooth.enable = true;
services.printing.enable = true;

# Packages n Stuff

services.xserver.enable = true;
services.displayManager.sddm = {
	enable = true;
	wayland.enable = true;
};
services.desktopManager.plasma6.enable = true;
services.power-profiles-daemon.enable = true;
programs.git = {
	enable = true;
	lfs.enable = true;
};


programs.steam = {
	enable = true;
	extraCompatPackages = with pkgs; [ proton-ge-bin ];
};
hardware.steam-hardware.enable = true;

nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs; [ librewolf papirus-icon-theme prismlauncher vesktop amdgpu_top spotify fd compsize kdePackages.sddm-kcm lsof libreoffice-qt6-fresh ];
fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  twemoji-color-font
  liberation_ttf
];


programs = {
	neovim = {
		enable = true;
		defaultEditor = true;
	};
	htop = {
		enable = true;
	};
};
}
