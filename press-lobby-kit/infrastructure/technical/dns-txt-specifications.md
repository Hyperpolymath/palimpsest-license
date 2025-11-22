# DNS TXT Record Specifications for License Declaration
## Technical Advisory Document

**Version:** 1.0
**Date:** 2025-11-22
**Status:** Draft for Discussion
**Audience:** DNS Operators, System Administrators, Domain Registrars

---

## Executive Summary

This specification defines how DNS TXT records can be used to declare and propagate Palimpsest License metadata across the Internet infrastructure. By leveraging the existing DNS infrastructure, content providers can establish machine-readable, cryptographically verifiable licensing declarations that persist throughout content distribution.

## Background

### Why DNS for Licensing?

The Domain Name System provides:

- **Universal availability:** Every domain has DNS infrastructure
- **Hierarchical trust:** DNSSEC enables cryptographic verification
- **Caching and propagation:** Built-in distribution mechanism
- **Machine-readable:** Automated systems can query and verify
- **Lightweight:** Minimal overhead for implementation

### Problem Statement

Current licensing mechanisms fail at scale:

- HTML meta tags are easily stripped
- HTTP headers can be removed by intermediaries
- Embedded metadata doesn't survive content transformations
- No authoritative source of truth for licensing

DNS TXT records provide a **authoritative, domain-level declaration** that survives content manipulation.

## Technical Specification

### 1. Basic License Declaration

#### Standard Format

```dns
_license.example.org. IN TXT "palimpsest-v0.4"
```

**Structure:**

- **Subdomain:** `_license` (following RFC 8552 convention for underscored labels)
- **Record type:** TXT
- **Value:** License identifier and version

#### Multi-Part TXT Records

For complex metadata, use structured key-value pairs:

```dns
_license.example.org. IN TXT "v=palimpsest1; license=v0.4; ni-consent=required"
_license.example.org. IN TXT "metadata-url=https://example.org/.well-known/license"
_license.example.org. IN TXT "hash-algorithm=sha3-512; hash=3a5f..."
```

**Field Definitions:**

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `v` | Yes | Protocol version | `palimpsest1` |
| `license` | Yes | License version | `v0.4`, `v0.3` |
| `ni-consent` | No | Non-interpretive consent | `required`, `granted`, `denied` |
| `metadata-url` | Recommended | Full license metadata | URL to JSON-LD |
| `hash-algorithm` | No | Content fingerprint method | `sha3-512`, `blake3` |
| `hash` | No | Content hash (truncated) | First 32 chars of hash |
| `dao-governed` | No | DAO governance flag | `true`, `false` |
| `lineage-protected` | No | Emotional lineage flag | `true` |
| `quantum-proof` | No | Quantum-resistant hashing | `true` |

### 2. Subdomain Hierarchy

#### Per-Subdomain Licensing

Different subdomains can have different licenses:

```dns
; Main domain - Palimpsest licensed
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"

; Creative subdomain - stricter protection
_license.creative.example.org. IN TXT "v=palimpsest1; license=v0.4; ni-consent=required"

; Archive subdomain - public domain
_license.archive.example.org. IN TXT "v=pd1; license=cc0"
```

#### Inheritance Rules

If no specific `_license` record exists for a subdomain, inherit from parent:

```
Query: _license.blog.example.org
→ NXDOMAIN
→ Query: _license.example.org
→ Returns: "v=palimpsest1; license=v0.4"
```

### 3. Path-Specific Licensing

Use TXT records with path encodings:

```dns
; General license
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"

; Specific path (Base64-encoded: /creative/works)
_license._L2NyZWF0aXZlL3dvcmtz.example.org. IN TXT "ni-consent=required"
```

**Note:** This approach is complex and should be used sparingly. Prefer HTTP headers for path-specific licensing.

### 4. DNSSEC Integration

#### Signed Records

Ensure TXT records are DNSSEC-signed for authenticity:

```dns
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"
_license.example.org. IN RRSIG TXT 13 3 3600 (
    20251222000000 20251122000000 12345 example.org.
    kRCOH6u7h... )
```

**Verification Process:**

1. Query `_license.example.org TXT`
2. Retrieve RRSIG record
3. Validate signature chain to root
4. Trust license declaration if signature valid

#### Trust Anchor

Publishers should document their DNSSEC configuration:

```dns
example.org. IN DS 12345 13 2 (
    3a5f9c2b... )
```

Consumers can verify the chain from root → TLD → domain → `_license`.

### 5. Well-Known URI Integration

Combine DNS TXT with .well-known URIs (RFC 8615):

**DNS Record:**
```dns
_license.example.org. IN TXT "metadata-url=https://example.org/.well-known/license"
```

**Well-Known Location:**
```
https://example.org/.well-known/license
```

**Response (JSON-LD):**
```json
{
  "@context": "https://schema.org/",
  "@type": "CreativeWork",
  "license": "https://palimpsest.example/license/v0.4",
  "name": "Palimpsest License v0.4",
  "version": "0.4",
  "requires": {
    "nonInterpretiveConsent": true,
    "metadataPreservation": true,
    "emotionalLineage": true,
    "quantumProofTraceability": true
  },
  "governance": {
    "type": "DAO",
    "council": "Palimpsest Stewardship Council"
  }
}
```

### 6. Content Fingerprinting

Include cryptographic hashes to link content to license:

```dns
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"
_license.example.org. IN TXT "hash-algo=sha3-512"
_license-hash.example.org. IN TXT "content=3a5f9c2b4d8e1a7f..."
```

**Hash Calculation:**

```bash
# For a specific file
sha3sum -a 512 content.html > hash.txt

# For entire site (Merkle root)
find /var/www -type f -exec sha3sum -a 512 {} \; | sort | sha3sum -a 512
```

### 7. Service-Specific Records

#### For Specific Services

```dns
; Web content
_license._http.example.org. IN TXT "v=palimpsest1; license=v0.4"

; API endpoints
_license._api.example.org. IN TXT "v=palimpsest1; license=v0.4; ni-consent=required"

; Email content
_license._smtp.example.org. IN TXT "v=palimpsest1; license=v0.4"
```

#### Service Discovery

Combine with SRV records:

```dns
_http._tcp.example.org. IN SRV 0 5 80 www.example.org.
_license._http.example.org. IN TXT "v=palimpsest1; license=v0.4"
```

## Implementation Examples

### BIND9 Configuration

```bind
; Zone file for example.org
$ORIGIN example.org.
$TTL 3600

; Standard records
@       IN SOA   ns1.example.org. admin.example.org. (
                 2025112201 ; Serial
                 3600       ; Refresh
                 1800       ; Retry
                 604800     ; Expire
                 86400 )    ; Minimum TTL

@       IN NS    ns1.example.org.
@       IN A     192.0.2.1

; License declaration
_license IN TXT  "v=palimpsest1; license=v0.4; ni-consent=required"
_license IN TXT  "metadata-url=https://example.org/.well-known/license"

; DNSSEC signing
; (Run: dnssec-signzone -o example.org zone.example.org)
```

### PowerDNS Configuration

```sql
-- SQL backend configuration
INSERT INTO records (domain_id, name, type, content, ttl, prio)
VALUES
  (1, '_license.example.org', 'TXT', 'v=palimpsest1; license=v0.4', 3600, 0),
  (1, '_license.example.org', 'TXT', 'ni-consent=required', 3600, 0);
```

### Cloudflare API

```bash
# Create TXT record via API
curl -X POST "https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records" \
  -H "Authorization: Bearer {api_token}" \
  -H "Content-Type: application/json" \
  --data '{
    "type": "TXT",
    "name": "_license",
    "content": "v=palimpsest1; license=v0.4; ni-consent=required",
    "ttl": 3600
  }'
```

### Route 53 (AWS)

```json
{
  "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
      "Name": "_license.example.org",
      "Type": "TXT",
      "TTL": 3600,
      "ResourceRecords": [{
        "Value": "\"v=palimpsest1; license=v0.4; ni-consent=required\""
      }]
    }
  }]
}
```

## Query Methods

### Command Line

#### Using `dig`

```bash
# Basic query
dig TXT _license.example.org

# With DNSSEC validation
dig +dnssec TXT _license.example.org

# Short answer only
dig +short TXT _license.example.org
```

#### Using `host`

```bash
host -t TXT _license.example.org
```

#### Using `nslookup`

```bash
nslookup -type=TXT _license.example.org
```

### Programmatic Access

#### Python

```python
import dns.resolver
import dns.dnssec

def get_license(domain):
    """Query license TXT record with DNSSEC validation."""
    try:
        # Query _license subdomain
        answers = dns.resolver.resolve(f'_license.{domain}', 'TXT')

        # Parse TXT records
        license_info = {}
        for rdata in answers:
            for txt_string in rdata.strings:
                txt = txt_string.decode('utf-8')
                # Parse key=value pairs
                for pair in txt.split('; '):
                    if '=' in pair:
                        key, value = pair.split('=', 1)
                        license_info[key] = value
                    else:
                        license_info['license'] = pair

        return license_info
    except dns.resolver.NXDOMAIN:
        return None

# Usage
license = get_license('example.org')
print(f"License: {license.get('license')}")
print(f"NI Consent: {license.get('ni-consent')}")
```

#### JavaScript (Node.js)

```javascript
const dns = require('dns').promises;

async function getLicense(domain) {
  try {
    const records = await dns.resolveTxt(`_license.${domain}`);
    const license = {};

    records.forEach(record => {
      const txt = record.join('');
      txt.split('; ').forEach(pair => {
        const [key, value] = pair.split('=');
        license[key] = value || true;
      });
    });

    return license;
  } catch (err) {
    console.error('License query failed:', err);
    return null;
  }
}

// Usage
getLicense('example.org').then(license => {
  console.log('License:', license.license);
  console.log('NI Consent:', license['ni-consent']);
});
```

#### Go

```go
package main

import (
    "context"
    "fmt"
    "net"
    "strings"
)

func GetLicense(domain string) (map[string]string, error) {
    resolver := &net.Resolver{}
    txts, err := resolver.LookupTXT(context.Background(), "_license."+domain)
    if err != nil {
        return nil, err
    }

    license := make(map[string]string)
    for _, txt := range txts {
        parts := strings.Split(txt, "; ")
        for _, part := range parts {
            kv := strings.SplitN(part, "=", 2)
            if len(kv) == 2 {
                license[kv[0]] = kv[1]
            }
        }
    }

    return license, nil
}

func main() {
    license, err := GetLicense("example.org")
    if err != nil {
        panic(err)
    }
    fmt.Printf("License: %s\n", license["license"])
    fmt.Printf("NI Consent: %s\n", license["ni-consent"])
}
```

## Caching Considerations

### TTL Strategy

Choose appropriate TTL values:

| Use Case | Recommended TTL | Reasoning |
|----------|----------------|-----------|
| Stable licenses | 86400 (24 hours) | Reduce query load |
| Active development | 3600 (1 hour) | Allow quick updates |
| High-security | 300 (5 minutes) | Rapid revocation |
| Emergency revocation | 60 (1 minute) | Immediate propagation |

### Cache Invalidation

To force cache refresh:

1. Lower TTL before making changes
2. Wait for old TTL to expire
3. Update TXT record
4. Restore normal TTL after propagation

**Example Timeline:**

```
Day 0: Set TTL to 300 (5 minutes)
Day 1: Update license from v0.3 to v0.4
Day 2: Verify propagation globally
Day 3: Restore TTL to 86400
```

## Security Considerations

### DNSSEC Mandatory

All `_license` TXT records **must** be DNSSEC-signed:

- Prevents DNS spoofing attacks
- Ensures license authenticity
- Enables chain-of-trust verification

### Monitoring and Alerts

Monitor for unauthorised changes:

```bash
# Cron job to verify license record
#!/bin/bash
EXPECTED="v=palimpsest1; license=v0.4"
ACTUAL=$(dig +short TXT _license.example.org | tr -d '"')

if [ "$ACTUAL" != "$EXPECTED" ]; then
  echo "LICENSE RECORD MISMATCH!" | mail -s "DNS Alert" admin@example.org
fi
```

### Rate Limiting

Protect against DNS amplification attacks:

- Implement response rate limiting (RRL)
- Monitor query patterns for `_license` subdomain
- Use DNSSEC to reduce cache poisoning risk

## Best Practices

### 1. Use DNSSEC Always

Never publish `_license` records without DNSSEC:

```bash
# Sign the zone
dnssec-signzone -A -3 $(head -c 1000 /dev/random | sha256sum | cut -b 1-16) \
  -N INCREMENT -o example.org -t zone.example.org
```

### 2. Multiple TXT Records

Split complex metadata across multiple TXT records:

```dns
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"
_license.example.org. IN TXT "ni-consent=required; dao-governed=true"
_license.example.org. IN TXT "metadata-url=https://example.org/.well-known/license"
```

### 3. Wildcard Inheritance

Use wildcards carefully:

```dns
; Explicit license for main domain
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"

; Wildcard for all subdomains (use cautiously)
_license.*.example.org. IN TXT "v=palimpsest1; license=v0.4"
```

**Warning:** Wildcards can have unexpected behaviour. Prefer explicit records.

### 4. Monitoring and Logging

Track `_license` TXT queries:

```bind
; BIND9 query logging
logging {
    channel license_queries {
        file "/var/log/named/license-queries.log";
        severity info;
        print-time yes;
    };
    category queries { license_queries; };
};
```

### 5. Documentation

Document your DNS license setup:

```markdown
# DNS License Configuration

## Records
- `_license.example.org` → Palimpsest v0.4
- DNSSEC: Enabled
- TTL: 86400 seconds
- Validation URL: https://example.org/.well-known/license

## Monitoring
- Cron: /etc/cron.hourly/check-license-dns
- Alert email: admin@example.org

## Change Procedure
1. Lower TTL to 300
2. Wait 24 hours
3. Update TXT record
4. Verify globally: https://dnsviz.net
5. Restore TTL to 86400
```

## Migration Guide

### For Existing Domains

#### Step 1: Audit Current Configuration

```bash
# Check if DNSSEC is enabled
dig +dnssec example.org SOA

# Check existing TXT records
dig TXT example.org
```

#### Step 2: Enable DNSSEC

If not already enabled:

```bash
# Generate keys
dnssec-keygen -a ECDSAP256SHA256 -n ZONE example.org
dnssec-keygen -a ECDSAP256SHA256 -n ZONE -f KSK example.org

# Sign zone
dnssec-signzone -o example.org zone.example.org
```

#### Step 3: Add License TXT Records

```dns
_license.example.org. IN TXT "v=palimpsest1; license=v0.4"
_license.example.org. IN TXT "metadata-url=https://example.org/.well-known/license"
```

#### Step 4: Verify

```bash
# Test DNS resolution
dig +dnssec TXT _license.example.org

# Validate DNSSEC
dig +dnssec +multi +trace TXT _license.example.org

# Online validation
# Visit: https://dnssec-debugger.verisignlabs.com/
```

#### Step 5: Update Application

Modify your application to query DNS license records:

```python
# Example: Check license before serving content
from flask import Flask, abort
import dns.resolver

app = Flask(__name__)

@app.before_request
def check_license():
    # Query license for this domain
    license = get_license(request.host)
    if license and license.get('ni-consent') == 'required':
        # Verify request is not from AI scraper
        if is_ai_scraper(request.user_agent):
            abort(403, "NI consent required")
```

## Integration Points

### CDN Integration

CDNs should query `_license` TXT records when caching content:

```nginx
# Nginx configuration
location / {
    # Lua script to query DNS license
    access_by_lua_block {
        local resolver = require "resty.dns.resolver"
        local r, err = resolver:new{nameservers = {"8.8.8.8"}}
        local answers, err = r:query("_license.example.org", {qtype = r.TYPE_TXT})

        if answers then
            for _, ans in ipairs(answers) do
                if string.find(ans.txt, "ni-consent=required") then
                    -- Block AI scrapers
                    if ngx.var.http_user_agent:match("GPTBot") then
                        ngx.exit(403)
                    end
                end
            end
        end
    }

    proxy_pass http://backend;
}
```

### HTTP Header Correlation

Web servers should inject headers based on DNS license:

```python
# Django middleware example
class LicenseMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response
        self.license = get_license(settings.DOMAIN)

    def __call__(self, request):
        response = self.get_response(request)

        if self.license:
            response['X-License'] = self.license.get('license', 'unknown')
            response['X-License-NI-Consent'] = self.license.get('ni-consent', 'not-specified')
            response['X-License-URL'] = self.license.get('metadata-url', '')

        return response
```

### Monitoring Dashboards

Create dashboards to track license DNS health:

```prometheus
# Prometheus metrics for license DNS
dns_license_query_success{domain="example.org"} 1
dns_license_query_duration_seconds{domain="example.org"} 0.023
dns_license_dnssec_valid{domain="example.org"} 1
```

## Troubleshooting

### Common Issues

#### 1. TXT Record Not Found

**Symptom:**
```bash
$ dig TXT _license.example.org
;; ANSWER SECTION:
(empty)
```

**Solutions:**
- Verify record exists in zone file
- Check zone serial was incremented
- Reload DNS server: `rndc reload`
- Wait for TTL expiry if recently added

#### 2. DNSSEC Validation Fails

**Symptom:**
```bash
$ dig +dnssec TXT _license.example.org
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 0, ADDITIONAL: 0
```

**Solutions:**
- Verify DNSSEC chain: `dig +trace +dnssec _license.example.org`
- Check DS record at parent zone
- Re-sign zone if signatures expired
- Validate with: https://dnsviz.net

#### 3. Inconsistent Results

**Symptom:** Different DNS servers return different results

**Solutions:**
- Check zone transfer (AXFR) is working
- Verify all authoritative nameservers have same data
- Clear caches: `rndc flush`
- Reduce TTL temporarily to force refresh

## Registrar-Specific Guides

### Cloudflare

1. Log in to Cloudflare Dashboard
2. Select domain
3. Go to DNS tab
4. Click "Add Record"
5. Type: TXT
6. Name: `_license`
7. Content: `v=palimpsest1; license=v0.4`
8. TTL: Auto
9. Click "Save"

### GoDaddy

1. Log in to GoDaddy
2. My Products → Domains
3. Click DNS next to domain
4. Click "Add" under Records
5. Type: TXT
6. Host: `_license`
7. TXT Value: `v=palimpsest1; license=v0.4`
8. TTL: 1 Hour
9. Click "Save"

### Namecheap

1. Log in to Namecheap
2. Domain List → Manage
3. Advanced DNS tab
4. Add New Record
5. Type: TXT Record
6. Host: `_license`
7. Value: `v=palimpsest1; license=v0.4`
8. TTL: Automatic
9. Save All Changes

## Conclusion

DNS TXT records provide a robust, scalable mechanism for declaring Palimpsest License metadata. When combined with DNSSEC, they offer cryptographically verifiable, authoritative license declarations that persist throughout content distribution.

**Key Benefits:**

- Universal availability through existing DNS infrastructure
- DNSSEC-based cryptographic verification
- Machine-readable for automated compliance
- Survives content manipulation and redistribution
- Minimal implementation overhead

**Next Steps:**

1. Enable DNSSEC on your domain
2. Add `_license` TXT records
3. Update applications to query license metadata
4. Monitor compliance and propagation
5. Integrate with HTTP headers and BGP communities

---

## References

- RFC 1035: Domain Names - Implementation and Specification
- RFC 4034: Resource Records for DNS Security Extensions
- RFC 4035: Protocol Modifications for DNS Security Extensions
- RFC 8552: Scoped Interpretation of DNS Resource Records
- RFC 8615: Well-Known Uniform Resource Identifiers (URIs)

## Contact

For technical support or questions:
- Palimpsest Technical Working Group
- Email: dns-support@palimpsest.example
- GitHub: github.com/palimpsest-license

---

*This specification is part of the Palimpsest License infrastructure project. Implementation examples provided under the Palimpsest License v0.4.*
