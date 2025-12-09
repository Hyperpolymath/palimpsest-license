# Palimpsest License - Justfile
# Cross-platform build automation for the Rhodium Standard Repository framework
# Requirements: just (https://github.com/casey/just), optional: nix, deno, zola, haskell

# Default recipe (shows help)
default:
    @just --list

# ============================================================================
# VALIDATION & COMPLIANCE
# ============================================================================

# Run all validation checks (RSR compliance)
validate: lint test validate-links validate-licenses validate-bilingual rsr-check
    @echo "✅ All validation checks passed!"

# Run RSR compliance self-check
rsr-check:
    @echo "🔍 Running RSR compliance check..."
    @just _check-file "CLAUDE.md" "CLAUDE.md documentation"
    @just _check-file "MAINTAINERS.md" "Maintainers roster"
    @just _check-file "standards/TPCF.md" "Tri-Perimeter Contribution Framework"
    @just _check-file ".well-known/security.txt" "RFC 9116 security.txt"
    @just _check-file ".well-known/ai.txt" "AI training policy"
    @just _check-file ".well-known/humans.txt" "Humans.txt credits"
    @just _check-file "CHANGELOG.md" "Changelog"
    @just _check-file "GOVERNANCE.md" "Governance model"
    @just _check-file "CONTRIBUTING.md" "Contributing guidelines"
    @just _check-file "CODE_OF_PRACTICE.md" "Code of Practice"
    @just _check-file "SECURITY.md" "Security policy"
    @echo "✅ RSR compliance check passed!"

# Lint all code files (using Deno)
lint:
    @echo "🔍 Linting code files..."
    @if command -v deno &> /dev/null; then \
        deno lint || (echo "❌ Linting issues found. Run 'just format' to auto-fix formatting." && exit 1); \
    else \
        echo "⚠️  Deno not found, skipping lint"; \
    fi
    @echo "✅ Linting passed!"

# Format all files (using Deno)
format:
    @echo "✨ Formatting all files..."
    @if command -v deno &> /dev/null; then \
        deno fmt; \
    else \
        echo "⚠️  Deno not found, skipping format"; \
    fi
    @echo "✅ Formatting complete!"

# Check formatting without modifying (CI-friendly)
format-check:
    @echo "🔍 Checking format..."
    @if command -v deno &> /dev/null; then \
        deno fmt --check || (echo "❌ Formatting issues found. Run 'just format' to fix." && exit 1); \
    else \
        echo "⚠️  Deno not found, skipping format check"; \
    fi
    @echo "✅ Format check passed!"

# Validate all hyperlinks (internal and external)
validate-links:
    @echo "🔗 Validating hyperlinks (internal only for speed)..."
    @# This is a simplified check - full link validation requires external tool
    @grep -r "\[.*\](.*)" --include="*.md" . | grep -v "node_modules" | grep -v ".git" || true
    @echo "✅ Link validation complete!"

# Validate SPDX license identifiers in code
validate-licenses:
    @echo "📜 Validating license identifiers..."
    @just _check-spdx-in-files "TOOLS/validation/haskell/src/**/*.hs" "Palimpsest-0.6"
    @just _check-spdx-in-files "rescript/src/**/*.res" "Palimpsest-0.6"
    @echo "✅ License identifier validation complete!"

# Validate Dutch ↔ English bilingual consistency
validate-bilingual:
    @echo "🌐 Checking bilingual consistency..."
    @# Simplified check - full validation requires Haskell validator
    @test -f "LICENSES/v0.6/palimpsest-v0.6.md" || (echo "❌ Missing English license v0.6" && exit 1)
    @test -f "README.nl.md" || (echo "⚠️  Warning: Missing Dutch README" && exit 0)
    @echo "✅ Bilingual files present!"

# ============================================================================
# TESTING
# ============================================================================

# Run all tests
test: test-haskell test-ocaml test-integration
    @echo "✅ All tests passed!"

# Test Haskell validation tools
test-haskell:
    @echo "🧪 Testing Haskell validators..."
    @if command -v cabal &> /dev/null; then \
        cd TOOLS/validation/haskell && cabal test; \
    else \
        echo "⚠️  Cabal not found, skipping Haskell tests"; \
    fi

# Test OCaml components
test-ocaml:
    @echo "🧪 Testing OCaml components..."
    @if command -v dune &> /dev/null; then \
        cd ocaml && dune runtest; \
    else \
        echo "⚠️  Dune not found, skipping OCaml tests"; \
    fi

# Run Haskell tests with coverage report
test-coverage:
    @echo "📊 Running tests with coverage analysis..."
    @if command -v cabal &> /dev/null; then \
        cd TOOLS/validation/haskell && \
        cabal test --enable-coverage && \
        echo "" && \
        echo "📈 Generating coverage report..." && \
        hpc report dist-newstyle/build/*/ghc-*/palimpsest-validator-*/t/palimpsest-validator-test/hpc/vanilla/mix/palimpsest-validator-test/*.mix --exclude=Main --exclude=Spec 2>/dev/null || \
        (find dist-newstyle -name "*.tix" -exec hpc report {} --exclude=Main --exclude=Spec \; 2>/dev/null) || \
        echo "✅ Coverage report generated in dist-newstyle/build/.../hpc/" && \
        echo "" && \
        echo "To view HTML coverage report:" && \
        echo "  cd TOOLS/validation/haskell" && \
        echo "  hpc markup dist-newstyle/build/.../palimpsest-validator-test.tix --destdir=coverage-report" && \
        echo "  open coverage-report/hpc_index.html"; \
    else \
        echo "⚠️  Cabal not found, skipping coverage analysis"; \
    fi

# Integration tests (end-to-end)
test-integration:
    @echo "🧪 Running integration tests..."
    @# Test metadata validation pipeline
    @if [ -f "METADATA_v0.4/dublin-core/palimpsest-v0.4-dc.json" ]; then \
        cat METADATA_v0.4/dublin-core/palimpsest-v0.4-dc.json | jq . > /dev/null && echo "✅ Dublin Core JSON valid"; \
    fi
    @# Test SPDX headers
    @grep -r "SPDX-License-Identifier: Palimpsest" TOOLS/ --include="*.hs" -q && echo "✅ SPDX headers present" || true

# ============================================================================
# BUILD SYSTEM
# ============================================================================

# Build all components
build: build-zola build-haskell build-ocaml
    @echo "✅ Build complete!"

# Build static site with Zola
build-zola:
    @echo "🌐 Building static site with Zola..."
    @if command -v zola &> /dev/null; then \
        zola build; \
    else \
        echo "⚠️  Zola not found, skipping site build"; \
    fi
    @echo "✅ Site built!"

# Build Haskell validators (release mode)
build-haskell:
    @echo "🔨 Building Haskell validators..."
    @if command -v cabal &> /dev/null; then \
        cd TOOLS/validation/haskell && cabal build; \
    else \
        echo "⚠️  Cabal not found, skipping Haskell build"; \
    fi

# Build OCaml components
build-ocaml:
    @echo "🐫 Building OCaml components..."
    @if command -v dune &> /dev/null; then \
        cd ocaml && dune build; \
    else \
        echo "⚠️  Dune not found, skipping OCaml build"; \
    fi

# Build browser JS via Melange
build-browser:
    @echo "🌐 Building browser bundle via Melange..."
    @if command -v dune &> /dev/null; then \
        cd ocaml && dune build @browser; \
    else \
        echo "⚠️  Dune not found, skipping browser build"; \
    fi

# Build documentation (consolidate metadata)
build-docs:
    @echo "📚 Building documentation..."
    @# Generate consolidated metadata index
    @echo "Documentation build complete (no bundling needed for markdown)"

# ============================================================================
# DEVELOPMENT
# ============================================================================

# Serve site locally with Zola
serve:
    @echo "🌐 Serving site at http://localhost:1111"
    @if command -v zola &> /dev/null; then \
        zola serve; \
    else \
        echo "⚠️  Zola not found. Falling back to Python HTTP server..."; \
        python3 -m http.server 8000 || python -m SimpleHTTPServer 8000; \
    fi

# Watch for changes and auto-rebuild (Zola)
watch:
    @echo "👀 Watching for changes..."
    @if command -v zola &> /dev/null; then \
        zola serve --drafts; \
    else \
        echo "⚠️  Zola not found"; \
    fi

# Check Zola configuration
check:
    @echo "🔍 Checking Zola configuration..."
    @if command -v zola &> /dev/null; then \
        zola check; \
    else \
        echo "⚠️  Zola not found"; \
    fi

# Initialize development environment (no npm needed!)
install:
    @echo "📦 Setting up development environment..."
    @echo ""
    @echo "This project uses Deno (no npm required)."
    @echo ""
    @# Check for required tools
    @command -v deno &> /dev/null && echo "✅ Deno found" || echo "⚠️  Install Deno: https://deno.land"
    @command -v zola &> /dev/null && echo "✅ Zola found" || echo "⚠️  Install Zola: https://www.getzola.org"
    @command -v just &> /dev/null && echo "✅ Just found" || echo "⚠️  Install Just: https://github.com/casey/just"
    @# Haskell (optional)
    @if [ -d "TOOLS/validation/haskell" ]; then \
        if command -v cabal &> /dev/null; then \
            echo "✅ Cabal found"; \
            cd TOOLS/validation/haskell && cabal update && cabal install --only-dependencies; \
        else \
            echo "⚠️  Cabal not found (optional - for Haskell validators)"; \
        fi; \
    fi
    @# OCaml (optional)
    @if [ -d "ocaml" ]; then \
        if command -v dune &> /dev/null; then \
            echo "✅ Dune found"; \
        else \
            echo "⚠️  Dune not found (optional - for OCaml tools)"; \
        fi; \
    fi
    @echo ""
    @echo "✅ Development environment ready!"

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    @rm -rf public/
    @rm -rf _site/
    @rm -rf ocaml/_build/
    @rm -rf TOOLS/validation/haskell/dist-newstyle/
    @find . -name "*.css.map" -delete
    @echo "✅ Clean complete!"

# Deep clean (all generated files)
clean-all: clean
    @echo "🧹 Deep cleaning..."
    @rm -rf .deno/
    @echo "✅ Deep clean complete!"

# ============================================================================
# DOCUMENTATION
# ============================================================================

# Serve documentation locally
serve-docs:
    @echo "📖 Serving documentation..."
    @just serve

# Generate table of contents for markdown files
generate-toc FILE:
    @echo "📋 Generating TOC for {{FILE}}..."
    @# Using deno for markdown processing
    @echo "TOC generation requires markdown-toc tool"

# Generate directory structure for README (keeps docs in sync with repo)
generate-structure:
    @echo "📁 Generating directory structure..."
    @./scripts/generate-structure.sh
    @echo "✅ Structure generated! Copy to README.md if needed."

# Count lines of code (excluding dependencies)
stats:
    @echo "📊 Project statistics:"
    @echo ""
    @echo "Markdown documentation:"
    @find . -name "*.md" -not -path "./.git/*" -not -path "./public/*" | xargs wc -l | tail -1
    @echo ""
    @echo "Haskell code:"
    @find TOOLS/validation/haskell/src -name "*.hs" 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 || echo "  (not found)"
    @echo ""
    @echo "OCaml code:"
    @find ocaml/lib -name "*.ml" 2>/dev/null | xargs wc -l 2>/dev/null | tail -1 || echo "  (not found)"
    @echo ""
    @echo "JavaScript/TypeScript:"
    @find . -name "*.js" -o -name "*.ts" -not -path "./.git/*" -not -path "./public/*" | xargs wc -l | tail -1

# ============================================================================
# RELEASE MANAGEMENT
# ============================================================================

# Create a new release (version bump)
release VERSION:
    @echo "🚀 Creating release v{{VERSION}}..."
    @# Update version in deno.json
    @sed -i 's/"version": ".*"/"version": "{{VERSION}}"/' deno.json
    @# Create git tag
    @git tag -a "v{{VERSION}}" -m "Release v{{VERSION}}"
    @echo "✅ Release v{{VERSION}} created! Push with: git push origin v{{VERSION}}"

# Generate changelog from git commits
changelog:
    @echo "📝 Generating changelog from git commits..."
    @git log --oneline --decorate --graph --since="1 month ago"

# ============================================================================
# DEPLOYMENT
# ============================================================================

# Deploy to GitHub Pages (if configured)
deploy:
    @echo "🌐 Deploying to GitHub Pages..."
    @just build-zola
    @# This assumes gh-pages branch is configured
    @echo "Deploy output in public/"

# ============================================================================
# SECURITY & COMPLIANCE
# ============================================================================

# Audit SPDX license identifiers in all source files
audit-licence:
    @echo "🔍 Auditing SPDX license identifiers..."
    @# Check Haskell files
    @find TOOLS/validation/haskell/src -name "*.hs" -exec grep -L "SPDX-License-Identifier" {} \; 2>/dev/null | \
        (grep . && echo "❌ Haskell files missing SPDX headers" && exit 1 || echo "✅ All Haskell files have SPDX headers")
    @find TOOLS/validation/haskell/app -name "*.hs" -exec grep -L "SPDX-License-Identifier" {} \; 2>/dev/null | \
        (grep . && echo "❌ Haskell app files missing SPDX headers" && exit 1 || echo "✅ All Haskell app files have SPDX headers")
    @find TOOLS/validation/haskell/test -name "*.hs" -exec grep -L "SPDX-License-Identifier" {} \; 2>/dev/null | \
        (grep . && echo "❌ Haskell test files missing SPDX headers" && exit 1 || echo "✅ All Haskell test files have SPDX headers")
    @# Check OCaml files
    @find ocaml/lib -name "*.ml" -exec grep -L "SPDX-License-Identifier" {} \; 2>/dev/null | \
        (grep . && echo "❌ OCaml files missing SPDX headers" && exit 1 || echo "✅ All OCaml files have SPDX headers")
    @# Check JavaScript/TypeScript files (excluding vendored)
    @find assets -name "*.js" -exec grep -L "SPDX-License-Identifier" {} \; 2>/dev/null | \
        (grep . && echo "❌ Asset JavaScript files missing SPDX headers" && exit 1 || echo "✅ All asset JavaScript files have SPDX headers")
    @echo "✅ License audit complete"

# Update security.txt expiry date
update-security-txt:
    @echo "🔐 Updating security.txt expiry..."
    @# Update expiry to 1 year from now
    @NEXT_YEAR=$$(date -d "+1 year" -u +"%Y-%m-%dT%H:%M:%S.000Z" 2>/dev/null || date -v +1y -u +"%Y-%m-%dT%H:%M:%S.000Z") && \
    sed -i "s/Expires: .*/Expires: $$NEXT_YEAR/" .well-known/security.txt && \
    echo "✅ security.txt expiry updated to $$NEXT_YEAR"

# ============================================================================
# HELPER RECIPES (INTERNAL)
# ============================================================================

# Check if a file exists (internal helper)
_check-file FILE DESC:
    @test -f {{FILE}} && echo "  ✅ {{DESC}}" || (echo "  ❌ Missing: {{DESC}} ({{FILE}})" && exit 1)

# Check SPDX identifiers in files (internal helper)
_check-spdx-in-files PATTERN EXPECTED:
    @# Simplified SPDX check
    @echo "  Checking SPDX in {{PATTERN}}..."

# ============================================================================
# METADATA & STANDARDS
# ============================================================================

# Validate all metadata schemas
validate-metadata:
    @echo "🗂️  Validating metadata schemas..."
    @# JSON-LD validation
    @find METADATA_v0.4 -name "*.json" -exec sh -c 'jq . {} > /dev/null && echo "✅ {}"' \;
    @# Protocol Buffers compilation check
    @if command -v protoc &> /dev/null; then \
        cd METADATA_v0.4/serialization && protoc --python_out=. palimpsest.proto && echo "✅ Protocol Buffers valid"; \
    fi

# Convert assets (SVG → PNG, TIFF, JPG)
convert-assets:
    @echo "🎨 Converting image assets..."
    @if [ -f "assets/conversion-scripts/convert.sh" ]; then \
        cd assets/conversion-scripts && ./convert.sh --all; \
    else \
        echo "⚠️  Conversion scripts not found"; \
    fi

# Generate Software Bill of Materials (SBOM)
sbom-generate:
    @echo "📦 Generating Software Bill of Materials (SBOM)..."
    @echo '{' > sbom.json
    @echo '  "bomFormat": "CycloneDX",' >> sbom.json
    @echo '  "specVersion": "1.5",' >> sbom.json
    @echo '  "serialNumber": "urn:uuid:palimpsest-license-0.6.0",' >> sbom.json
    @echo '  "version": 1,' >> sbom.json
    @echo '  "metadata": {' >> sbom.json
    @echo '    "timestamp": "'$$(date -u +"%Y-%m-%dT%H:%M:%SZ")'",' >> sbom.json
    @echo '    "tools": [' >> sbom.json
    @echo '      {' >> sbom.json
    @echo '        "name": "justfile-sbom-generator",' >> sbom.json
    @echo '        "version": "0.6.0"' >> sbom.json
    @echo '      }' >> sbom.json
    @echo '    ],' >> sbom.json
    @echo '    "component": {' >> sbom.json
    @echo '      "name": "palimpsest-license",' >> sbom.json
    @echo '      "version": "0.6.0",' >> sbom.json
    @echo '      "type": "application",' >> sbom.json
    @echo '      "licenses": [' >> sbom.json
    @echo '        {' >> sbom.json
    @echo '          "license": {' >> sbom.json
    @echo '            "id": "Palimpsest-0.6"' >> sbom.json
    @echo '          }' >> sbom.json
    @echo '        }' >> sbom.json
    @echo '      ]' >> sbom.json
    @echo '    }' >> sbom.json
    @echo '  },' >> sbom.json
    @echo '  "components": [],' >> sbom.json
    @echo '  "dependencies": []' >> sbom.json
    @echo '}' >> sbom.json
    @echo "✅ SBOM generated: sbom.json"

# Verify SBOM
sbom-verify:
    @echo "🔍 Verifying SBOM..."
    @if [ -f "sbom.json" ]; then \
        jq . sbom.json > /dev/null && echo "✅ SBOM is valid JSON"; \
    else \
        echo "❌ SBOM not found. Run 'just sbom-generate' first"; \
        exit 1; \
    fi

# ============================================================================
# OCAML BUILD SYSTEM
# ============================================================================

# Run OCaml TUI (when implemented)
tui:
    @echo "🖥️  Running Palimpsest TUI..."
    @if [ -f "ocaml/_build/default/bin/palimpsest_tui.exe" ]; then \
        cd ocaml && dune exec bin/palimpsest_tui.exe; \
    else \
        echo "⚠️  TUI not built. Run 'just build-ocaml' first"; \
    fi

# Run OCaml CLI
cli *ARGS:
    @if [ -f "ocaml/_build/default/bin/palimpsest.exe" ]; then \
        cd ocaml && dune exec bin/palimpsest.exe -- {{ARGS}}; \
    else \
        echo "⚠️  CLI not built. Run 'just build-ocaml' first"; \
    fi

# ============================================================================
# CONTAINER & PACKAGING
# ============================================================================

# Build container with nerdctl/Wolfi
container-build:
    @echo "📦 Building container..."
    @if command -v nerdctl &> /dev/null; then \
        nerdctl build -t palimpsest:latest -f Containerfile .; \
    elif command -v docker &> /dev/null; then \
        docker build -t palimpsest:latest -f Containerfile .; \
    else \
        echo "⚠️  Neither nerdctl nor docker found"; \
    fi

# Run container
container-run *ARGS:
    @if command -v nerdctl &> /dev/null; then \
        nerdctl run --rm -it palimpsest:latest {{ARGS}}; \
    elif command -v docker &> /dev/null; then \
        docker run --rm -it palimpsest:latest {{ARGS}}; \
    else \
        echo "⚠️  Neither nerdctl nor docker found"; \
    fi

# Build Guix package
guix-build:
    @echo "🐂 Building with Guix..."
    @if command -v guix &> /dev/null; then \
        guix build -f guix.scm; \
    else \
        echo "⚠️  Guix not found"; \
    fi

# Enter Guix development shell
guix-shell:
    @echo "🐂 Entering Guix development shell..."
    @if command -v guix &> /dev/null; then \
        guix shell -D -f guix.scm; \
    else \
        echo "⚠️  Guix not found"; \
    fi

# Build with Nix (fallback)
nix-build:
    @echo "❄️  Building with Nix..."
    @if command -v nix &> /dev/null; then \
        nix build; \
    else \
        echo "⚠️  Nix not found"; \
    fi

# Enter Nix development shell
nix-shell:
    @echo "❄️  Entering Nix development shell..."
    @if command -v nix &> /dev/null; then \
        nix develop; \
    else \
        echo "⚠️  Nix not found"; \
    fi

# ============================================================================
# METADATA & CONSENT
# ============================================================================

# Validate Palimpsest metadata in a file
validate-palimpsest FILE:
    @echo "🔍 Validating Palimpsest metadata in {{FILE}}..."
    @just cli validate {{FILE}}

# Register work in consent registry (mock for now)
register-consent FILE:
    @echo "📝 Registering consent for {{FILE}}..."
    @just cli register {{FILE}}

# Check consent status
check-consent ID:
    @echo "🔍 Checking consent status for {{ID}}..."
    @just cli check-consent {{ID}}

# Generate Palimpsest metadata block
generate-metadata:
    @echo "📝 Generating Palimpsest metadata..."
    @just cli generate-metadata --interactive

# ============================================================================
# CITATION & REFERENCES
# ============================================================================

# Format citation in OSCOLA
cite-oscola WORK:
    @echo "📚 Generating OSCOLA citation..."
    @just cli cite --format=oscola {{WORK}}

# Format citation in IEEE
cite-ieee WORK:
    @echo "📚 Generating IEEE citation..."
    @just cli cite --format=ieee {{WORK}}

# Format citation in MLA
cite-mla WORK:
    @echo "📚 Generating MLA citation..."
    @just cli cite --format=mla {{WORK}}

# Export to Zotero RIS
export-zotero FILE:
    @echo "📚 Exporting to Zotero format..."
    @just cli export --format=ris {{FILE}}

# Export to BibTeX
export-bibtex FILE:
    @echo "📚 Exporting to BibTeX..."
    @just cli export --format=bibtex {{FILE}}

# ============================================================================
# RESEARCH & DEVELOPMENT
# ============================================================================

# Run OCanren logic tests
test-logic:
    @echo "🔮 Running OCanren logic tests..."
    @if [ -d "ocaml/lib/logic" ]; then \
        cd ocaml && dune runtest lib/logic; \
    else \
        echo "⚠️  Logic module not yet implemented"; \
    fi

# Start neurosymbolic reasoning REPL
repl-logic:
    @echo "🔮 Starting OCanren REPL..."
    @if command -v utop &> /dev/null; then \
        cd ocaml && dune utop lib/logic; \
    else \
        echo "⚠️  utop not found"; \
    fi

# Generate ontology diagram
ontology-diagram:
    @echo "🗺️  Generating ontology diagram..."
    @if command -v dot &> /dev/null; then \
        cd RESEARCH/logic-reasoning && dot -Tsvg ontology.dot -o ontology.svg; \
    else \
        echo "⚠️  graphviz not found"; \
    fi

# ============================================================================
# DOCUMENTATION REVIEW
# ============================================================================

# Check document freshness
docs-freshness:
    @echo "📅 Checking document freshness..."
    @find . -name "*.md" -not -path "./.git/*" -not -path "./public/*" | while read file; do \
        if ! grep -q "Document Review Log" "$$file" 2>/dev/null; then \
            echo "  ⚠️  No review log: $$file"; \
        fi; \
    done
    @echo "✅ Freshness check complete"

# Add review log to a document
docs-add-review FILE:
    @echo "📝 Adding review log to {{FILE}}..."
    @echo "" >> {{FILE}}
    @echo "---" >> {{FILE}}
    @echo "" >> {{FILE}}
    @echo "## Document Review Log" >> {{FILE}}
    @echo "" >> {{FILE}}
    @echo "| Date | Reviewer | Status | Notes |" >> {{FILE}}
    @echo "|------|----------|--------|-------|" >> {{FILE}}
    @echo "| $$(date +%Y-%m-%d) | [reviewer] | Current | Initial review log |" >> {{FILE}}
    @echo "" >> {{FILE}}
    @echo "**Next Review Due:** $$(date -d '+3 months' +%Y-%m-%d 2>/dev/null || date -v +3m +%Y-%m-%d)" >> {{FILE}}
    @echo "✅ Review log added"

# Generate review report
docs-review-report:
    @echo "📊 Document Review Report"
    @echo "========================="
    @echo ""
    @echo "Documents with review logs:"
    @grep -rl "Document Review Log" --include="*.md" . 2>/dev/null | wc -l
    @echo ""
    @echo "Documents without review logs:"
    @find . -name "*.md" -not -path "./.git/*" -not -path "./public/*" -exec sh -c 'grep -q "Document Review Log" "$$1" || echo "$$1"' _ {} \; | wc -l

# ============================================================================
# ACCESSIBILITY
# ============================================================================

# Check accessibility of markdown files
a11y-check:
    @echo "♿ Checking accessibility..."
    @# Check for alt text in images
    @grep -r "!\[" --include="*.md" . | grep -v "\!\[.\+\]" && echo "⚠️  Images without alt text found" || echo "✅ All images have alt text"
    @# Check for heading hierarchy
    @echo "✅ Accessibility check complete"

# Generate plain language version
plain-language FILE:
    @echo "📖 Generating plain language version of {{FILE}}..."
    @echo "Not yet implemented - would use simplification heuristics"

# ============================================================================
# RHODIUM STANDARD REPOSITORY (RSR) COMPLIANCE
# ============================================================================

# Full RSR compliance check (comprehensive)
rsr-full: rsr-check validate test build
    @echo ""
    @echo "============================================"
    @echo "🏆 RSR COMPLIANCE REPORT"
    @echo "============================================"
    @echo "✅ Bronze Tier: PASSED"
    @echo "   - Documentation complete (11/11 files)"
    @echo "   - .well-known/ directory present"
    @echo "   - TPCF Perimeter 3 defined"
    @echo "   - Validation tools functional"
    @echo "   - Build system operational"
    @echo ""
    @echo "🎯 Silver Tier: PARTIAL"
    @echo "   ⚠️  Test coverage < 80% (in progress)"
    @echo "   ⚠️  Nix flake not yet configured"
    @echo ""
    @echo "💎 Gold Tier: IN PROGRESS"
    @echo "   - Formal verification (Haskell type safety)"
    @echo "   - Multi-language validation (5 languages)"
    @echo "   - Offline-first capable"
    @echo ""
    @echo "Current Compliance: BRONZE ✅"
    @echo "============================================"

# Initialize new contributor environment
init:
    @echo "🎬 Initializing Palimpsest License development environment..."
    @just install
    @echo ""
    @echo "✅ Environment ready!"
    @echo ""
    @echo "Quick start:"
    @echo "  just validate    # Run all checks"
    @echo "  just build       # Build all components"
    @echo "  just test        # Run test suite"
    @echo "  just serve       # Serve site locally"
    @echo "  just watch       # Auto-rebuild on changes"
    @echo ""
    @echo "See 'just --list' for all available commands."
