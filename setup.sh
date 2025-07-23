#!/bin/bash

set -eo pipefail

echo "🔍 Initializing Palimpsest License v0.4 setup..."

# -----------------------------------
# 1. Validate essential tools
# -----------------------------------

# Check for Julia
if ! command -v julia &> /dev/null; then
    echo "❌ Julia not found. Please install Julia 1.9+ from https://julialang.org/downloads/"
    exit 1
fi

# Check Julia version
JULIA_VERSION=$(julia -v | awk '{print $2}')
REQUIRED_JULIA="1.9"
if [[ "$(printf "%s\n" "$REQUIRED_JULIA" "$JULIA_VERSION" | sort -V | head -n1)" != "$REQUIRED_JULIA" ]]; then
    echo "❌ Julia $REQUIRED_JULIA+ required, but found $JULIA_VERSION"
    exit 1
fi

# Check for Bun
if ! command -v bun &> /dev/null; then
    echo "❌ Bun not found. Please install it from https://bun.sh"
    echo "On macOS with Homebrew: brew install bun"
    echo "On Ubuntu/Debian: curl -fsSL https://bun.sh/install | bash"
    exit 1
fi

BUN_VERSION=$(bun --version)
echo "   → Bun version $BUN_VERSION detected (ok)"

# -----------------------------------
# 2. Validate project structure
# -----------------------------------

echo "🔧 Validating project files..."

if [ ! -f Project.toml ]; then
    echo "❌ Project.toml not found"
    echo "Ensure you're in the correct directory and the Julia project file exists"
    exit 1
fi

# Optional: check for src/ or other expected dirs
#if [ ! -d src ]; then
#    echo "⚠️  src/ directory not found"
#fi

# -----------------------------------
# 3. Install dependencies
# -----------------------------------

echo "🚀 Installing project dependencies..."

# Install Julia packages
echo "   → Installing Julia dependencies..."
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'

# If you use Bun for frontend assets or scripts, install them here:
if [ -f bun.lockb ] || [ -d "frontend" ]; then
    echo "   → Installing Bun dependencies..."
    bun install
else
    echo "   → No Bun lockfile or frontend dir found — skipping Bun install"
fi

# -----------------------------------
# 4. Run validations
# -----------------------------------

echo "🧪 Validating environment..."

# Test Julia
julia -e 'println("✅ Julia test passed: ", VERSION)'

# Test Bun
bun --eval 'console.log("✅ Bun test passed:", Bun.version)'

# -----------------------------------
# 5. Final message
# -----------------------------------

echo ""
echo "🎉 Setup complete! You're ready to contribute to Palimpsest License v0.4"
echo "Use 'julia --project=.' to enter the Julia REPL"
echo "Use 'bun dev' or equivalent if this is a frontend-enabled repo"

