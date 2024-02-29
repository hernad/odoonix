{lib, ...}:

let

   overridePyPackage = with builtins; 
     module: final: prev: 

      prev.${module.mod}.overridePythonAttrs (old: 
      let
         ver = if hasAttr "version" module then module.version else if 
                  hasAttr "version" old then old.version else "1.0.0"; 
         ext = if hasAttr "extension" module then module.extension else if
                  hasAttr "extension" old then old.extension else "tar.gz";
      in
      rec
      {
         version = ver;
         extension = ext;
         doCheck = if hasAttr "doCheck" module then module.doCheck else if
                      hasAttr "doCheck" old then old.doCheck else true;
                    
         patches = if hasAttr "patches" module then module.patches else if
                      hasAttr "patches" old then old.patches else [];

         buildInputs = if hasAttr "buildInputs" module then module.buildInputs else if
                      hasAttr "buildInputs" old then old.buildInputs else [];


         postPatch = if hasAttr "postPatch" module then module.postPatch else if
                      hasAttr "postPatch" old then old.postPatch else "";              
         
      } // (if hasAttr "sha256" module || hasAttr "hash" module then {

        src = let 
            hashName = if hasAttr "sha256" module then "sha256" else "hash" ;            
            hashValue = if hasAttr "sha256" module then module.sha256 else 
                  module.hash;

         in old.src.override {
           version = ver;
           extension = ext;
           ${hashName} = hashValue;
         };

      } else {}));


in
{

    #mapAttrs (name: value: name + "-" + value)
    #   { x = "foo"; y = "bar"; }
    #=> { x = "x-foo"; y = "y-bar"; }

    generatePyOverrides = mods: newMod: oldMod: lib.mapAttrs (name: value: (overridePyPackage (value // { mod = name; }) newMod oldMod)) mods;
  
}