# Installation Guide - Palimpsest ReScript

This guide explains how to install and set up the Palimpsest License ReScript implementation in your project.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Methods](#installation-methods)
- [Building from Source](#building-from-source)
- [Using Compiled JavaScript](#using-compiled-javascript)
- [CDN Usage](#cdn-usage)
- [Verification](#verification)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### For Building from Source

- Node.js 16.x or higher
- npm 7.x or higher (or yarn/pnpm)
- ReScript 11.x or higher (installed automatically)

### For Using Compiled JavaScript

- Modern web browser (ES6+ support)
- No build tools required

## Installation Methods

### Method 1: NPM Package (Recommended)

```bash
cd rescript
npm install
```

This will install ReScript and all dependencies specified in `package.json`.

### Method 2: Building from Source

1. Clone the repository:

```bash
git clone https://github.com/your-username/palimpsest-license.git
cd palimpsest-license/rescript
```

2. Install dependencies:

```bash
npm install
```

3. Build the project:

```bash
npm run build
```

The compiled JavaScript files will be generated in the `lib/js` directory, mirroring the source structure.

### Method 3: Using Pre-compiled JavaScript

If you prefer not to build from source, you can use the pre-compiled JavaScript files directly:

1. Download the compiled files from the `lib/js` directory
2. Include them in your project
3. Import as needed

## Building from Source

### Development Build

For development with watch mode (automatically rebuilds on file changes):

```bash
npm run watch
```

### Production Build

For a one-time build:

```bash
npm run build
```

### Clean Build

To clean previous builds and rebuild:

```bash
npm run clean
npm run build
```

### Formatting

To format ReScript source files:

```bash
npm run format
```

## Using Compiled JavaScript

### In a Web Application

The compiled JavaScript uses ES6 modules. You can import them in your application:

```javascript
// Import specific modules
import { parse } from './lib/js/src/core/MetadataParser.bs.js';
import { check } from './lib/js/src/core/ComplianceChecker.bs.js';
import { generateVersionBadge } from './lib/js/src/components/BadgeGenerator.bs.js';

// Use the functions
const metadataJson = '{"workTitle": "My Work", "licenseUri": "..."}';
const result = parse(metadataJson);
```

### In Node.js

```javascript
const { parse } = require('./lib/js/src/core/MetadataParser.bs.js');
const { check } = require('./lib/js/src/core/ComplianceChecker.bs.js');

// Use the modules
const metadata = parse(jsonString);
if (metadata.TAG === 'Ok') {
  console.log('Parsed successfully:', metadata._0);
}
```

### Module Structure

After building, the compiled JavaScript files maintain the source structure:

```
lib/js/src/
├── core/
│   ├── PalimpsestTypes.bs.js
│   ├── MetadataParser.bs.js
│   ├── ComplianceChecker.bs.js
│   └── MetadataValidator.bs.js
├── components/
│   ├── BadgeGenerator.bs.js
│   ├── MetadataDisplay.bs.js
│   └── ConsentFlow.bs.js
├── widgets/
│   └── LicenseWidget.bs.js
└── utils/
    └── WebIntegration.bs.js
```

## CDN Usage

For quick prototyping or simple projects, you can use a CDN (once published):

```html
<!-- In your HTML -->
<script type="module">
  import { parse } from 'https://unpkg.com/@palimpsest/rescript@latest/lib/js/src/core/MetadataParser.bs.js';

  // Use the parser
  const result = parse(metadataJson);
</script>
```

**Note:** CDN support requires the package to be published to npm. For now, use local installation.

## Verification

### Verify Installation

Check that ReScript is installed correctly:

```bash
npx rescript -version
```

Expected output: `11.x.x` (or your installed version)

### Verify Build

After building, check that compiled files exist:

```bash
ls -la lib/js/src/core/
```

You should see `.bs.js` files for each `.res` source file.

### Test Import

Create a simple test file `test.mjs`:

```javascript
import { versionToString } from './lib/js/src/core/PalimpsestTypes.bs.js';

const version = { TAG: 0 }; // V04
console.log('Version:', versionToString(version));
```

Run it:

```bash
node test.mjs
```

Expected output: `Version: 0.4`

## Troubleshooting

### Build Errors

**Problem:** `Error: Cannot find module 'rescript'`

**Solution:** Ensure dependencies are installed:

```bash
npm install
```

**Problem:** Permission errors during build

**Solution:** Check file permissions or use `sudo` (not recommended) or fix npm permissions:

```bash
sudo chown -R $USER:$USER .
```

### Import Errors

**Problem:** `Cannot find module` when importing compiled JavaScript

**Solution:** Verify the file path is correct and includes `.bs.js` extension:

```javascript
// Correct
import { parse } from './lib/js/src/core/MetadataParser.bs.js';

// Incorrect
import { parse } from './lib/js/src/core/MetadataParser';
```

**Problem:** `Unexpected token 'export'` in Node.js

**Solution:** Use `.mjs` extension for files with ES6 imports or configure `package.json`:

```json
{
  "type": "module"
}
```

### ReScript Errors

**Problem:** Type errors in ReScript source

**Solution:** ReScript has a strict type system. Review the error message and fix type mismatches. Common issues:

- Missing type annotations for function parameters
- Incorrect variant tag usage
- Option type misuse (use `Belt.Option` helpers)

**Problem:** `Warning: this module doesn't have a corresponding .res file`

**Solution:** Clean the build and rebuild:

```bash
npm run clean
npm run build
```

### Runtime Errors

**Problem:** `undefined is not a function` when calling ReScript functions

**Solution:** Check the compiled JavaScript structure. ReScript may wrap values differently. For variants and records, consult the compiled output.

## Next Steps

- Read the [API Documentation](./API.md) to learn about available modules
- Check [Integration Examples](./INTEGRATION.md) for practical usage
- Review the [Developer Guide](./DEVELOPER_GUIDE.md) for best practices

## Getting Help

- Review the [main documentation](../../CLAUDE.md)
- Check the [troubleshooting guide](./TROUBLESHOOTING.md)
- Open an issue on GitHub
- Contact the Palimpsest Stewardship Council

## Platform-Specific Notes

### Windows

ReScript works on Windows, but watch mode may have issues with some terminal emulators. Use PowerShell or WSL for best results.

### macOS

No known issues. ReScript works well on macOS with all package managers (npm, yarn, pnpm).

### Linux

No known issues. Ensure Node.js is installed via your distribution's package manager or nvm.

## Security Considerations

- Always verify the integrity of installed packages
- Use exact version numbers in production
- Review compiled JavaScript if deploying to production
- Keep ReScript and dependencies updated for security patches

---

**Version:** 0.4.0
**Last Updated:** 2025-11-22
