let
  powerdevilOverlay = final: prev: {
    kdePackages = prev.kdePackages // {
      powerdevil = prev.kdePackages.powerdevil.overrideAttrs
        (old: { buildInputs = old.buildInputs ++ [ final.ddcutil ]; });
    };
  };
in {
  hardware.i2c.enable = true;
  nixpkgs.overlays = [ powerdevilOverlay ];
}
