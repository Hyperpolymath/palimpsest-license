# Integration Examples - Palimpsest ReScript

Practical examples for integrating Palimpsest License tools into your website or application.

## Table of Contents

- [Quick Start](#quick-start)
- [Basic Website Integration](#basic-website-integration)
- [React Integration](#react-integration)
- [Vue.js Integration](#vuejs-integration)
- [Static Site Generators](#static-site-generators)
- [Content Management Systems](#content-management-systems)
- [Advanced Examples](#advanced-examples)

---

## Quick Start

### Minimal Example

Add license information to any webpage with just a few lines:

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Creative Work</title>
</head>
<body>
  <h1>My Poetry Collection</h1>

  <!-- License badge placeholder -->
  <div id="palimpsest-badge"></div>

  <!-- Metadata in JSON-LD -->
  <script type="application/ld+json" id="palimpsest-metadata">
  {
    "version": "0.4",
    "language": "en",
    "workTitle": "Echoes of Resilience",
    "licenseUri": "https://palimpsest.org/licenses/v0.4",
    "attribution": {
      "creators": [
        {
          "name": "Jane Doe",
          "identifier": "https://orcid.org/0000-0000-0000-0000"
        }
      ],
      "mustPreserveLineage": true
    },
    "consents": [
      {
        "usageType": "training",
        "status": "denied",
        "revocable": true
      }
    ]
  }
  </script>

  <!-- Load and initialise Palimpsest -->
  <script type="module">
    import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
    import { generateVersionBadge } from './lib/js/src/components/BadgeGenerator.bs.js';

    // Parse metadata
    const scriptEl = document.getElementById('palimpsest-metadata');
    const result = parseString(scriptEl.textContent);

    if (result.TAG === 'Ok') {
      const metadata = result._0;

      // Generate and inject badge
      const badge = generateVersionBadge(metadata);
      document.getElementById('palimpsest-badge').innerHTML = badge;
    }
  </script>
</body>
</html>
```

---

## Basic Website Integration

### Example 1: Complete License Widget

Display comprehensive license information with an interactive widget:

```html
<!DOCTYPE html>
<html>
<head>
  <title>My Photography Portfolio</title>
  <style>
    /* Import widget styles */
    @import url('./lib/css/palimpsest-widget.css');
  </style>
</head>
<body>
  <h1>Urban Landscapes</h1>
  <p>A photographic exploration of city life...</p>

  <!-- Widget placeholder -->
  <div id="license-widget"></div>

  <script type="module">
    import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
    import { generateWidget } from './lib/js/src/widgets/LicenseWidget.bs.js';

    const metadata = {
      version: { TAG: 1 }, // V04
      language: { TAG: 0 }, // En
      workTitle: "Urban Landscapes",
      licenseUri: "https://palimpsest.org/licenses/v0.4",
      attribution: {
        creators: [{
          name: "Alex Smith",
          identifier: "https://alexsmith.photography",
          role: "Photographer"
        }],
        mustPreserveLineage: false
      },
      consents: [
        {
          usageType: { TAG: 0 }, // Interpretive
          status: { TAG: 2, _0: "Non-commercial research only" }, // ConditionallyGranted
          revocable: true
        },
        {
          usageType: { TAG: 3 }, // Training
          status: { TAG: 1 }, // Denied
          revocable: true
        }
      ],
      emotionalLineage: undefined,
      traceability: undefined,
      customFields: undefined
    };

    const config = {
      showBadge: true,
      showMetadata: true,
      showCompliance: false,
      showConsents: true,
      expandable: true,
      theme: { TAG: 0 } // light
    };

    const widget = generateWidget({ metadata, config, includeCSS: true });
    document.getElementById('license-widget').innerHTML = widget;
  </script>
</body>
</html>
```

### Example 2: Compliance Check on Page Load

Automatically verify compliance when loading content:

```html
<script type="module">
  import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
  import { check } from './lib/js/src/core/ComplianceChecker.bs.js';

  // Parse embedded metadata
  const metadataJson = document.getElementById('palimpsest-metadata').textContent;
  const parseResult = parseString(metadataJson);

  if (parseResult.TAG === 'Ok') {
    const metadata = parseResult._0;

    // Define intended usage
    const requestedUsages = [
      { TAG: 0 }, // Interpretive
      { TAG: 2 }  // Derivative
    ];

    // Check compliance
    const complianceResult = check(metadata, requestedUsages);

    if (!complianceResult.isCompliant) {
      // Display warning
      const warning = document.createElement('div');
      warning.className = 'compliance-warning';
      warning.innerHTML = `
        <h3>⚠️ Usage Restrictions</h3>
        <p>This content has usage restrictions. Please review:</p>
        <ul>
          ${complianceResult.issues.map(issue => `
            <li><strong>${issue.clause}</strong>: ${issue.description}</li>
          `).join('')}
        </ul>
      `;
      document.body.insertBefore(warning, document.body.firstChild);
    }
  }
</script>
```

---

## React Integration

### Example 3: React Component with Badge

```javascript
import React, { useEffect, useState } from 'react';
import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
import { generateFromMetadata } from './lib/js/src/components/BadgeGenerator.bs.js';

function PalimpsestBadge({ metadataJson }) {
  const [badge, setBadge] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    const result = parseString(metadataJson);

    if (result.TAG === 'Ok') {
      const metadata = result._0;
      const badgePackage = generateFromMetadata(metadata);
      setBadge(badgePackage);
    } else {
      setError(result._0);
    }
  }, [metadataJson]);

  if (error) {
    return <div className="error">Error loading license: {error}</div>;
  }

  if (!badge) {
    return <div>Loading...</div>;
  }

  return (
    <div className="palimpsest-badge">
      <div dangerouslySetInnerHTML={{ __html: badge.svg }} />
      <a href={badge.licenseUri} target="_blank" rel="license noopener">
        View License
      </a>
    </div>
  );
}

export default PalimpsestBadge;
```

### Example 4: React Consent Form

```javascript
import React, { useState } from 'react';
import { generateEmbeddableConsentForm } from './lib/js/src/components/ConsentFlow.bs.js';

function ConsentManager({ existingConsents = [] }) {
  const [formHtml, setFormHtml] = useState('');

  useEffect(() => {
    const config = {
      showExplanations: true,
      allowConditional: true,
      requireJustification: false,
      multiStep: true
    };

    const html = generateEmbeddableConsentForm({ config, existingConsents });
    setFormHtml(html);

    // Listen for consent updates
    const handleConsentUpdate = (event) => {
      console.log('Consents updated:', event.detail);
      // Save to backend
      saveConsents(event.detail);
    };

    window.addEventListener('palimpsest:consent-updated', handleConsentUpdate);

    return () => {
      window.removeEventListener('palimpsest:consent-updated', handleConsentUpdate);
    };
  }, [existingConsents]);

  return <div dangerouslySetInnerHTML={{ __html: formHtml }} />;
}

async function saveConsents(consentData) {
  await fetch('/api/consents', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(consentData)
  });
}

export default ConsentManager;
```

---

## Vue.js Integration

### Example 5: Vue Component

```vue
<template>
  <div class="palimpsest-license">
    <div v-if="loading">Loading license information...</div>
    <div v-else-if="error" class="error">{{ error }}</div>
    <div v-else v-html="widgetHtml"></div>
  </div>
</template>

<script>
import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
import { generateWidget } from './lib/js/src/widgets/LicenseWidget.bs.js';

export default {
  name: 'PalimpsestLicense',
  props: {
    metadataJson: {
      type: String,
      required: true
    }
  },
  data() {
    return {
      loading: true,
      error: null,
      widgetHtml: ''
    };
  },
  mounted() {
    this.loadLicense();
  },
  methods: {
    loadLicense() {
      const result = parseString(this.metadataJson);

      if (result.TAG === 'Ok') {
        const metadata = result._0;
        const config = {
          showBadge: true,
          showMetadata: true,
          showCompliance: true,
          showConsents: true,
          expandable: true,
          theme: { TAG: 0 } // light
        };

        this.widgetHtml = generateWidget({ metadata, config, includeCSS: true });
        this.loading = false;
      } else {
        this.error = result._0;
        this.loading = false;
      }
    }
  }
};
</script>
```

---

## Static Site Generators

### Example 6: Jekyll Integration

Create a Jekyll include file `_includes/palimpsest-license.html`:

```liquid
{% assign metadata = include.metadata | default: page.palimpsest %}

<div id="palimpsest-license"></div>

<script type="application/ld+json" id="metadata-{{ page.url | slugify }}">
{{ metadata | jsonify }}
</script>

<script type="module">
  import { parseString } from '{{ site.baseurl }}/assets/js/palimpsest/MetadataParser.bs.js';
  import { display } from '{{ site.baseurl }}/assets/js/palimpsest/MetadataDisplay.bs.js';

  const scriptId = 'metadata-{{ page.url | slugify }}';
  const metadata = document.getElementById(scriptId).textContent;
  const result = parseString(metadata);

  if (result.TAG === 'Ok') {
    const style = {
      format: { TAG: 1 }, // Standard
      showIcons: true,
      showLinks: true,
      highlightTrauma: true
    };

    const html = display(result._0, { style });
    document.getElementById('palimpsest-license').innerHTML = html;
  }
</script>
```

Use in your post front matter:

```yaml
---
title: "My Creative Essay"
palimpsest:
  version: "0.4"
  workTitle: "Reflections on Identity"
  licenseUri: "https://palimpsest.org/licenses/v0.4"
  attribution:
    creators:
      - name: "Author Name"
---
```

### Example 7: Hugo Shortcode

Create `layouts/shortcodes/palimpsest.html`:

```html
{{- $metadata := .Get "metadata" | default .Page.Params.palimpsest -}}

<div class="palimpsest-widget" id="palimpsest-{{ .Page.File.UniqueID }}"></div>

<script type="module">
  import { generateEmbeddableSnippet } from '/js/palimpsest/LicenseWidget.bs.js';

  const metadata = {{ $metadata | jsonify }};
  const snippet = generateEmbeddableSnippet({ metadata });
  document.getElementById('palimpsest-{{ .Page.File.UniqueID }}').innerHTML = snippet;
</script>
```

---

## Content Management Systems

### Example 8: WordPress Plugin Integration

```php
<?php
/**
 * Palimpsest License Integration for WordPress
 */

function palimpsest_enqueue_scripts() {
    wp_enqueue_script(
        'palimpsest-integration',
        plugin_dir_url(__FILE__) . 'js/palimpsest-integration.js',
        array(),
        '1.0.0',
        true
    );
}
add_action('wp_enqueue_scripts', 'palimpsest_enqueue_scripts');

function palimpsest_license_shortcode($atts) {
    $metadata = get_post_meta(get_the_ID(), '_palimpsest_metadata', true);

    if (!$metadata) {
        return '';
    }

    $output = '<div id="palimpsest-' . get_the_ID() . '"></div>';
    $output .= '<script type="application/ld+json" id="metadata-' . get_the_ID() . '">';
    $output .= json_encode($metadata);
    $output .= '</script>';

    return $output;
}
add_shortcode('palimpsest_license', 'palimpsest_license_shortcode');
```

JavaScript file `palimpsest-integration.js`:

```javascript
import { autoInitialize } from './lib/palimpsest/WebIntegration.bs.js';

document.addEventListener('DOMContentLoaded', () => {
  // Find all metadata scripts
  const scripts = document.querySelectorAll('[id^="metadata-"]');

  scripts.forEach(script => {
    const postId = script.id.replace('metadata-', '');
    autoInitialize({ TAG: 0, _0: script.id }); // scriptId
  });
});
```

---

## Advanced Examples

### Example 9: Dynamic Compliance Checking with User Input

```html
<div id="usage-checker">
  <h3>Check Usage Compliance</h3>
  <p>What do you want to do with this work?</p>

  <label>
    <input type="checkbox" name="usage" value="interpretive"> AI Analysis
  </label>
  <label>
    <input type="checkbox" name="usage" value="training"> AI Training
  </label>
  <label>
    <input type="checkbox" name="usage" value="commercial"> Commercial Use
  </label>

  <button id="check-compliance">Check Compliance</button>

  <div id="compliance-result"></div>
</div>

<script type="module">
  import { parseString } from './lib/js/src/core/MetadataParser.bs.js';
  import { check, generateReport } from './lib/js/src/core/ComplianceChecker.bs.js';

  const metadata = parseString(document.getElementById('palimpsest-metadata').textContent)._0;

  document.getElementById('check-compliance').addEventListener('click', () => {
    const checkboxes = document.querySelectorAll('input[name="usage"]:checked');
    const usageMap = {
      'interpretive': { TAG: 0 },
      'training': { TAG: 3 },
      'commercial': { TAG: 4 }
    };

    const requestedUsages = Array.from(checkboxes).map(cb =>
      usageMap[cb.value]
    );

    if (requestedUsages.length === 0) {
      alert('Please select at least one usage type');
      return;
    }

    const result = check(metadata, requestedUsages);
    const report = generateReport(result);

    document.getElementById('compliance-result').innerHTML =
      `<pre>${report}</pre>`;
  });
</script>
```

### Example 10: API Integration with Backend Verification

```javascript
// Client-side: Send metadata for verification
import { serialiseString } from './lib/js/src/core/MetadataParser.bs.js';

async function verifyLicense(metadata, usageType) {
  const response = await fetch('/api/verify-license', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      metadata: serialiseString(metadata),
      usageType: usageType
    })
  });

  return await response.json();
}

// Server-side (Node.js): Verify and log
const { parseString } = require('./lib/js/src/core/MetadataParser.bs.js');
const { checkUsage } = require('./lib/js/src/core/ComplianceChecker.bs.js');

app.post('/api/verify-license', (req, res) => {
  const { metadata, usageType } = req.body;

  const parseResult = parseString(metadata);
  if (parseResult.TAG !== 'Ok') {
    return res.status(400).json({ error: 'Invalid metadata' });
  }

  const result = checkUsage(parseResult._0, usageType);

  // Log compliance check
  logComplianceCheck(req.user, parseResult._0, usageType, result);

  res.json({
    compliant: result.isCompliant,
    issues: result.issues
  });
});
```

---

## Best Practices

1. **Always validate metadata** before using it in production
2. **Cache badge generation** results for better performance
3. **Use structured data** (JSON-LD) for SEO benefits
4. **Provide fallbacks** for users without JavaScript
5. **Respect user privacy** when logging compliance checks
6. **Keep metadata up-to-date** when work details change
7. **Test across browsers** to ensure compatibility

---

**Version:** 0.4.0
**Last Updated:** 2025-11-22
