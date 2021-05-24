let
  projectDir = "/home/romain/Code/swara";

  haskellNixSrc = builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz";
  haskellNix = import haskellNixSrc { };
  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;

  project = pkgs.haskell-nix.project {
    compiler-nix-name = "ghc8104";
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      name = "swara";
      src = ./.;
    };
  };

  start-db = pkgs.writeShellScriptBin "start-db" ''
    if [ ! -d $PGDATA ];then
      ${pkgs.postgresql_13}/bin/initdb
    fi
    ${pkgs.postgresql_13}/bin/postgres -k ${projectDir}/.state/postgresql
  '';

  procfile = pkgs.writeText "procfile" ''
    backend: cd ${projectDir} && ${pkgs.ghcid}/bin/ghcid --command "cabal repl server" -W -T :main
    frontend: cd ${projectDir}/client && ${pkgs.nodejs}/bin/npm run dev
    database: ${start-db}/bin/start-db
  '';

  shell = project.shellFor {
    packages = ps: with ps; [ server ];
    exactDeps = true;
    withHoogle = false;

    tools = {
      cabal = "latest";
      cabal-fmt = "latest";
      ghcid = "latest";
      hlint = "latest";
      haskell-language-server = "latest";
    };

    buildInputs = [
      pkgs.nixpkgs-fmt
      pkgs.nodejs
      pkgs.nodePackages.prettier
      pkgs.overmind
    ];

    OVERMIND_PROCFILE = procfile;
    PGDATA = "${projectDir}/.state/postgresql/data";
  };

in
{ inherit project shell; }

#   let
#   project = import ./default.nix;
#   nixpkgs = import <nixpkgs> { };
#   projectDir = "/home/romain/Code/sitar-react";

#   start-db = nixpkgs.writeShellScriptBin "start-db" ''
#     if [ ! -d $PGDATA ];then
#       ${nixpkgs.postgresql_13}/bin/initdb
#     fi
#     ${nixpkgs.postgresql_13}/bin/postgres -k ${projectDir}/.state/postgresql
#   '';

#   procfile = nixpkgs.writeText "procfile" ''
#     backend: cd ${projectDir} && ${nixpkgs.ghcid}/bin/ghcid --command "cabal repl backend" -W -T :main
#     frontend: cd ${projectDir}/frontend && ${nixpkgs.nodejs}/bin/npm run dev
#     database: ${start-db}/bin/start-db
#   '';
# in
# project.shellFor {
#   exactDeps = true;
#   withHoogle = false;
#   packages = ps: with ps; [ backend ];

#   tools = {
#     cabal = "latest";
#     haskell-language-server = "latest";
#     hlint = "latest";
#   };

#   buildInputs = [
#     nixpkgs.ghcid
#     nixpkgs.haskellPackages.cabal-fmt
#     nixpkgs.nixpkgs-fmt
#     nixpkgs.nodejs
#     nixpkgs.nodePackages.prettier
#     nixpkgs.overmind
#   ];

#   OVERMIND_PROCFILE = procfile;
#   PGDATA = "${projectDir}/.state/postgresql/data";
# }
