# Content-Security-Policy Headers for License Enforcement
## Technical Advisory Document

**Version:** 1.0
**Date:** 2025-11-22
**Status:** Draft for Discussion
**Audience:** Web Developers, System Administrators, Security Engineers, CDN Operators

---

## Executive Summary

This document specifies how Content-Security-Policy (CSP) headers can be leveraged to enforce Palimpsest License requirements at the browser level. By extending CSP directives and introducing custom policies, web servers can prevent unauthorised use of licensed content whilst maintaining compatibility with existing web security infrastructure.

## Background

### Content-Security-Policy Overview

CSP, defined in W3C standards, allows web servers to:

- Control resource loading (scripts, images, styles, etc.)
- Prevent XSS and injection attacks
- Restrict content origins and destinations
- Enforce security policies at the browser level

### Why CSP for Licensing?

CSP provides a browser-enforced mechanism to:

- **Prevent content scraping:** Block unauthorised embedding and extraction
- **Control derivative works:** Restrict how content can be transformed
- **Enforce attribution:** Require metadata preservation in client-side operations
- **Block AI scrapers:** Prevent interpretive AI systems from processing content
- **Audit compliance:** Report policy violations to origin server

## Standard CSP Directives

### Existing Directives Relevant to Licensing

| Directive | Use for Licensing | Example |
|-----------|-------------------|---------|
| `default-src` | Restrict content loading | `default-src 'self'` |
| `img-src` | Control image embedding | `img-src 'self' https://trusted.org` |
| `frame-ancestors` | Prevent unauthorised framing | `frame-ancestors 'none'` |
| `report-uri` | Log violations | `report-uri /license-violation-report` |
| `report-to` | Modern violation reporting | `report-to license-endpoint` |

### Basic License Protection

```http
Content-Security-Policy:
  default-src 'self';
  frame-ancestors 'none';
  report-uri /csp-violations
```

**Effect:**

- Content cannot be embedded in iframes (prevents scraping)
- Violations reported to server
- Basic protection against unauthorised redistribution

## Extended CSP for Palimpsest License

### Proposed Custom Directives

We propose extending CSP with Palimpsest-specific directives:

```http
Content-Security-Policy:
  palimpsest-license v0.4;
  palimpsest-ni-consent required;
  palimpsest-metadata-preservation mandatory;
  palimpsest-derivative-policy restricted;
  report-uri /license-violations
```

### Directive Definitions

#### 1. `palimpsest-license`

Declares the license version governing the content.

**Syntax:**
```
palimpsest-license <version>
```

**Examples:**
```http
Content-Security-Policy: palimpsest-license v0.4
Content-Security-Policy: palimpsest-license v0.3
```

**Browser behaviour:**

- Browsers recognising this directive display license badge
- Compatible browsers enforce Palimpsest policies
- Unknown directives ignored (graceful degradation)

#### 2. `palimpsest-ni-consent`

Controls non-interpretive AI system access.

**Syntax:**
```
palimpsest-ni-consent required | granted | denied
```

**Examples:**
```http
Content-Security-Policy: palimpsest-ni-consent required

Content-Security-Policy: palimpsest-ni-consent denied
```

**Browser behaviour:**

- `required`: Block known AI scraper user agents
- `granted`: Allow AI systems with proper attribution
- `denied`: Absolute prohibition on AI interpretation

**Implementation:**

```javascript
// Browser-side enforcement (conceptual)
if (csp.palimpsest_ni_consent === 'required') {
  const userAgent = navigator.userAgent;
  const aiScrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot'];

  if (aiScrapers.some(bot => userAgent.includes(bot))) {
    // Block rendering or API access
    document.body.innerHTML = '<h1>403: NI Consent Required</h1>';
    throw new Error('Palimpsest License: NI consent required');
  }
}
```

#### 3. `palimpsest-metadata-preservation`

Requires metadata preservation in any client-side operations.

**Syntax:**
```
palimpsest-metadata-preservation mandatory | encouraged | none
```

**Examples:**
```http
Content-Security-Policy: palimpsest-metadata-preservation mandatory
```

**Browser behaviour:**

- `mandatory`: Prevent copy/download without metadata
- `encouraged`: Warn users to preserve metadata
- `none`: No enforcement (monitoring only)

**Implementation:**

```javascript
// Prevent copy without metadata
document.addEventListener('copy', (e) => {
  if (csp.palimpsest_metadata_preservation === 'mandatory') {
    const selection = window.getSelection().toString();
    const metadata = `

---
Source: ${window.location.href}
License: Palimpsest v0.4
Author: ${document.querySelector('meta[name="author"]').content}
Date: ${new Date().toISOString()}
`;

    const enrichedContent = selection + metadata;
    e.clipboardData.setData('text/plain', enrichedContent);
    e.preventDefault();
  }
});
```

#### 4. `palimpsest-derivative-policy`

Controls client-side content transformation.

**Syntax:**
```
palimpsest-derivative-policy unrestricted | restricted | prohibited
```

**Examples:**
```http
Content-Security-Policy: palimpsest-derivative-policy restricted
```

**Browser behaviour:**

- `unrestricted`: Allow transformations with attribution
- `restricted`: Allow only approved transformations
- `prohibited`: Block all client-side modifications

**Implementation:**

```javascript
// Block canvas manipulation of licensed images
if (csp.palimpsest_derivative_policy === 'prohibited') {
  const originalGetContext = HTMLCanvasElement.prototype.getContext;

  HTMLCanvasElement.prototype.getContext = function(...args) {
    const ctx = originalGetContext.apply(this, args);

    // Wrap drawing methods
    const originalDrawImage = ctx.drawImage;
    ctx.drawImage = function(image, ...drawArgs) {
      // Check if image has Palimpsest license
      if (image.dataset?.palimpsestLicense) {
        throw new Error('Palimpsest License: Derivative works prohibited');
      }
      return originalDrawImage.apply(this, [image, ...drawArgs]);
    };

    return ctx;
  };
}
```

#### 5. `palimpsest-attribution`

Specifies attribution requirements.

**Syntax:**
```
palimpsest-attribution required | symbolic | lineage
```

**Examples:**
```http
Content-Security-Policy: palimpsest-attribution lineage
```

**Browser behaviour:**

- `required`: Standard attribution (name, link)
- `symbolic`: Emotional/cultural context required
- `lineage`: Full derivation chain required

#### 6. `palimpsest-report-endpoint`

Dedicated endpoint for license violation reports.

**Syntax:**
```
palimpsest-report-endpoint <uri>
```

**Examples:**
```http
Content-Security-Policy: palimpsest-report-endpoint /license-violations
```

## CSP Reporting Integration

### Violation Report Format

When a Palimpsest policy is violated, browsers should send:

```json
{
  "csp-report": {
    "document-uri": "https://example.org/creative-work",
    "violated-directive": "palimpsest-ni-consent",
    "blocked-uri": "self",
    "original-policy": "palimpsest-license v0.4; palimpsest-ni-consent required",
    "source-file": "https://example.org/creative-work",
    "line-number": 42,
    "column-number": 15,
    "status-code": 403,
    "palimpsest-context": {
      "license-version": "v0.4",
      "violation-type": "ni-consent-required",
      "user-agent": "Mozilla/5.0 (compatible; GPTBot/1.0)",
      "timestamp": "2025-11-22T12:34:56Z",
      "client-ip": "192.0.2.1",
      "metadata": {
        "work-id": "urn:uuid:12345678-1234-1234-1234-123456789abc",
        "creator-id": "creator@example.org"
      }
    }
  }
}
```

### Report-To API

Modern CSP uses the Reporting API (RFC TBD):

```http
Report-To: {
  "group": "palimpsest-violations",
  "max_age": 86400,
  "endpoints": [{
    "url": "https://example.org/license-violation-reports"
  }]
}

Content-Security-Policy:
  palimpsest-license v0.4;
  palimpsest-ni-consent required;
  report-to palimpsest-violations
```

### Server-Side Report Handling

```python
# Flask example for handling violation reports
from flask import Flask, request, jsonify
import logging

app = Flask(__name__)
logger = logging.getLogger('palimpsest.violations')

@app.route('/license-violation-reports', methods=['POST'])
def handle_violation():
    """Process Palimpsest license violation reports."""
    report = request.get_json()

    if 'csp-report' in report:
        csp = report['csp-report']
        context = csp.get('palimpsest-context', {})

        # Log violation
        logger.warning(
            f"License violation: {context.get('violation-type')} "
            f"by {context.get('user-agent')} "
            f"on {csp.get('document-uri')}"
        )

        # Check if AI scraper
        if 'GPTBot' in context.get('user-agent', ''):
            # Alert for NI consent violation
            send_alert(
                severity='HIGH',
                message='AI scraper accessed NI-protected content',
                details=context
            )

        # Store for analysis
        db.violations.insert({
            'timestamp': context.get('timestamp'),
            'document_uri': csp.get('document-uri'),
            'violation_type': context.get('violation-type'),
            'user_agent': context.get('user-agent'),
            'client_ip': context.get('client-ip'),
            'work_id': context.get('metadata', {}).get('work-id')
        })

    return jsonify({'status': 'received'}), 204

def send_alert(severity, message, details):
    """Send alert for serious violations."""
    # Email, Slack, PagerDuty, etc.
    pass
```

## Implementation Examples

### Apache Configuration

```apache
# .htaccess or httpd.conf

# Basic Palimpsest CSP
<IfModule mod_headers.c>
    Header set Content-Security-Policy "\
        default-src 'self'; \
        frame-ancestors 'none'; \
        palimpsest-license v0.4; \
        palimpsest-ni-consent required; \
        palimpsest-metadata-preservation mandatory; \
        report-uri /license-violations"
</IfModule>

# Conditional CSP based on content type
<FilesMatch "\.(html|php)$">
    Header set Content-Security-Policy "\
        palimpsest-license v0.4; \
        palimpsest-ni-consent required; \
        report-uri /csp-report"
</FilesMatch>

<FilesMatch "\.(jpg|jpeg|png|gif)$">
    Header set Content-Security-Policy "\
        palimpsest-license v0.4; \
        palimpsest-derivative-policy prohibited; \
        report-uri /csp-report"
</FilesMatch>
```

### Nginx Configuration

```nginx
# nginx.conf or site configuration

server {
    listen 443 ssl http2;
    server_name example.org;

    # Basic Palimpsest CSP for all content
    add_header Content-Security-Policy "\
        default-src 'self'; \
        frame-ancestors 'none'; \
        palimpsest-license v0.4; \
        palimpsest-ni-consent required; \
        report-uri /license-violations" always;

    # Stricter CSP for creative works
    location /creative/ {
        add_header Content-Security-Policy "\
            default-src 'none'; \
            frame-ancestors 'none'; \
            palimpsest-license v0.4; \
            palimpsest-ni-consent denied; \
            palimpsest-derivative-policy prohibited; \
            palimpsest-metadata-preservation mandatory; \
            report-uri /creative-violations" always;
    }

    # Report endpoint
    location /license-violations {
        proxy_pass http://localhost:5000/license-violation-reports;
        proxy_set_header Content-Type application/csp-report;
    }
}
```

### Cloudflare Workers

```javascript
// Cloudflare Worker to add Palimpsest CSP headers

addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  // Fetch origin response
  const response = await fetch(request)

  // Clone response to modify headers
  const newResponse = new Response(response.body, response)

  // Determine license policy based on path
  const url = new URL(request.url)
  let csp = "default-src 'self'; palimpsest-license v0.4;"

  if (url.pathname.startsWith('/creative/')) {
    // Strict protection for creative works
    csp += " palimpsest-ni-consent required;"
    csp += " palimpsest-derivative-policy prohibited;"
    csp += " palimpsest-metadata-preservation mandatory;"
    csp += " frame-ancestors 'none';"
  } else if (url.pathname.startsWith('/blog/')) {
    // Moderate protection for blog posts
    csp += " palimpsest-ni-consent required;"
    csp += " palimpsest-metadata-preservation mandatory;"
  }

  // Add reporting
  csp += " report-uri /license-violations;"

  // Set CSP header
  newResponse.headers.set('Content-Security-Policy', csp)

  // Set Report-To for modern browsers
  newResponse.headers.set('Report-To', JSON.stringify({
    group: 'palimpsest-violations',
    max_age: 86400,
    endpoints: [{ url: 'https://example.org/license-violation-reports' }]
  }))

  return newResponse
}
```

### Express.js (Node.js)

```javascript
const express = require('express');
const helmet = require('helmet');

const app = express();

// Palimpsest CSP middleware
function palimpsestCSP(options = {}) {
  return (req, res, next) => {
    const {
      license = 'v0.4',
      niConsent = 'required',
      metadataPreservation = 'mandatory',
      derivativePolicy = 'restricted',
      reportUri = '/license-violations'
    } = options;

    const csp = [
      "default-src 'self'",
      `palimpsest-license ${license}`,
      `palimpsest-ni-consent ${niConsent}`,
      `palimpsest-metadata-preservation ${metadataPreservation}`,
      `palimpsest-derivative-policy ${derivativePolicy}`,
      `report-uri ${reportUri}`
    ].join('; ');

    res.setHeader('Content-Security-Policy', csp);

    // Modern reporting
    res.setHeader('Report-To', JSON.stringify({
      group: 'palimpsest-violations',
      max_age: 86400,
      endpoints: [{ url: `${req.protocol}://${req.get('host')}${reportUri}` }]
    }));

    next();
  };
}

// Apply to all routes
app.use(palimpsestCSP({
  license: 'v0.4',
  niConsent: 'required',
  metadataPreservation: 'mandatory'
}));

// Stricter policy for specific routes
app.use('/creative', palimpsestCSP({
  license: 'v0.4',
  niConsent: 'denied',
  derivativePolicy: 'prohibited'
}));

// Violation report handler
app.post('/license-violations', express.json({ type: 'application/csp-report' }), (req, res) => {
  const report = req.body;

  if (report['csp-report']) {
    console.log('CSP Violation:', JSON.stringify(report, null, 2));

    // Process violation
    // - Log to database
    // - Send alerts for serious violations
    // - Update abuse lists
  }

  res.status(204).send();
});

app.listen(3000);
```

### Django Middleware

```python
# middleware.py

import json
from django.conf import settings
from django.http import JsonResponse

class PalimpsestCSPMiddleware:
    """Middleware to add Palimpsest CSP headers."""

    def __init__(self, get_response):
        self.get_response = get_response
        self.license_version = getattr(settings, 'PALIMPSEST_LICENSE_VERSION', 'v0.4')

    def __call__(self, request):
        response = self.get_response(request)

        # Determine policy based on path
        csp_directives = ["default-src 'self'"]

        # Add Palimpsest directives
        csp_directives.append(f"palimpsest-license {self.license_version}")

        if request.path.startswith('/creative/'):
            # Strict protection
            csp_directives.extend([
                "palimpsest-ni-consent denied",
                "palimpsest-derivative-policy prohibited",
                "palimpsest-metadata-preservation mandatory",
                "frame-ancestors 'none'"
            ])
        else:
            # Standard protection
            csp_directives.extend([
                "palimpsest-ni-consent required",
                "palimpsest-metadata-preservation mandatory"
            ])

        csp_directives.append("report-uri /license-violations")

        # Set CSP header
        response['Content-Security-Policy'] = '; '.join(csp_directives)

        # Modern reporting
        response['Report-To'] = json.dumps({
            'group': 'palimpsest-violations',
            'max_age': 86400,
            'endpoints': [{'url': f"{request.scheme}://{request.get_host()}/license-violation-reports"}]
        })

        return response

# views.py

from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_http_methods
import json
import logging

logger = logging.getLogger('palimpsest.violations')

@csrf_exempt
@require_http_methods(["POST"])
def license_violation_report(request):
    """Handle CSP violation reports."""
    try:
        report = json.loads(request.body)

        if 'csp-report' in report:
            csp = report['csp-report']

            logger.warning(
                f"License violation on {csp.get('document-uri')} "
                f"- {csp.get('violated-directive')}"
            )

            # Store in database
            from .models import LicenseViolation
            LicenseViolation.objects.create(
                document_uri=csp.get('document-uri'),
                violated_directive=csp.get('violated-directive'),
                user_agent=request.META.get('HTTP_USER_AGENT'),
                client_ip=request.META.get('REMOTE_ADDR')
            )

    except Exception as e:
        logger.error(f"Error processing violation report: {e}")

    return JsonResponse({'status': 'received'}, status=204)
```

## Browser Integration

### Client-Side License Detection

JavaScript libraries can detect and enforce CSP policies:

```javascript
// palimpsest-csp.js - Client-side enforcement library

class PalimpsestCSP {
  constructor() {
    this.policies = this.parseCSP();
    this.enforce();
  }

  parseCSP() {
    const csp = document.querySelector('meta[http-equiv="Content-Security-Policy"]')?.content ||
                document.head.querySelector('[http-equiv="Content-Security-Policy"]')?.getAttribute('content');

    if (!csp) return null;

    const policies = {};
    csp.split(';').forEach(directive => {
      const [key, ...values] = directive.trim().split(/\s+/);
      if (key.startsWith('palimpsest-')) {
        policies[key] = values.join(' ');
      }
    });

    return policies;
  }

  enforce() {
    if (!this.policies) return;

    // Enforce NI consent
    if (this.policies['palimpsest-ni-consent']) {
      this.enforceNIConsent();
    }

    // Enforce metadata preservation
    if (this.policies['palimpsest-metadata-preservation'] === 'mandatory') {
      this.enforceMetadataPreservation();
    }

    // Enforce derivative policy
    if (this.policies['palimpsest-derivative-policy']) {
      this.enforceDerivativePolicy();
    }

    // Display license badge
    this.displayLicenseBadge();
  }

  enforceNIConsent() {
    const consent = this.policies['palimpsest-ni-consent'];

    if (consent === 'denied' || consent === 'required') {
      // Check user agent (server-side is more reliable)
      const aiScrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'Claude-Web'];

      if (aiScrapers.some(bot => navigator.userAgent.includes(bot))) {
        this.reportViolation('palimpsest-ni-consent', 'AI scraper detected');
        document.body.innerHTML = '<h1>403 Forbidden</h1><p>Non-interpretive consent required.</p>';
        throw new Error('Palimpsest License: NI consent violation');
      }
    }
  }

  enforceMetadataPreservation() {
    // Intercept copy events
    document.addEventListener('copy', (e) => {
      const selection = window.getSelection().toString();

      if (selection) {
        const metadata = this.generateMetadata();
        const enrichedContent = `${selection}\n\n${metadata}`;

        e.clipboardData.setData('text/plain', enrichedContent);
        e.clipboardData.setData('text/html', `
          <div>
            ${document.getSelection().getRangeAt(0).cloneContents().textContent}
            <div style="margin-top:1em;font-size:0.8em;color:#666;">
              ${metadata.replace(/\n/g, '<br>')}
            </div>
          </div>
        `);

        e.preventDefault();

        // Show notification
        this.showNotification('Metadata preserved in clipboard');
      }
    });

    // Prevent right-click save without metadata
    document.addEventListener('contextmenu', (e) => {
      if (e.target.tagName === 'IMG') {
        e.preventDefault();
        this.showMetadataDialog(e.target);
      }
    });
  }

  enforceDerivativePolicy() {
    const policy = this.policies['palimpsest-derivative-policy'];

    if (policy === 'prohibited') {
      // Block canvas operations on licensed images
      const images = document.querySelectorAll('img[data-palimpsest-license]');

      images.forEach(img => {
        img.addEventListener('dragstart', (e) => {
          e.preventDefault();
          this.reportViolation('palimpsest-derivative-policy', 'Attempted image extraction');
        });

        // Prevent canvas drawing
        img.setAttribute('crossorigin', 'anonymous');
        img.dataset.palimpsestProtected = 'true';
      });
    }
  }

  generateMetadata() {
    return `
---
Source: ${window.location.href}
License: Palimpsest ${this.policies['palimpsest-license'] || 'v0.4'}
Title: ${document.title}
Author: ${document.querySelector('meta[name="author"]')?.content || 'Unknown'}
Date Accessed: ${new Date().toISOString()}
License URL: ${window.location.origin}/.well-known/license
---
`.trim();
  }

  displayLicenseBadge() {
    const badge = document.createElement('div');
    badge.id = 'palimpsest-license-badge';
    badge.style.cssText = `
      position: fixed;
      bottom: 10px;
      right: 10px;
      background: #4CAF50;
      color: white;
      padding: 8px 12px;
      border-radius: 4px;
      font-size: 12px;
      font-family: sans-serif;
      z-index: 10000;
      cursor: pointer;
      box-shadow: 0 2px 5px rgba(0,0,0,0.2);
    `;
    badge.textContent = `🛡️ Palimpsest ${this.policies['palimpsest-license'] || 'v0.4'}`;

    badge.addEventListener('click', () => {
      this.showLicenseModal();
    });

    document.body.appendChild(badge);
  }

  showLicenseModal() {
    const modal = document.createElement('div');
    modal.style.cssText = `
      position: fixed;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 4px 20px rgba(0,0,0,0.3);
      z-index: 10001;
      max-width: 500px;
    `;

    modal.innerHTML = `
      <h2>Palimpsest License ${this.policies['palimpsest-license'] || 'v0.4'}</h2>
      <p>This content is protected under the Palimpsest License.</p>
      <h3>Requirements:</h3>
      <ul>
        <li><strong>NI Consent:</strong> ${this.policies['palimpsest-ni-consent'] || 'Not specified'}</li>
        <li><strong>Metadata Preservation:</strong> ${this.policies['palimpsest-metadata-preservation'] || 'Not specified'}</li>
        <li><strong>Derivative Works:</strong> ${this.policies['palimpsest-derivative-policy'] || 'Not specified'}</li>
      </ul>
      <p><a href="/.well-known/license" target="_blank">View full license</a></p>
      <button id="close-modal" style="margin-top:10px;padding:8px 16px;cursor:pointer;">Close</button>
    `;

    const overlay = document.createElement('div');
    overlay.style.cssText = `
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0,0,0,0.5);
      z-index: 10000;
    `;

    document.body.appendChild(overlay);
    document.body.appendChild(modal);

    modal.querySelector('#close-modal').addEventListener('click', () => {
      overlay.remove();
      modal.remove();
    });

    overlay.addEventListener('click', () => {
      overlay.remove();
      modal.remove();
    });
  }

  showNotification(message) {
    const notification = document.createElement('div');
    notification.style.cssText = `
      position: fixed;
      top: 10px;
      right: 10px;
      background: #2196F3;
      color: white;
      padding: 12px 16px;
      border-radius: 4px;
      z-index: 10000;
      animation: slideIn 0.3s ease-out;
    `;
    notification.textContent = message;

    document.body.appendChild(notification);

    setTimeout(() => {
      notification.style.animation = 'slideOut 0.3s ease-in';
      setTimeout(() => notification.remove(), 300);
    }, 3000);
  }

  reportViolation(directive, details) {
    const report = {
      'csp-report': {
        'document-uri': window.location.href,
        'violated-directive': directive,
        'original-policy': document.querySelector('meta[http-equiv="Content-Security-Policy"]')?.content,
        'palimpsest-context': {
          'license-version': this.policies['palimpsest-license'] || 'unknown',
          'violation-type': directive,
          'user-agent': navigator.userAgent,
          'timestamp': new Date().toISOString(),
          'details': details
        }
      }
    };

    // Send report to server
    fetch('/license-violations', {
      method: 'POST',
      headers: { 'Content-Type': 'application/csp-report' },
      body: JSON.stringify(report)
    }).catch(err => console.error('Failed to send violation report:', err));
  }
}

// Auto-initialize
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', () => new PalimpsestCSP());
} else {
  new PalimpsestCSP();
}
```

### Browser Extension Support

Browser extensions can enhance CSP enforcement:

```javascript
// Palimpsest Browser Extension
// manifest.json
{
  "manifest_version": 3,
  "name": "Palimpsest License Guardian",
  "version": "1.0",
  "permissions": ["webRequest", "webRequestBlocking", "tabs"],
  "host_permissions": ["<all_urls>"],
  "background": {
    "service_worker": "background.js"
  }
}

// background.js
chrome.webRequest.onHeadersReceived.addListener(
  (details) => {
    const cspHeader = details.responseHeaders.find(
      h => h.name.toLowerCase() === 'content-security-policy'
    );

    if (cspHeader && cspHeader.value.includes('palimpsest-')) {
      // Parse Palimpsest policies
      const policies = parsePalimpsestCSP(cspHeader.value);

      // Display badge
      chrome.action.setBadgeText({
        text: policies['palimpsest-license'] || 'P',
        tabId: details.tabId
      });

      chrome.action.setBadgeBackgroundColor({
        color: policies['palimpsest-ni-consent'] === 'denied' ? '#FF0000' : '#4CAF50',
        tabId: details.tabId
      });

      // Store for popup display
      chrome.storage.local.set({
        [`license_${details.tabId}`]: policies
      });
    }

    return { responseHeaders: details.responseHeaders };
  },
  { urls: ["<all_urls>"] },
  ["responseHeaders"]
);

function parsePalimpsestCSP(csp) {
  const policies = {};
  csp.split(';').forEach(directive => {
    const [key, ...values] = directive.trim().split(/\s+/);
    if (key.startsWith('palimpsest-')) {
      policies[key] = values.join(' ');
    }
  });
  return policies;
}
```

## Testing and Validation

### CSP Validator Tool

```python
#!/usr/bin/env python3
# palimpsest-csp-validator.py

import requests
import sys

def validate_palimpsest_csp(url):
    """Validate Palimpsest CSP implementation."""
    try:
        response = requests.head(url, timeout=10)
        csp = response.headers.get('Content-Security-Policy', '')

        if not csp:
            print(f"❌ No CSP header found for {url}")
            return False

        print(f"✓ CSP header present")

        # Check for Palimpsest directives
        palimpsest_directives = [
            'palimpsest-license',
            'palimpsest-ni-consent',
            'palimpsest-metadata-preservation',
            'palimpsest-derivative-policy'
        ]

        found_directives = []
        for directive in palimpsest_directives:
            if directive in csp:
                found_directives.append(directive)
                print(f"✓ {directive} found")
            else:
                print(f"⚠️  {directive} not found")

        # Check reporting
        if 'report-uri' in csp or 'report-to' in csp:
            print("✓ Violation reporting configured")
        else:
            print("⚠️  No violation reporting configured")

        return len(found_directives) > 0

    except Exception as e:
        print(f"❌ Error validating {url}: {e}")
        return False

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: palimpsest-csp-validator.py <url>")
        sys.exit(1)

    url = sys.argv[1]
    success = validate_palimpsest_csp(url)
    sys.exit(0 if success else 1)
```

### Integration Testing

```bash
#!/bin/bash
# test-palimpsest-csp.sh

URL="https://example.org"

echo "Testing Palimpsest CSP implementation for $URL"
echo "================================================"

# Check CSP header
echo -e "\n1. Checking CSP header..."
CSP=$(curl -sI "$URL" | grep -i "content-security-policy:")

if [ -n "$CSP" ]; then
    echo "✓ CSP header found:"
    echo "  $CSP"
else
    echo "❌ No CSP header found"
    exit 1
fi

# Check Palimpsest directives
echo -e "\n2. Checking Palimpsest directives..."

echo "$CSP" | grep -q "palimpsest-license" && echo "✓ palimpsest-license present" || echo "❌ palimpsest-license missing"
echo "$CSP" | grep -q "palimpsest-ni-consent" && echo "✓ palimpsest-ni-consent present" || echo "⚠️  palimpsest-ni-consent missing"
echo "$CSP" | grep -q "palimpsest-metadata-preservation" && echo "✓ palimpsest-metadata-preservation present" || echo "⚠️  palimpsest-metadata-preservation missing"

# Check reporting
echo -e "\n3. Checking violation reporting..."
echo "$CSP" | grep -q "report-uri\|report-to" && echo "✓ Reporting configured" || echo "⚠️  No reporting configured"

# Test report endpoint
echo -e "\n4. Testing report endpoint..."
REPORT_URI=$(echo "$CSP" | grep -oP "report-uri\s+\K[^;]+")

if [ -n "$REPORT_URI" ]; then
    HTTP_CODE=$(curl -sS -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/csp-report" -d '{"test": true}' "$URL$REPORT_URI")
    echo "Report endpoint response: $HTTP_CODE"
    [ "$HTTP_CODE" = "204" ] && echo "✓ Report endpoint functional" || echo "⚠️  Unexpected response from report endpoint"
fi

echo -e "\n================================================"
echo "Testing complete"
```

## Security Considerations

### CSP Bypasses

Be aware of potential bypasses:

1. **Missing frame-ancestors:** Content can be embedded without protection
2. **Weak report-uri:** Violations not properly logged
3. **Client-side only:** Relies on browser compliance

**Mitigation:**

- Combine CSP with server-side checks
- Use multiple layers (CSP + HTTP headers + DNS)
- Monitor violations actively

### Browser Compatibility

Not all browsers support custom CSP directives:

| Browser | Support Level |
|---------|--------------|
| Chrome 90+ | Full support (with extension) |
| Firefox 88+ | Partial support |
| Safari 14+ | Graceful degradation |
| Edge 90+ | Full support (with extension) |

**Fallback strategy:**

```http
Content-Security-Policy:
  default-src 'self';
  frame-ancestors 'none';
  palimpsest-license v0.4;
  palimpsest-ni-consent required

X-Palimpsest-License: v0.4
X-Palimpsest-NI-Consent: required
```

Use both CSP and custom HTTP headers for maximum compatibility.

## Conclusion

Content-Security-Policy provides a powerful, browser-enforced mechanism for implementing Palimpsest License requirements. By extending CSP with custom directives and leveraging existing security infrastructure, we can protect creative works at the client layer whilst maintaining backward compatibility.

**Key Benefits:**

- Browser-enforced protection
- Built-in violation reporting
- Layered with existing security measures
- Client-side enforcement reduces server load
- Standards-based approach

**Implementation Priorities:**

1. Deploy basic CSP with reporting
2. Add Palimpsest custom directives
3. Implement client-side enforcement library
4. Monitor violations and adjust policies
5. Submit W3C proposal for standardisation

---

## References

- W3C Content Security Policy Level 3
- RFC 7469: Public Key Pinning Extension for HTTP
- OWASP CSP Cheat Sheet
- MDN Web Docs: Content-Security-Policy

## Contact

Questions and feedback:
- Palimpsest CSP Working Group
- Email: csp@palimpsest.example
- GitHub: github.com/palimpsest-license/csp

---

*This specification is part of the Palimpsest License infrastructure initiative. CSP implementation examples provided under Palimpsest License v0.4.*
