{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShellNoCC {
  # ensure aws cli will use the correct urllib3
  shellHook = ''
    export PYTHONPATH=""
  '';

  packages = with pkgs; [ 
    ansible
    awscli2
    python311Packages.urllib3
  ];

}
