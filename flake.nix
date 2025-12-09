{
  description = "Palimpsest License - Future-proof licensing for creative work in the age of AI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Haskell validation tools
        haskellPackages = pkgs.haskellPackages.override {
          overrides = hself: hsuper: {
            palimpsest-validator = hself.callCabal2nix "palimpsest-validator" ./TOOLS/validation/haskell { };
          };
        };

        # Node.js dependencies for documentation and tooling
        nodeDependencies = pkgs.mkYarnPackage {
          name = "palimpsest-node-deps";
          src = ./.;
          packageJSON = ./package.json;
          yarnLock = ./package-lock.json;
        };

      in
      {
        # Development shell with all tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core utilities
            just                 # Build automation
            git                  # Version control
            jq                   # JSON processing

            # Documentation tools
            nodejs               # For npm scripts, prettier, etc.
            nodePackages.prettier # Code formatting
            nodePackages.eslint  # JavaScript linting
            nodePackages.npm     # Package management
            python3              # For serving docs locally

            # OCaml tools (primary language)
            ocaml                # OCaml compiler
            dune_3               # OCaml build system
            opam                 # OCaml package manager
            ocamlPackages.utop   # OCaml REPL
            ocamlPackages.merlin # OCaml IDE support
            ocamlPackages.ocaml-lsp # OCaml LSP
            ocamlPackages.odoc   # OCaml documentation

            # Haskell tools (migrating away, but still needed)
            cabal-install        # Haskell build tool
            ghc                  # Glasgow Haskell Compiler
            haskellPackages.haskell-language-server # Haskell LSP

            # SCSS compilation
            sass                 # Dart Sass compiler

            # Image conversion (for assets)
            imagemagick          # SVG → PNG/JPG/TIFF
            librsvg              # SVG rendering

            # Container tools
            nerdctl              # Container runtime (if available)

            # Configuration tools
            nickel               # Configuration language

            # Optional: for Protocol Buffers
            protobuf             # protoc compiler

            # Optional: for advanced validation
            shellcheck           # Shell script linting
            vale                 # Prose linting
          ];

          shellHook = ''
            echo "🏛️  Palimpsest License Development Environment"
            echo ""
            echo "Available commands:"
            echo "  just --list      # Show all available tasks"
            echo "  just validate    # Run RSR compliance checks"
            echo "  just build       # Build all components"
            echo "  just test        # Run test suite"
            echo "  just watch       # Auto-rebuild on changes"
            echo ""
            echo "📚 Documentation: /GUIDES_v0.4/"
            echo "🔨 Tools: /TOOLS/validation/"
            echo "📦 Metadata: /METADATA_v0.4/"
            echo ""
            echo "RSR Framework: Bronze-tier compliant ✅"
            echo "TPCF Perimeter: Community Sandbox (P3) 🌐"
            echo ""

            # Set up environment variables
            export PALIMPSEST_VERSION="0.4.0"
            export PALIMPSEST_ENV="development"

            # Ensure npm dependencies are available
            export PATH="$PWD/node_modules/.bin:$PATH"

            # Haskell development
            export HIE_HOOGLE_DATABASE="$HOME/.hoogle"
          '';
        };

        # Minimal shell (no Haskell, faster to build)
        devShells.minimal = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            git
            jq
            nodejs
            nodePackages.prettier
            python3
            sass
          ];

          shellHook = ''
            echo "🏛️  Palimpsest License (Minimal Environment)"
            echo "For full environment with Haskell: nix develop"
          '';
        };

        # CI shell (non-interactive, for automation)
        devShells.ci = pkgs.mkShell {
          buildInputs = with pkgs; [
            just
            git
            jq
            nodejs
            nodePackages.prettier
            nodePackages.eslint
            sass
            imagemagick
            librsvg
          ];
        };

        # Packages
        packages = {
          # Haskell validator as a package
          palimpsest-validator = haskellPackages.palimpsest-validator;

          # Documentation bundle
          docs = pkgs.stdenv.mkDerivation {
            name = "palimpsest-docs";
            src = ./.;
            buildInputs = [ pkgs.nodejs pkgs.sass ];
            buildPhase = ''
              npm run scss:build
            '';
            installPhase = ''
              mkdir -p $out
              cp -r GUIDES_v0.4 $out/
              cp -r docs $out/
              cp -r LICENSES $out/
              cp -r styles/css $out/styles/
              cp README.md $out/
              cp CLAUDE.md $out/
            '';
          };

          # Full license bundle (for distribution)
          default = pkgs.stdenv.mkDerivation {
            name = "palimpsest-license-${self.rev or "dev"}";
            src = ./.;
            buildInputs = [ pkgs.nodejs pkgs.sass pkgs.jq ];

            buildPhase = ''
              # Build styles
              ${pkgs.sass}/bin/sass styles/scss/main.scss styles/css/main.css --style=compressed --no-source-map

              # Validate JSON metadata
              for json in $(find METADATA_v0.4 -name "*.json"); do
                ${pkgs.jq}/bin/jq . $json > /dev/null || exit 1
              done
            '';

            installPhase = ''
              mkdir -p $out

              # Core license files
              cp -r LICENSES $out/
              cp -r LICENSE_CORE $out/
              cp LICENSE.md $out/

              # Documentation
              cp -r GUIDES_v0.4 $out/
              cp -r docs $out/
              cp README.md $out/
              cp README.nl.md $out/
              cp CLAUDE.md $out/
              cp CHANGELOG.md $out/

              # Governance & community
              cp GOVERNANCE.md $out/
              cp CONTRIBUTING.md $out/
              cp CODE_OF_PRACTICE.md $out/
              cp SECURITY.md $out/
              cp MAINTAINERS.md $out/
              cp TPCF.md $out/

              # Metadata
              cp -r METADATA_v0.4 $out/
              cp -r metadata $out/

              # Standards & compliance
              mkdir -p $out/.well-known
              cp .well-known/* $out/.well-known/
              cp security.txt $out/
              cp vulnerability.txt $out/
              cp trust.txt $out/
              cp llms.txt $out/
              cp robots.txt $out/
              cp humans.txt $out/

              # Examples
              cp -r examples $out/

              # Assets & embeds
              cp -r assets $out/
              cp -r embed $out/

              # Built styles
              mkdir -p $out/styles/css
              cp styles/css/*.css $out/styles/css/

              # Tools (source only, not built binaries)
              cp -r TOOLS $out/
            '';

            meta = with pkgs.lib; {
              description = "Palimpsest License - Protecting creative work in the age of AI";
              homepage = "https://palimpsest-license.org";
              license = [
                licenses.mit          # For code
                licenses.cc-by-sa-40  # For documentation
              ];
              maintainers = [ "Palimpsest Stewardship Council" ];
              platforms = platforms.all;
            };
          };
        };

        # Checks (run with `nix flake check`)
        checks = {
          # Validate all JSON files
          json-validation = pkgs.runCommand "validate-json" {
            buildInputs = [ pkgs.jq ];
          } ''
            cd ${self}
            for json in $(find METADATA_v0.4 -name "*.json"); do
              ${pkgs.jq}/bin/jq . $json > /dev/null || exit 1
            done
            touch $out
          '';

          # Check markdown formatting
          markdown-format = pkgs.runCommand "check-markdown" {
            buildInputs = [ pkgs.nodejs pkgs.nodePackages.prettier ];
          } ''
            cd ${self}
            ${pkgs.nodePackages.prettier}/bin/prettier --check "**/*.md" || exit 1
            touch $out
          '';

          # RSR compliance check
          rsr-compliance = pkgs.runCommand "rsr-compliance" {
            buildInputs = [ pkgs.just pkgs.git ];
          } ''
            cd ${self}
            ${pkgs.just}/bin/just rsr-check || exit 1
            touch $out
          '';
        };

        # Apps (executable entry points)
        apps = {
          # Run validation
          validate = {
            type = "app";
            program = "${pkgs.writeShellScript "validate" ''
              cd ${self}
              ${pkgs.just}/bin/just validate
            ''}";
          };

          # Serve documentation
          serve-docs = {
            type = "app";
            program = "${pkgs.writeShellScript "serve-docs" ''
              cd ${self}
              ${pkgs.python3}/bin/python -m http.server 8000
            ''}";
          };

          # Build all
          build = {
            type = "app";
            program = "${pkgs.writeShellScript "build" ''
              cd ${self}
              ${pkgs.just}/bin/just build
            ''}";
          };
        };
      }
    );
}
