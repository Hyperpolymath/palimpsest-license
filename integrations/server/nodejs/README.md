# Palimpsest License - Node.js/Express Middleware

Official Node.js middleware for integrating the Palimpsest License into Express applications.

## Features

- 🔄 Automatic license metadata injection
- 📝 HTTP headers with license information
- 🌐 HTML meta tags and JSON-LD support
- ✅ License validation utilities
- 🌍 Bilingual support (English & Dutch)
- 🎨 Customisable license widgets
- 🔒 Compliance checking

## Installation

```bash
npm install @palimpsest/license-middleware
```

## Quick Start

```typescript
import express from 'express';
import { palimpsestMiddleware } from '@palimpsest/license-middleware';

const app = express();

// Apply Palimpsest License middleware globally
app.use(palimpsestMiddleware({
  workTitle: 'My Creative Work',
  authorName: 'Jane Doe',
  authorUrl: 'https://example.com/jane',
  emotionalLineage: 'A reflection on diaspora and belonging',
  version: '0.4',
  language: 'en'
}));

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>My Work</title>
      </head>
      <body>
        <h1>My Creative Work</h1>
        <p>Content goes here...</p>
      </body>
    </html>
  `);
});

app.listen(3000);
```

The middleware will automatically inject:
- HTTP headers (`X-License`, `X-Palimpsest-Version`, etc.)
- HTML meta tags in the `<head>` section
- JSON-LD metadata before `</body>`

## Configuration Options

```typescript
interface PalimpsestConfig {
  version?: string;                    // License version (default: "0.4")
  licenseUrl?: string;                 // License URL
  workTitle?: string;                  // Title of your work
  authorName?: string;                 // Author's name
  authorUrl?: string;                  // Author's URL or identifier
  emotionalLineage?: string;           // Emotional/cultural context
  agiConsentRequired?: boolean;        // AGI consent flag (default: true)
  injectHeaders?: boolean;             // Inject HTTP headers (default: true)
  injectHtmlMeta?: boolean;           // Inject HTML meta tags (default: true)
  injectJsonLd?: boolean;             // Inject JSON-LD (default: true)
  language?: 'en' | 'nl';             // Language preference (default: 'en')
}
```

## Advanced Usage

### License Information Endpoint

Create a dedicated endpoint that returns license information:

```typescript
import { licenseInfoHandler } from '@palimpsest/license-middleware';

app.get('/license', licenseInfoHandler({
  workTitle: 'My Work',
  authorName: 'Jane Doe',
  emotionalLineage: 'A story of resilience'
}));
```

Returns:
```json
{
  "license": {
    "name": "Palimpsest License v0.4",
    "version": "0.4",
    "url": "https://palimpsestlicense.org/v0.4",
    "identifier": "Palimpsest-0.4"
  },
  "work": {
    "title": "My Work",
    "author": "Jane Doe",
    "authorUrl": null
  },
  "protections": {
    "emotionalLineage": "A story of resilience",
    "agiConsentRequired": true,
    "metadataPreservationRequired": true,
    "quantumProofTraceability": true
  },
  "compliance": {
    "guideUrl": "https://palimpsestlicense.org/guides/compliance",
    "auditTemplateUrl": "https://palimpsestlicense.org/toolkit/audit"
  }
}
```

### Generate License Widget

Create a visual license notice:

```typescript
import { generateLicenseWidget } from '@palimpsest/license-middleware';

app.get('/widget', (req, res) => {
  const widget = generateLicenseWidget({
    workTitle: 'My Work',
    authorName: 'Jane Doe',
    language: 'en'
  }, 'light'); // or 'dark'

  res.send(`
    <!DOCTYPE html>
    <html>
      <body>
        ${widget}
      </body>
    </html>
  `);
});
```

### Validate Metadata

Check if metadata complies with Palimpsest License requirements:

```typescript
import { validateMetadata } from '@palimpsest/license-middleware';

const metadata = {
  '@type': 'CreativeWork',
  license: 'https://palimpsestlicense.org/v0.4',
  author: { name: 'Jane Doe' }
};

const result = validateMetadata(metadata);

if (!result.valid) {
  console.error('Validation errors:', result.errors);
}
```

### Custom Headers Only

If you only want HTTP headers without HTML injection:

```typescript
app.use(palimpsestMiddleware({
  workTitle: 'My Work',
  authorName: 'Jane Doe',
  injectHeaders: true,
  injectHtmlMeta: false,
  injectJsonLd: false
}));
```

### Dutch Language Support

```typescript
app.use(palimpsestMiddleware({
  workTitle: 'Mijn Werk',
  authorName: 'Jane Doe',
  emotionalLineage: 'Een reflectie op diaspora en verbondenheid',
  language: 'nl'
}));
```

## API Reference

### `palimpsestMiddleware(config)`

Express middleware that injects Palimpsest License metadata.

**Parameters:**
- `config` (PalimpsestConfig): Configuration options

**Returns:** Express middleware function

### `licenseInfoHandler(config)`

Express route handler that returns license information as JSON.

**Parameters:**
- `config` (PalimpsestConfig): Configuration options

**Returns:** Express request handler

### `generateJsonLd(config)`

Generate JSON-LD metadata string.

**Parameters:**
- `config` (PalimpsestConfig): Configuration options

**Returns:** JSON-LD string

### `generateHtmlMeta(config)`

Generate HTML meta tags string.

**Parameters:**
- `config` (PalimpsestConfig): Configuration options

**Returns:** HTML meta tags

### `generateLicenseWidget(config, theme)`

Generate HTML license widget.

**Parameters:**
- `config` (PalimpsestConfig): Configuration options
- `theme` ('light' | 'dark'): Visual theme

**Returns:** HTML string

### `validateMetadata(metadata)`

Validate Palimpsest License metadata.

**Parameters:**
- `metadata` (Record<string, any>): Metadata object to validate

**Returns:** `{ valid: boolean, errors: string[] }`

## Compliance

This middleware helps ensure compliance with:
- **Clause 2.3**: Metadata preservation
- **Clause 1.2**: Non-Interpretive (NI) systems consent
- **Emotional lineage** protection
- **Quantum-proof traceability**

### What This Middleware Does

✅ Injects machine-readable metadata
✅ Preserves attribution information
✅ Declares AGI consent status
✅ Provides validation utilities

### What You Still Need To Do

- Obtain explicit consent for AI training (if applicable)
- Preserve emotional and cultural context in derivatives
- Maintain metadata when distributing content
- Review the [Compliance Roadmap](https://palimpsestlicense.org/guides/compliance)

## Examples

See the `examples/` directory for:
- Basic Express application
- REST API with license validation
- Static file serving with license headers
- Multi-language support

## TypeScript Support

This package includes full TypeScript definitions. Import types:

```typescript
import type { PalimpsestConfig } from '@palimpsest/license-middleware';
```

## Testing

```bash
npm test
```

## Contributing

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.

## Licence

This middleware is licensed under the Palimpsest License v0.4.

## Support

- Documentation: https://palimpsestlicense.org
- Issues: https://github.com/palimpsest-license/palimpsest-license/issues
- Email: hello@palimpsestlicense.org

## Related Packages

- `@palimpsest/license-client` - Client-side JavaScript library
- `@palimpsest/license-validator` - Standalone validation library
- `@palimpsest/metadata-parser` - Metadata extraction utilities
