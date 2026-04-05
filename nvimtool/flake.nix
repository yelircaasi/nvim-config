{
    description = "";
    inputs = {
        nixpkgs = {
            url = "github:nixos/nixpkgs/91849ded6ed12d309e6697bea17e0bda5fdc7ad3"; # 2026-03
        };

        flake-utils = {
            url = "github:numtide/flake-utils/11707dc2f618dd54ca8739b309ec4fc024de578b"; # 2025-10
        };

        pyproject-nix = {
            url = "github:pyproject-nix/pyproject.nix/87cb6f8e3138d013aba64b8ead55e7ed1976416f"; # 2026-04
            inputs.nixpkgs.follows = "nixpkgs";
        };

        uv2nix = {
            url = "github:pyproject-nix/uv2nix/3cffcee173635d553e213d11418690b5290ff1c9"; # 2026-04
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        pyproject-build-systems = {
            url = "github:pyproject-nix/build-system-pkgs/b6e74f433b02fa4b8a7965ee24680f4867e2926f"; # 2026-04
            inputs.pyproject-nix.follows = "pyproject-nix";
            inputs.uv2nix.follows = "uv2nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = {
        self,
        nixpkgs,
        flake-utils,
        pyproject-nix,
        uv2nix,
        pyproject-build-systems,
    }:
        flake-utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {
                inherit system;
                config.permittedInsecurePackages = []; #"olm-3.2.16"];
            };

            envs = import ./nix/python-environments.nix {
                inherit
                    pkgs
                    pyproject-nix
                    uv2nix
                    pyproject-build-systems
                    ;
            };

            inherit (envs) packageNameNix;
        in {
            packages = {
                default = envs.package;
                ${packageNameNix} = envs.package;
            };

            apps = {
                default = envs.app;
                ${packageNameNix} = envs.app;
            };

            devShells = {
                default = envs.uvPure;
                uv = envs.uvPure;
                uvFHS = envs.uvFHS;
                poetryFHS = envs.poetryFHS;
            };

            legacyPackages = pkgs;
        });
}
