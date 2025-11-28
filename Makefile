# Makefile for Palimpsest License Project

.PHONY: all install lint test clean help convert-all convert-png convert-jpg convert-tiff clean-converted badges

# Default target
all: install lint test

# Install dependencies for all relevant languages
install:
	@echo "Installing Node.js dependencies..."
	npm install
	@echo "Installing Python dependencies..."
	pip install -r requirements.txt
	@echo "Setup complete. Run 'make help' for available commands."

# Run linters
lint:
	@echo "Linting JavaScript files..."
	npx eslint . --ext .js
	@echo "Formatting with Prettier..."
	npx prettier --check .

# Run tests
test:
	@echo "Running project tests..."
	./test.sh

# Clean up build artifacts and dependencies
clean:
	@echo "Cleaning up..."
	rm -rf node_modules
	find . -name "__pycache__" -exec rm -rf {} +
	@echo "Cleanup complete."

# Display help message
help:
	@echo "Available commands:"
	@echo "  make install       - Install project dependencies"
	@echo "  make lint          - Run linters and format checkers"
	@echo "  make test          - Run all tests"
	@echo "  make clean         - Remove installed dependencies and artifacts"
	@echo ""
	@echo "Asset conversion commands:"
	@echo "  make badges        - Generate all badge variants"
	@echo "  make convert-all   - Convert all SVG assets to PNG, JPG, and TIFF"
	@echo "  make convert-png   - Convert SVG assets to PNG only"
	@echo "  make convert-jpg   - Convert SVG assets to JPG only"
	@echo "  make convert-tiff  - Convert SVG assets to TIFF only"
	@echo "  make clean-converted - Remove all converted assets"

# Asset conversion targets
CONVERT_SCRIPT = ./assets/conversion-scripts/convert.sh
BRANDING_DIR = ./assets/branding
BADGES_DIR = ./assets/badges

# Convert all assets to all formats
convert-all:
	@echo "Converting all SVG assets to PNG, JPG, and TIFF..."
	@if [ -x "$(CONVERT_SCRIPT)" ]; then \
		$(CONVERT_SCRIPT) -a $(BRANDING_DIR); \
	else \
		echo "Error: $(CONVERT_SCRIPT) not found or not executable"; \
		exit 1; \
	fi
	@echo "Conversion complete!"

# Convert to PNG only
convert-png:
	@echo "Converting SVG assets to PNG..."
	@if [ -x "$(CONVERT_SCRIPT)" ]; then \
		$(CONVERT_SCRIPT) -f png -a $(BRANDING_DIR); \
	else \
		echo "Error: $(CONVERT_SCRIPT) not found or not executable"; \
		exit 1; \
	fi
	@echo "PNG conversion complete!"

# Convert to JPG only
convert-jpg:
	@echo "Converting SVG assets to JPG..."
	@if [ -x "$(CONVERT_SCRIPT)" ]; then \
		$(CONVERT_SCRIPT) -f jpg -a $(BRANDING_DIR); \
	else \
		echo "Error: $(CONVERT_SCRIPT) not found or not executable"; \
		exit 1; \
	fi
	@echo "JPG conversion complete!"

# Convert to TIFF only
convert-tiff:
	@echo "Converting SVG assets to TIFF..."
	@if [ -x "$(CONVERT_SCRIPT)" ]; then \
		$(CONVERT_SCRIPT) -f tiff -a $(BRANDING_DIR); \
	else \
		echo "Error: $(CONVERT_SCRIPT) not found or not executable"; \
		exit 1; \
	fi
	@echo "TIFF conversion complete!"

# Generate badge variants (will be implemented separately)
badges:
	@echo "Generating badge variants..."
	@echo "This will create SVG badge variants in different sizes and styles"
	@echo "Not yet implemented - see assets/badges/ for manual badge creation"

# Clean converted assets
clean-converted:
	@echo "Removing converted assets..."
	@rm -rf $(BADGES_DIR)/png/*
	@rm -rf $(BADGES_DIR)/jpg/*
	@rm -rf $(BADGES_DIR)/tiff/*
	@echo "Converted assets removed!"