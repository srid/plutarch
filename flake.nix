{
  description = "plutarch";

  inputs.haskell-nix.url = "github:L-as/haskell.nix?ref=master";
  inputs.nixpkgs.follows = "haskell-nix/nixpkgs-unstable";
  inputs.flake-compat-ci.url = "github:hercules-ci/flake-compat-ci";
  inputs.hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };

  # https://github.com/input-output-hk/plutus/pull/4328
  inputs.plutus.url = "github:L-as/plutus?ref=master";
  # https://github.com/input-output-hk/cardano-prelude/pull/162
  inputs.cardano-prelude.url = "github:locallycompact/cardano-prelude?rev=93f95047bb36a055bdd56fb0cafd887c072cdce2";
  inputs.cardano-prelude.flake = false;
  inputs.cardano-base.url = "github:input-output-hk/cardano-base";
  inputs.cardano-base.flake = false;
  inputs.cardano-crypto.url = "github:input-output-hk/cardano-crypto?rev=07397f0e50da97eaa0575d93bee7ac4b2b2576ec";
  inputs.cardano-crypto.flake = false;
  # https://github.com/Quid2/flat/pull/27
  inputs.flat.url = "github:Quid2/flat?rev=41a040c413351e021982bb78bd00f750628f8060";
  inputs.flat.flake = false;
  # https://github.com/input-output-hk/Win32-network/pull/10
  inputs.Win32-network.url = "github:input-output-hk/Win32-network?rev=2d1a01c7cbb9f68a1aefe2934aad6c70644ebfea";
  inputs.Win32-network.flake = false;
  # https://github.com/haskell-foundation/foundation/pull/555
  inputs.foundation.url = "github:haskell-foundation/foundation?rev=0bb195e1fea06d144dafc5af9a0ff79af0a5f4a0";
  inputs.foundation.flake = false;
  # https://github.com/locallycompact/protolude
  inputs.protolude.url = "github:protolude/protolude?rev=d821ef0ac7552cfa2c3e7a7bdf29539f57e3fae6";
  inputs.protolude.flake = false;
  # https://github.com/vincenthz/hs-memory/pull/87
  inputs.hs-memory.url = "github:vincenthz/hs-memory?rev=3cf661a8a9a8ac028df77daa88e8d65c55a3347a";
  inputs.hs-memory.flake = false;
  # https://github.com/haskell-crypto/cryptonite/issues/357
  inputs.cryptonite.url = "github:haskell-crypto/cryptonite?rev=cec291d988f0f17828384f3358214ab9bf724a13";
  inputs.cryptonite.flake = false;
  # https://github.com/JonasDuregard/sized-functors/pull/10
  inputs.sized-functors.url = "github:JonasDuregard/sized-functors?rev=fe6bf78a1b97ff7429630d0e8974c9bc40945dcf";
  inputs.sized-functors.flake = false;
  # https://github.com/mokus0/th-extras/pull/17
  inputs.th-extras.url = "github:mokus0/th-extras?rev=787ed752c1e5d41b5903b74e171ed087de38bffa";
  inputs.th-extras.flake = false;
  inputs.Shrinker.url = "github:Plutonomicon/Shrinker";
  inputs.Shrinker.flake = false;
  inputs.haskell-language-server.url = "github:haskell/haskell-language-server";
  inputs.haskell-language-server.flake = false;

  outputs = inputs@{ self, nixpkgs, haskell-nix, plutus, flake-compat, flake-compat-ci, hercules-ci-effects, ... }:
    let
      extraSources = [
        {
          src = inputs.protolude;
          subdirs = [ "." ];
        }
        {
          src = inputs.foundation;
          subdirs = [
            "foundation"
            "basement"
          ];
        }
        {
          src = inputs.cardano-prelude;
          subdirs = [
            "cardano-prelude"
          ];
        }
        {
          src = inputs.hs-memory;
          subdirs = [ "." ];
        }
        {
          src = inputs.cardano-crypto;
          subdirs = [ "." ];
        }
        {
          src = inputs.cryptonite;
          subdirs = [ "." ];
        }
        {
          src = inputs.flat;
          subdirs = [ "." ];
        }
        {
          src = inputs.cardano-base;
          subdirs = [
            "binary"
            "cardano-crypto-class"
          ];
        }
        {
          src = inputs.sized-functors;
          subdirs = [ "." ];
        }
        {
          src = inputs.th-extras;
          subdirs = [ "." ];
        }
        {
          src = inputs.plutus;
          subdirs = [
            "plutus-core"
            "plutus-ledger-api"
            "plutus-tx"
            "prettyprinter-configurable"
            "word-array"
          ];
        }
      ];

      supportedSystems = with nixpkgs.lib.systems.supported; tier1 ++ tier2 ++ tier3;

      perSystem = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = system: import nixpkgs { inherit system; overlays = [ haskell-nix.overlay ]; inherit (haskell-nix) config; };
      nixpkgsFor' = system: import nixpkgs { inherit system; inherit (haskell-nix) config; };

      ghcVersion = "ghc921";

      tools.fourmolu = { };
      tools.haskell-language-server = {
        modules = [{
          # https://github.com/input-output-hk/haskell.nix/issues/1177
          nonReinstallablePkgs = [
            "rts"
            "ghc-heap"
            "ghc-prim"
            "integer-gmp"
            "integer-simple"
            "base"
            "deepseq"
            "array"
            "ghc-boot-th"
            "pretty"
            "template-haskell"
            # ghcjs custom packages
            "ghcjs-prim"
            "ghcjs-th"
            "ghc-bignum"
            "exceptions"
            "stm"
            "ghc-boot"
            "ghc"
            "Cabal"
            "Win32"
            "array"
            "binary"
            "bytestring"
            "containers"
            "directory"
            "filepath"
            "ghc-boot"
            "ghc-compact"
            "ghc-prim"
            # "ghci" "haskeline"
            "hpc"
            "mtl"
            "parsec"
            "process"
            "text"
            "time"
            "transformers"
            "unix"
            "xhtml"
            "terminfo"
          ];
        }];
        compiler-nix-name = ghcVersion;
        # For some reason it doesn't use the latest version automatically.
        index-state =
          let l = builtins.attrNames (import "${haskell-nix.inputs.hackage}/index-state-hashes.nix"); in
          builtins.elemAt l (builtins.length l - 1);
        name = "haskell-language-server";
        version = "latest";
        cabalProjectLocal = ''
          allow-newer: *:*

          constraints:
            primitive-unlifted < 1.0.0.0

          package haskell-language-server
            flags: +use-ghc-stub +pedantic +ignore-plugins-ghc-bounds -alternateNumberFormat -brittany -callhierarchy -class -eval -floskell -fourmolu -haddockComments -hlint -importLens -ormolu -refineImports -retrie -splice -stylishhaskell -tactic -importLens

        '';
        src = "${inputs.haskell-language-server}";
      };

      haskellModule = system: {
        packages = {
          basement.src = "${inputs.foundation}/basement";
          basement.components.library.postUnpack = "\n";
          cardano-binary.doHaddock = false;
          cardano-binary.ghcOptions = [ "-Wwarn" ];
          cardano-binary.src = "${inputs.cardano-base}/binary";
          cardano-binary.components.library.postUnpack = "\n";
          cardano-crypto-class.components.library.pkgconfig = nixpkgs.lib.mkForce [ [ (import plutus { inherit system; }).pkgs.libsodium-vrf ] ];
          cardano-crypto-class.doHaddock = false;
          cardano-crypto-class.ghcOptions = [ "-Wwarn" ];
          cardano-crypto-class.src = "${inputs.cardano-base}/cardano-crypto-class";
          cardano-crypto-class.components.library.postUnpack = "\n";
          cardano-crypto-praos.components.library.pkgconfig = nixpkgs.lib.mkForce [ [ (import plutus { inherit system; }).pkgs.libsodium-vrf ] ];
          cardano-crypto.src = "${inputs.cardano-crypto}";
          cardano-crypto.components.library.postUnpack = "\n";
          cardano-prelude.doHaddock = false; # somehow above options are not applied?
          cardano-prelude.ghcOptions = [ "-Wwarn" ];
          cardano-prelude.src = "${inputs.cardano-prelude}/cardano-prelude";
          cardano-prelude.components.library.postUnpack = "\n";
          cryptonite.src = "${inputs.cryptonite}";
          cryptonite.components.library.postUnpack = "\n";
          flat.src = "${inputs.flat}";
          flat.components.library.postUnpack = "\n";
          foundation.src = "${inputs.foundation}/foundation";
          foundation.components.library.postUnpack = "\n";
          memory.src = "${inputs.hs-memory}";
          memory.components.library.postUnpack = "\n";
          plutus-core.src = "${inputs.plutus}/plutus-core";
          plutus-core.components.library.postUnpack = "\n";
          plutus-tx.src = "${inputs.plutus}/plutus-tx";
          plutus-tx.components.library.postUnpack = "\n";
          plutus-ledger-api.src = "${inputs.plutus}/plutus-ledger-api";
          plutus-ledger-api.components.library.postUnpack = "\n";
          #prettyprinter-configurable.src = "${inputs.plutus}/prettyprinter-configurable";
          #prettyprinter-configurable.components.library.postUnpack = "\n";
          protolude.src = "${inputs.protolude}";
          protolude.components.library.postUnpack = "\n";
          word-array.src = "${inputs.plutus}/word-array";
          word-array.components.library.postUnpack = "\n";
        };
      };

      cabalProjectLocal = ''
        package plutus-tx-plugin
          flags: +use-ghc-stub

        allow-newer:
          cardano-binary:base
          , cardano-crypto-class:base
          , cardano-prelude:base
          , canonical-json:bytestring
          , plutus-core:ral
          , plutus-core:some
          , monoidal-containers:base
          , hedgehog:mmorph
          , text:deepseq
          , hedgehog:template-haskell
          , protolude:base
          , protolude:ghc-prim
          , protolude:transformers-compat
          , protolude:hashable
          , protolude:bytestring
          , size-based:template-haskell

        constraints:
          OneTuple ^>= 0.3.1
          , Only ^>= 0.1
          , QuickCheck ^>= 2.14.2
          , StateVar ^>= 1.2.2
          , Stream ^>= 0.4.7.2
          , adjunctions ^>= 4.4
          , aeson ^>= 2.0.3.0
          , algebraic-graphs ^>= 0.6
          , ansi-terminal ^>= 0.11.1
          , ansi-wl-pprint ^>= 0.6.9
          , assoc ^>= 1.0.2
          , async ^>= 2.2.4
          , attoparsec ^>= 0.14.4
          , barbies ^>= 2.0.3.1
          , base-compat ^>= 0.12.1
          , base-compat-batteries ^>= 0.12.1
          , base-orphans ^>= 0.8.6
          , base16-bytestring ^>= 1.0.2.0
          , basement ^>= 0.0.12
          , bifunctors ^>= 5.5.11
          , bimap ^>= 0.4.0
          , bin ^>= 0.1.2
          , boring ^>= 0.2
          , boxes ^>= 0.1.5
          , cabal-doctest ^>= 1.0.9
          , call-stack ^>= 0.4.0
          , canonical-json ^>= 0.6.0.0
          , cardano-binary ^>= 1.5.0
          , cardano-crypto ^>= 1.1.0
          , cardano-crypto-class ^>= 2.0.0
          , cardano-prelude ^>= 0.1.0.0
          , case-insensitive ^>= 1.2.1.0
          , cassava ^>= 0.5.2.0
          , cborg ^>= 0.2.6.0
          , clock ^>= 0.8.2
          , colour ^>= 2.3.6
          , comonad ^>= 5.0.8
          , composition-prelude ^>= 3.0.0.2
          , concurrent-output ^>= 1.10.14
          , constraints ^>= 0.13.2
          , constraints-extras ^>= 0.3.2.1
          , contravariant ^>= 1.5.5
          , cryptonite ^>= 0.29
          , data-default ^>= 0.7.1.1
          , data-default-class ^>= 0.1.2.0
          , data-default-instances-containers ^>= 0.0.1
          , data-default-instances-dlist ^>= 0.0.1
          , data-default-instances-old-locale ^>= 0.0.1
          , data-fix ^>= 0.3.2
          , dec ^>= 0.0.4
          , dependent-map ^>= 0.4.0.0
          , dependent-sum ^>= 0.7.1.0
          , dependent-sum-template ^>= 0.1.1.1
          , deriving-aeson ^>= 0.2.8
          , deriving-compat ^>= 0.6
          , dictionary-sharing ^>= 0.1.0.0
          , distributive ^>= 0.6.2.1
          , dlist ^>= 1.0
          , dom-lt ^>= 0.2.3
          , double-conversion ^>= 2.0.2.0
          , erf ^>= 2.0.0.0
          , exceptions ^>= 0.10.4
          , extra ^>= 1.7.10
          , fin ^>= 0.2.1
          , flat ^>= 0.4.5
          , foldl ^>= 1.4.12
          , formatting ^>= 7.1.3
          , foundation ^>= 0.0.26.1
          , free ^>= 5.1.7
          , half ^>= 0.3.1
          , hashable ^>= 1.4.0.2
          , haskell-lexer ^>= 1.1
          , hedgehog ^>= 1.0.5
          , indexed-traversable ^>= 0.1.2
          , indexed-traversable-instances ^>= 0.1.1
          , integer-logarithms ^>= 1.0.3.1
          , invariant ^>= 0.5.5
          , kan-extensions ^>= 5.2.3
          , lazy-search ^>= 0.1.2.1
          , lazysmallcheck ^>= 0.6
          , lens ^>= 5.1
          , lifted-async ^>= 0.10.2.2
          , lifted-base ^>= 0.2.3.12
          , list-t ^>= 1.0.5.1
          , logict ^>= 0.7.0.3
          , megaparsec ^>= 9.2.0
          , memory ^>= 0.16.0
          , microlens ^>= 0.4.12.0
          , mmorph ^>= 1.2.0
          , monad-control ^>= 1.0.3.1
          , mono-traversable ^>= 1.0.15.3
          , monoidal-containers ^>= 0.6.2.0
          , mtl-compat ^>= 0.2.2
          , newtype ^>= 0.2.2.0
          , newtype-generics ^>= 0.6.1
          , nothunks ^>= 0.1.3
          , old-locale ^>= 1.0.0.7
          , old-time ^>= 1.1.0.3
          , optparse-applicative ^>= 0.16.1.0
          , parallel ^>= 3.2.2.0
          , parser-combinators ^>= 1.3.0
          , plutus-core ^>= 0.1.0.0
          , plutus-ledger-api ^>= 0.1.0.0
          , plutus-tx ^>= 0.1.0.0
          , pretty-show ^>= 1.10
          , prettyprinter ^>= 1.7.1
          , prettyprinter-configurable ^>= 0.1.0.0
          , primitive ^>= 0.7.3.0
          , profunctors ^>= 5.6.2
          , protolude ^>= 0.3.0
          , quickcheck-instances ^>= 0.3.27
          , ral ^>= 0.2.1
          , random ^>= 1.2.1
          , rank2classes ^>= 1.4.4
          , recursion-schemes ^>= 5.2.2.2
          , reflection ^>= 2.1.6
          , resourcet ^>= 1.2.4.3
          , safe ^>= 0.3.19
          , safe-exceptions ^>= 0.1.7.2
          , scientific ^>= 0.3.7.0
          , semialign ^>= 1.2.0.1
          , semigroupoids ^>= 5.3.7
          , semigroups ^>= 0.20
          , serialise ^>= 0.2.4.0
          , size-based ^>= 0.1.2.0
          , some ^>= 1.0.3
          , split ^>= 0.2.3.4
          , splitmix ^>= 0.1.0.4
          , stm ^>= 2.5.0.0
          , strict ^>= 0.4.0.1
          , syb ^>= 0.7.2.1
          , tagged ^>= 0.8.6.1
          , tasty ^>= 1.4.2.1
          , tasty-golden ^>= 2.3.5
          , tasty-hedgehog ^>= 1.1.0.0
          , tasty-hunit ^>= 0.10.0.3
          , temporary ^>= 1.3
          , terminal-size ^>= 0.3.2.1
          , testing-type-modifiers ^>= 0.1.0.1
          , text-short ^>= 0.1.5
          , th-abstraction ^>= 0.4.3.0
          , th-compat ^>= 0.1.3
          , th-expand-syns ^>= 0.4.9.0
          , th-extras ^>= 0.0.0.6
          , th-lift ^>= 0.8.2
          , th-lift-instances ^>= 0.1.19
          , th-orphans ^>= 0.13.12
          , th-reify-many ^>= 0.1.10
          , th-utilities ^>= 0.2.4.3
          , these ^>= 1.1.1.1
          , time-compat ^>= 1.9.6.1
          , transformers-base ^>= 0.4.6
          , transformers-compat ^>= 0.7.1
          , type-equality ^>= 1
          , typed-process ^>= 0.2.8.0
          , unbounded-delays ^>= 0.1.1.1
          , universe-base ^>= 1.1.3
          , unliftio-core ^>= 0.2.0.1
          , unordered-containers ^>= 0.2.16.0
          , uuid-types ^>= 1.0.5
          , vector ^>= 0.12.3.1
          , vector-algorithms ^>= 0.8.0.4
          , void ^>= 0.7.3
          , wcwidth ^>= 0.0.2
          , witherable ^>= 0.4.2
          , wl-pprint-annotated ^>= 0.1.0.1
          , word-array ^>= 0.1.0.0
      '';

      projectForGhc = ghcName: system:
        let pkgs = nixpkgsFor system; in
        let pkgs' = nixpkgsFor' system; in
        (nixpkgsFor system).haskell-nix.cabalProject' ({
          # This is truly a horrible hack but is necessary. We can't disable tests otherwise in haskell.nix.
          src = if ghcName == ghcVersion then ./. else
          pkgs.runCommand "fake-src" { } ''
            cp -rT ${./.} $out
            chmod u+w $out $out/plutarch.cabal
            # Remove stanzas from .cabal that won't work in GHC 8.10
            sed -i '/-- Everything below this line is deleted for GHC 8.10/,$d' $out/plutarch.cabal
            # Remove packages that won't work in GHC 8.10 (yet)
            chmod -R u+w $out/plutarch-test
            rm -rf $out/plutarch-test
          '';
          compiler-nix-name = ghcName;
          inherit extraSources;
          modules = [ (haskellModule system) ];
          shell = {
            withHoogle = true;

            exactDeps = true;

            # We use the ones from Nixpkgs, since they are cached reliably.
            # Eventually we will probably want to build these with haskell.nix.
            nativeBuildInputs = [ pkgs'.cabal-install pkgs'.hlint pkgs'.haskellPackages.cabal-fmt pkgs'.nixpkgs-fmt ];

            inherit tools;

            additional = ps: [
              ps.plutus-ledger-api
              #ps.shrinker
              #ps.shrinker-testing
            ];
          };
        } // (if ghcName == ghcVersion then {
          inherit cabalProjectLocal;
        } else { }));

      projectFor = projectForGhc ghcVersion;
      projectFor810 = projectForGhc "ghc8107";

      formatCheckFor = system:
        let
          pkgs = nixpkgsFor system;
          pkgs' = nixpkgsFor' system;
          t = pkgs.haskell-nix.tools ghcVersion { inherit (tools) fourmolu haskell-language-server; };
        in
        pkgs.runCommand "format-check"
          {
            nativeBuildInputs = [ pkgs'.haskellPackages.cabal-fmt pkgs'.nixpkgs-fmt t.fourmolu ];
          } ''
          export LC_CTYPE=C.UTF-8
          export LC_ALL=C.UTF-8
          export LANG=C.UTF-8
          cd ${self}
          ./bin/format || (echo "    Please run ./bin/format" ; exit 1)
          mkdir $out
        ''
      ;
    in
    {
      inherit extraSources cabalProjectLocal haskellModule tools;

      project = perSystem projectFor;
      project810 = perSystem projectFor810;
      flake = perSystem (system: (projectFor system).flake { });
      flake810 = perSystem (system: (projectFor810 system).flake { });

      packages = perSystem (system: self.flake.${system}.packages);
      checks = perSystem (system:
        let ghc810 = ((projectFor810 system).flake { }).packages; # We don't run the tests, we just check that it builds.
        in
        self.flake.${system}.checks
        // {
          formatCheck = formatCheckFor system;
          benchmark = (nixpkgsFor system).runCommand "benchmark" { } "${self.apps.${system}.benchmark.program} | tee $out";
          test = (nixpkgsFor system).runCommand "test" { } "cd plutarch-test; ${self.apps.${system}.test.program} | tee $out";
        } // {
          "ghc810-plutarch:lib:plutarch" = ghc810."plutarch:lib:plutarch";
        }
      );
      check = perSystem (system:
        (nixpkgsFor system).runCommand "combined-test"
          {
            checksss = builtins.attrValues self.checks.${system};
          } ''
          echo $checksss

          touch $out
        ''
      );
      apps = perSystem (system:
        self.flake.${system}.apps
        // {
          test = {
            type = "app";
            program = "${self.flake.${system}.packages."plutarch-test:exe:plutarch-test"}/bin/plutarch-test";
          };
          benchmark = {
            type = "app";
            program = "${self.flake.${system}.packages."plutarch-benchmark:bench:benchmark"}/bin/benchmark";
          };
          benchmark-diff = {
            type = "app";
            program = "${self.flake.${system}.packages."plutarch-benchmark:exe:benchmark-diff"}/bin/benchmark-diff";
          };
        }
      );
      devShell = perSystem (system: self.flake.${system}.devShell);

      effects = { src }:
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          hci-effects = hercules-ci-effects.lib.withPkgs pkgs;
        in
        {
          # Hercules 0.9 will allow us to calculate the merge-base so we can test all PRs.
          # Right now we just hardcode this effect to test every commit against
          # origin/staging. We set != "refs/head/master" so that merges into master don't
          # cause a lot of unnecessary bogus benchmarks to appear in CI for the time
          # being.
          benchmark-diff = hci-effects.runIf (src.ref != "refs/heads/master") (
            hci-effects.mkEffect {
              src = self;
              buildInputs = with pkgs; [ git nixFlakes ];
              effectScript = ''
                git clone https://github.com/Plutonomicon/plutarch.git plutarch
                cd plutarch

                git checkout $(git merge-base origin/staging ${src.rev})
                nix --extra-experimental-features 'nix-command flakes' run .#benchmark -- --csv > before.csv

                git checkout ${src.rev}
                nix --extra-experimental-features 'nix-command flakes' run .#benchmark -- --csv > after.csv

                echo
                echo
                echo "Benchmark diff between $(git merge-base origin/staging ${src.rev}) and ${src.rev}:"
                echo
                echo

                nix --extra-experimental-features 'nix-command flakes' run .#benchmark-diff -- before.csv after.csv
              '';
            }
          );
        };

      ciNix = args@{ src }: flake-compat-ci.lib.recurseIntoFlakeWith {
        flake = self;
        systems = [ "x86_64-linux" ];
        effectsArgs = args;
      };
    };
}
