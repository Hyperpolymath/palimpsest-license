# Creative Works Consent Framework: Implementation Guide

**Version**: 1.0
**Date**: 2025-11-22
**Status**: Draft

## Table of Contents

1. [Introduction](#introduction)
2. [Quick Start](#quick-start)
3. [For Creators](#for-creators)
4. [For Developers](#for-developers)
5. [For AI System Operators](#for-ai-system-operators)
6. [For Platform Providers](#for-platform-providers)
7. [Advanced Topics](#advanced-topics)
8. [Testing and Validation](#testing-and-validation)
9. [Troubleshooting](#troubleshooting)
10. [Resources](#resources)

---

## 1. Introduction

### 1.1. What is CWCF?

The Creative Works Consent Framework (CWCF) is a web standard that enables creators to express machine-readable consent for AI and automated systems accessing their creative works. It provides:

* **Granular control**: Different permissions for different AI types
* **Machine-readable**: Automated verification by AI systems
* **Legally enforceable**: Integration with licensing frameworks
* **Flexible**: Individual or collective governance
* **Future-proof**: Extensible to emerging AI paradigms

### 1.2. Who Should Read This Guide?

* **Creators**: Authors, artists, musicians, journalists wanting to protect their work
* **Developers**: Web developers, CMS creators building consent support
* **AI operators**: Companies building AI systems that need consent verification
* **Platform providers**: Hosting services, CDNs implementing consent enforcement

### 1.3. Prerequisites

* Basic understanding of web technologies (HTML, HTTP)
* Familiarity with JSON (for developers)
* Understanding of creative works licensing (helpful but not required)

---

## 2. Quick Start

### 2.1. For Creators: 5-Minute Setup

**Step 1**: Create a consent declaration file

Create `/.well-known/creative-works-consent.json` on your website:

```json
{
  "@context": "https://palimpsestlicense.org/cwcf/v1",
  "@type": "CreativeWork",
  "name": "My Website Content",
  "author": {
    "@type": "Person",
    "name": "Your Name"
  },
  "consent": {
    "training": "deny",
    "generation": "deny",
    "analysis": "allow"
  }
}
```

**Step 2**: Add HTML meta tag

Add to your `<head>` section:

```html
<link rel="consent-declaration"
      href="/.well-known/creative-works-consent.json">
<meta name="ai-training" content="deny">
<meta name="ai-generation" content="deny">
```

**Step 3**: Test

Visit: `https://validator.palimpsestlicense.org/cwcf`

Enter your website URL and verify the declaration is valid.

**Done!** Your consent preferences are now machine-readable.

### 2.2. For Developers: Quick Integration

**Install validator library**:

```bash
npm install @cwcf/validator
```

**Verify consent before processing**:

```javascript
const { ConsentValidator } = require('@cwcf/validator');

async function checkConsent(url, aiType = 'llm') {
  const validator = new ConsentValidator();
  const consent = await validator.check(url, aiType);

  if (consent.status === 'deny') {
    throw new Error('Creator denies consent for AI training');
  }

  return consent;
}
```

---

## 3. For Creators

### 3.1. Understanding Consent Options

#### 3.1.1. Basic Consent Values

* **"deny"**: Explicitly prohibit this use
* **"allow"**: Explicitly permit this use
* **"conditional"**: Permit if requirements met (attribution, payment, etc.)
* **"unspecified"**: No explicit decision (may be treated as deny)

#### 3.1.2. Common Use Cases

Choose the right consent values for your use case:

```json
{
  "consent": {
    "training": "deny",      // No AI training
    "generation": "deny",    // No AI generation from my work
    "analysis": "allow",     // Allow analysis (e.g., sentiment)
    "indexing": "allow",     // Allow search engine indexing
    "agentic": "deny"        // No autonomous AI agents
  }
}
```

### 3.2. Setting Up Your Consent Declaration

#### 3.2.1. Basic Declaration

Minimal declaration for a personal website:

```json
{
  "@context": "https://palimpsestlicense.org/cwcf/v1",
  "@type": "CreativeWork",
  "@id": "https://yoursite.com",
  "name": "My Website",
  "author": {
    "@type": "Person",
    "name": "Your Name",
    "url": "https://yoursite.com/about"
  },
  "license": "https://creativecommons.org/licenses/by-nc-nd/4.0/",
  "consent": {
    "training": "deny",
    "generation": "deny"
  }
}
```

#### 3.2.2. Declaration with Attribution Requirements

Allow AI training if properly attributed:

```json
{
  "@context": "https://palimpsestlicense.org/cwcf/v1",
  "@type": "CreativeWork",
  "name": "My Articles",
  "author": {"@type": "Person", "name": "Jane Journalist"},
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "consent": {
    "training": "conditional",
    "generation": "conditional"
  },
  "aiTypes": {
    "llm": {
      "consent": "conditional",
      "requirements": ["attribution"]
    }
  },
  "lineage": {
    "required": true,
    "format": ["json-ld"],
    "minimumFields": ["sourceWork", "sourceAuthor", "sourceLicense"]
  },
  "attribution": {
    "method": "direct",
    "required": true,
    "format": {
      "human": "Jane Journalist, via YourSite.com"
    }
  }
}
```

#### 3.2.3. Cultural Heritage Protection

For culturally sensitive works:

```json
{
  "@context": "https://palimpsestlicense.org/cwcf/v1",
  "@type": "CreativeWork",
  "name": "Traditional Stories Collection",
  "author": {
    "@type": "Organization",
    "name": "Community Elders Council"
  },
  "consent": {
    "training": "deny",
    "generation": "deny",
    "analysis": "conditional"
  },
  "culturalHeritage": {
    "protected": true,
    "category": ["traditional-knowledge", "sacred"],
    "stewards": ["https://community.example.org/elders"],
    "protocols": ["https://community.example.org/protocols"]
  },
  "privacy": {
    "sensitiveContent": true,
    "category": ["cultural-heritage"],
    "minimumProtections": ["steward-approval"]
  }
}
```

### 3.3. Hosting Your Declaration

#### 3.3.1. Static Websites

Place file at: `/.well-known/creative-works-consent.json`

Configure web server to serve with correct headers:

```
Content-Type: application/json
Cache-Control: public, max-age=86400
Access-Control-Allow-Origin: *
```

#### 3.3.2. WordPress

Install the CWCF plugin:

1. Download: https://wordpress.org/plugins/cwcf-consent/
2. Activate plugin
3. Navigate to Settings → CWCF Consent
4. Configure consent preferences via UI
5. Plugin automatically serves declaration at well-known URI

#### 3.3.3. Static Site Generators

**Hugo** - Add to `static/.well-known/creative-works-consent.json`

**Jekyll** - Add to root directory with front matter:
```yaml
---
permalink: /.well-known/creative-works-consent.json
---
```

**Gatsby** - Add to `static/` directory

#### 3.3.4. Content Management Systems

Most modern CMSs support custom JSON endpoints. Check documentation for:

* Drupal: CWCF module
* Joomla: CWCF component
* Ghost: Custom integration code
* Webflow: Custom code embed

### 3.4. Adding HTML Metadata

Include in your HTML `<head>`:

```html
<!-- Link to consent declaration -->
<link rel="consent-declaration"
      href="/.well-known/creative-works-consent.json"
      type="application/creative-works-consent+json">

<!-- Quick reference meta tags -->
<meta name="ai-training" content="deny">
<meta name="ai-generation" content="deny">
<meta name="ai-analysis" content="allow">

<!-- Rights holder -->
<meta name="author" content="Your Name">
<meta name="license" content="https://creativecommons.org/licenses/by-nc-nd/4.0/">
```

### 3.5. Updating and Revoking Consent

#### 3.5.1. Updating Declarations

To update consent:

1. Edit your `creative-works-consent.json` file
2. Update version number (recommended):
   ```json
   {
     "version": "2.0",
     "dateModified": "2025-12-01"
   }
   ```
3. Clear CDN cache if applicable
4. Notify AI systems if possible (via registry)

#### 3.5.2. Revocation

To revoke previously granted consent:

```json
{
  "consent": {
    "training": "deny"  // Changed from "allow"
  },
  "revocation": {
    "date": "2025-12-01",
    "reason": "Retracting previous consent",
    "noticePeriod": "P30D",
    "contact": "mailto:creator@example.com"
  }
}
```

AI systems should honour revocations within the notice period and cease using the work for training new models.

---

## 4. For Developers

### 4.1. Server-Side Implementation

#### 4.1.1. Node.js / Express

```javascript
const express = require('express');
const app = express();

// Serve consent declaration
app.get('/.well-known/creative-works-consent.json', (req, res) => {
  res.setHeader('Content-Type', 'application/creative-works-consent+json');
  res.setHeader('Cache-Control', 'public, max-age=86400');
  res.setHeader('Access-Control-Allow-Origin', '*');

  res.json({
    "@context": "https://palimpsestlicense.org/cwcf/v1",
    "@type": "CreativeWork",
    "consent": {
      "training": "deny",
      "generation": "deny"
    }
  });
});

// Add HTTP headers to all responses
app.use((req, res, next) => {
  res.setHeader('Creative-Works-Consent', 'training=deny; generation=deny');
  res.setHeader('Link', '</.well-known/creative-works-consent.json>; rel="consent-declaration"');
  next();
});
```

#### 4.1.2. Python / Flask

```python
from flask import Flask, jsonify, make_response

app = Flask(__name__)

CONSENT_DECLARATION = {
    "@context": "https://palimpsestlicense.org/cwcf/v1",
    "@type": "CreativeWork",
    "consent": {
        "training": "deny",
        "generation": "deny"
    }
}

@app.route('/.well-known/creative-works-consent.json')
def consent_declaration():
    response = make_response(jsonify(CONSENT_DECLARATION))
    response.headers['Content-Type'] = 'application/creative-works-consent+json'
    response.headers['Cache-Control'] = 'public, max-age=86400'
    response.headers['Access-Control-Allow-Origin'] = '*'
    return response

@app.after_request
def add_consent_headers(response):
    response.headers['Creative-Works-Consent'] = 'training=deny; generation=deny'
    response.headers['Link'] = '</.well-known/creative-works-consent.json>; rel="consent-declaration"'
    return response
```

#### 4.1.3. Nginx Configuration

```nginx
location /.well-known/creative-works-consent.json {
    alias /var/www/consent.json;
    add_header Content-Type 'application/creative-works-consent+json';
    add_header Cache-Control 'public, max-age=86400';
    add_header Access-Control-Allow-Origin '*';
}

# Add headers to all responses
add_header Creative-Works-Consent 'training=deny; generation=deny' always;
add_header Link '</.well-known/creative-works-consent.json>; rel="consent-declaration"' always;
```

### 4.2. Client-Side JavaScript

#### 4.2.1. Fetching Consent Declarations

```javascript
class ConsentChecker {
  async fetchConsent(url) {
    const wellKnownUrl = new URL('/.well-known/creative-works-consent.json', url);

    try {
      const response = await fetch(wellKnownUrl.toString());
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const consent = await response.json();
      return this.parseConsent(consent);
    } catch (error) {
      console.error('Failed to fetch consent:', error);
      // Default to deny if declaration unavailable
      return { training: 'deny', generation: 'deny' };
    }
  }

  parseConsent(declaration) {
    return {
      training: declaration.consent?.training || 'deny',
      generation: declaration.consent?.generation || 'deny',
      analysis: declaration.consent?.analysis || 'unspecified',
      aiTypes: declaration.aiTypes || {}
    };
  }

  isAllowed(consent, operation, aiType = 'general') {
    // Check AI type-specific consent first
    if (consent.aiTypes[aiType]?.[operation]) {
      return consent.aiTypes[aiType][operation] === 'allow';
    }

    // Fall back to general consent
    return consent[operation] === 'allow';
  }
}

// Usage
const checker = new ConsentChecker();
const consent = await checker.fetchConsent('https://example.com');

if (checker.isAllowed(consent, 'training', 'llm')) {
  console.log('AI training permitted');
} else {
  console.log('AI training denied');
}
```

#### 4.2.2. Browser Extension Example

```javascript
// content-script.js
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.action === 'checkConsent') {
    checkPageConsent().then(sendResponse);
    return true; // Async response
  }
});

async function checkPageConsent() {
  // Check meta tags
  const metaTags = {
    training: document.querySelector('meta[name="ai-training"]')?.content,
    generation: document.querySelector('meta[name="ai-generation"]')?.content
  };

  // Check link relation
  const consentLink = document.querySelector('link[rel="consent-declaration"]');

  if (consentLink) {
    try {
      const response = await fetch(consentLink.href);
      const declaration = await response.json();
      return { source: 'declaration', consent: declaration.consent };
    } catch (e) {
      console.error('Failed to fetch consent declaration:', e);
    }
  }

  if (metaTags.training || metaTags.generation) {
    return { source: 'meta-tags', consent: metaTags };
  }

  return { source: 'none', consent: { training: 'unspecified' } };
}

// Display consent badge
async function displayConsentBadge() {
  const consent = await checkPageConsent();
  const badge = document.createElement('div');
  badge.className = 'cwcf-badge';

  if (consent.consent.training === 'deny') {
    badge.innerHTML = '🛡️ AI Training: Denied';
    badge.className += ' cwcf-deny';
  } else if (consent.consent.training === 'allow') {
    badge.innerHTML = '✅ AI Training: Allowed';
    badge.className += ' cwcf-allow';
  }

  document.body.appendChild(badge);
}
```

### 4.3. Validation and Testing

#### 4.3.1. JSON Schema Validation

```javascript
const Ajv = require('ajv');
const ajv = new Ajv();

const consentSchema = {
  type: 'object',
  required: ['@context', '@type', 'consent'],
  properties: {
    '@context': { type: 'string' },
    '@type': { type: 'string', enum: ['CreativeWork'] },
    consent: {
      type: 'object',
      properties: {
        training: { enum: ['allow', 'deny', 'conditional', 'unspecified'] },
        generation: { enum: ['allow', 'deny', 'conditional', 'unspecified'] },
        analysis: { enum: ['allow', 'deny', 'conditional', 'unspecified'] }
      }
    }
  }
};

const validate = ajv.compile(consentSchema);

function validateConsent(declaration) {
  const valid = validate(declaration);
  if (!valid) {
    console.error('Validation errors:', validate.errors);
    return false;
  }
  return true;
}
```

#### 4.3.2. Integration Tests

```javascript
const { test } = require('@jest/globals');
const fetch = require('node-fetch');

test('Consent declaration is accessible', async () => {
  const response = await fetch('https://example.com/.well-known/creative-works-consent.json');
  expect(response.status).toBe(200);
  expect(response.headers.get('content-type')).toContain('json');
});

test('Consent declaration is valid JSON-LD', async () => {
  const response = await fetch('https://example.com/.well-known/creative-works-consent.json');
  const declaration = await response.json();

  expect(declaration).toHaveProperty('@context');
  expect(declaration).toHaveProperty('@type');
  expect(declaration).toHaveProperty('consent');
});

test('Training consent is denied', async () => {
  const response = await fetch('https://example.com/.well-known/creative-works-consent.json');
  const declaration = await response.json();

  expect(declaration.consent.training).toBe('deny');
});
```

---

## 5. For AI System Operators

### 5.1. Consent Verification Workflow

```
┌─────────────────┐
│  Discover URL   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Fetch Consent   │
│   Declaration   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Parse & Validate│
└────────┬────────┘
         │
         ▼
    ┌────┴────┐
    │ Consent?│
    └────┬────┘
         │
    ┌────┴──────┐
    │           │
    ▼           ▼
┌─────┐    ┌────────┐
│ALLOW│    │ DENY / │
│     │    │CONDITI-│
│     │    │  ONAL  │
└──┬──┘    └───┬────┘
   │           │
   ▼           ▼
┌──────┐   ┌───────────┐
│Process│   │  Skip /   │
│Content│   │Check Reqs │
└──────┘   └───────────┘
```

### 5.2. Bulk Verification for Training Datasets

When processing large datasets:

```python
import asyncio
import aiohttp
from typing import List, Dict

class ConsentVerifier:
    def __init__(self, cache_size=10000):
        self.cache = {}
        self.session = None

    async def verify_url(self, url: str, ai_type: str = 'llm') -> Dict:
        """Verify consent for a single URL."""
        if url in self.cache:
            return self.cache[url]

        consent_url = f"{url}/.well-known/creative-works-consent.json"

        try:
            async with self.session.get(consent_url, timeout=5) as response:
                if response.status == 200:
                    declaration = await response.json()
                    consent = self.parse_consent(declaration, ai_type)
                else:
                    # Default to deny if no declaration
                    consent = {'status': 'deny', 'reason': 'no_declaration'}
        except Exception as e:
            consent = {'status': 'deny', 'reason': 'fetch_error', 'error': str(e)}

        self.cache[url] = consent
        return consent

    def parse_consent(self, declaration: Dict, ai_type: str) -> Dict:
        """Parse consent declaration for specific AI type."""
        # Check AI type-specific consent
        if ai_type in declaration.get('aiTypes', {}):
            ai_consent = declaration['aiTypes'][ai_type]['consent']
            requirements = declaration['aiTypes'][ai_type].get('requirements', [])
        else:
            ai_consent = declaration.get('consent', {}).get('training', 'deny')
            requirements = []

        return {
            'status': ai_consent,
            'requirements': requirements,
            'lineage': declaration.get('lineage', {}),
            'attribution': declaration.get('attribution', {})
        }

    async def verify_batch(self, urls: List[str], ai_type: str = 'llm') -> List[Dict]:
        """Verify consent for a batch of URLs."""
        self.session = aiohttp.ClientSession()
        try:
            tasks = [self.verify_url(url, ai_type) for url in urls]
            results = await asyncio.gather(*tasks)
            return list(zip(urls, results))
        finally:
            await self.session.close()

# Usage
async def main():
    verifier = ConsentVerifier()
    urls = [
        'https://example1.com',
        'https://example2.com',
        'https://example3.com'
    ]

    results = await verifier.verify_batch(urls, ai_type='llm')

    allowed = [url for url, consent in results if consent['status'] == 'allow']
    denied = [url for url, consent in results if consent['status'] == 'deny']
    conditional = [url for url, consent in results if consent['status'] == 'conditional']

    print(f"Allowed: {len(allowed)}")
    print(f"Denied: {len(denied)}")
    print(f"Conditional: {len(conditional)}")

asyncio.run(main())
```

### 5.3. Embedding Lineage Tags in Outputs

When generating synthetic outputs:

```python
import json
from datetime import datetime

class LineageGenerator:
    def __init__(self, ai_system_name: str, ai_system_version: str):
        self.system_name = ai_system_name
        self.system_version = ai_system_version

    def generate_lineage_tag(self, source_works: List[Dict], output_id: str) -> Dict:
        """Generate JSON-LD lineage tag for synthetic output."""
        return {
            "@context": "https://palimpsestlicense.org/cwcf/v1",
            "@type": "SyntheticOutput",
            "@id": output_id,
            "dateGenerated": datetime.utcnow().isoformat() + 'Z',
            "generatedBy": {
                "@type": "AISystem",
                "name": self.system_name,
                "version": self.system_version
            },
            "derivedFrom": [
                {
                    "@type": "CreativeWork",
                    "@id": work['url'],
                    "name": work['title'],
                    "author": work['author'],
                    "license": work['license'],
                    "consent": work['consent']
                }
                for work in source_works
            ]
        }

    def embed_in_output(self, output_text: str, lineage: Dict) -> str:
        """Embed lineage tag in output text."""
        lineage_json = json.dumps(lineage, indent=2)

        # Embed as JSON-LD in markdown
        return f"""
{output_text}

---

<script type="application/ld+json">
{lineage_json}
</script>
"""

# Usage
generator = LineageGenerator('MyAI', 'v1.0')

source_works = [
    {
        'url': 'https://example.com/article',
        'title': 'Original Article',
        'author': 'Jane Author',
        'license': 'CC-BY-4.0',
        'consent': {'training': 'conditional', 'requirements': ['attribution']}
    }
]

lineage = generator.generate_lineage_tag(source_works, 'https://ai.example.com/output/12345')
output_with_lineage = generator.embed_in_output('Generated text here...', lineage)
```

### 5.4. Compliance Reporting

```python
from collections import defaultdict
from datetime import datetime
import json

class ComplianceReporter:
    def __init__(self):
        self.stats = defaultdict(int)
        self.violations = []

    def record_check(self, url: str, consent: Dict, action_taken: str):
        """Record a consent check."""
        self.stats['total_checks'] += 1
        self.stats[f"consent_{consent['status']}"] += 1
        self.stats[f"action_{action_taken}"] += 1

        if action_taken == 'violated':
            self.violations.append({
                'url': url,
                'consent': consent,
                'timestamp': datetime.utcnow().isoformat()
            })

    def generate_report(self) -> Dict:
        """Generate compliance report."""
        return {
            'reportDate': datetime.utcnow().isoformat() + 'Z',
            'statistics': dict(self.stats),
            'complianceRate': (
                (self.stats['action_complied'] / self.stats['total_checks'] * 100)
                if self.stats['total_checks'] > 0 else 0
            ),
            'violations': self.violations
        }

    def export_report(self, filename: str):
        """Export report to JSON file."""
        with open(filename, 'w') as f:
            json.dump(self.generate_report(), f, indent=2)

# Usage
reporter = ComplianceReporter()

# During training
for url, content in training_data:
    consent = await verify_consent(url)

    if consent['status'] == 'deny':
        reporter.record_check(url, consent, 'complied')
        continue  # Skip this content
    elif consent['status'] == 'allow':
        reporter.record_check(url, consent, 'complied')
        # Process content
    elif consent['status'] == 'conditional':
        if check_requirements_met(consent['requirements']):
            reporter.record_check(url, consent, 'complied')
            # Process with requirements
        else:
            reporter.record_check(url, consent, 'skipped')
            continue

# Generate quarterly report
reporter.export_report('compliance-report-q4-2025.json')
```

---

## 6. For Platform Providers

### 6.1. CDN Integration

#### 6.1.1. Cloudflare Workers

```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const url = new URL(request.url)

  // Serve consent declaration
  if (url.pathname === '/.well-known/creative-works-consent.json') {
    const consentDeclaration = {
      "@context": "https://palimpsestlicense.org/cwcf/v1",
      "@type": "CreativeWork",
      "consent": {
        "training": "deny",
        "generation": "deny"
      }
    }

    return new Response(JSON.stringify(consentDeclaration), {
      headers: {
        'Content-Type': 'application/creative-works-consent+json',
        'Cache-Control': 'public, max-age=86400',
        'Access-Control-Allow-Origin': '*'
      }
    })
  }

  // Fetch from origin
  const response = await fetch(request)

  // Add consent headers to all responses
  const newResponse = new Response(response.body, response)
  newResponse.headers.set('Creative-Works-Consent', 'training=deny; generation=deny')
  newResponse.headers.set('Link', '</.well-known/creative-works-consent.json>; rel="consent-declaration"')

  return newResponse
}
```

#### 6.1.2. AWS CloudFront

Lambda@Edge function:

```javascript
exports.handler = async (event) => {
    const request = event.Records[0].cf.request;
    const response = event.Records[0].cf.response;

    // Add consent headers
    response.headers['creative-works-consent'] = [{
        key: 'Creative-Works-Consent',
        value: 'training=deny; generation=deny'
    }];

    response.headers['link'] = [{
        key: 'Link',
        value: '</.well-known/creative-works-consent.json>; rel="consent-declaration"'
    }];

    return response;
};
```

### 6.2. Hosting Platform Integration

#### 6.2.1. Netlify

Add to `netlify.toml`:

```toml
[[headers]]
  for = "/*"
  [headers.values]
    Creative-Works-Consent = "training=deny; generation=deny"
    Link = '''</.well-known/creative-works-consent.json>; rel="consent-declaration"'''

[[redirects]]
  from = "/.well-known/creative-works-consent.json"
  to = "/consent-declaration.json"
  status = 200
```

#### 6.2.2. Vercel

Add `vercel.json`:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Creative-Works-Consent",
          "value": "training=deny; generation=deny"
        },
        {
          "key": "Link",
          "value": "</.well-known/creative-works-consent.json>; rel=\"consent-declaration\""
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/.well-known/creative-works-consent.json",
      "destination": "/api/consent"
    }
  ]
}
```

---

## 7. Advanced Topics

### 7.1. Collective Governance with DAOs

```javascript
// Ethereum smart contract integration
const Web3 = require('web3');
const web3 = new Web3('https://mainnet.infura.io/v3/YOUR_KEY');

class DAOConsentManager {
  constructor(contractAddress, contractABI) {
    this.contract = new web3.eth.Contract(contractABI, contractAddress);
  }

  async requestConsent(workId, aiType, requester) {
    // Submit consent request to DAO
    const proposal = await this.contract.methods.proposeConsent(
      workId,
      aiType,
      requester
    ).send({ from: requester });

    return proposal.events.ProposalCreated.returnValues.proposalId;
  }

  async checkConsentStatus(proposalId) {
    const proposal = await this.contract.methods.getProposal(proposalId).call();

    return {
      approved: proposal.approved,
      votesFor: proposal.votesFor,
      votesAgainst: proposal.votesAgainst,
      deadline: new Date(proposal.deadline * 1000)
    };
  }

  async generateConsentDeclaration(workId) {
    const consent = await this.contract.methods.getWorkConsent(workId).call();

    return {
      "@context": "https://palimpsestlicense.org/cwcf/v1",
      "@type": "CreativeWork",
      "@id": workId,
      "governance": {
        "type": "dao",
        "body": this.contract.options.address,
        "approvalRequired": true,
        "blockchain": "ethereum"
      },
      "consent": {
        "training": consent.training ? "allow" : "deny",
        "generation": consent.generation ? "allow" : "deny"
      }
    };
  }
}
```

### 7.2. Cryptographic Signatures

```javascript
const jose = require('jose');
const fs = require('fs');

async function signConsentDeclaration(declaration, privateKey) {
  const jws = await new jose.CompactSign(
    new TextEncoder().encode(JSON.stringify(declaration))
  )
    .setProtectedHeader({ alg: 'ES256' })
    .sign(privateKey);

  return jws;
}

async function verifyConsentDeclaration(jws, publicKey) {
  const { payload } = await jose.compactVerify(jws, publicKey);
  return JSON.parse(new TextDecoder().decode(payload));
}

// Usage
const { publicKey, privateKey } = await jose.generateKeyPair('ES256');

const declaration = {
  "@context": "https://palimpsestlicense.org/cwcf/v1",
  "@type": "CreativeWork",
  "consent": { "training": "deny" }
};

const signed = await signConsentDeclaration(declaration, privateKey);
const verified = await verifyConsentDeclaration(signed, publicKey);
```

### 7.3. Quantum-Proof Lineage

```python
from hashlib import sha256, sha512
import json

class QuantumProofLineage:
    """Generate quantum-resistant lineage tags using hash chains."""

    def __init__(self):
        self.hash_algorithm = sha512  # Quantum-resistant

    def generate_lineage_hash(self, work_data: Dict) -> str:
        """Generate quantum-proof hash for work."""
        canonical = json.dumps(work_data, sort_keys=True)
        return self.hash_algorithm(canonical.encode()).hexdigest()

    def create_lineage_chain(self, source_works: List[Dict], output: Dict) -> Dict:
        """Create hash chain linking output to source works."""
        source_hashes = [
            {
                'work_id': work['id'],
                'hash': self.generate_lineage_hash(work),
                'algorithm': 'SHA-512'
            }
            for work in source_works
        ]

        # Chain hash: hash of all source hashes + output
        chain_input = ''.join([h['hash'] for h in source_hashes])
        chain_input += json.dumps(output, sort_keys=True)
        chain_hash = self.hash_algorithm(chain_input.encode()).hexdigest()

        return {
            '@type': 'QuantumProofLineage',
            'algorithm': 'SHA-512',
            'sourceHashes': source_hashes,
            'chainHash': chain_hash,
            'timestamp': output['timestamp']
        }

    def verify_lineage(self, lineage: Dict, source_works: List[Dict], output: Dict) -> bool:
        """Verify quantum-proof lineage chain."""
        # Regenerate source hashes
        regenerated = self.create_lineage_chain(source_works, output)

        return regenerated['chainHash'] == lineage['chainHash']
```

---

## 8. Testing and Validation

### 8.1. Online Validators

* **Official Validator**: https://validator.palimpsestlicense.org/cwcf
* **JSON-LD Playground**: https://json-ld.org/playground/
* **Schema Validator**: https://www.jsonschemavalidator.net/

### 8.2. CLI Validation Tool

```bash
npm install -g @cwcf/validator

# Validate a consent declaration
cwcf-validate https://example.com

# Validate a local file
cwcf-validate ./consent.json

# Check specific AI type
cwcf-validate https://example.com --ai-type llm

# Generate sample declaration
cwcf-generate --output consent.json
```

### 8.3. Browser Extensions

* **CWCF Checker**: Chrome/Firefox extension displaying consent status
* **Creator Shield**: Shows consent badges on webpages
* **AI Training Monitor**: Alerts when visiting sites that allow/deny AI training

---

## 9. Troubleshooting

### 9.1. Common Issues

#### 9.1.1. 404 Not Found on Well-Known URI

**Problem**: `/.well-known/creative-works-consent.json` returns 404

**Solutions**:
* Verify file is in correct location
* Check web server configuration allows `.well-known` directory
* Ensure no URL rewriting conflicts
* Test with `curl https://yoursite.com/.well-known/creative-works-consent.json`

#### 9.1.2. CORS Errors

**Problem**: Browser console shows CORS error when fetching declaration

**Solution**: Add CORS headers:
```
Access-Control-Allow-Origin: *
Access-Control-Allow-Methods: GET, OPTIONS
Access-Control-Allow-Headers: Content-Type
```

#### 9.1.3. Invalid JSON-LD

**Problem**: Validator reports invalid JSON-LD

**Solutions**:
* Validate JSON syntax at jsonlint.com
* Check `@context` URL is correct
* Ensure all required fields present (`@type`, `consent`)
* Verify enum values match specification

#### 9.1.4. Caching Issues

**Problem**: Changes to consent declaration not appearing

**Solutions**:
* Clear CDN cache
* Check `Cache-Control` headers
* Use cache-busting query parameters for testing
* Verify no browser extension caching

---

## 10. Resources

### 10.1. Specifications

* **IRTF Draft**: https://datatracker.ietf.org/doc/draft-creative-works-consent/
* **W3C CG Charter**: https://www.w3.org/community/creative-works-consent/
* **JSON-LD Context**: https://palimpsestlicense.org/cwcf/v1/context.jsonld
* **JSON Schema**: https://palimpsestlicense.org/cwcf/v1/schema.json

### 10.2. Tools and Libraries

* **JavaScript**: `npm install @cwcf/validator`
* **Python**: `pip install cwcf-validator`
* **Rust**: `cargo add cwcf-validator`
* **WordPress Plugin**: https://wordpress.org/plugins/cwcf-consent/
* **Browser Extension**: https://chrome.google.com/webstore/ (search CWCF)

### 10.3. Community

* **Mailing List**: public-cwcf@w3.org
* **GitHub**: https://github.com/w3c/creative-works-consent
* **Forum**: https://discuss.palimpsestlicense.org/
* **Chat**: IRC #cwcf on irc.w3.org

### 10.4. Support

* **Documentation**: https://palimpsestlicense.org/cwcf/docs/
* **FAQ**: https://palimpsestlicense.org/cwcf/faq/
* **Issue Tracker**: https://github.com/w3c/creative-works-consent/issues
* **Email**: support@palimpsestlicense.org

---

**Document Version**: 1.0
**Last Updated**: 2025-11-22
**License**: CC-BY 4.0
