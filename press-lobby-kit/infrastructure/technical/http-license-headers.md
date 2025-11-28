# HTTP Headers for License Declaration
## Technical Advisory Document

**Version:** 1.0
**Date:** 2025-11-22
**Status:** Draft for Discussion
**Audience:** Web Developers, System Administrators, CDN Operators, Proxy Administrators

---

## Executive Summary

This document specifies custom HTTP headers for declaring and propagating Palimpsest License metadata across web infrastructure. By implementing standardised license headers, content providers can ensure licensing requirements persist through the entire HTTP request-response cycle, from origin server through CDNs, proxies, and caches to end clients.

## Background

### Why HTTP Headers for Licensing?

HTTP headers provide:

- **Universal compatibility:** Supported by all web infrastructure
- **Request-response symmetry:** Both clients and servers can signal licensing
- **Middleware processing:** Proxies and CDNs can enforce policies
- **Easy implementation:** Simple to add to existing systems
- **Debugging capability:** Visible in developer tools and logs

### Design Principles

1. **Non-invasive:** Don't interfere with existing headers
2. **Namespaced:** Use `X-Palimpsest-` prefix (or `Palimpsest-` when standardised)
3. **Structured:** Machine-readable and parseable
4. **Extensible:** Support future license versions and features
5. **Cacheable:** Work with HTTP caching mechanisms

## Header Specifications

### Core Headers

#### 1. `X-Palimpsest-License`

**Purpose:** Declares the license version governing the content.

**Syntax:**
```http
X-Palimpsest-License: <version>
```

**Examples:**
```http
X-Palimpsest-License: v0.4
X-Palimpsest-License: v0.3
```

**Usage:**
- MUST be present on all Palimpsest-licensed content
- SHOULD be included in both request and response
- MUST be preserved through caching and proxying

#### 2. `X-Palimpsest-NI-Consent`

**Purpose:** Declares non-interpretive AI consent status.

**Syntax:**
```http
X-Palimpsest-NI-Consent: required | granted | denied
```

**Values:**
- `required`: Explicit consent must be obtained before AI processing
- `granted`: Consent has been granted (with conditions)
- `denied`: Absolute prohibition on AI interpretation

**Examples:**
```http
X-Palimpsest-NI-Consent: required
X-Palimpsest-NI-Consent: denied
```

**Usage:**
- Proxies SHOULD block known AI scrapers when value is `denied` or `required`
- CDNs SHOULD log AI access attempts for compliance auditing
- Clients SHOULD respect this header when processing content

#### 3. `X-Palimpsest-Metadata-URL`

**Purpose:** Points to the full license metadata document.

**Syntax:**
```http
X-Palimpsest-Metadata-URL: <absolute-uri>
```

**Examples:**
```http
X-Palimpsest-Metadata-URL: https://example.org/.well-known/license
X-Palimpsest-Metadata-URL: https://example.org/licenses/work-12345.json
```

**Usage:**
- MUST be an absolute URI (RFC 3986)
- SHOULD point to JSON-LD document
- MAY include content hash parameter for integrity verification

#### 4. `X-Palimpsest-Attribution`

**Purpose:** Specifies creator attribution requirements.

**Syntax:**
```http
X-Palimpsest-Attribution: <type>; creator="<name>"; uri="<url>"
```

**Types:**
- `required`: Standard attribution (name, link)
- `symbolic`: Emotional/cultural context required
- `lineage`: Full derivation chain required

**Examples:**
```http
X-Palimpsest-Attribution: required; creator="Jane Doe"; uri="https://example.org/creator/jane-doe"
X-Palimpsest-Attribution: symbolic; creator="Survivors of X"; uri="https://example.org/lineage/xyz"
X-Palimpsest-Attribution: lineage; creator="Original Work"; uri="https://example.org/lineage/trace"
```

#### 5. `X-Palimpsest-Derivative-Policy`

**Purpose:** Controls creation of derivative works.

**Syntax:**
```http
X-Palimpsest-Derivative-Policy: unrestricted | restricted | prohibited
```

**Values:**
- `unrestricted`: Allow derivatives with attribution
- `restricted`: Allow only specified transformations
- `prohibited`: No derivatives permitted

**Examples:**
```http
X-Palimpsest-Derivative-Policy: restricted; allowed="translation,commentary"
X-Palimpsest-Derivative-Policy: prohibited
```

#### 6. `X-Palimpsest-Content-Hash`

**Purpose:** Cryptographic hash for content integrity and traceability.

**Syntax:**
```http
X-Palimpsest-Content-Hash: <algorithm>=<hash-value>
```

**Algorithms:**
- `sha3-512`: SHA-3 with 512-bit output
- `blake3`: BLAKE3 (quantum-resistant)
- `sha256`: SHA-256 (legacy support)

**Examples:**
```http
X-Palimpsest-Content-Hash: sha3-512=3a5f9c2b4d8e1a7f3b6c9d2e5f8a1b4c7d0e3f6a9b2c5d8e1f4a7b0c3d6e9f2a5b8c1d4e7f0a3b6c9d2e5f8a1b4c
X-Palimpsest-Content-Hash: blake3=abc123def456...
```

**Usage:**
- SHOULD be calculated on complete response body
- MUST be recalculated if content is modified
- MAY be used for integrity verification and content tracking

#### 7. `X-Palimpsest-Lineage-ID`

**Purpose:** Unique identifier for emotional lineage tracking.

**Syntax:**
```http
X-Palimpsest-Lineage-ID: <uuid> | <urn>
```

**Examples:**
```http
X-Palimpsest-Lineage-ID: urn:uuid:550e8400-e29b-41d4-a716-446655440000
X-Palimpsest-Lineage-ID: lineage:protest-song:we-shall-overcome
```

**Usage:**
- MUST be globally unique
- SHOULD use UUID format (RFC 4122)
- MAY use semantic URN for cultural significance

#### 8. `X-Palimpsest-DAO-Contract`

**Purpose:** Ethereum contract address for DAO governance.

**Syntax:**
```http
X-Palimpsest-DAO-Contract: <ethereum-address> | <blockchain>:<address>
```

**Examples:**
```http
X-Palimpsest-DAO-Contract: 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1
X-Palimpsest-DAO-Contract: ethereum:0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1
X-Palimpsest-DAO-Contract: polygon:0xabcdef...
```

#### 9. `X-Palimpsest-Expires`

**Purpose:** License expiry or renewal date (for temporal licensing).

**Syntax:**
```http
X-Palimpsest-Expires: <http-date>
```

**Examples:**
```http
X-Palimpsest-Expires: Wed, 21 Oct 2026 07:28:00 GMT
X-Palimpsest-Expires: never
```

**Usage:**
- Uses HTTP-date format (RFC 7231)
- Value `never` indicates perpetual licensing
- Caches SHOULD revalidate after expiry

#### 10. `X-Palimpsest-Trace-ID`

**Purpose:** Request tracing for compliance auditing.

**Syntax:**
```http
X-Palimpsest-Trace-ID: <trace-id>
```

**Examples:**
```http
X-Palimpsest-Trace-ID: 550e8400-e29b-41d4-a716-446655440000
```

**Usage:**
- Generated per request
- Logged throughout infrastructure
- Enables end-to-end compliance tracking

### Composite Header

For efficiency, all Palimpsest metadata can be combined:

#### `X-Palimpsest-License-Info`

**Syntax:**
```http
X-Palimpsest-License-Info: <key>=<value>; <key>=<value>; ...
```

**Example:**
```http
X-Palimpsest-License-Info: version=v0.4; ni-consent=required; metadata-url="https://example.org/.well-known/license"; derivative-policy=prohibited; attribution=required
```

**Usage:**
- Single header containing all license metadata
- Reduces header overhead
- Easier for middleware to parse

## Request Headers

### Client-Side License Negotiation

Clients can signal license awareness:

#### `X-Palimpsest-Client-Capabilities`

**Syntax:**
```http
X-Palimpsest-Client-Capabilities: <capability>[,<capability>...]
```

**Capabilities:**
- `metadata-preservation`: Client preserves metadata
- `attribution-display`: Client displays attribution
- `ni-consent-aware`: Client respects NI consent
- `lineage-tracking`: Client tracks emotional lineage

**Example:**
```http
X-Palimpsest-Client-Capabilities: metadata-preservation,attribution-display,ni-consent-aware
```

#### `X-Palimpsest-Client-Purpose`

**Purpose:** Declares intended use of content.

**Syntax:**
```http
X-Palimpsest-Client-Purpose: <purpose>
```

**Values:**
- `human-reading`: Direct human consumption
- `archival`: Long-term preservation
- `ai-training`: Training AI models (requires consent)
- `ai-inference`: AI interpretation (requires consent)
- `derivative-creation`: Creating derivative works
- `analysis`: Research/analysis

**Examples:**
```http
X-Palimpsest-Client-Purpose: human-reading
X-Palimpsest-Client-Purpose: ai-training
```

**Usage:**
- Server MAY deny requests based on purpose
- Useful for audit logs and compliance
- Enables purpose-based access control

## Implementation Examples

### Server-Side Implementation

#### Apache

```apache
# .htaccess or httpd.conf

<IfModule mod_headers.c>
    # Basic license headers for all content
    Header set X-Palimpsest-License "v0.4"
    Header set X-Palimpsest-NI-Consent "required"
    Header set X-Palimpsest-Metadata-URL "https://example.org/.well-known/license"

    # Conditional headers based on content type
    <FilesMatch "\.(html|htm)$">
        Header set X-Palimpsest-Attribution "required; creator=\"Jane Doe\"; uri=\"https://example.org/creator/jane\""
        Header set X-Palimpsest-Derivative-Policy "restricted"
    </FilesMatch>

    <FilesMatch "\.(jpg|jpeg|png|gif)$">
        Header set X-Palimpsest-Derivative-Policy "prohibited"
        Header set X-Palimpsest-NI-Consent "denied"
    </FilesMatch>

    # Generate content hash (requires mod_ssl)
    # Header set X-Palimpsest-Content-Hash "sha256=%{SSL_SERVER_CERT_SHA256}e"

    # Preserve headers through proxies
    Header merge Cache-Control "must-revalidate"
</IfModule>

# Block AI scrapers for NI-protected content
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteCond %{HTTP_USER_AGENT} (GPTBot|ChatGPT|CCBot|ClaudeBot|Bard|Gemini) [NC]
    RewriteRule .* - [F,L]
</IfModule>
```

#### Nginx

```nginx
# nginx.conf or site configuration

server {
    listen 443 ssl http2;
    server_name example.org;

    # Basic license headers
    add_header X-Palimpsest-License "v0.4" always;
    add_header X-Palimpsest-NI-Consent "required" always;
    add_header X-Palimpsest-Metadata-URL "https://example.org/.well-known/license" always;

    # Generate trace ID
    add_header X-Palimpsest-Trace-ID $request_id always;

    # Location-specific headers
    location /creative/ {
        add_header X-Palimpsest-License "v0.4" always;
        add_header X-Palimpsest-NI-Consent "denied" always;
        add_header X-Palimpsest-Derivative-Policy "prohibited" always;
        add_header X-Palimpsest-Attribution "required; creator=\"Artist Name\"; uri=\"https://example.org/artist\"" always;

        # Block AI scrapers
        if ($http_user_agent ~* "(GPTBot|ChatGPT|CCBot|ClaudeBot)") {
            return 403 "NI consent required";
        }
    }

    # Content hash generation (Lua module)
    location /hashed-content/ {
        add_header X-Palimpsest-License "v0.4" always;

        body_filter_by_lua_block {
            local resty_sha256 = require "resty.sha256"
            local sha256 = resty_sha256:new()

            local chunk, eof = ngx.arg[1], ngx.arg[2]
            if chunk then
                sha256:update(chunk)
            end
            if eof then
                local digest = sha256:final()
                ngx.header["X-Palimpsest-Content-Hash"] = "sha256=" .. digest
            end
        }
    }
}
```

#### Node.js / Express

```javascript
const express = require('express');
const crypto = require('crypto');

const app = express();

// Middleware: Add Palimpsest license headers
function palimpsestHeaders(options = {}) {
  return (req, res, next) => {
    const {
      version = 'v0.4',
      niConsent = 'required',
      metadataUrl = '/.well-known/license',
      attribution = null,
      derivativePolicy = 'restricted',
      daoContract = null
    } = options;

    // Basic headers
    res.setHeader('X-Palimpsest-License', version);
    res.setHeader('X-Palimpsest-NI-Consent', niConsent);
    res.setHeader('X-Palimpsest-Metadata-URL', `${req.protocol}://${req.get('host')}${metadataUrl}`);

    // Optional headers
    if (attribution) {
      res.setHeader('X-Palimpsest-Attribution', attribution);
    }

    if (derivativePolicy) {
      res.setHeader('X-Palimpsest-Derivative-Policy', derivativePolicy);
    }

    if (daoContract) {
      res.setHeader('X-Palimpsest-DAO-Contract', daoContract);
    }

    // Generate trace ID
    const traceId = crypto.randomUUID();
    res.setHeader('X-Palimpsest-Trace-ID', traceId);

    // Log request with trace ID
    console.log(`[${traceId}] ${req.method} ${req.url} - License: ${version}`);

    // Check client purpose
    const clientPurpose = req.get('X-Palimpsest-Client-Purpose');
    if (clientPurpose === 'ai-training' && niConsent === 'denied') {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'AI training not permitted for this content',
        license: version,
        'ni-consent': niConsent
      });
    }

    next();
  };
}

// Middleware: Block AI scrapers
function blockAIScrapers(req, res, next) {
  const userAgent = req.get('user-agent') || '';
  const aiScrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot', 'Bard', 'Gemini'];

  if (aiScrapers.some(bot => userAgent.includes(bot))) {
    const niConsent = res.get('X-Palimpsest-NI-Consent');

    if (niConsent === 'denied' || niConsent === 'required') {
      return res.status(403).send('403 Forbidden: Non-interpretive consent required');
    }
  }

  next();
}

// Middleware: Add content hash
function addContentHash(req, res, next) {
  const originalSend = res.send;

  res.send = function(body) {
    if (body) {
      const hash = crypto.createHash('sha3-512').update(body).digest('hex');
      res.setHeader('X-Palimpsest-Content-Hash', `sha3-512=${hash}`);
    }

    originalSend.call(this, body);
  };

  next();
}

// Apply middleware
app.use(palimpsestHeaders({
  version: 'v0.4',
  niConsent: 'required',
  attribution: 'required; creator="Example Creator"; uri="https://example.org/creator"'
}));

app.use(blockAIScrapers);
app.use(addContentHash);

// Routes
app.get('/', (req, res) => {
  res.send('<h1>Palimpsest-licensed content</h1>');
});

app.get('/creative/:id', (req, res) => {
  // Stricter policy for creative works
  res.setHeader('X-Palimpsest-NI-Consent', 'denied');
  res.setHeader('X-Palimpsest-Derivative-Policy', 'prohibited');

  res.send(`<h1>Creative Work ${req.params.id}</h1>`);
});

app.listen(3000, () => console.log('Server running on port 3000'));
```

#### Python / Django

```python
# middleware.py

import uuid
import hashlib
from django.utils.deprecation import MiddlewareMixin

class PalimpsestHeadersMiddleware(MiddlewareMixin):
    """Add Palimpsest license headers to all responses."""

    def __init__(self, get_response):
        super().__init__(get_response)
        self.get_response = get_response

    def process_response(self, request, response):
        # Basic headers
        response['X-Palimpsest-License'] = 'v0.4'
        response['X-Palimpsest-NI-Consent'] = 'required'
        response['X-Palimpsest-Metadata-URL'] = f"{request.scheme}://{request.get_host()}/.well-known/license"

        # Generate trace ID
        trace_id = str(uuid.uuid4())
        response['X-Palimpsest-Trace-ID'] = trace_id

        # Path-specific headers
        if request.path.startswith('/creative/'):
            response['X-Palimpsest-NI-Consent'] = 'denied'
            response['X-Palimpsest-Derivative-Policy'] = 'prohibited'

        # Content hash (for cacheable responses)
        if hasattr(response, 'content') and response.status_code == 200:
            content_hash = hashlib.sha3_512(response.content).hexdigest()
            response['X-Palimpsest-Content-Hash'] = f'sha3-512={content_hash}'

        return response

class BlockAIScrapersMiddleware(MiddlewareMixin):
    """Block AI scrapers based on NI consent header."""

    AI_SCRAPERS = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot', 'Bard', 'Gemini']

    def process_request(self, request):
        user_agent = request.META.get('HTTP_USER_AGENT', '')

        # Check if request is from AI scraper
        is_ai_scraper = any(bot in user_agent for bot in self.AI_SCRAPERS)

        if is_ai_scraper:
            # Determine policy for this path
            ni_consent = self.get_ni_consent_for_path(request.path)

            if ni_consent in ['denied', 'required']:
                from django.http import HttpResponseForbidden
                return HttpResponseForbidden('403 Forbidden: Non-interpretive consent required')

        return None

    def get_ni_consent_for_path(self, path):
        """Determine NI consent policy based on path."""
        if path.startswith('/creative/'):
            return 'denied'
        return 'required'

# settings.py

MIDDLEWARE = [
    # ... other middleware
    'myapp.middleware.PalimpsestHeadersMiddleware',
    'myapp.middleware.BlockAIScrapersMiddleware',
]
```

#### Python / Flask

```python
from flask import Flask, request, g
import uuid
import hashlib

app = Flask(__name__)

@app.before_request
def setup_palimpsest():
    """Set up Palimpsest licensing for request."""
    # Generate trace ID
    g.trace_id = str(uuid.uuid4())

    # Check client purpose
    client_purpose = request.headers.get('X-Palimpsest-Client-Purpose')
    g.client_purpose = client_purpose

    # Block AI scrapers
    user_agent = request.headers.get('User-Agent', '')
    ai_scrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot']

    if any(bot in user_agent for bot in ai_scrapers):
        if request.path.startswith('/creative/'):
            return ('403 Forbidden: Non-interpretive consent required', 403)

@app.after_request
def add_palimpsest_headers(response):
    """Add Palimpsest license headers to response."""
    # Basic headers
    response.headers['X-Palimpsest-License'] = 'v0.4'
    response.headers['X-Palimpsest-NI-Consent'] = 'required'
    response.headers['X-Palimpsest-Metadata-URL'] = f"{request.scheme}://{request.host}/.well-known/license"
    response.headers['X-Palimpsest-Trace-ID'] = g.trace_id

    # Path-specific headers
    if request.path.startswith('/creative/'):
        response.headers['X-Palimpsest-NI-Consent'] = 'denied'
        response.headers['X-Palimpsest-Derivative-Policy'] = 'prohibited'

    # Content hash
    if response.data and response.status_code == 200:
        content_hash = hashlib.sha3_512(response.data).hexdigest()
        response.headers['X-Palimpsest-Content-Hash'] = f'sha3-512={content_hash}'

    return response

@app.route('/')
def index():
    return '<h1>Palimpsest-licensed content</h1>'

@app.route('/creative/<work_id>')
def creative_work(work_id):
    return f'<h1>Creative Work {work_id}</h1>'

if __name__ == '__main__':
    app.run(debug=True)
```

### CDN Configuration

#### Cloudflare Workers

```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  // Block AI scrapers at edge
  const userAgent = request.headers.get('user-agent') || '';
  const aiScrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot'];

  if (aiScrapers.some(bot => userAgent.includes(bot))) {
    // Check if path requires NI consent
    const url = new URL(request.url);

    if (url.pathname.startsWith('/creative/')) {
      return new Response('403 Forbidden: Non-interpretive consent required', {
        status: 403,
        headers: {
          'X-Palimpsest-License': 'v0.4',
          'X-Palimpsest-NI-Consent': 'denied',
          'Content-Type': 'text/plain'
        }
      });
    }
  }

  // Fetch from origin
  const response = await fetch(request);

  // Add/preserve Palimpsest headers
  const newResponse = new Response(response.body, response);

  // Add headers if not present
  if (!newResponse.headers.has('X-Palimpsest-License')) {
    newResponse.headers.set('X-Palimpsest-License', 'v0.4');
    newResponse.headers.set('X-Palimpsest-NI-Consent', 'required');
    newResponse.headers.set('X-Palimpsest-Metadata-URL', `${url.origin}/.well-known/license`);
  }

  // Generate trace ID
  newResponse.headers.set('X-Palimpsest-Trace-ID', crypto.randomUUID());

  return newResponse;
}
```

#### AWS CloudFront Functions

```javascript
function handler(event) {
    var request = event.request;
    var response = event.response;
    var headers = response.headers;

    // Add Palimpsest license headers
    headers['x-palimpsest-license'] = { value: 'v0.4' };
    headers['x-palimpsest-ni-consent'] = { value: 'required' };
    headers['x-palimpsest-metadata-url'] = {
        value: 'https://example.org/.well-known/license'
    };

    // Generate trace ID
    headers['x-palimpsest-trace-id'] = {
        value: generateUUID()
    };

    // Block AI scrapers
    var userAgent = request.headers['user-agent'] ? request.headers['user-agent'].value : '';
    var aiScrapers = ['GPTBot', 'ChatGPT', 'CCBot', 'ClaudeBot'];

    for (var i = 0; i < aiScrapers.length; i++) {
        if (userAgent.indexOf(aiScrapers[i]) !== -1) {
            if (request.uri.indexOf('/creative/') === 0) {
                return {
                    statusCode: 403,
                    statusDescription: 'Forbidden',
                    headers: {
                        'x-palimpsest-license': { value: 'v0.4' },
                        'x-palimpsest-ni-consent': { value: 'denied' }
                    }
                };
            }
        }
    }

    return response;
}

function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0;
        var v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}
```

### Proxy Configuration

#### Varnish Cache

```vcl
# varnish.vcl

vcl 4.1;

backend default {
    .host = "origin.example.org";
    .port = "80";
}

sub vcl_recv {
    # Block AI scrapers for NI-protected content
    if (req.url ~ "^/creative/" &&
        req.http.User-Agent ~ "(GPTBot|ChatGPT|CCBot|ClaudeBot)") {
        return (synth(403, "Non-interpretive consent required"));
    }
}

sub vcl_backend_response {
    # Preserve Palimpsest headers in cache
    if (beresp.http.X-Palimpsest-License) {
        set beresp.http.X-Palimpsest-License-Cached = beresp.http.X-Palimpsest-License;
    }
}

sub vcl_deliver {
    # Add Palimpsest headers to response
    if (!resp.http.X-Palimpsest-License) {
        set resp.http.X-Palimpsest-License = "v0.4";
        set resp.http.X-Palimpsest-NI-Consent = "required";
        set resp.http.X-Palimpsest-Metadata-URL = "https://example.org/.well-known/license";
    }

    # Generate trace ID
    set resp.http.X-Palimpsest-Trace-ID = req.http.X-Request-ID;

    # Path-specific headers
    if (req.url ~ "^/creative/") {
        set resp.http.X-Palimpsest-NI-Consent = "denied";
        set resp.http.X-Palimpsest-Derivative-Policy = "prohibited";
    }
}

sub vcl_synth {
    if (resp.status == 403 && resp.reason == "Non-interpretive consent required") {
        set resp.http.X-Palimpsest-License = "v0.4";
        set resp.http.X-Palimpsest-NI-Consent = "denied";
        set resp.http.Content-Type = "text/plain; charset=utf-8";
        synthetic("403 Forbidden: Non-interpretive consent required");
        return (deliver);
    }
}
```

#### Squid Proxy

```squid
# squid.conf

# Add Palimpsest license headers
reply_header_access X-Palimpsest-License allow all
reply_header_add X-Palimpsest-License "v0.4" all

reply_header_access X-Palimpsest-NI-Consent allow all
reply_header_add X-Palimpsest-NI-Consent "required" all

# Block AI scrapers (requires ACL)
acl ai_scrapers browser GPTBot ChatGPT CCBot ClaudeBot
acl creative_paths urlpath_regex ^/creative/

http_access deny ai_scrapers creative_paths

# Custom deny message
deny_info ERR_PALIMPSEST_NI_CONSENT ai_scrapers

# Error page template (err/ERR_PALIMPSEST_NI_CONSENT)
# HTTP/1.1 403 Forbidden
# X-Palimpsest-License: v0.4
# X-Palimpsest-NI-Consent: denied
# Content-Type: text/html
#
# <h1>403 Forbidden</h1>
# <p>Non-interpretive consent required for this content.</p>
```

## Header Validation

### Client-Side Validation

```javascript
// Check Palimpsest headers on loaded page
function checkPalimpsestLicense() {
  return fetch(window.location.href, { method: 'HEAD' })
    .then(response => {
      const headers = {};

      for (const [key, value] of response.headers.entries()) {
        if (key.startsWith('x-palimpsest-')) {
          headers[key] = value;
        }
      }

      console.log('Palimpsest License Headers:', headers);

      return {
        license: headers['x-palimpsest-license'],
        niConsent: headers['x-palimpsest-ni-consent'],
        metadataUrl: headers['x-palimpsest-metadata-url'],
        attributionHeaders: headers['x-palimpsest-attribution'],
        derivativePolicy: headers['x-palimpsest-derivative-policy']
      };
    });
}

// Usage
checkPalimpsestLicense().then(license => {
  if (license.niConsent === 'denied') {
    console.warn('This content prohibits AI interpretation');
  }
});
```

### Server-Side Validation Tool

```bash
#!/bin/bash
# check-palimpsest-headers.sh

URL="$1"

if [ -z "$URL" ]; then
    echo "Usage: $0 <url>"
    exit 1
fi

echo "Checking Palimpsest license headers for: $URL"
echo "================================================"

HEADERS=$(curl -sI "$URL")

# Check required headers
echo -e "\nRequired Headers:"
echo "$HEADERS" | grep -i "X-Palimpsest-License:" && echo "✓ License version declared" || echo "❌ License version missing"
echo "$HEADERS" | grep -i "X-Palimpsest-Metadata-URL:" && echo "✓ Metadata URL present" || echo "⚠️  Metadata URL missing"

# Check optional headers
echo -e "\nOptional Headers:"
echo "$HEADERS" | grep -i "X-Palimpsest-NI-Consent:" && echo "✓ NI consent declared" || echo "⚠️  NI consent not specified"
echo "$HEADERS" | grep -i "X-Palimpsest-Attribution:" && echo "✓ Attribution requirements specified" || echo "⚠️  Attribution not specified"
echo "$HEADERS" | grep -i "X-Palimpsest-Derivative-Policy:" && echo "✓ Derivative policy specified" || echo "⚠️  Derivative policy not specified"

# Check tracing
echo -e "\nTracing:"
echo "$HEADERS" | grep -i "X-Palimpsest-Trace-ID:" && echo "✓ Trace ID present" || echo "⚠️  No trace ID"

# Check content hash
echo -e "\nIntegrity:"
echo "$HEADERS" | grep -i "X-Palimpsest-Content-Hash:" && echo "✓ Content hash present" || echo "⚠️  No content hash"

# Display all Palimpsest headers
echo -e "\nAll Palimpsest Headers:"
echo "$HEADERS" | grep -i "X-Palimpsest-"

echo -e "\n================================================"
```

## Best Practices

### 1. Always Include Core Headers

Minimum required headers:

```http
X-Palimpsest-License: v0.4
X-Palimpsest-Metadata-URL: https://example.org/.well-known/license
```

### 2. Use Trace IDs

Enable end-to-end tracking:

```http
X-Palimpsest-Trace-ID: 550e8400-e29b-41d4-a716-446655440000
```

### 3. Preserve Headers Through Caching

Configure caches to preserve license headers:

```nginx
# Nginx
proxy_pass_header X-Palimpsest-License;
proxy_pass_header X-Palimpsest-NI-Consent;
```

### 4. Log License Headers

```apache
# Apache
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{X-Palimpsest-License}o\" \"%{X-Palimpsest-Trace-ID}o\"" palimpsest
CustomLog logs/palimpsest_access.log palimpsest
```

### 5. Coordinate with Other Standards

Combine with existing headers:

```http
Content-Type: text/html; charset=utf-8
Cache-Control: public, max-age=3600
X-Palimpsest-License: v0.4
X-Palimpsest-NI-Consent: required
Link: <https://example.org/.well-known/license>; rel="license"
```

### 6. Version Management

Support multiple license versions:

```http
X-Palimpsest-License: v0.4
X-Palimpsest-License-Previous: v0.3
X-Palimpsest-License-Effective-Date: Wed, 01 Nov 2025 00:00:00 GMT
```

## Security Considerations

### Header Injection Prevention

Validate all header values:

```python
import re

def safe_header_value(value):
    """Sanitize header value to prevent injection."""
    # Remove newlines and carriage returns
    value = re.sub(r'[\r\n]', '', value)
    # Limit length
    return value[:1000]
```

### HTTPS Mandatory

License headers SHOULD only be transmitted over HTTPS:

```nginx
# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name example.org;
    return 301 https://$server_name$request_uri;
}
```

### Rate Limiting

Prevent abuse of license checking:

```nginx
# Nginx rate limiting
limit_req_zone $binary_remote_addr zone=license:10m rate=10r/s;

location /.well-known/license {
    limit_req zone=license burst=20;
}
```

## Monitoring and Analytics

### Dashboard Metrics

Track license header usage:

```prometheus
# Prometheus metrics
palimpsest_license_requests_total{version="v0.4"} 12345
palimpsest_ni_consent_denials_total 42
palimpsest_ai_scraper_blocks_total 156
```

### Log Analysis

```bash
# Extract Palimpsest license stats from logs
awk '/X-Palimpsest-License/ {license[$NF]++} END {for (l in license) print l, license[l]}' access.log

# Count AI scraper blocks
grep "403.*GPTBot" access.log | wc -l
```

## Conclusion

HTTP headers provide a straightforward, universally compatible mechanism for declaring and propagating Palimpsest License metadata. By implementing these standardised headers, content providers can ensure licensing requirements are visible and enforceable throughout the HTTP infrastructure.

**Key Benefits:**

- Universal compatibility with existing infrastructure
- Easy to implement across platforms
- Visible in developer tools for debugging
- Cacheable and proxy-friendly
- Foundation for automated compliance

**Implementation Priorities:**

1. Implement core headers (License, Metadata-URL)
2. Add NI consent and attribution headers
3. Configure logging and monitoring
4. Deploy AI scraper blocking
5. Integrate with CDN and caching layers

---

## References

- RFC 7230: HTTP/1.1 Message Syntax and Routing
- RFC 7231: HTTP/1.1 Semantics and Content
- RFC 8941: Structured Field Values for HTTP
- MDN Web Docs: HTTP Headers

## Contact

Questions and feedback:
- Palimpsest HTTP Working Group
- Email: http@palimpsest.example
- GitHub: github.com/palimpsest-license/http-headers

---

*This specification is part of the Palimpsest License infrastructure initiative. Implementation examples provided under Palimpsest License v0.4.*
