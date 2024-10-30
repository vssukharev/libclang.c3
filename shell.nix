{ pkgs ? import <nixpkgs> {} }: with pkgs; 
mkShell {
  shellHook = ''zsh'';
  
  buildInputs = [
    c3c
    libclang.lib
  ];

  CPATH = builtins.concatStringsSep ":" [ "${libclang.dev}/include" ];
  LIBRARY_PATH = builtins.concatStringsSep ":" [ "${libclang.lib}/lib" ];
}

