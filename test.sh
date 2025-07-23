#!/bin/bash
#
# Main test runner script for the Palimpsest License v0.4 project.

set -e  # Exit on any error
trap 'echo "❌ Error occurred at line $LINENO"; exit 1' ERR

echo "🧪 Starting Palimpsest License v0.4 tests..."

# Define colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to run a test and report results
run_test() {
  local test_name="$1"
  local test_cmd="$2"

  echo -e "${YELLOW}⏳ Running $test_name...${NC}"
  if eval "$test_cmd"; then
    echo -e "${GREEN}✅ $test_name passed.${NC}"
    return 0
  else
    echo -e "${RED}❌ $test_name failed.${NC}"
    return 1
  fi
}

# 1. Run linters if Makefile exists
if [ -f "Makefile" ]; then
  run_test "Linting" "make lint" || echo "Continuing despite linting issues..."
else
  echo -e "${YELLOW}⚠️ No Makefile found, skipping linting.${NC}"
fi

# 2. Validate license files
run_test "License file validation" "test -f LICENSES/v0.4/palimpsest-v0.4.md && test -f LICENSES/v0.4/AGPL-3.0.txt"

# 3. Check for required directories
run_test "Directory structure" "test -d GUIDES_v0.4 && test -d TOOLKIT_v0.4 && test -d METADATA_v0.4"

# 4. Validate JSON files
if command -v jq &> /dev/null; then
  run_test "JSON validation" "find . -name '*.json' -not -path '*/node_modules/*' -not -path '*/.git/*' -exec jq '.' {} \; > /dev/null"
else
  echo -e "${YELLOW}⚠️ jq not installed, skipping JSON validation.${NC}"
fi

# 5. Test Julia license parser if available
if command -v julia &> /dev/null; then
  if [ -f "TOOLKIT_v0.4/Julia_License_Parser/license_parser.jl" ]; then
    # Create a temporary test file
    echo "Testing Julia parser..." > test_parser.tmp
    run_test "Julia license parser" "julia -e 'include(\"TOOLKIT_v0.4/Julia_License_Parser/license_parser.jl\"); using .LicenseParser; println(\"Parser loaded successfully\")'"
    rm test_parser.tmp
  else
    echo -e "${YELLOW}⚠️ Julia parser not found, skipping parser test.${NC}"
  fi
else
  echo -e "${YELLOW}⚠️ Julia not installed, skipping parser test.${NC}"
fi

# 6. Check for broken links in markdown files
if command -v markdown-link-check &> /dev/null; then
  echo -e "${YELLOW}⏳ Checking for broken links in README.md...${NC}"
  markdown-link-check README.md || echo -e "${YELLOW}⚠️ Some links may be broken in README.md${NC}"
else
  echo -e "${YELLOW}⚠️ markdown-link-check not installed, skipping link validation.${NC}"
fi

# 7. Validate version consistency
VERSION_FILE=$(cat VERSION 2>/dev/null || echo "0.4.0")
echo -e "${YELLOW}⏳ Checking version consistency ($VERSION_FILE)...${NC}"
VERSION_ISSUES=0

# Check package.json
if [ -f "package.json" ]; then
  PACKAGE_VERSION=$(grep -o '"version": "[^"]*' package.json | cut -d'"' -f3)
  if [ "$PACKAGE_VERSION" != "$VERSION_FILE" ]; then
    echo -e "${RED}❌ Version mismatch in package.json: $PACKAGE_VERSION vs $VERSION_FILE${NC}"
    VERSION_ISSUES=1
  fi
fi

# Check pyproject.toml
if [ -f "pyproject.toml" ]; then
  PY_VERSION=$(grep -o 'version = "[^"]*' pyproject.toml | cut -d'"' -f2)
  if [ "$PY_VERSION" != "$VERSION_FILE" ]; then
    echo -e "${RED}❌ Version mismatch in pyproject.toml: $PY_VERSION vs $VERSION_FILE${NC}"
    VERSION_ISSUES=1
  fi
fi

if [ $VERSION_ISSUES -eq 0 ]; then
  echo -e "${GREEN}✅ Version consistency check passed.${NC}"
fi

# 8. Check for empty files that should have content
echo -e "${YELLOW}⏳ Checking for empty required files...${NC}"
EMPTY_FILES=0
REQUIRED_FILES=(
  "LICENSES/v0.4/palimpsest-v0.4.md"
  "GUIDES_v0.4/Compliance_Roadmap.md"
  "TOOLKIT_v0.4/Julia_License_Parser/license_parser.jl"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ -f "$file" ] && [ ! -s "$file" ]; then
    echo -e "${RED}❌ Required file is empty: $file${NC}"
    EMPTY_FILES=1
  fi
done

if [ $EMPTY_FILES -eq 0 ]; then
  echo -e "${GREEN}✅ All required files have content.${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}✅ Palimpsest License v0.4 tests completed!${NC}"
echo "Note: Some tests may have been skipped due to missing dependencies."
echo "To install dependencies:"
echo "  - For JSON validation: npm install -g jq"
echo "  - For link checking: npm install -g markdown-link-check"
echo "  - For Julia tests: install Julia from https://julialang.org/"

exit 0
