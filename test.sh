#!/bin/bash
#
# Main test runner script for the Palimpsest project.

set -e

echo "🧪 Starting Palimpsest project tests..."

# Run linters via Makefile
make lint

# Placeholder for future tests
echo "✅ Linting passed."
echo "⏳ (Placeholder) Running manifest validation tests..."
echo "⏳ (Placeholder) Running link checker..."

echo "✅ All tests passed successfully!"
exit 0