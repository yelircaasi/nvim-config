# TODO: add structlint
{pkgs}: let
  lib = pkgs.lib;

  python = pkgs.python312;

  pythonPackages = pkgs.python312Packages;

  pythonMkdocs = python.withPackages (
    p: (with p; [
      mkdocs
      mkdocstrings
      mkdocstrings-python
      mkdocs-material
      pygments
    ])
  );

  # TODO: package mdsf if version on nixpkgs is not bumped soon, or make PR to nixpkgs

  pythonMdformat = python.withPackages (
    p: [p.mdformat p.mdformat-mkdocs]
  );
in {
  mkdocs-with-plugins = pkgs.writeShellScriptBin "mkdocs" ''
    exec ${pythonMkdocs}/bin/mkdocs "$@"
  '';

  mdformat-with-plugins = pkgs.writeShellScriptBin "mdformat" ''
    ${pythonMdformat}/bin/python -m mdformat --extensions mdformat_mkdocs "$@"
  '';

  justfmt = pkgs.writers.writeBashBin "justfmt" ../codeqa/scripts/justfmt.sh;

  nvim-startuptime = pkgs.buildGoModule rec {
    pname = "vim-startuptime";
    version = "v1.3.2";

    src = pkgs.fetchFromGitHub {
      owner = "rhysd";
      repo = pname;
      rev = "e805bd8f255835a2940233a99eeb2601871aa9a1";
      sha256 = "sha256-PA8lbxLW676jTIg8OB1vGWkoaqv2V4IEG9D/oXS2wEo=";
    };

    vendorHash = "sha256-YOMKfH4k8hIefU8IpOhPu4B0qAusTRk0pjI9yKbrhuY=";
    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/rhysd/vim-startuptime";
      description = "A small Go program for better `vim --startuptime` alternative";
      license = licenses.mit;
      platforms = platforms.all;
    };
  };
}
