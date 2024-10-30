{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: 
    let 
      pkgs = import nixpkgs { inherit system; };
    in 
    {
      legacyPackages = pkgs;
      devShells.default = import ./shell.nix { inherit pkgs; };
    }
  );
}
