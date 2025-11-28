# EDNS/OPT Record Usage for License Metadata
## Technical Advisory Document

**Version:** 1.0
**Date:** 2025-11-22
**Status:** Draft for Discussion
**Audience:** DNS Operators, Resolver Developers, Authoritative Server Administrators

---

## Executive Summary

This document specifies how Extension Mechanisms for DNS (EDNS) and OPT pseudo-records can carry Palimpsest License metadata within DNS transactions. By leveraging EDNS options, license information can be transmitted alongside DNS queries and responses, enabling real-time license verification at the resolution layer.

## Background

### EDNS Overview

EDNS(0), defined in RFC 6891, extends DNS functionality by:

- Increasing message size beyond 512 bytes
- Allowing additional flags and return codes
- Supporting optional data in OPT pseudo-RR
- Enabling protocol extensions without breaking compatibility

### Why EDNS for Licensing?

Traditional TXT records require separate queries. EDNS options enable:

- **Single-transaction license exchange:** License metadata piggybacked on existing queries
- **Resolver-aware licensing:** Recursive resolvers can enforce policies
- **Client-side verification:** Applications receive license info directly
- **Reduced query overhead:** No additional DNS roundtrips

## EDNS Option Code Allocation

### Requesting IANA Assignment

We propose requesting an IANA-assigned EDNS option code for Palimpsest License metadata.

**Proposed Name:** `PALIMPSEST`
**Proposed Code:** TBD (pending IANA assignment)
**Status:** Experimental (using private code 65280-65534 for now)
**Reference:** This specification

### Experimental Code

For pilot deployments, use private-use code:

```
EDNS Option Code: 65400 (Private Use)
Option Name: PALIMPSEST-EXPERIMENTAL
```

## Option Format

### Wire Format

```
                     1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          OPTION-CODE          |         OPTION-LENGTH         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| VERSION |FLAGS|  LICENSE-VER  |         RESERVED              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                                                               |
/                     METADATA (variable)                       /
/                                                               /
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

### Field Definitions

| Field | Bytes | Description |
|-------|-------|-------------|
| OPTION-CODE | 2 | EDNS option code (65400 experimental) |
| OPTION-LENGTH | 2 | Length of option data in octets |
| VERSION | 1 | Protocol version (0x01 for v1) |
| FLAGS | 1 | License requirement flags |
| LICENSE-VER | 2 | Palimpsest License version (0x0004 = v0.4) |
| RESERVED | 2 | Reserved for future use (must be 0) |
| METADATA | Variable | Additional metadata (TLV format) |

### Flags Field

```
Bit 0 (MSB): NI-Consent-Required
Bit 1:       Metadata-Preservation-Required
Bit 2:       Emotional-Lineage-Protected
Bit 3:       DAO-Governed
Bit 4:       Quantum-Proof-Enabled
Bit 5:       DNSSEC-Required
Bit 6-7:     Reserved (must be 0)
```

**Example:**
```
Flags = 0b10110100 = 0xB4
→ NI-Consent: Yes
→ Metadata-Preservation: No
→ Emotional-Lineage: Yes
→ DAO-Governed: Yes
→ Quantum-Proof: No
→ DNSSEC-Required: Yes
```

### Metadata TLV Format

Variable-length metadata uses Type-Length-Value encoding:

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|     TYPE      |    LENGTH     |    VALUE (variable length)    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

**Defined Types:**

| Type | Name | Description |
|------|------|-------------|
| 0x01 | METADATA-URL | URL to full license metadata (UTF-8) |
| 0x02 | HASH | Content hash (SHA3-512 truncated to 32 bytes) |
| 0x03 | DAO-ADDRESS | Ethereum contract address (20 bytes) |
| 0x04 | CREATOR-ID | Creator identifier (variable) |
| 0x05 | TIMESTAMP | Unix timestamp of license assignment (8 bytes) |
| 0x06 | LINEAGE-ID | Emotional lineage UUID (16 bytes) |

## Query and Response Flow

### Client Query with License Request

A client querying for `example.org` can request license metadata:

```
; DNS Query
;; QUESTION SECTION:
example.org.            IN      A

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; PALIMPSEST: request-license=true
```

**Wire Format (OPT RR):**

```
;; OPT RR
NAME:       (root)
TYPE:       41 (OPT)
CLASS:      4096 (UDP payload size)
TTL:        0x00000000
RDLEN:      variable
RDATA:
  OPTION-CODE:    65400
  OPTION-LENGTH:  1
  DATA:           0x01 (request flag)
```

### Server Response with License Data

The authoritative server responds with license metadata:

```
;; ANSWER SECTION:
example.org.            3600    IN      A       192.0.2.1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; PALIMPSEST: license=v0.4, ni-consent=required, flags=0xB4
```

**Wire Format (OPT RR with full metadata):**

```
OPTION-CODE:    65400
OPTION-LENGTH:  42
DATA:
  VERSION:        0x01
  FLAGS:          0xB4 (NI-consent, lineage, DAO, DNSSEC)
  LICENSE-VER:    0x0004 (v0.4)
  RESERVED:       0x0000
  TLV:
    TYPE:         0x01 (METADATA-URL)
    LENGTH:       0x1E (30 bytes)
    VALUE:        "https://example.org/.well-known/license"
```

## Resolver Behaviour

### Recursive Resolver Processing

Recursive resolvers should:

1. **Recognise EDNS PALIMPSEST option** in client queries
2. **Forward option to authoritative servers** in upstream queries
3. **Cache license metadata** alongside DNS records
4. **Return license data** in responses to clients
5. **Enforce policies** based on license flags

#### Example: BIND9 Plugin

```c
// Conceptual BIND9 plugin for EDNS PALIMPSEST
static isc_result_t
palimpsest_edns_process(dns_message_t *message) {
    isc_buffer_t *buffer;
    unsigned char *data;
    uint16_t option_code, option_length;

    // Search for PALIMPSEST option in OPT RR
    result = dns_message_getopt(message, &opt);
    if (result != ISC_R_SUCCESS) return result;

    // Parse options
    for (buffer = ISC_LIST_HEAD(opt->rdatalist);
         buffer != NULL;
         buffer = ISC_LIST_NEXT(buffer, link)) {

        data = isc_buffer_current(buffer);
        option_code = (data[0] << 8) | data[1];
        option_length = (data[2] << 8) | data[3];

        if (option_code == PALIMPSEST_OPTION_CODE) {
            // Parse license metadata
            palimpsest_parse_metadata(data + 4, option_length);

            // Cache alongside DNS record
            palimpsest_cache_license(message->qname, data + 4);

            // Enforce policies
            if (palimpsest_policy_check(data + 4) == DENY) {
                return DNS_R_REFUSED;
            }
        }
    }

    return ISC_R_SUCCESS;
}
```

### Policy Enforcement

Resolvers can enforce license policies:

**Example Policy:**

```yaml
# Resolver policy configuration
palimpsest:
  enforce: true
  policies:
    - name: "Block AI Scrapers for NI-Required Content"
      condition: "flags.ni_consent_required == true"
      action:
        - log: "NI-consent required for ${qname}"
        - if: "client.user_agent matches /(GPTBot|CCBot|ChatGPT)/"
          then: "REFUSED"

    - name: "Require DNSSEC for Licensed Content"
      condition: "flags.dnssec_required == true"
      action:
        - validate_dnssec: true
        - if: "dnssec_status != SECURE"
          then: "SERVFAIL"
```

### Caching Considerations

License metadata should be cached with the same TTL as the associated DNS record:

```
Cache Entry:
  QNAME:          example.org
  QTYPE:          A
  TTL:            3600
  RDATA:          192.0.2.1
  LICENSE:
    VERSION:      v0.4
    FLAGS:        0xB4
    METADATA-URL: https://example.org/.well-known/license
    CACHED-AT:    1700000000
    EXPIRES-AT:   1700003600
```

## Authoritative Server Implementation

### BIND9 Configuration

Extend BIND9 to include EDNS PALIMPSEST option:

```bind
// named.conf
options {
    edns-udp-size 4096;
    // Enable EDNS PALIMPSEST support
    palimpsest-metadata-zone "example.org" {
        license-version "v0.4";
        flags "ni-consent-required";
        metadata-url "https://example.org/.well-known/license";
    };
};
```

### PowerDNS Lua Plugin

```lua
-- PowerDNS Lua EDNS plugin
function gettag(dq)
    -- Check for PALIMPSEST EDNS option in query
    if dq.ednsOptions[65400] then
        pdnslog("PALIMPSEST option requested for " .. dq.qname:toString())

        -- Retrieve license metadata
        local license = get_license_metadata(dq.qname:toString())

        if license then
            -- Construct EDNS response
            local flags = 0
            if license.ni_consent_required then flags = flags + 128 end
            if license.metadata_preservation then flags = flags + 64 end
            if license.emotional_lineage then flags = flags + 32 end
            if license.dao_governed then flags = flags + 16 end

            local response_data = string.char(
                0x01,  -- VERSION
                flags,  -- FLAGS
                0x00, 0x04,  -- LICENSE-VER (v0.4)
                0x00, 0x00  -- RESERVED
            )

            -- Add metadata-url TLV
            if license.metadata_url then
                response_data = response_data .. string.char(0x01)  -- TYPE
                response_data = response_data .. string.char(#license.metadata_url)  -- LENGTH
                response_data = response_data .. license.metadata_url  -- VALUE
            end

            -- Set EDNS option in response
            dq.ednsOptions[65400] = response_data
        end
    end

    return DNSAction.None
end
```

### Knot DNS Configuration

```yaml
# knot.conf
server:
  edns-client-subnet: on

mod-palimpsest:
  - id: default
    license-version: v0.4
    flags:
      - ni-consent-required
      - dao-governed
    metadata-url: https://example.org/.well-known/license

zone:
  - domain: example.org
    modules:
      - mod-palimpsest/default
```

## Client Implementation

### Command-Line Tools

#### Modified `dig` Usage

```bash
# Query with PALIMPSEST EDNS option
dig +edns=0 +palimpsest example.org

# Expected output:
; <<>> DiG 9.18.0 <<>> +edns=0 +palimpsest example.org
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 12345
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; PALIMPSEST: license=v0.4, flags=0xB4 (NI-CONSENT|LINEAGE|DAO|DNSSEC)
; METADATA-URL: https://example.org/.well-known/license

;; QUESTION SECTION:
;example.org.                   IN      A

;; ANSWER SECTION:
example.org.            3600    IN      A       192.0.2.1
```

### Library Support

#### Python (dnspython)

```python
import dns.message
import dns.query
import dns.edns

# Custom EDNS option for PALIMPSEST
class PalimpsestOption(dns.edns.Option):
    """EDNS option for Palimpsest License metadata."""

    def __init__(self, request=False, data=None):
        super().__init__(65400)  # Experimental option code
        self.request = request
        self.data = data

    def to_wire(self, file=None):
        if self.request:
            # Request license metadata
            return b'\x01'
        elif self.data:
            return self.data
        return b''

    @classmethod
    def from_wire_parser(cls, otype, parser):
        data = parser.get_remaining()
        return cls(request=False, data=data)

    def parse_response(self):
        """Parse license metadata from response."""
        if len(self.data) < 6:
            return None

        version = self.data[0]
        flags = self.data[1]
        license_ver = (self.data[2] << 8) | self.data[3]

        metadata = {
            'version': version,
            'license': f'v{license_ver >> 8}.{license_ver & 0xFF}',
            'flags': {
                'ni_consent': bool(flags & 0x80),
                'metadata_preservation': bool(flags & 0x40),
                'emotional_lineage': bool(flags & 0x20),
                'dao_governed': bool(flags & 0x10),
                'quantum_proof': bool(flags & 0x08),
                'dnssec_required': bool(flags & 0x04),
            }
        }

        # Parse TLVs
        pos = 6
        while pos < len(self.data):
            if pos + 2 > len(self.data):
                break
            tlv_type = self.data[pos]
            tlv_length = self.data[pos + 1]
            tlv_value = self.data[pos + 2:pos + 2 + tlv_length]

            if tlv_type == 0x01:  # METADATA-URL
                metadata['metadata_url'] = tlv_value.decode('utf-8')
            elif tlv_type == 0x02:  # HASH
                metadata['hash'] = tlv_value.hex()

            pos += 2 + tlv_length

        return metadata

# Usage
def query_with_license(qname, qtype='A'):
    """Query DNS with PALIMPSEST EDNS option."""
    q = dns.message.make_query(qname, qtype, use_edns=True)

    # Add PALIMPSEST option requesting license metadata
    palimpsest_opt = PalimpsestOption(request=True)
    q.use_edns(edns=0, payload=4096, options=[palimpsest_opt])

    # Send query
    response = dns.query.udp(q, '8.8.8.8')

    # Extract license metadata from response
    for option in response.options:
        if isinstance(option, PalimpsestOption):
            license = option.parse_response()
            print(f"License: {license['license']}")
            print(f"NI Consent Required: {license['flags']['ni_consent']}")
            print(f"Metadata URL: {license.get('metadata_url', 'N/A')}")
            return license

    return None

# Example
license = query_with_license('example.org')
```

#### JavaScript (Node.js)

```javascript
const dgram = require('dgram');
const dnsPacket = require('dns-packet');

class PalimpsestEDNS {
  static OPTION_CODE = 65400;

  static encodeRequest() {
    return Buffer.from([0x01]); // Request flag
  }

  static decodeResponse(data) {
    if (data.length < 6) return null;

    const version = data[0];
    const flags = data[1];
    const licenseVer = (data[2] << 8) | data[3];

    const metadata = {
      version,
      license: `v${licenseVer >> 8}.${licenseVer & 0xFF}`,
      flags: {
        niConsent: !!(flags & 0x80),
        metadataPreservation: !!(flags & 0x40),
        emotionalLineage: !!(flags & 0x20),
        daoGoverned: !!(flags & 0x10),
        quantumProof: !!(flags & 0x08),
        dnssecRequired: !!(flags & 0x04),
      }
    };

    // Parse TLVs
    let pos = 6;
    while (pos < data.length) {
      if (pos + 2 > data.length) break;

      const type = data[pos];
      const length = data[pos + 1];
      const value = data.slice(pos + 2, pos + 2 + length);

      if (type === 0x01) { // METADATA-URL
        metadata.metadataUrl = value.toString('utf8');
      } else if (type === 0x02) { // HASH
        metadata.hash = value.toString('hex');
      }

      pos += 2 + length;
    }

    return metadata;
  }

  static async query(domain, type = 'A', nameserver = '8.8.8.8') {
    return new Promise((resolve, reject) => {
      const socket = dgram.createSocket('udp4');

      // Construct DNS query with PALIMPSEST EDNS option
      const query = dnsPacket.encode({
        type: 'query',
        id: Math.floor(Math.random() * 65536),
        flags: dnsPacket.RECURSION_DESIRED,
        questions: [{
          type,
          name: domain
        }],
        additionals: [{
          type: 'OPT',
          name: '.',
          udpPayloadSize: 4096,
          flags: 0,
          options: [{
            code: PalimpsestEDNS.OPTION_CODE,
            data: PalimpsestEDNS.encodeRequest()
          }]
        }]
      });

      socket.on('message', (msg) => {
        const response = dnsPacket.decode(msg);

        // Extract PALIMPSEST option from response
        const opt = response.additionals?.find(rr => rr.type === 'OPT');
        const palimpsestOpt = opt?.options?.find(o => o.code === PalimpsestEDNS.OPTION_CODE);

        if (palimpsestOpt) {
          const license = PalimpsestEDNS.decodeResponse(palimpsestOpt.data);
          resolve({ response, license });
        } else {
          resolve({ response, license: null });
        }

        socket.close();
      });

      socket.on('error', reject);

      socket.send(query, 53, nameserver);

      setTimeout(() => {
        socket.close();
        reject(new Error('DNS query timeout'));
      }, 5000);
    });
  }
}

// Usage
(async () => {
  const { response, license } = await PalimpsestEDNS.query('example.org');

  if (license) {
    console.log('License:', license.license);
    console.log('NI Consent Required:', license.flags.niConsent);
    console.log('Metadata URL:', license.metadataUrl);
  }
})();
```

## Security Considerations

### Option Injection Prevention

Prevent malicious injection of PALIMPSEST options:

1. **Validate option length:** Ensure OPTION-LENGTH matches actual data
2. **Sanity-check flags:** Reject invalid flag combinations
3. **Verify TLV structure:** Validate TLV encoding
4. **DNSSEC validation:** Require DNSSEC for authoritative responses

### Amplification Attack Mitigation

PALIMPSEST options increase response size, creating amplification risk:

**Mitigation strategies:**

- **Limit option size:** Maximum 512 bytes of metadata
- **Require DNSSEC:** Only include option in signed responses
- **Rate limiting:** Limit queries with PALIMPSEST option per client
- **Response policy:** Drop option for suspicious clients

### Privacy Considerations

EDNS options are visible to network observers:

- **Metadata exposure:** License info visible in plaintext
- **Mitigation:** Use DNS-over-TLS (DoT) or DNS-over-HTTPS (DoH)
- **Alternative:** Encrypt TLV values with domain public key

**Example: Encrypted metadata TLV**

```
TLV TYPE:     0xFF (Encrypted Metadata)
TLV LENGTH:   variable
TLV VALUE:    [Algorithm ID][Encrypted Data]

Algorithm IDs:
  0x01 = AES-256-GCM with domain's public key
  0x02 = ChaCha20-Poly1305 with ECDH key exchange
```

## Performance Considerations

### Response Size Impact

PALIMPSEST option adds overhead to DNS responses:

| Metadata | Approx Size | Impact |
|----------|-------------|--------|
| Basic flags only | 6 bytes | Minimal |
| + Metadata URL | 50 bytes | Low |
| + Hash | 38 bytes | Low |
| + Full metadata | 200 bytes | Moderate |

**UDP Fragmentation:**

- Standard DNS over UDP: 512 bytes
- EDNS: 4096 bytes (typical)
- Palimpsest with full metadata: ~250 bytes total
- **Result:** No fragmentation in typical cases

### Query Latency

Additional processing time:

- **Option parsing:** <1ms
- **Metadata lookup:** 1-5ms (cached)
- **Policy enforcement:** <1ms
- **Total overhead:** ~2-7ms

**Negligible impact** for most use cases.

### Caching Efficiency

License metadata cached alongside DNS records:

- **Memory overhead:** ~200 bytes per cached domain
- **For 1M cached domains:** ~200 MB additional memory
- **Acceptable** for modern resolver hardware

## Deployment Strategy

### Phase 1: Experimental Deployment (Months 1-6)

- Use private option code 65400
- Deploy on pilot authoritative servers
- Test with modified resolvers (BIND9, Unbound)
- Gather operational experience

### Phase 2: IANA Assignment (Months 6-18)

- Submit IETF Internet-Draft
- Request IANA option code assignment
- Migrate from experimental to official code
- Engage DNS software vendors

### Phase 3: Standardisation (Months 18-36)

- Publish RFC
- Native support in BIND9, Unbound, PowerDNS
- Integration with resolver products (Pi-hole, etc.)
- Industry-wide adoption

## Integration Examples

### CDN with EDNS License Awareness

```nginx
# Nginx with DNS module for license checking
http {
    resolver 8.8.8.8 edns=on palimpsest=on;

    server {
        listen 80;
        server_name example.org;

        location / {
            # Lua script to check license via EDNS
            access_by_lua_block {
                local dns = require "resty.dns.resolver"
                local r = dns:new{nameservers = {"8.8.8.8"}}

                -- Query with PALIMPSEST EDNS option
                local answers, err = r:query_with_edns(
                    ngx.var.host,
                    {qtype = r.TYPE_A, palimpsest_request = true}
                )

                if answers and answers.edns_palimpsest then
                    local license = answers.edns_palimpsest

                    -- Enforce NI consent
                    if license.flags.ni_consent then
                        if ngx.var.http_user_agent:match("GPTBot") then
                            ngx.exit(403)
                        end
                    end

                    -- Add headers
                    ngx.header["X-License"] = license.version
                    ngx.header["X-License-NI-Consent"] = tostring(license.flags.ni_consent)
                end
            }

            proxy_pass http://backend;
        }
    }
}
```

### Browser Extension

```javascript
// Browser extension to display license info
chrome.webRequest.onBeforeRequest.addListener(
  async (details) => {
    const url = new URL(details.url);

    // Query DNS with PALIMPSEST option
    const license = await queryPalimpsestDNS(url.hostname);

    if (license) {
      // Display license badge in browser UI
      chrome.action.setBadgeText({
        text: license.license,
        tabId: details.tabId
      });

      chrome.action.setBadgeBackgroundColor({
        color: license.flags.niConsent ? '#FF0000' : '#00FF00',
        tabId: details.tabId
      });

      // Warn user if NI consent required
      if (license.flags.niConsent) {
        chrome.notifications.create({
          type: 'basic',
          title: 'License Notice',
          message: `${url.hostname} requires non-interpretive consent`,
          iconUrl: 'icon.png'
        });
      }
    }
  },
  {urls: ["<all_urls>"]}
);
```

## Troubleshooting

### Common Issues

#### 1. Option Not Returned

**Symptom:** Query includes PALIMPSEST option, but response doesn't

**Possible causes:**
- Authoritative server doesn't support option
- Resolver strips unknown options
- EDNS not enabled

**Solutions:**
- Verify server software version and support
- Test with `dig +edns=0 +bufsize=4096`
- Check resolver configuration

#### 2. Malformed Option Data

**Symptom:** Option present but unparseable

**Possible causes:**
- Version mismatch
- Incorrect wire format
- Truncated response

**Solutions:**
- Verify VERSION field matches specification
- Check OPTION-LENGTH matches actual data length
- Increase UDP buffer size

#### 3. DNSSEC Validation Fails

**Symptom:** EDNS option present but DNSSEC validation fails

**Possible causes:**
- Option added after DNSSEC signing
- Signature doesn't cover OPT RR (expected behaviour)
- Resolver requires DNSSEC for license metadata

**Solutions:**
- OPT RR is never signed in DNSSEC (by design)
- Validate QNAME, not OPT RR
- Use authenticated channel (DoT/DoH) if DNSSEC insufficient

## Future Extensions

### Planned Enhancements

1. **Licensing Chain:** Include ancestor license information
2. **Multi-license support:** Multiple concurrent licenses
3. **Revocation lists:** License revocation via EDNS
4. **Temporal licensing:** Time-bound license metadata
5. **Geographic licensing:** Region-specific license terms

### Compatibility with Other EDNS Options

PALIMPSEST option designed to coexist with:

- **EDNS Client Subnet (ECS):** RFC 7871
- **COOKIE:** RFC 7873
- **CHAIN:** RFC 7901
- **Padding:** RFC 7830

**Example: Combined options**

```
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
; CLIENT-SUBNET: 192.0.2.0/24
; COOKIE: 0123456789abcdef
; PALIMPSEST: license=v0.4, flags=0xB4
```

## Conclusion

EDNS/OPT records provide an efficient, standards-based mechanism for propagating Palimpsest License metadata through DNS infrastructure. By embedding license information directly in DNS transactions, we enable real-time, resolver-level enforcement of creative rights.

**Key Benefits:**

- Single-query license verification
- Resolver-level policy enforcement
- Backward compatible with existing DNS
- Minimal performance overhead
- Foundation for future DNS-based rights management

**Implementation Priorities:**

1. Deploy experimental option code (65400)
2. Develop resolver plugins (BIND9, Unbound, PowerDNS)
3. Create client libraries (Python, JavaScript, Go)
4. Submit IETF Internet-Draft
5. Request IANA option code assignment

---

## References

- RFC 6891: Extension Mechanisms for DNS (EDNS(0))
- RFC 7871: Client Subnet in DNS Queries
- RFC 7873: Domain Name System (DNS) Cookies
- RFC 8914: Extended DNS Errors
- IANA EDNS Option Codes Registry

## Contact

Technical questions and feedback:
- Palimpsest DNS Working Group
- Email: edns@palimpsest.example
- GitHub: github.com/palimpsest-license/dns-edns

---

*This specification is part of the Palimpsest License infrastructure initiative. Implementation freely available under Palimpsest License v0.4.*
