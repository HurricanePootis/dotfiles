# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
# System Options
powerManagement.powerDownCommands = "${pkgs.kmod}/bin/rmmod mt7912e";
powerManagement.powerUpCommands = "${pkgs.kmod}/bin/modprobe mt7921e";
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

boot = {
	kernelPackages = pkgs.linuxPackages_latest;
	kernelParams = [ "amd_pstate=active" ];
};

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


environment.systemPackages = with pkgs; [ librewolf papirus-icon-theme prismlauncher vesktop ];



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
