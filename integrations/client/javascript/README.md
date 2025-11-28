# Palimpsest License - Client-side JavaScript Library

Official JavaScript library for verifying and displaying Palimpsest License information in web browsers.

## Features

- 🔍 Extract and verify license metadata from pages
- 🎨 Create customisable license badges and notices
- 🌍 Bilingual support (English & Dutch)
- 🎭 Light and dark themes
- 📱 Responsive and accessible
- 🚀 Zero dependencies
- 📦 Multiple module formats (UMD, ESM, CommonJS)
- ⚡ Auto-initialization support

## Installation

### Via npm

```bash
npm install @palimpsest/license-client
```

### Via CDN

```html
<!-- Latest version -->
<script src="https://unpkg.com/@palimpsest/license-client@latest/dist/palimpsest.js"></script>

<!-- Specific version -->
<script src="https://unpkg.com/@palimpsest/license-client@0.4.0/dist/palimpsest.js"></script>
```

### Download

Download `palimpsest.js` from the [releases page](https://github.com/palimpsest-license/palimpsest-license/releases).

## Quick Start

### Auto-initialization

Add `data-auto-init` to automatically create widgets on page load:

```html
<!DOCTYPE html>
<html>
<head>
  <meta name="license" content="https://palimpsestlicense.org/v0.4">
  <meta name="palimpsest:version" content="0.4">
</head>
<body>
  <!-- Badge widget -->
  <div data-palimpsest-widget="badge"
       data-theme="light"
       data-language="en"></div>

  <!-- Notice widget -->
  <div data-palimpsest-widget="notice"
       data-theme="light"
       data-language="en"></div>

  <script src="palimpsest.js" data-auto-init></script>
</body>
</html>
```

### Manual Usage

```html
<script src="palimpsest.js"></script>
<script>
  // Verify license metadata
  const verification = Palimpsest.verifyLicense();
  console.log('License valid:', verification.valid);

  // Extract metadata
  const metadata = Palimpsest.extractLicenseMetadata();
  console.log('License metadata:', metadata);

  // Create a badge
  const badge = Palimpsest.createLicenseBadge({
    version: '0.4',
    language: 'en',
    theme: 'light'
  });
  document.getElementById('badge-container').appendChild(badge);

  // Create a notice
  const notice = Palimpsest.createLicenseNotice({
    language: 'en',
    theme: 'dark'
  });
  document.getElementById('notice-container').appendChild(notice);
</script>
```

### ES6 Module

```javascript
import Palimpsest from '@palimpsest/license-client';

// Or import specific functions
import {
  verifyLicense,
  createLicenseBadge,
  extractLicenseMetadata
} from '@palimpsest/license-client';

const metadata = extractLicenseMetadata();
const verification = verifyLicense();

if (verification.valid) {
  const badge = createLicenseBadge({ theme: 'dark' });
  document.body.appendChild(badge);
}
```

## API Reference

### `extractLicenseMetadata()`

Extract license metadata from the current page.

**Returns:** `Object|null` - License metadata object or null if not found

```javascript
const metadata = Palimpsest.extractLicenseMetadata();
// Returns:
// {
//   '@type': 'CreativeWork',
//   'license': 'https://palimpsestlicense.org/v0.4',
//   'author': { '@type': 'Person', 'name': 'Jane Doe' },
//   'additionalProperty': [...]
// }
```

### `verifyLicense()`

Verify if the current page has valid Palimpsest License metadata.

**Returns:** `Object` - Verification result

```javascript
const result = Palimpsest.verifyLicense();
// Returns:
// {
//   valid: true,
//   errors: [],
//   metadata: {...}
// }
```

### `createLicenseBadge(options)`

Create a license badge widget.

**Parameters:**
- `options.version` (string) - License version (default: '0.4')
- `options.licenseUrl` (string) - License URL
- `options.language` (string) - Language: 'en' or 'nl' (default: 'en')
- `options.theme` (string) - Theme: 'light' or 'dark' (default: 'light')

**Returns:** `HTMLElement` - Badge element

```javascript
const badge = Palimpsest.createLicenseBadge({
  version: '0.4',
  language: 'nl',
  theme: 'dark'
});

document.getElementById('container').appendChild(badge);
```

### `createLicenseNotice(options)`

Create a full license notice widget.

**Parameters:**
- `options.version` (string) - License version
- `options.licenseUrl` (string) - License URL
- `options.language` (string) - Language: 'en' or 'nl'
- `options.theme` (string) - Theme: 'light' or 'dark'

**Returns:** `HTMLElement` - Notice element

```javascript
const notice = Palimpsest.createLicenseNotice({
  language: 'en',
  theme: 'light'
});

document.body.appendChild(notice);
```

### `autoInit()`

Automatically initialise license widgets on page load.

```javascript
Palimpsest.autoInit();
```

## Examples

### React Integration

```jsx
import { useEffect, useRef } from 'react';
import Palimpsest from '@palimpsest/license-client';

function LicenseBadge({ theme = 'light', language = 'en' }) {
  const containerRef = useRef(null);

  useEffect(() => {
    if (containerRef.current) {
      const badge = Palimpsest.createLicenseBadge({ theme, language });
      containerRef.current.appendChild(badge);
    }
  }, [theme, language]);

  return <div ref={containerRef} />;
}
```

### Vue Integration

```vue
<template>
  <div ref="badgeContainer"></div>
</template>

<script>
import Palimpsest from '@palimpsest/license-client';

export default {
  props: {
    theme: { type: String, default: 'light' },
    language: { type: String, default: 'en' }
  },
  mounted() {
    const badge = Palimpsest.createLicenseBadge({
      theme: this.theme,
      language: this.language
    });
    this.$refs.badgeContainer.appendChild(badge);
  }
}
</script>
```

### License Verification on Page Load

```javascript
document.addEventListener('DOMContentLoaded', () => {
  const verification = Palimpsest.verifyLicense();

  if (!verification.valid) {
    console.error('License verification failed:', verification.errors);
    // Optionally show a warning to the user
    alert('This page does not have valid Palimpsest License metadata');
  } else {
    console.log('License verified successfully');
  }
});
```

### Custom Styling

```javascript
const notice = Palimpsest.createLicenseNotice({ theme: 'light' });

// Add custom styles
notice.style.maxWidth = '600px';
notice.style.margin = '40px auto';
notice.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';

document.body.appendChild(notice);
```

## Browser Support

- Chrome/Edge: Latest 2 versions
- Firefox: Latest 2 versions
- Safari: Latest 2 versions
- No IE11 support (use polyfills if needed)

## TypeScript Support

TypeScript definitions are included in the package:

```typescript
import Palimpsest, {
  LicenseMetadata,
  VerificationResult
} from '@palimpsest/license-client';

const metadata: LicenseMetadata | null = Palimpsest.extractLicenseMetadata();
const result: VerificationResult = Palimpsest.verifyLicense();
```

## Contributing

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.

## Licence

This library is licensed under the Palimpsest License v0.4.

## Support

- Documentation: https://palimpsestlicense.org
- Issues: https://github.com/palimpsest-license/palimpsest-license/issues
- Email: hello@palimpsestlicense.org
