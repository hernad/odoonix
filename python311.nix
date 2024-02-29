{pkgs, lib, ft, ...}:

let
  mods = (import ./mods.nix {inherit ft lib;});
  #overridePyPackage = (import ./functions.nix {inherit lib;} ).overridePyPackage;
  generatePyOverrides = (import ./functions.nix {inherit lib;} ).generatePyOverrides;

in
pkgs.python311.override {
  packageOverrides = self: super: generatePyOverrides mods self super;
}