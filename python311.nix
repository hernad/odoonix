{pkgs, lib, ft, ...}:

let
  mods = (import ./python-mods.nix {inherit ft lib;});
  #overridePyPackage = (import ./functions.nix {inherit lib;} ).overridePyPackage;
  generatePyOverrides = (import ./python-functions.nix {inherit lib;} ).generatePyOverrides;

in
pkgs.python311.override {
  packageOverrides = self: super: generatePyOverrides mods self super;
}