# Route Object Integration for License Metadata
## Implementation Guide

**Version:** 1.0
**Date:** 2025-11-22
**Audience:** Network operators, IRR administrators, ISP technical staff

---

## Overview

This guide explains how to annotate Internet Routing Registry (IRR) route objects with Palimpsest License metadata. By extending route objects in RPSL (Routing Policy Specification Language), network operators can publish licensing information that persists in routing databases and is accessible via WHOIS queries.

## Benefits

- **Persistent metadata:** License information stored in authoritative routing databases
- **WHOIS-queryable:** Anyone can discover licensing via standard WHOIS queries
- **Standards-based:** Uses existing RPSL syntax (RFC 2622, RFC 4012)
- **Low overhead:** Simple text additions to existing route objects
- **Audit trail:** Changes tracked in IRR database logs

## RPSL Basics

### Standard Route Object

```rpsl
route:          192.0.2.0/24
descr:          Example Network
origin:         AS64512
mnt-by:         EXAMPLE-MNT
changed:        admin@example.org 20251122
source:         RIPE
```

### RPSL Fields

| Field | Purpose | Required |
|-------|---------|----------|
| `route:` | IP prefix | Yes |
| `origin:` | Origin AS number | Yes |
| `descr:` | Description | No |
| `remarks:` | Free-form text | No |
| `mnt-by:` | Maintainer object | Yes |
| `changed:` | Change log | Yes |
| `source:` | IRR database | Yes |

## Adding License Metadata

### Using `remarks:` Fields

The `remarks:` field is the standard way to add arbitrary metadata:

```rpsl
route:          192.0.2.0/24
descr:          Example Creative Content Network
origin:         AS64512
remarks:        ========================================
remarks:        Palimpsest License Metadata
remarks:        ========================================
remarks:        license-type: palimpsest
remarks:        license-version: v0.4
remarks:        license-url: https://example.org/.well-known/license
remarks:        ni-consent-required: true
remarks:        metadata-preservation: mandatory
remarks:        emotional-lineage: protected
remarks:        dao-governed: true
remarks:        dao-contract: 0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb1
remarks:        lineage-id: urn:uuid:550e8400-e29b-41d4-a716-446655440000
remarks:        contact-email: licensing@example.org
remarks:        contact-url: https://example.org/licensing
remarks:        last-updated: 2025-11-22
remarks:        ========================================
mnt-by:         EXAMPLE-MNT
changed:        admin@example.org 20251122
source:         RIPE
```

### Structured Format

For machine-parseability, use consistent key-value format:

```rpsl
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
remarks:        palimpsest:metadata-url=https://example.org/.well-known/license
remarks:        palimpsest:dao-contract=0x742d35...
```

**Benefits:**
- Easy to parse programmatically
- Namespaced with `palimpsest:` prefix
- Consistent across all route objects

## Complete Examples

### Example 1: Basic Creative Content Network

```rpsl
route:          198.51.100.0/24
descr:          Creative Works Distribution Network
origin:         AS65001
remarks:
remarks:        === Palimpsest License ===
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:license-url=https://creative.example/.well-known/license
remarks:        palimpsest:ni-consent=required
remarks:        palimpsest:attribution=required
remarks:        palimpsest:contact=licensing@creative.example
remarks:
admin-c:        ADMIN-EXAMPLE
tech-c:         TECH-EXAMPLE
mnt-by:         CREATIVE-MNT
changed:        admin@creative.example 20251122
source:         RIPE
```

### Example 2: DAO-Governed Cultural Archive

```rpsl
route:          203.0.113.0/24
descr:          Cultural Heritage Digital Archive
origin:         AS65002
remarks:
remarks:        === Palimpsest License Metadata ===
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:license-type=cultural-heritage
remarks:        palimpsest:ni-consent=denied
remarks:        palimpsest:derivative-policy=prohibited
remarks:        palimpsest:emotional-lineage=protected
remarks:        palimpsest:dao-governed=true
remarks:        palimpsest:dao-contract=ethereum:0xabc123...
remarks:        palimpsest:lineage-id=urn:uuid:12345678-1234-1234-1234-123456789abc
remarks:        palimpsest:metadata-url=https://archive.example/.well-known/license
remarks:        palimpsest:contact=rights@archive.example
remarks:        palimpsest:updated=2025-11-22
remarks:
remarks:        This network serves culturally sensitive
remarks:        content requiring explicit consent for any use.
remarks:        AI training explicitly prohibited.
remarks:
admin-c:        ADMIN-ARCHIVE
tech-c:         TECH-ARCHIVE
mnt-by:         ARCHIVE-MNT
changed:        admin@archive.example 20251122
source:         RIPE
```

### Example 3: ISP Supporting Licensed Customers

```rpsl
route:          192.0.2.0/22
descr:          ISP Network - Mixed Use
origin:         AS64500
remarks:
remarks:        This network transits Palimpsest-licensed content.
remarks:
remarks:        === License Preservation Policy ===
remarks:        palimpsest:preservation-enabled=true
remarks:        palimpsest:bgp-communities=64500:1000-64500:1010
remarks:        palimpsest:transit-policy=preserve-metadata
remarks:        palimpsest:peering-policy=https://isp.example/peering-policy
remarks:        palimpsest:support-email=license-support@isp.example
remarks:
remarks:        We preserve BGP license communities and HTTP
remarks:        license headers for customer content.
remarks:
remarks:        For license-aware transit inquiries:
remarks:        sales@isp.example
remarks:
admin-c:        ADMIN-ISP
tech-c:         TECH-ISP
mnt-by:         ISP-MNT
changed:        noc@isp.example 20251122
source:         RIPE
```

## Metadata Fields

### Recommended Fields

| Field | Values | Description |
|-------|--------|-------------|
| `license-version` | v0.3, v0.4, etc. | Palimpsest License version |
| `license-url` | URL | Full license metadata location |
| `ni-consent` | required, granted, denied | Non-interpretive AI consent |
| `attribution` | required, symbolic, lineage | Attribution requirements |
| `derivative-policy` | unrestricted, restricted, prohibited | Derivative work policy |
| `metadata-preservation` | mandatory, encouraged, none | Metadata handling |
| `emotional-lineage` | protected, tracked | Emotional/cultural lineage |
| `dao-governed` | true, false | DAO governance status |
| `dao-contract` | 0x... | Ethereum contract address |
| `lineage-id` | UUID/URN | Lineage tracking identifier |
| `contact` | email | Licensing contact |
| `updated` | YYYY-MM-DD | Last metadata update |

### Optional Fields

| Field | Description |
|-------|-------------|
| `license-type` | Content category (cultural, commercial, etc.) |
| `quantum-proof` | Quantum-resistant traceability enabled |
| `hash-algorithm` | Content hashing method (sha3-512, blake3) |
| `preservation-enabled` | For ISPs: license preservation support |
| `bgp-communities` | BGP community range for licensing |
| `transit-policy` | Link to detailed policy document |

## Querying License Metadata

### WHOIS Queries

```bash
# Query specific route
$ whois -h whois.ripe.net 192.0.2.0/24

route:          192.0.2.0/24
descr:          Example Creative Content Network
origin:         AS64512
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
...
```

### Filtering Results

```bash
# Extract only Palimpsest metadata
$ whois -h whois.ripe.net 192.0.2.0/24 | grep "palimpsest:"

remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
remarks:        palimpsest:metadata-url=https://example.org/.well-known/license
```

### Programmatic Access

**Python example:**

```python
import subprocess
import re

def query_license_metadata(prefix):
    """Query Palimpsest license metadata from IRR."""
    result = subprocess.run(
        ['whois', '-h', 'whois.ripe.net', prefix],
        capture_output=True,
        text=True
    )

    metadata = {}
    for line in result.stdout.split('\n'):
        if 'palimpsest:' in line:
            # Parse: "remarks:        palimpsest:key=value"
            match = re.search(r'palimpsest:(\w+(?:-\w+)*)=(.+)', line)
            if match:
                key, value = match.groups()
                metadata[key] = value.strip()

    return metadata

# Usage
license = query_license_metadata('192.0.2.0/24')
print(f"License version: {license.get('license-version')}")
print(f"NI consent: {license.get('ni-consent')}")
print(f"Metadata URL: {license.get('metadata-url')}")
```

**JavaScript/Node.js example:**

```javascript
const { exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);

async function queryLicenseMetadata(prefix) {
  const { stdout } = await execPromise(`whois -h whois.ripe.net ${prefix}`);

  const metadata = {};
  const lines = stdout.split('\n');

  for (const line of lines) {
    if (line.includes('palimpsest:')) {
      const match = line.match(/palimpsest:([\w-]+)=(.+)/);
      if (match) {
        const [, key, value] = match;
        metadata[key] = value.trim();
      }
    }
  }

  return metadata;
}

// Usage
queryLicenseMetadata('192.0.2.0/24').then(license => {
  console.log('License version:', license['license-version']);
  console.log('NI consent:', license['ni-consent']);
  console.log('Metadata URL:', license['metadata-url']);
});
```

## Updating Route Objects

### Via Email (Traditional)

Most IRRs accept updates via PGP-signed email:

```email
From: admin@example.org
To: auto-dbm@ripe.net
Subject: UPDATE

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

route:          192.0.2.0/24
descr:          Example Network
origin:         AS64512
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
remarks:        palimpsest:metadata-url=https://example.org/.well-known/license
mnt-by:         EXAMPLE-MNT
changed:        admin@example.org 20251122
source:         RIPE

-----BEGIN PGP SIGNATURE-----
...
-----END PGP SIGNATURE-----
```

### Via Web Interface

**RIPE NCC:**
1. Log in to https://apps.db.ripe.net/
2. Navigate to "Database Updates"
3. Select route object
4. Edit `remarks:` fields to add license metadata
5. Submit update

**ARIN:**
1. Log in to ARIN Online
2. Navigate to "Manage Resources"
3. Select route object (if available)
4. Update via web form or template

**APNIC:**
1. Log in to MyAPNIC
2. Select "Manage Resources"
3. Update route object
4. Add license metadata in `remarks:`

### Via API (where available)

**RIPE REST API example:**

```bash
curl -X PUT https://rest.db.ripe.net/ripe/route/192.0.2.0/24AS64512 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
    "objects": {
      "object": [{
        "type": "route",
        "source": {"id": "ripe"},
        "attributes": {
          "attribute": [
            {"name": "route", "value": "192.0.2.0/24"},
            {"name": "origin", "value": "AS64512"},
            {"name": "descr", "value": "Example Network"},
            {"name": "remarks", "value": "palimpsest:license-version=v0.4"},
            {"name": "remarks", "value": "palimpsest:ni-consent=required"},
            {"name": "mnt-by", "value": "EXAMPLE-MNT"},
            {"name": "changed", "value": "admin@example.org 20251122"},
            {"name": "source", "value": "RIPE"}
          ]
        }
      }]
    }
  }'
```

## IRR Database-Specific Notes

### RIPE NCC

**Database:** whois.ripe.net
**Coverage:** Europe, Middle East, Central Asia
**Update methods:** Email, web, REST API
**Authentication:** PGP, password, API key

**Special considerations:**
- DNSSEC integration available
- ROA (Route Origin Authorization) support
- Well-documented REST API

### ARIN

**Database:** whois.arin.net
**Coverage:** North America
**Update methods:** ARIN Online, email, REST API
**Authentication:** ARIN Online credentials, PGP

**Special considerations:**
- IRR not as widely used in ARIN region (prefer RPKI)
- Route objects may not exist for all allocations
- Consider using RADB as alternative

### APNIC

**Database:** whois.apnic.net
**Coverage:** Asia-Pacific
**Update methods:** MyAPNIC, email
**Authentication:** MyAPNIC credentials, PGP

### RADB

**Database:** whois.radb.net
**Coverage:** Global (independent registry)
**Update methods:** Email, web
**Authentication:** PGP, password

**Special considerations:**
- Popular in North America
- Many ISPs rely on RADB
- Faster update processing than RIRs

### Level3 / RIPE / NTTCOM / etc.

Many large ISPs maintain their own IRR databases:

- **Level3:** rr.level3.net
- **NTTCOM:** rr.ntt.net
- **HE:** rr.he.net (if available)

Check with your upstream provider for their specific IRR.

## Best Practices

### 1. Consistent Formatting

Use consistent key-value format:

```rpsl
remarks:        palimpsest:key-name=value
```

**Not:**
```rpsl
remarks:        License: Palimpsest v0.4
remarks:        NI consent required
```

### 2. Namespace Everything

Use `palimpsest:` prefix to avoid conflicts:

```rpsl
remarks:        palimpsest:license-version=v0.4
```

**Not:**
```rpsl
remarks:        license-version=v0.4  # Could conflict with other uses
```

### 3. Include Contact Information

Always provide a contact for licensing questions:

```rpsl
remarks:        palimpsest:contact=licensing@example.org
remarks:        palimpsest:contact-url=https://example.org/licensing
```

### 4. Link to Full Metadata

Use `license-url` or `metadata-url` for complete information:

```rpsl
remarks:        palimpsest:metadata-url=https://example.org/.well-known/license
```

### 5. Update Regularly

Keep metadata current:

```rpsl
remarks:        palimpsest:updated=2025-11-22
changed:        admin@example.org 20251122
```

### 6. Document for Humans Too

Include human-readable explanations:

```rpsl
remarks:
remarks:        === Palimpsest License ===
remarks:        This network serves creative content protected
remarks:        under the Palimpsest License v0.4.
remarks:
remarks:        AI training requires explicit consent.
remarks:        Contact: licensing@example.org
remarks:
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
remarks:
```

## Automation

### Bulk Updates

For multiple route objects:

```python
#!/usr/bin/env python3
"""Bulk update route objects with Palimpsest metadata."""

import subprocess
import sys

ROUTES = [
    ('192.0.2.0/24', 'AS64512'),
    ('198.51.100.0/24', 'AS64512'),
    ('203.0.113.0/24', 'AS64512'),
]

LICENSE_REMARKS = [
    'palimpsest:license-version=v0.4',
    'palimpsest:ni-consent=required',
    'palimpsest:metadata-url=https://example.org/.well-known/license',
    'palimpsest:contact=licensing@example.org',
]

def generate_route_object(prefix, origin):
    """Generate route object with license metadata."""
    remarks = '\n'.join(f'remarks:        {r}' for r in LICENSE_REMARKS)

    return f"""route:          {prefix}
descr:          Example Network
origin:         {origin}
{remarks}
mnt-by:         EXAMPLE-MNT
changed:        admin@example.org 20251122
source:         RIPE
"""

def update_route(route_obj):
    """Submit route object update via email."""
    # Sign with PGP
    proc = subprocess.Popen(
        ['gpg', '--clearsign'],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE
    )
    signed, _ = proc.communicate(route_obj.encode())

    # Email to IRR
    email_body = f"""From: admin@example.org
To: auto-dbm@ripe.net
Subject: UPDATE

{signed.decode()}
"""

    # Send via mail command or SMTP library
    subprocess.run(
        ['mail', '-s', 'UPDATE', 'auto-dbm@ripe.net'],
        input=email_body.encode()
    )

def main():
    for prefix, origin in ROUTES:
        print(f"Updating {prefix} ({origin})...")
        route_obj = generate_route_object(prefix, origin)
        print(route_obj)
        # update_route(route_obj)  # Uncomment to actually send
        print("---")

if __name__ == '__main__':
    main()
```

### Monitoring

Monitor route objects for changes:

```bash
#!/bin/bash
# monitor-route-objects.sh

ROUTES=(
    "192.0.2.0/24"
    "198.51.100.0/24"
    "203.0.113.0/24"
)

for route in "${ROUTES[@]}"; do
    echo "Checking $route..."

    # Query WHOIS
    result=$(whois -h whois.ripe.net "$route")

    # Check for license metadata
    if echo "$result" | grep -q "palimpsest:"; then
        echo "✓ License metadata present"

        # Extract version
        version=$(echo "$result" | grep "palimpsest:license-version" | cut -d= -f2)
        echo "  Version: $version"

        # Extract NI consent
        ni=$(echo "$result" | grep "palimpsest:ni-consent" | cut -d= -f2)
        echo "  NI Consent: $ni"
    else
        echo "✗ No license metadata found"
        # Send alert
        echo "Missing license metadata for $route" | mail -s "Alert" admin@example.org
    fi

    echo ""
done
```

## Integration with Other Systems

### BGP Route Servers

Link route object metadata to BGP communities:

```rpsl
remarks:        palimpsest:bgp-community=64512:1000
remarks:        palimpsest:bgp-community=64512:1001
```

Reference in router configs:

```cisco
! Match license community from IRR
ip community-list standard PALIMPSEST permit 64512:1000

route-map APPLY_LICENSE permit 10
 match community PALIMPSEST
 set local-preference 150
```

### DNS

Cross-reference with DNS TXT records:

```rpsl
remarks:        palimpsest:dns-record=_license.example.org
```

Clients can verify consistency:

```bash
# Check IRR
whois -h whois.ripe.net 192.0.2.0/24 | grep palimpsest

# Check DNS
dig +short TXT _license.example.org

# Verify match
```

### Monitoring Dashboards

Pull IRR metadata into dashboards:

```python
# Grafana dashboard data source
def get_license_status():
    routes = load_monitored_routes()
    status = {}

    for route in routes:
        metadata = query_license_metadata(route)
        status[route] = {
            'has_license': bool(metadata),
            'version': metadata.get('license-version'),
            'ni_consent': metadata.get('ni-consent'),
            'last_updated': metadata.get('updated')
        }

    return status
```

## Troubleshooting

### Issue: Updates Rejected

**Symptom:** IRR rejects route object update

**Common causes:**
- Invalid RPSL syntax
- Authentication failure (bad PGP signature)
- Maintainer (mnt-by) mismatch
- Missing required fields

**Solution:**
- Validate syntax: https://www.ripe.net/analyse/archived-projects/ris-tools-web-interfaces/rpsl-object-validator
- Check PGP key matches maintainer
- Verify mnt-by object exists and you have rights
- Include all required fields

### Issue: Metadata Not Appearing in WHOIS

**Symptom:** Added remarks, but WHOIS query doesn't show them

**Possible causes:**
- Update not yet propagated (wait 5-60 minutes)
- Wrong database queried (check source field)
- Route object for different prefix/origin
- Cache not updated (try different WHOIS server)

**Solution:**
- Query with `-B` flag to bypass cache: `whois -B -h whois.ripe.net 192.0.2.0/24`
- Check update confirmation email
- Verify route object in web interface
- Try alternative WHOIS servers

### Issue: Syntax Errors

**Symptom:** `remarks:` field rejected or malformed

**Solution:**
- Ensure proper RPSL formatting
- Each `remarks:` on separate line
- No special characters causing parsing issues
- Consistent indentation/spacing

**Correct:**
```rpsl
remarks:        palimpsest:license-version=v0.4
remarks:        palimpsest:ni-consent=required
```

**Incorrect:**
```rpsl
remarks: palimpsest:license-version=v0.4, palimpsest:ni-consent=required
```

## Conclusion

Route object integration provides a standards-based, persistent method for publishing Palimpsest License metadata. By leveraging existing IRR infrastructure and WHOIS protocols, network operators can make licensing information discoverable and verifiable at the routing layer.

**Key benefits:**
- Uses established protocols and databases
- Queryable via standard WHOIS tools
- Preserved in authoritative records
- Supports both human and machine consumption

**Next steps:**
1. Update your route objects with license metadata
2. Document in network policy and peering agreements
3. Coordinate with BGP community signaling
4. Monitor and maintain metadata currency

---

## References

- RFC 2622: Routing Policy Specification Language (RPSL)
- RFC 4012: Routing Policy Specification Language next generation (RPSLng)
- RIPE Database Reference Manual: https://www.ripe.net/manage-ips-and-asns/db/support/documentation
- ARIN IRR Guide: https://www.arin.net/resources/registry/irr/
- RADb Documentation: https://www.radb.net/

## Contact

For questions about route object integration:

- **Email:** irr-support@palimpsest.example
- **GitHub:** github.com/palimpsest-license/infrastructure
- **Mailing list:** infrastructure-discuss@palimpsest.example

---

*This guide is licensed under the Palimpsest License v0.4. You may share, adapt, and distribute with attribution.*
