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

  procfile = pkgs.writeText "procfile" ''
    backend: cd ${projectDir} && ${pkgs.ghcid}/bin/ghcid --command "cabal repl server" -W -T :main
    frontend: cd ${projectDir}/client && ${pkgs.nodejs}/bin/npm run dev
    database: ${pkgs.writeShellScriptBin "start-db" ''
      if [ ! -d $PGDATA ];then
        ${pkgs.postgresql_13}/bin/initdb
      fi
      ${pkgs.postgresql_13}/bin/postgres -k ${projectDir}/.state/postgresql
    ''}/bin/start-db
    openapi: ls ${projectDir}/openapi.json | ${pkgs.entr}/bin/entr ${pkgs.writeShellScriptBin "watch-openapi" ''
      SOURCE="${projectDir}/openapi.json"
      CHECKSUM=$(md5sum "$SOURCE" | awk '{ print $1 }')
      FILE="${projectDir}/openapi.md5"

      if [ ! -f "$FILE" ] || [ "$CHECKSUM" != "$(cat $FILE)" ];
      then
          ${projectDir}/client/node_modules/.bin/openapi -i "$SOURCE" -o ${projectDir}/client/src/services/openapi
          echo $CHECKSUM > $FILE
      fi
    ''}/bin/watch-openapi
  '';

  shell = project.shellFor {
    packages = ps: with ps; [ server ];
    exactDeps = true;
    withHoogle = false;

    tools = {
      cabal = "latest";
      # cabal-fmt = "latest";
      ghcid = "latest";
      hlint = "latest";
      haskell-language-server = "latest";
    };

    buildInputs = [
      pkgs.nixpkgs-fmt
      pkgs.nodejs
      pkgs.nodePackages.prettier
      pkgs.overmind
      pkgs.yarn
    ];

    OVERMIND_PROCFILE = procfile;
    PGDATA = "${projectDir}/.state/postgresql/data";
  };

in
{ inherit project shell; }
