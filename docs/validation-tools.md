# Validation Tools Documentation

## Overview

The Palimpsest License validation suite is a comprehensive, functional programming-based toolkit for validating legal documents, metadata schemas, bilingual consistency, and cross-references. The validator is implemented in **Haskell**, chosen for its strong type safety, reliability, and suitability for precise legal document validation.

**Location:** `/TOOLS/validation/haskell/`

## Why Haskell?

After careful consideration of several functional programming languages (Haskell, OCaml, Julia), **Haskell** was selected for the following reasons:

### Strengths for Legal Document Validation

1. **Type Safety and Legal Precision**
   - Haskell's strong static type system prevents validation logic errors
   - The compiler catches mistakes before they can affect validation results
   - Pure functions ensure predictable, reproducible validation behaviour
   - No hidden side effects that could compromise validation integrity

2. **Pattern Matching for Structured Documents**
   - Natural fit for validating clause structures and legal document hierarchies
   - Algebraic data types model legal concepts precisely
   - Exhaustive pattern matching ensures all cases are handled

3. **Excellent Parsing Ecosystem**
   - **Megaparsec**: Powerful parser combinators for Markdown and custom formats
   - **Aeson**: Industrial-strength JSON and JSON-LD parsing
   - **xml-conduit**: Robust XML parsing and validation
   - **regex-tdfa**: POSIX-compliant regular expressions

4. **Composability and Modularity**
   - Validators can be easily combined and reused
   - Monad transformers allow complex validation logic
   - Reader monad for configuration, Writer monad for warnings, Either monad for errors

5. **Reliability and Maintainability**
   - Pure functional code is easier to test and reason about
   - Strong typing documents expected behaviour
   - Haskell code tends to be more maintainable over time
   - Large, mature ecosystem with stable libraries

### Alternatives Considered

- **OCaml**: Excellent type system, but smaller ecosystem for document parsing
- **Julia**: Strong for scientific computing, but less mature for text processing
- **F#**: Good .NET integration, but less portable across platforms

## Architecture

### Validator Monad Stack

The validation system uses a custom monad stack for clean error handling and configuration:

```haskell
type ValidatorM = ReaderT ValidationConfig
                  (WriterT [ValidationWarning]
                  (ExceptT ValidationError IO))
```

This provides:
- **ReaderT**: Access to validation configuration
- **WriterT**: Accumulation of non-fatal warnings
- **ExceptT**: Short-circuit error handling for critical issues
- **IO**: File system access and output

### Core Modules

1. **Palimpsest.Validator.Types**
   - Core types: `ValidationResult`, `ValidationError`, `ValidationWarning`
   - Severity levels: `Critical`, `Error`, `Warning`, `Info`
   - Configuration and monad definitions

2. **Palimpsest.Validator.License**
   - License text format validation
   - Clause structure and numbering validation
   - Required sections checking
   - Common pitfalls detection (Clause 1.2, 2.3)

3. **Palimpsest.Validator.Metadata**
   - JSON-LD schema validation
   - XML lineage tag validation
   - SPDX licence entry validation
   - Dublin Core metadata support

4. **Palimpsest.Validator.Bilingual**
   - Dutch ↔ English consistency checking
   - Clause alignment validation
   - Structural parity verification
   - Bilingual mapping table parsing

5. **Palimpsest.Validator.Reference**
   - Cross-reference validation
   - Broken link detection
   - Clause reference verification
   - Internal anchor checking

6. **Palimpsest.Validator.Utils**
   - File system utilities
   - Text normalisation
   - Pattern extraction helpers

## Installation

### Prerequisites

You need either:
- **GHC** (Glasgow Haskell Compiler) 8.10+ and **Cabal** 3.0+
- OR **Stack** (alternative Haskell build tool)

### Install GHCup (Recommended)

GHCup is the recommended way to install Haskell tooling:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

This installs GHC, Cabal, and optionally Stack and HLS (Haskell Language Server).

### Install the Validator

#### Automated Installation

```bash
cd TOOLS/validation
./install.sh
```

The script will:
1. Detect your Haskell toolchain
2. Build the validator
3. Install `palimpsest-validate` to `~/.local/bin`
4. Verify PATH configuration

#### Manual Installation with Cabal

```bash
cd TOOLS/validation/haskell
cabal update
cabal build
cabal install --installdir=$HOME/.local/bin --overwrite-policy=always
```

#### Manual Installation with Stack

```bash
cd TOOLS/validation/haskell
stack build
stack install
```

### Verify Installation

```bash
palimpsest-validate --help
```

## Usage

### Command-Line Interface

The validator provides several subcommands:

```bash
palimpsest-validate [OPTIONS] COMMAND
```

#### Global Options

- `--root PATH` - Root path of the Palimpsest License project (default: current directory)
- `--strict` - Strict mode: fail on warnings
- `--verbose` - Verbose output showing detailed validation steps
- `--no-bilingual` - Skip bilingual consistency checks
- `--no-references` - Skip cross-reference validation
- `--help` - Show help message

#### Commands

**1. Validate Entire Project**

```bash
palimpsest-validate project --root /path/to/palimpsest-license
```

Runs all validators:
- License files (v0.3, v0.4)
- Metadata files (JSON-LD, XML)
- Bilingual consistency (if enabled)
- Cross-references (if enabled)

**2. Validate License File**

```bash
palimpsest-validate license LICENSES/v0.4/palimpsest-v0.4.md
```

Validates:
- Document structure
- Clause numbering
- Required sections
- Metadata preservation clause
- NI systems consent clause

**3. Validate Metadata**

```bash
palimpsest-validate metadata METADATA_v0.4/spdx_example.jsonld
```

Validates:
- JSON-LD syntax and structure
- SPDX licence entries
- Required fields
- Palimpsest-specific requirements

**4. Validate Bilingual Consistency**

```bash
palimpsest-validate bilingual \
  LICENSES/v0.3/palimpsest-license-v0.3.en.md \
  LICENSES/v0.3/palimpsest-license-v0.3.nl.md \
  docs/bilingual-map.md
```

Validates:
- Clause count matches
- Clause alignment
- Title consistency
- Version consistency

**5. Validate Cross-References**

```bash
palimpsest-validate references \
  GUIDES_v0.4/User_Guide.md \
  GUIDES_v0.4/Developer_Guide.md \
  TOOLKIT_v0.4/Audit_Template.md
```

Validates:
- File references (Markdown links)
- Clause references
- Internal anchors
- URL format

### Examples

**Validate the entire project verbosely:**

```bash
palimpsest-validate project --root . --verbose
```

**Strict validation (fail on warnings):**

```bash
palimpsest-validate project --root . --strict
```

**Quick license validation:**

```bash
palimpsest-validate license LICENSES/v0.3/palimpsest-license-v0.3.en.md
```

**Skip optional checks:**

```bash
palimpsest-validate project --no-bilingual --no-references
```

## Validation Rules

### License Text Validation

The license validator checks:

1. **Structure**
   - Proper header with "Palimpsest License" title
   - Version number is detectable (e.g., "v0.3", "v0.4")
   - At least one clause is present

2. **Clause Numbering**
   - Clauses are numbered sequentially (1, 2, 3, ...)
   - No duplicate clause numbers
   - No gaps in numbering sequence

3. **Required Sections**
   - Definitions
   - Attribution
   - Governing Law
   - Termination

4. **Common Pitfalls (from EXPLAINME_ROOT.md)**
   - Clause 2.3: Metadata preservation clause must be present
   - Clause 1.2: Non-Interpretive (NI) systems consent clause must be present
   - Emotional lineage protection should be mentioned

5. **Language Detection**
   - English: "Governing Law", "Definitions"
   - Dutch: "Toepasselijk Recht", "Definities"

### Metadata Validation

The metadata validator checks:

1. **JSON-LD Structure**
   - Valid JSON syntax
   - `@context` field present (for valid JSON-LD)
   - `@type` field present
   - `licenses` array (if present) contains valid entries

2. **SPDX Licence Entries**
   - `licenseId` field required
   - `name` field required
   - `reference` field recommended for Palimpsest licences
   - Boolean fields (`isOsiApproved`, `isFsfLibre`) have correct type

3. **XML Lineage Tags**
   - Root element is `<lineageTag>`
   - Required children: `<creator>`, `<workId>`, `<timestamp>`

4. **Dublin Core** (if applicable)
   - Required elements: `dc:title`, `dc:creator`, `dc:date`, `dc:rights`, `dc:identifier`

### Bilingual Consistency

The bilingual validator checks:

1. **Structural Parity**
   - Same number of clauses in both languages
   - Both have headers (or both don't)
   - Both specify governing law (or both don't)

2. **Clause Alignment**
   - Clause numbers match between versions
   - Clause titles match expected translations (from `bilingual-map.md`)
   - No unmapped clauses (or warnings issued)

3. **Version Consistency**
   - Version numbers match exactly
   - Both versions are at the same revision level

4. **Title Matching**
   - Handles minor formatting differences (punctuation, capitalisation)
   - Allows for clause number prefixes (e.g., "Clause 1 — Definitions")

### Cross-Reference Validation

The reference validator checks:

1. **Clause References**
   - Valid format: "Clause X" or "Clause X.Y"
   - Referenced clause numbers are well-formed

2. **File References** (Markdown links)
   - Target files exist on filesystem
   - Paths are correctly resolved (relative or absolute)

3. **Internal Links**
   - Anchors exist in the same document
   - Anchor format matches headings correctly

4. **URL References**
   - Valid URL format (http:// or https://)
   - Note: Does not check if URLs are accessible (could be added)

## Development

### Building from Source

```bash
cd TOOLS/validation/haskell
make build
```

Or with Stack:

```bash
make build-stack
```

### Running Tests

```bash
make test
```

Tests use the **HSpec** testing framework with **QuickCheck** for property-based testing.

### Development Workflow

```bash
# Quick development build (no optimisation)
make dev

# Run validator on project
make run

# Run specific validators
make run-license
make run-metadata
make run-bilingual

# Format Haskell code (requires stylish-haskell)
make format

# Generate Haddock documentation
make docs
```

### Project Structure

```
haskell/
├── app/
│   └── Main.hs                      # CLI application
├── src/
│   └── Palimpsest/
│       └── Validator/
│           ├── Types.hs             # Core types and monad
│           ├── Utils.hs             # Utility functions
│           ├── License.hs           # Licence format validator
│           ├── Metadata.hs          # Metadata schema validator
│           ├── Bilingual.hs         # Bilingual consistency checker
│           └── Reference.hs         # Cross-reference validator
├── test/
│   ├── Spec.hs                      # Test entry point
│   └── Palimpsest/Validator/
│       ├── LicenseSpec.hs           # Licence validator tests
│       ├── MetadataSpec.hs          # Metadata validator tests
│       └── BilingualSpec.hs         # Bilingual validator tests
├── palimpsest-validator.cabal       # Cabal configuration
├── stack.yaml                       # Stack configuration
├── cabal.project                    # Cabal project config
├── Makefile                         # Build automation
├── README.md                        # Project README
└── LICENSE                          # MIT Licence
```

### Adding New Validators

To add a new validator:

1. Create a new module in `src/Palimpsest/Validator/`
2. Define validation functions using the `ValidatorM` monad
3. Export the module in `palimpsest-validator.cabal`
4. Add it to `Palimpsest.Validator` main module
5. Add corresponding tests in `test/Palimpsest/Validator/`
6. Update documentation

Example skeleton:

```haskell
{-# LANGUAGE OverloadedStrings #-}

module Palimpsest.Validator.MyValidator
  ( validateMyThing
  ) where

import Control.Monad.Reader (ask)
import Palimpsest.Validator.Types

validateMyThing :: FilePath -> ValidatorM ()
validateMyThing path = do
  config <- ask
  -- Your validation logic here
  validationWarning Warning (T.pack path) "Example warning"
```

## Integration with CI/CD

### GitHub Actions

Add to `.github/workflows/validate.yml`:

```yaml
name: Validate License

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Haskell
        uses: haskell/actions/setup@v2
        with:
          ghc-version: '9.2'
          cabal-version: '3.6'

      - name: Install validator
        run: |
          cd TOOLS/validation
          ./install.sh

      - name: Run validation
        run: palimpsest-validate project --strict --verbose
```

### Pre-commit Hook

Add to `.git/hooks/pre-commit`:

```bash
#!/bin/bash
palimpsest-validate project --strict
if [ $? -ne 0 ]; then
  echo "Validation failed. Commit aborted."
  exit 1
fi
```

## Comparison with Python Approach

### Advantages of Haskell

| Aspect | Haskell | Python |
|--------|---------|--------|
| **Type Safety** | Strong static typing catches errors at compile time | Dynamic typing, errors found at runtime |
| **Reliability** | Pure functions, no side effects | Mutable state, potential side effects |
| **Performance** | Compiled to native code, fast execution | Interpreted, slower execution |
| **Legal Precision** | Type system enforces correctness | Must rely on tests and conventions |
| **Parsing** | Parser combinators, composable | Regex and string manipulation |
| **Maintainability** | Types document behaviour | Requires extensive documentation |

### Trade-offs

- **Learning Curve**: Haskell has a steeper learning curve than Python
- **Ecosystem**: Python has more libraries, but Haskell's are often more robust
- **Deployment**: Haskell compiles to standalone binaries; Python requires interpreter
- **Community**: Smaller Haskell community, but focused on quality

For legal document validation, **precision and reliability** outweigh ease of learning, making Haskell the better choice.

## Troubleshooting

### Installation Issues

**Problem:** `ghc: command not found`

**Solution:** Install GHCup:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

**Problem:** `palimpsest-validate: command not found` after installation

**Solution:** Add `~/.local/bin` to your PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Problem:** Build fails with dependency errors

**Solution:** Update Cabal package list:
```bash
cabal update
cabal build
```

### Validation Issues

**Problem:** False positives for clause references

**Solution:** Ensure clause numbering follows the expected format ("Clause 1", "Clause 2.3")

**Problem:** Bilingual validation fails on valid translations

**Solution:** Check `docs/bilingual-map.md` is up to date with the correct mappings

**Problem:** File references fail despite files existing

**Solution:** Check that paths are relative to the correct base directory. Use `--verbose` to see resolved paths.

## Future Enhancements

Planned improvements:

1. **Enhanced URL Validation**: Actually check if URLs are accessible (with configurable timeout)
2. **PDF Export Validation**: Validate generated PDF versions of licences
3. **YAML Frontmatter**: Validate YAML frontmatter in Markdown files
4. **Custom Rule Engine**: Allow users to define custom validation rules
5. **Machine-Readable Output**: JSON/XML output for CI/CD integration
6. **Incremental Validation**: Only validate changed files (git integration)
7. **Clause Content Analysis**: Semantic analysis of clause content
8. **Blockchain Hash Verification**: Validate quantum-proof hashes for traceability

## Support and Contributing

### Getting Help

- **Documentation**: Start with this file and `TOOLS/validation/haskell/README.md`
- **Examples**: See `make run-*` targets for usage examples
- **Issues**: Report problems via GitHub Issues
- **Governance**: Major changes follow `GOVERNANCE.md` procedures

### Contributing

See the main project's `CONTRIBUTING.md` for guidelines. When contributing to the validator:

1. Follow Haskell style guidelines (use `stylish-haskell`)
2. Add tests for new validators
3. Update documentation
4. Ensure all tests pass: `make test`
5. Run the validator on the project: `make run`

### Code Style

- Use `stylish-haskell` for formatting
- Follow Haskell best practices
- Document all exported functions with Haddock comments
- Keep line length under 100 characters
- Use meaningful variable names

## Licence

The Palimpsest Validator is licenced under the **MIT Licence**, allowing free use, modification, and distribution. See `TOOLS/validation/haskell/LICENSE` for details.

---

**Version:** 0.1.0
**Last Updated:** 2024-11-22
**Maintainer:** Palimpsest Stewardship Council
