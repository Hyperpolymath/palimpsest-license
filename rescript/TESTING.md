# ReScript/JavaScript Test Suite

## Overview

The ReScript test suite provides comprehensive testing of client-side Palimpsest License tools including metadata parsing, compliance checking, and badge generation.

## Test Structure

### Test Files

#### 1. **MetadataParser.test.js**
Tests for metadata parsing functionality:
- JSON-LD parsing (valid/invalid metadata)
- SPDX identifier validation
- Metadata extraction
- Edge cases (empty objects, null values)

**Test Coverage:**
- Valid JSON-LD metadata parsing
- Missing @context detection
- Nested license arrays
- SPDX identifier format validation
- License ID extraction
- Null value handling

#### 2. **ComplianceChecker.test.js**
Tests for license compliance validation:
- Required clause validation
- Clause 1.2 (NI Systems) compliance
- Clause 2.3 (Metadata) compliance
- Emotional lineage protection
- Version compliance
- Compliance report generation

**Test Coverage:**
- Required clauses presence detection
- Missing clause detection
- NI systems clause validation
- Metadata preservation clause validation
- Emotional lineage keyword detection
- Version format validation
- Compliance report structure
- Non-compliant license flagging

#### 3. **BadgeGenerator.test.js**
Tests for badge and QR code generation:
- Badge URL generation
- Markdown badge generation
- HTML badge generation
- QR code parameters
- Badge customization
- SVG badge generation
- Badge validation

**Test Coverage:**
- Version badge URL generation
- Compliance badge generation
- Markdown format generation
- HTML format generation
- QR code URL parameters
- Custom colors and labels
- URL encoding
- SVG structure
- Badge URL format validation

## Running Tests

### Install Dependencies
```bash
cd rescript
npm install
```

### Run All Tests
```bash
npm test
```

### Run Tests in Watch Mode
```bash
npm run test:watch
```

### Run Unit Tests Only
```bash
npm run test:unit
```

### Generate Coverage Report
```bash
npm test
# Coverage report will be generated in coverage/ directory
```

## Coverage Configuration

Jest is configured with the following coverage thresholds:

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 70,
      "functions": 70,
      "lines": 70,
      "statements": 70
    }
  }
}
```

**Target:** 70%+ coverage for all metrics

## Test Statistics

**Total Test Suites:** 3
**Total Tests:** 45+

Breakdown:
- MetadataParser: 15+ tests
- ComplianceChecker: 20+ tests
- BadgeGenerator: 15+ tests

## Test Organization

```
rescript/
├── __tests__/
│   ├── MetadataParser.test.js
│   ├── ComplianceChecker.test.js
│   └── BadgeGenerator.test.js
├── src/
│   ├── core/
│   │   ├── MetadataParser.res
│   │   ├── ComplianceChecker.res
│   │   └── MetadataValidator.res
│   └── components/
│       └── BadgeGenerator.res
└── package.json
```

## Test Patterns

### Unit Test Example
```javascript
describe('Module Name', () => {
  describe('Feature', () => {
    test('should do something specific', () => {
      // Arrange
      const input = {...};

      // Act
      const result = functionUnderTest(input);

      // Assert
      expect(result).toBe(expected);
    });
  });
});
```

### Edge Case Testing
Each test suite includes:
- Empty input handling
- Null/undefined values
- Malformed data
- Special characters
- Boundary conditions

## Integration with ReScript

Tests are written in JavaScript and test the compiled JavaScript output from ReScript. This approach:
- Validates the ReScript → JavaScript compilation
- Tests the actual runtime behavior
- Allows use of standard JavaScript testing tools
- Provides compatibility with standard CI/CD pipelines

## Coverage Reports

After running tests with coverage, view the HTML report:

```bash
cd rescript
npm test
open coverage/lcov-report/index.html
```

## Continuous Integration

Tests should be run:
1. Before every commit (pre-commit hook)
2. In CI/CD pipeline
3. Before merging pull requests
4. After dependency updates
5. Before releases

## Adding New Tests

When adding tests:
1. Create test file in `__tests__/` directory
2. Use `.test.js` extension
3. Follow existing patterns
4. Test both success and failure cases
5. Include edge cases
6. Document complex scenarios
7. Update this file

## Future Improvements

- [ ] Add E2E tests for UI components
- [ ] Implement visual regression tests for badges
- [ ] Add performance benchmarks
- [ ] Create test fixtures for realistic scenarios
- [ ] Add integration tests with browser environment
- [ ] Implement snapshot testing for generated output
- [ ] Add accessibility tests for UI components

## Dependencies

- **jest**: Testing framework
- **@types/jest**: TypeScript definitions for Jest
- **rescript**: ReScript compiler

## Test Environment

Tests run in Node.js environment by default:
```javascript
/**
 * @jest-environment node
 */
```

For browser-specific tests, use:
```javascript
/**
 * @jest-environment jsdom
 */
```

## Troubleshooting

### Tests Not Found
Ensure test files match pattern: `**/__tests__/**/*.test.js`

### Import Errors
Check that ReScript files have been compiled:
```bash
npm run build
```

### Coverage Issues
Verify coverage collection patterns in `package.json`:
```json
{
  "collectCoverageFrom": [
    "src/**/*.{js,res}",
    "!src/**/*.bs.js"
  ]
}
```
