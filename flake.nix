#https://ianthehenry.com/posts/how-to-learn-nix/flakes/

{
#  # Executed by `nix flake check`
#  checks."<system>"."<name>" = derivation;
#  # Executed by `nix build .#<name>`

#  packages."<system>"."<name>" = derivation;
#  # Executed by `nix build .`
#  packages."<system>".default = derivation;

description = "odoo nixos developer environment";



inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
};

outputs = { self, nixpkgs, ... }@inputs:
let
    inherit (self) outputs;


    #forAllSystems = nixpkgs.lib.genAttrs [
    
    # https://github.com/NixOS/nixpkgs/issues/44255
    #freetype_static = pkgs.freetype.overrideAttrs (oldArgs: { dontDisableStatic = true; });
    ft = pkgs.freetype.overrideAttrs (oldArgs: { dontDisableStatic = true; });
    lib = pkgs.lib;
    #ft = pkgs.freetype;

    myConfig = {
        allowBroken = true;
        permittedInsecurePackages = [
            "openssl-1.1.1w"
        ];
    
        packageOverrides = pkgs: {
          python311 = (import ./python311.nix {inherit pkgs lib ft;});
        };
    };

    # https://nixos.org/manual/nixpkgs/unstable/#how-to-override-a-python-package-for-all-python-versions-using-extensions
        

    system = "x86_64-linux";

    pkgs = (import nixpkgs {
        inherit system;
        config = myConfig;   
    });
    stdenv = pkgs.stdenv;

    forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
    ];


     nixpkgsFor = forAllSystems (system: import nixpkgs 
       {
         inherit system;
         config = myConfig;
         #overlays = [ self.overlays.default ];

       }
    );

    odoo17 = self.packages.${system}.my-odoo-17;
    odoo17-11 = self.packages.${system}.my-odoo-17-11;
    
    odoo16 = self.packages.${system}.my-odoo-16;

    python-311 = self.packages.${system}.odoo-python-311;
    
    
    nginx-start = self.packages.${system}.nginx-start;
    my-wkhtmltopdf = self.packages.${system}.my-wkhtmltopdf;

    odoo-16-start = pkgs.writeShellScriptBin "odoo-16-start" ''
      #export PATH=${pkgs.wkhtmltopdf-bin}/bin:$PATH
      #echo "PATH=$PATH"
      #wkhtmltopdf --version
      exec ${odoo16}/bin/odoo -c ${./odoo.conf} "$@"
    '';

    odoo-17-start = pkgs.writeShellScriptBin "odoo-17-start" ''
      exec ${odoo17}/bin/odoo -c ${./odoo.conf} "$@"
    '';
    
    odoo-17-11-start = pkgs.writeShellScriptBin "odoo-17-11-start" ''
      exec ${odoo17-11}/bin/odoo -c ${./odoo.conf} "$@"
    '';

    #nginx-start = pkgs.writeShellScriptBin "nginx-start" ''
    #   exec ${pkgs.nginx}/bin/nginx -c ${./nginx/nginx.conf} "$@"
    #'';

    odooVersion17 = {
       url = null;
       version = "17.0";
       release = "20240130";
       hash = "sha256-0Dqar3CTBaG07LqMs7yykG3uK6FmPC3pJcWVIqZgibo=";

       #release = "20240204";
       #hash = "sha256-ieAlkbUS5b8j/2wRleLkzkVi0H0s7ZreCHbCjFnyKsA=";
    };

    odooVersion16 = {
       version = "16.0";
       release = "hernad-20240210";
       hash = "sha256-Wl+/rvfQ3LKTQcchnnWPp9+SHsttc5he02gwlu2EKVM=";
       url = "https://download.cloud.out.ba/odoo-16-hernad.zip";

       #release = "20240204";
       #hash = "sha256-ieAlkbUS5b8j/2wRleLkzkVi0H0s7ZreCHbCjFnyKsA=";
     };
in
{

     # https://git.sbruder.de/simon/nixpkgs-overlay/src/branch/master/flake.nix

     #overlays.default = import ./overlayPython.nix;

     packages = forAllSystems (system:
     let 
        pkgs = nixpkgsFor.${system};
     in 
     {

       odoo-python-311 = (import ./odoo-python-311.nix {inherit pkgs;}); 
       
      
       nginx-start = import ./nginx_start.nix { inherit stdenv pkgs; };
       postgresql-start = import ./postgresql_start.nix { inherit stdenv pkgs; };
       postgresql-stop = import ./postgresql_stop.nix { inherit stdenv pkgs; };
       
       
       my-odoo-16 = import ./odoo.nix  { inherit pkgs; odooVersion = odooVersion16; python = python-311; };
       my-odoo-17 = import ./odoo.nix  { inherit pkgs; odooVersion = odooVersion17; python = python-311; };

       
       odoo-16-start = odoo-16-start;
       odoo-17-start = odoo-17-start;
       #odoo-17-11-start = odoo-17-11-start;
       
       #default = self.packages.${system}.odoo-start;
       #nginx-start = nginx-start;



       odoo-python-311-pip = pkgs.python311.withPackages (ps: [
          ps.pip
          ps.virtualenv
       ]);

       my-wkhtmltopdf = pkgs.wkhtmltopdf-bin;
       
     });


     devShells.${system}.default = pkgs.mkShell {
         
      buildInputs = [
        nginx-start
     
        odoo-16-start
        odoo-17-start

        my-wkhtmltopdf
        
      ];

      shellHook = ''
        echo Let’s Nix with nginx !
        echo run: nginx-start\&

        echo "my-wkhtmltopdf: `${my-wkhtmltopdf}/bin/wkhtmltopdf --version`"

        echo "set (ln -sf) ./python311 ./odoo16/python311 ./odoo17/python311"
        
        ln -sf ${python-311}/bin/python ./python311

        ln -sf ${python-311}/bin/python ./odoo16/python311        
        ln -sf ${python-311}/bin/python ./odoo17/python311

        echo ok
        
      '';

     };

};

#  # Executed by `nix run .#<name>`
#  apps."<system>"."<name>" = {
#    type = "app";
#    program = "<store-path>";
#  };
#  # Executed by `nix run . -- <args?>`
#  apps."<system>".default = { type = "app"; program = "..."; };
#
#  # Formatter (alejandra, nixfmt or nixpkgs-fmt)
#  formatter."<system>" = derivation;
#  # Used for nixpkgs packages, also accessible via `nix build .#<name>`
#  legacyPackages."<system>"."<name>" = derivation;
#  # Overlay, consumed by other flakes
#  overlays."<name>" = final: prev: { };
#  # Default overlay
#  overlays.default = final: prev: { };
#  # Nixos module, consumed by other flakes
#  nixosModules."<name>" = { config }: { options = {}; config = {}; };
#  # Default module
#  nixosModules.default = { config }: { options = {}; config = {}; };
#  # Used with `nixos-rebuild switch --flake .#<hostname>`
#  # nixosConfigurations."<hostname>".config.system.build.toplevel must be a derivation
#  nixosConfigurations."<hostname>" = {};
#  # Used by `nix develop .#<name>`
#  devShells."<system>"."<name>" = derivation;
#  # Used by `nix develop`
#  devShells."<system>".default = derivation;
#  # Hydra build jobs
#  hydraJobs."<attr>"."<system>" = derivation;
#  # Used by `nix flake init -t <flake>#<name>`
#  templates."<name>" = {
#    path = "<store-path>";
#    description = "template description goes here?";
#  };
#  # Used by `nix flake init -t <flake>`
#  templates.default = { path = "<store-path>"; description = ""; };


}

