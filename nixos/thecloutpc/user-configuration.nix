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
security.rtkit.enable = true;
services.pipewire = {
	alsa.enable = true;
	wireplumber.enable = true;
	jack.enable = true;
	extraConfig.pipewire."10-clock-rate" = {
	"context.properties" = {
		"default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
		};
	};
};

# Drives and Mounts
fileSystems."/run/media/hurricane/superssd" =
    { device = "/dev/disk/by-uuid/33545447-1e6f-4086-9ad0-aebefd88ce1c";
      fsType = "btrfs";
      options = [ "compress=zstd" ];
    };
fileSystems."/run/media/hurricane/arch" =
	{ device = "/dev/disk/by-uuid/48310d9a-9a82-4b9e-aae5-13fda5ae3931";
	  fsType = "btrfs";
	  options = [ "compress=zstd" ];
	};
fileSystems."/run/media/hurricane/arch/home" =
    { device = "/dev/disk/by-uuid/48310d9a-9a82-4b9e-aae5-13fda5ae3931";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@home" ];
    };

fileSystems."/run/media/hurricane/arch/swap" =
    { device = "/dev/disk/by-uuid/48310d9a-9a82-4b9e-aae5-13fda5ae3931";
      fsType = "btrfs";
      options = [ "compress=zstd" "subvol=@swap" ];
    };

fileSystems."/run/media/hurricane/arch/boot" =
    { device = "/dev/disk/by-uuid/5BCE-FA91";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

fileSystems."/home/hurricane/.local/share/PrismLauncher" =
	{ device = "/run/media/hurricane/arch/home/hurricane/.local/share/PrismLauncher";
	  fsType = "none";
	  options = [ "bind" ];
	  depends = [ "/run/media/hurricane/arch/home" "/home" ];
	};
fileSystems."/run/media/hurricane/backup" =
        { device = "/dev/disk/by-uuid/15fd26b0-1b43-42b8-945d-5fa5ccdd2b0a";
          fsType = "ext4";
          options = [ "defaults" ];
        };


networking.nameservers = [ "2606:4700:4700::1111" "1.1.1.1" ];
services = {
	resolved = {
		enable = true;
		dnsovertls = "opportunistic";
		dnssec = "true";
		extraConfig = "MulticastDNS=resolve";
		};
	avahi = {
		enable = true;
	};
	printing = {
		enable = true;
	};
	mullvad-vpn = {
		enable = true;
		package = pkgs.mullvad-vpn;
	};
};
hardware.bluetooth.enable = true;

# Packages n Stuff

services.xserver.enable = true;
services.displayManager.sddm = {
	enable = true;
	wayland.enable = true;
};
services.desktopManager.plasma6.enable = true;
services.power-profiles-daemon.enable = true;
hardware.steam-hardware.enable = true;

nixpkgs.config.allowUnfree = true;
environment.systemPackages = with pkgs; [ librewolf papirus-icon-theme prismlauncher vesktop amdgpu_top spotify fd compsize kdePackages.sddm-kcm lsof libreoffice-qt6-fresh qbittorrent mpv nomacs ];
fonts.packages = with pkgs; [
  noto-fonts
  noto-fonts-cjk
  twemoji-color-font
  liberation_ttf
];

environment.variables= {
	MOZ_ENABLE_WAYLAND = "1";
	WINEESYNC = "1";
	WINEFSYNC = "1";
};


programs = {
	neovim = {
		enable = true;
		defaultEditor = true;
	};
	htop = {
		enable = true;
	};
	git = {
		enable = true;
		lfs.enable = true;
	};
	steam = {
		enable = true;
		extraCompatPackages = with pkgs; [ proton-ge-bin ];
		};
	};
}
