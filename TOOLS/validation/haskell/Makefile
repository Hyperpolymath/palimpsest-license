.PHONY: build clean install test run help

# Default target
all: build

# Build the project
build:
	@echo "Building Palimpsest Validator..."
	@cabal build

# Build with Stack (alternative)
build-stack:
	@echo "Building with Stack..."
	@stack build

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	@cabal clean
	@rm -rf dist-newstyle .stack-work

# Install the executable
install:
	@echo "Installing palimpsest-validate..."
	@cabal install --overwrite-policy=always

# Install with Stack
install-stack:
	@echo "Installing with Stack..."
	@stack install

# Run tests
test:
	@echo "Running tests..."
	@cabal test

# Run the validator on the project
run:
	@echo "Running validator on project..."
	@cabal run palimpsest-validate -- --root ../../.. project --verbose

# Run specific validation commands
run-license:
	@cabal run palimpsest-validate -- --root ../../.. license ../../../LICENSES/v0.3/palimpsest-license-v0.3.en.md

run-metadata:
	@cabal run palimpsest-validate -- --root ../../.. metadata ../../../METADATA_v0.4/spdx_example.jsonld

run-bilingual:
	@cabal run palimpsest-validate -- --root ../../.. bilingual \
		../../../LICENSES/v0.3/palimpsest-license-v0.3.en.md \
		../../../LICENSES/v0.3/palimpsest-license-v0.3.nl.md \
		../../../docs/bilingual-map.md

# Development mode - quick compile
dev:
	@cabal build --ghc-options="-O0"

# Format code (requires stylish-haskell)
format:
	@find src app test -name "*.hs" -exec stylish-haskell -i {} \;

# Generate documentation
docs:
	@cabal haddock

# Help
help:
	@echo "Palimpsest Validator - Makefile targets:"
	@echo ""
	@echo "  make build          - Build the project with cabal"
	@echo "  make build-stack    - Build with Stack"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make install        - Install the executable (cabal)"
	@echo "  make install-stack  - Install with Stack"
	@echo "  make test           - Run tests"
	@echo "  make run            - Run full project validation"
	@echo "  make run-license    - Run license validation"
	@echo "  make run-metadata   - Run metadata validation"
	@echo "  make run-bilingual  - Run bilingual validation"
	@echo "  make dev            - Quick development build"
	@echo "  make format         - Format Haskell code"
	@echo "  make docs           - Generate documentation"
	@echo "  make help           - Show this help"
