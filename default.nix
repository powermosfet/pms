{ pkgs ? import <nixpkgs> { } }:

let
  signal-cli = pkgs.signal-cli;
in
  pkgs.haskellPackages.callPackage ./pms.nix { }
