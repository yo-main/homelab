let
  unstable = import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/63590ac958a8af30ebd52c7a0309d8c52a94dd77")
    { config = {allowUnfree=true;}; };
in
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShellNoCC {
  # ensure aws cli will use the correct urllib3
  shellHook = ''
    export PYTHONPATH=""
    export EDITOR=hx
  '';

  packages = with unstable; [ 
    awscli2
    # ansible
    python314
  ];

}
