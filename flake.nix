{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
  };
  outputs = { self, nixpkgs }:
    let
      forAllSystems = with nixpkgs.lib; f: foldAttrs mergeAttrs { }
        (map (s: { ${s} = f s; }) systems.flakeExposed);
    in
    {
      devShell = forAllSystems
        (system:
          let pkgs = nixpkgs.legacyPackages.${system}; in
          pkgs.mkShell rec {
            packages = with pkgs; [
	      qt6Packages.qtshadertools
            ];
          });
    };
}
