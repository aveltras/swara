let
  haskellNixSrc = builtins.fetchTarball "https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz";
  haskellNix = import haskellNixSrc {};
  pkgs = import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs;

  project = pkgs.haskell-nix.project {
    compiler-nix-name = "ghc8104";
    src = pkgs.haskell-nix.haskellLib.cleanGit {
      name = "swara";
      src = ./.;
    };
  };

  shell = project.shellFor {
    packages = ps: with ps; [ server ];
    exactDeps = true;
    withHoogle = false;
    tools = {
      cabal = "latest";
      ghcid = "latest";
      hlint = "latest";
      haskell-language-server = "latest";
    };
  };
  
in { inherit project shell; }
