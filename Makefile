# Makefile for Palimpsest License Project

.PHONY: all install lint test clean help

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
	@echo "  make install  - Install project dependencies"
	@echo "  make lint     - Run linters and format checkers"
	@echo "  make test     - Run all tests"
	@echo "  make clean    - Remove installed dependencies and artifacts"