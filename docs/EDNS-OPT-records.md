# EDNS and OPT Records Specification
**Extension Mechanisms for DNS**

**Palimpsest License Project**
Version 1.0 | Last Updated: 2025-11-22

---

## Table of Contents

1. [Introduction](#introduction)
2. [What is EDNS?](#what-is-edns)
3. [Why EDNS Matters for Palimpsest](#why-edns-matters-for-palimpsest)
4. [Technical Overview](#technical-overview)
5. [OPT Resource Records](#opt-resource-records)
6. [Implementation Guide](#implementation-guide)
7. [DNSSEC Integration](#dnssec-integration)
8. [Custom EDNS Options for Palimpsest](#custom-edns-options-for-palimpsest)
9. [Security Considerations](#security-considerations)
10. [Testing and Validation](#testing-and-validation)
11. [Troubleshooting](#troubleshooting)
12. [Use Cases](#use-cases)
13. [Future Directions](#future-directions)
14. [Resources](#resources)

---

## Introduction

This document provides a comprehensive specification for implementing Extension Mechanisms for DNS (EDNS) and OPT resource records for the Palimpsest License Project. EDNS enables enhanced DNS functionality critical for modern internet infrastructure, including larger DNS messages, DNSSEC validation, and custom metadata transport.

### Purpose

For the Palimpsest License Project, EDNS serves several critical functions:

- **Enhanced Security:** Enables DNSSEC for cryptographic verification of DNS records
- **Metadata Transport:** Allows transmission of license metadata via DNS
- **Larger Payloads:** Supports complex license information in DNS responses
- **Client Subnet:** Enables geographic-aware license verification
- **Future-Proofing:** Provides extensibility for quantum-proof attribution mechanisms

### Scope

This guide covers:
- EDNS fundamentals and configuration
- OPT pseudo-resource records
- DNSSEC integration
- Custom EDNS options for license metadata
- Implementation best practices
- Security considerations

---

## What is EDNS?

**Extension Mechanisms for DNS (EDNS)** is a specification that extends the original DNS protocol to overcome limitations and add new capabilities.

### Background

Original DNS (RFC 1035) has limitations:
- **UDP Payload:** Limited to 512 bytes
- **No Extensibility:** Fixed message format
- **No Security:** No built-in authentication or integrity
- **No Metadata:** Limited ability to convey additional information

EDNS (RFC 6891) addresses these by:
- **Larger Messages:** UDP payloads up to 4,096 bytes (or more)
- **OPT Records:** Pseudo-RR for options and flags
- **Extensible Options:** Framework for new DNS features
- **DNSSEC Support:** Enables cryptographic validation

### Key Features

1. **OPT Resource Record:**
   - Pseudo-RR in additional section of DNS messages
   - Conveys extended flags and options
   - Negotiates buffer sizes

2. **Extended DNS Flags:**
   - DNSSEC OK (DO) flag
   - Version field for future extensions
   - Extended RCODE for error conditions

3. **EDNS Options:**
   - Client Subnet (ECS)
   - DNS Cookies
   - Padding
   - Chain queries
   - Custom options (experimental)

---

## Why EDNS Matters for Palimpsest

### Alignment with Project Mission

The Palimpsest License's core mission—protecting creators through cryptographic attribution and metadata preservation—directly benefits from EDNS:

1. **DNSSEC for Trust:**
   - Cryptographically verify license metadata
   - Prevent DNS spoofing of license information
   - Ensure integrity of attribution chains
   - Support quantum-proof signatures (future)

2. **Metadata Transport:**
   - Convey license metadata in DNS queries
   - Enable machine-readable license verification
   - Support distributed attribution systems
   - Facilitate DAO governance mechanisms

3. **Enhanced License Verification:**
   - Larger payloads for complex license terms
   - Structured metadata in DNS responses
   - Geographic-aware licensing (via ECS)
   - Attribution chain verification

4. **Future-Proofing:**
   - Quantum-resistant cryptography support
   - Extensible for emerging technologies
   - Adaptation to evolving AI verification needs
   - Support for decentralised systems

### Use Cases

1. **License Verification API:**
   ```bash
   # Query license status for a work
   dig +dnssec TXT license-verify.palimpsest-license.org
   ```

2. **Attribution Chain Lookup:**
   ```bash
   # Retrieve attribution chain via DNS
   dig +dnssec TXT attribution.[work-hash].palimpsest-license.org
   ```

3. **Metadata Retrieval:**
   ```bash
   # Get machine-readable metadata
   dig +dnssec TXT metadata.[version].palimpsest-license.org
   ```

4. **DNSSEC Validation:**
   ```bash
   # Verify cryptographic signatures
   dig +dnssec +multi DNSKEY palimpsest-license.org
   ```

---

## Technical Overview

### EDNS Message Format

EDNS extends DNS messages using an OPT pseudo-resource record in the additional section.

#### Standard DNS Message Structure:
```
+---------------------+
|       Header        |
+---------------------+
|      Question       |
+---------------------+
|       Answer        |
+---------------------+
|      Authority      |
+---------------------+
|     Additional      |  <-- OPT RR goes here
+---------------------+
```

#### OPT Resource Record Structure:
```
Field          Octets   Description
----------------------------------------------
NAME           1        Root domain (0x00)
TYPE           2        OPT (41)
CLASS          2        requestor's UDP payload size
TTL            4        extended RCODE and flags
RDLEN          2        length of RDATA
RDATA          variable EDNS options
```

### EDNS Version

Current EDNS version: **0** (EDNS0)

Format in OPT RR TTL field:
```
 0: Extended RCODE
 1: Version (currently 0)
 2: DO flag (DNSSEC OK)
 3: Z (reserved, must be 0)
```

### Buffer Sizes

EDNS negotiates larger UDP buffer sizes:

| Context | Recommended Size |
|---------|------------------|
| **Default DNS** | 512 bytes |
| **EDNS Minimum** | 512 bytes |
| **EDNS Recommended** | 1,232 bytes (RFC 6891) |
| **EDNS Common** | 4,096 bytes |
| **EDNS Maximum** | 65,535 bytes (UDP limit) |

**Palimpsest Recommendation:** 4,096 bytes for license metadata

---

## OPT Resource Records

### OPT RR Fields

#### NAME
- Always root domain (`.`)
- Encoded as single zero octet (0x00)

#### TYPE
- Value: **41** (OPT)
- Indicates this is an EDNS OPT pseudo-RR

#### CLASS
- Repurposed to indicate **requestor's UDP payload size**
- Example: 4096 (0x1000) = 4 KB buffer

#### TTL (32 bits)
```
 0      7 8    15 16   23 24   31
+--------+--------+--------+--------+
|  Ext   |Version |   DO   |    Z   |
| RCODE  |        |  Flag  |        |
+--------+--------+--------+--------+
```

- **Extended RCODE:** High 8 bits of extended 12-bit RCODE
- **Version:** EDNS version (0 currently)
- **DO Flag:** DNSSEC OK bit (bit 15)
- **Z:** Reserved (must be 0)

#### RDLEN
- Length of RDATA section in octets
- Contains EDNS option(s)

#### RDATA
- Variable-length field
- Contains zero or more EDNS options
- Each option has: Option-Code, Option-Length, Option-Data

### EDNS Option Format

Each EDNS option in RDATA:
```
+---+---+---+---+---+---+---+---+---+---+---+---+
| OPTION-CODE (16 bits)                         |
+---+---+---+---+---+---+---+---+---+---+---+---+
| OPTION-LENGTH (16 bits)                       |
+---+---+---+---+---+---+---+---+---+---+---+---+
| OPTION-DATA (variable)                        |
+---+---+---+---+---+---+---+---+---+---+---+---+
```

---

## Implementation Guide

### Prerequisites

1. **DNS Server:**
   - BIND 9.9+ (supports EDNS0, DNSSEC)
   - PowerDNS 4.0+ (supports EDNS0, DNSSEC)
   - Knot DNS 2.0+ (recommended for DNSSEC)
   - CloudFlare DNS (managed, supports EDNS/DNSSEC)

2. **DNSSEC Tools:**
   - `dnssec-keygen`: Generate DNSSEC keys
   - `dnssec-signzone`: Sign DNS zones
   - `delv`: DNSSEC validation utility
   - `drill`: DNS debugging tool with DNSSEC support

3. **Control:**
   - Authoritative control over palimpsest-license.org
   - Ability to configure DNS server
   - Access to DNSSEC key management

### Step 1: Enable EDNS on DNS Server

#### BIND Configuration

Edit `/etc/bind/named.conf.options`:

```conf
options {
    // Enable EDNS
    edns-udp-size 4096;
    max-udp-size 4096;

    // Enable DNSSEC validation
    dnssec-enable yes;
    dnssec-validation auto;

    // Minimal responses (efficiency)
    minimal-responses yes;

    // IPv6 support
    listen-on-v6 { any; };
};
```

#### PowerDNS Configuration

Edit `/etc/powerdns/pdns.conf`:

```conf
# Enable EDNS
edns-subnet-processing=yes
max-packet-cache-entries=4096

# Enable DNSSEC
dnssec=yes
default-ksk-algorithm=ecdsap256sha256
default-zsk-algorithm=ecdsap256sha256
```

#### Knot DNS Configuration

Edit `/etc/knot/knot.conf`:

```yaml
server:
    # Enable EDNS
    max-udp-payload: 4096

    # Enable DNSSEC
    automatic-dnssec: on

zone:
  - domain: palimpsest-license.org
    dnssec-signing: on
    dnssec-policy: default
```

### Step 2: Configure EDNS Buffer Size

Set appropriate buffer size for license metadata:

**Recommended:** 4,096 bytes (balances payload and fragmentation)

**Rationale:**
- Sufficient for complex license metadata
- Avoids IP fragmentation issues
- Widely supported by resolvers
- Compatible with network MTUs

**Configuration:**
```conf
# BIND
edns-udp-size 4096;

# PowerDNS
udp-truncation-threshold=4096

# Knot DNS
max-udp-payload: 4096
```

### Step 3: Enable DNSSEC

#### Generate DNSSEC Keys

```bash
# Key Signing Key (KSK) - ECDSA P-256
dnssec-keygen -a ECDSAP256SHA256 -b 256 -f KSK -n ZONE palimpsest-license.org

# Zone Signing Key (ZSK) - ECDSA P-256
dnssec-keygen -a ECDSAP256SHA256 -b 256 -n ZONE palimpsest-license.org
```

**Output:**
```
Kpalimpsest-license.org.+013+12345.key
Kpalimpsest-license.org.+013+12345.private
Kpalimpsest-license.org.+013+54321.key
Kpalimpsest-license.org.+013+54321.private
```

#### Sign the Zone

```bash
# Sign zone file
dnssec-signzone -A -3 $(head -c 16 /dev/urandom | xxd -p) -N INCREMENT \
    -o palimpsest-license.org -t db.palimpsest-license.org

# Output: db.palimpsest-license.org.signed
```

#### Update Zone File

```conf
# Add DNSKEY records to zone
$INCLUDE Kpalimpsest-license.org.+013+12345.key
$INCLUDE Kpalimpsest-license.org.+013+54321.key
```

#### Publish DS Record

Extract DS record for parent zone (.org):
```bash
dnssec-dsfromkey Kpalimpsest-license.org.+013+12345.key
```

**Output:**
```
palimpsest-license.org. IN DS 12345 13 2 [SHA-256 hash]
```

Submit this DS record to your domain registrar.

### Step 4: Configure EDNS Client Subnet (Optional)

Enable geographic-aware responses:

#### BIND Configuration:
```conf
options {
    // Enable ECS
    ecs-ipv4-prefix-length 24;
    ecs-ipv6-prefix-length 56;
};
```

#### Use Case for Palimpsest:
- Geographic-specific licensing terms
- Jurisdiction-aware metadata
- Regional DAO governance nodes

### Step 5: Test EDNS Configuration

```bash
# Test basic EDNS support
dig +edns=0 +bufsize=4096 @ns1.palimpsest-license.org palimpsest-license.org

# Test DNSSEC validation
dig +dnssec @ns1.palimpsest-license.org palimpsest-license.org

# Verify DNSKEY records
dig +dnssec +multi DNSKEY palimpsest-license.org

# Validate with delv
delv @ns1.palimpsest-license.org palimpsest-license.org
```

---

## DNSSEC Integration

### DNSSEC Overview

DNSSEC provides:
- **Authentication:** Verify DNS data origin
- **Integrity:** Detect DNS data tampering
- **Denial of Existence:** Authenticated negative responses

### DNSSEC Records

#### DNSKEY
Contains public keys for zone:
```dns
palimpsest-license.org. 86400 IN DNSKEY 256 3 13 [ZSK public key]
palimpsest-license.org. 86400 IN DNSKEY 257 3 13 [KSK public key]
```

#### RRSIG
Cryptographic signature over RRset:
```dns
palimpsest-license.org. 86400 IN RRSIG A 13 2 86400 20251222000000 20251122000000 12345 palimpsest-license.org. [signature]
```

#### DS
Delegation Signer in parent zone (.org):
```dns
palimpsest-license.org. 86400 IN DS 12345 13 2 [hash of KSK]
```

#### NSEC/NSEC3
Authenticated denial of existence:
```dns
palimpsest-license.org. 86400 IN NSEC3 1 0 10 AABBCCDD [hash] A NS SOA TXT RRSIG DNSKEY NSEC3PARAM
```

### Key Management

#### Algorithm Selection

**Recommended for Palimpsest:**
- **Algorithm:** ECDSA Curve P-256 with SHA-256 (ECDSAP256SHA256, #13)
- **Key Size:** 256 bits
- **Rationale:**
  - Modern, efficient algorithm
  - Strong security (128-bit security level)
  - Smaller signatures than RSA
  - Quantum-resistant migration path

**Alternative (Quantum-Resistant, Future):**
- **Algorithm:** EdDSA (when DNSSEC support matures)
- **Post-Quantum:** SPHINCS+, Dilithium (experimental)

#### Key Rotation

**ZSK (Zone Signing Key):**
- **Frequency:** Every 3 months
- **Method:** Pre-publish, double-sign, remove old

**KSK (Key Signing Key):**
- **Frequency:** Annually
- **Method:** Double-KSK, update DS at registrar

**Automation:**
```bash
# Automated key rotation with Knot DNS
knot.conf:
  policy:
    - id: default
      algorithm: ecdsap256sha256
      ksk-lifetime: 365d
      zsk-lifetime: 90d
      propagation-delay: 1h
      rrsig-lifetime: 14d
```

### Chain of Trust

```
. (root)
  |
  ├─ .org (TLD)
  │    |
  │    └─ palimpsest-license.org (our zone)
  │         |
  │         └─ license-verify.palimpsest-license.org (subdomain)
```

**Validation Path:**
1. Resolver queries license-verify.palimpsest-license.org
2. Retrieves RRSIG from our zone
3. Retrieves DNSKEY from our zone
4. Retrieves DS from .org
5. Retrieves DNSKEY from .org
6. Retrieves DS from root
7. Validates entire chain

---

## Custom EDNS Options for Palimpsest

### Designing Custom EDNS Options

EDNS allows custom options for experimental use:

**Option Code Ranges:**
- 0-65000: Standardised and experimental
- 65001-65534: Reserved for local/experimental use
- 65535: Reserved

**Palimpsest Custom Options:**

We propose experimental EDNS options for license metadata transport:

#### Option 65100: License Metadata Query

**Purpose:** Request license metadata for a work

**Format:**
```
Option-Code: 65100
Option-Length: Variable
Option-Data:
  +---+---+---+---+---+---+---+---+
  | Version (1 byte)              |
  +---+---+---+---+---+---+---+---+
  | Hash Algorithm (1 byte)       |
  +---+---+---+---+---+---+---+---+
  | Work Hash (32 bytes SHA-256)  |
  +---+---+---+---+---+---+---+---+
```

**Usage:**
```bash
# Query license for work (conceptual)
dig +edns-opt=65100:[version:1][algo:SHA256][hash:...] \
    license.palimpsest-license.org TXT
```

#### Option 65101: Attribution Chain Request

**Purpose:** Retrieve cryptographic attribution chain

**Format:**
```
Option-Code: 65101
Option-Length: Variable
Option-Data:
  +---+---+---+---+---+---+---+---+
  | Depth (1 byte, 0=full chain)  |
  +---+---+---+---+---+---+---+---+
  | Chain ID (32 bytes)           |
  +---+---+---+---+---+---+---+---+
```

#### Option 65102: Quantum-Proof Signature

**Purpose:** Request quantum-resistant signature verification

**Format:**
```
Option-Code: 65102
Option-Length: Variable
Option-Data:
  +---+---+---+---+---+---+---+---+
  | Algorithm (1 byte)            |
  +---+---+---+---+---+---+---+---+
  | Signature Request ID          |
  +---+---+---+---+---+---+---+---+
```

**Quantum Algorithms:**
- 0x01: Classical (ECDSA P-256)
- 0x10: SPHINCS+ (stateless hash-based)
- 0x11: Dilithium (lattice-based)
- 0x12: Falcon (lattice-based)

### Implementation Example

#### DNS Server Plugin (Conceptual)

```python
#!/usr/bin/env python3
# Palimpsest EDNS Option Handler (Conceptual)

from dnslib import DNSRecord, EDNS0, RR, TXT
import hashlib

EDNS_OPTION_LICENSE_METADATA = 65100
EDNS_OPTION_ATTRIBUTION_CHAIN = 65101

def handle_license_query(work_hash):
    """
    Retrieve license metadata for a work hash.
    Returns TXT record with JSON-LD license metadata.
    """
    # Look up work in license database
    metadata = license_db.get(work_hash)

    if metadata:
        # Return license metadata as JSON-LD TXT record
        return TXT(metadata.to_jsonld())
    else:
        # Return NXDOMAIN or empty response
        return None

def handle_attribution_chain(chain_id, depth=0):
    """
    Retrieve attribution chain for a work.
    Returns TXT records with cryptographic attribution data.
    """
    chain = attribution_db.get_chain(chain_id, depth)

    # Return chain as multiple TXT records
    return [TXT(link.to_dns_format()) for link in chain]

def edns_handler(request):
    """
    Process EDNS options in DNS query.
    """
    edns = request.get_edns()

    if not edns:
        return None

    for option in edns.options:
        if option.code == EDNS_OPTION_LICENSE_METADATA:
            work_hash = parse_license_option(option.data)
            return handle_license_query(work_hash)

        elif option.code == EDNS_OPTION_ATTRIBUTION_CHAIN:
            chain_id, depth = parse_attribution_option(option.data)
            return handle_attribution_chain(chain_id, depth)

    return None
```

### Security Considerations for Custom Options

1. **Validation:**
   - Verify option format before processing
   - Sanitise input data
   - Rate-limit queries

2. **Privacy:**
   - Don't leak sensitive metadata
   - Consider query privacy implications
   - Log appropriately

3. **Performance:**
   - Cache responses
   - Limit computational cost
   - Set query size limits

---

## Security Considerations

### Threat Model

EDNS/DNSSEC security concerns for Palimpsest:

1. **DNS Spoofing:**
   - Attacker forges DNS responses
   - Mitigation: DNSSEC validation

2. **DNS Amplification:**
   - Attacker uses large EDNS responses for DDoS
   - Mitigation: Response rate limiting (RRL)

3. **Key Compromise:**
   - DNSSEC private keys stolen
   - Mitigation: Hardware security modules (HSM), key rotation

4. **Quantum Computing:**
   - Future quantum computers break ECDSA
   - Mitigation: Plan migration to post-quantum algorithms

5. **Cache Poisoning:**
   - Attacker poisons resolver cache
   - Mitigation: DNSSEC, randomised query IDs

### Security Best Practices

#### 1. DNSSEC Key Security

**Key Storage:**
- Store private keys on separate, secure system
- Use HSM for KSK (hardware security module)
- Encrypt ZSK backups
- Restrict access (multi-person control)

**Key Rotation:**
```bash
# Automated rotation with monitoring
# Schedule: ZSK every 3 months, KSK annually

# Pre-publish new ZSK
dnssec-keygen -a ECDSAP256SHA256 -b 256 -n ZONE palimpsest-license.org

# Update zone with both keys (overlap period)
# Sign with both ZSKs for rollover period
# Remove old ZSK after TTL expiration
```

#### 2. Response Rate Limiting

Prevent DNS amplification attacks:

**BIND Configuration:**
```conf
rate-limit {
    responses-per-second 10;
    errors-per-second 5;
    nxdomains-per-second 5;
    window 10;
};
```

**PowerDNS Configuration:**
```conf
max-qperq=10
max-total-msec=500
```

#### 3. Query Logging

Monitor for suspicious activity:

```conf
logging {
    channel queries {
        file "/var/log/named/queries.log" versions 3 size 10m;
        severity info;
        print-time yes;
        print-category yes;
    };
    category queries { queries; };
};
```

#### 4. DNSSEC Monitoring

Automated monitoring for:
- Signature expiration
- Key rollover status
- Validation failures
- DS record synchronisation

**Tools:**
- **DNSViz:** https://dnsviz.net/
- **Zonemaster:** https://zonemaster.net/
- **DNSSEC Analyzer:** https://dnssec-debugger.verisignlabs.com/

#### 5. Quantum-Resistant Planning

Prepare for post-quantum migration:

**Current:**
- ECDSA P-256 (128-bit security)
- Regular monitoring of NIST PQC standards

**Transition Plan:**
- Monitor DNSSEC working group for PQC algorithms
- Test experimental implementations
- Plan migration to SPHINCS+, Dilithium, or EdDSA
- Dual-signature approach during transition

**Timeline:**
- 2025-2027: Monitor standards development
- 2028-2030: Begin experimental testing
- 2030+: Production deployment (as standards mature)

---

## Testing and Validation

### Testing Tools

1. **dig (Domain Information Groper):**
   ```bash
   # Basic EDNS query
   dig +edns=0 +bufsize=4096 palimpsest-license.org

   # DNSSEC validation
   dig +dnssec palimpsest-license.org

   # Detailed DNSKEY info
   dig +dnssec +multi DNSKEY palimpsest-license.org
   ```

2. **delv (Domain Entity Lookup and Validation):**
   ```bash
   # Validate DNSSEC chain
   delv @8.8.8.8 palimpsest-license.org

   # Detailed validation output
   delv +vtrace palimpsest-license.org
   ```

3. **drill (DNS Debugging Tool):**
   ```bash
   # Trace DNSSEC chain
   drill -D -T palimpsest-license.org

   # Check specific record with DNSSEC
   drill -D TXT palimpsest-license.org
   ```

4. **dnsviz (DNS Visualisation):**
   ```bash
   # Generate visualisation
   dnsviz probe palimpsest-license.org > probe.json
   dnsviz graph -r probe.json -T png -O

   # Or use online: https://dnsviz.net/d/palimpsest-license.org/dnssec/
   ```

### Validation Checklist

#### EDNS Configuration
- [ ] EDNS version 0 advertised correctly
- [ ] UDP buffer size set to 4,096 bytes
- [ ] DO (DNSSEC OK) flag supported
- [ ] Extended RCODE functioning
- [ ] Handles truncated responses correctly

#### DNSSEC Validation
- [ ] DNSKEY records published
- [ ] Zone properly signed with RRSIG
- [ ] DS record in parent zone (.org)
- [ ] Chain of trust validates from root
- [ ] NSEC/NSEC3 for authenticated denial
- [ ] Key rollover procedures tested

#### Security Validation
- [ ] Response rate limiting configured
- [ ] Query logging enabled
- [ ] Key storage secured
- [ ] Signature expiration monitoring
- [ ] No validation errors in dnsviz
- [ ] DNSSEC Analyzer shows green

#### Performance Validation
- [ ] Query response time < 100ms
- [ ] Large responses don't fragment
- [ ] Cache hit ratio > 80%
- [ ] No resolver timeout issues

### Automated Testing Script

```bash
#!/bin/bash
# Palimpsest EDNS/DNSSEC Validation Script

DOMAIN="palimpsest-license.org"
NS="ns1.palimpsest-license.org"

echo "=== Palimpsest EDNS/DNSSEC Validation ==="
echo

# Test 1: Basic EDNS support
echo "[1/8] Testing EDNS support..."
dig +edns=0 +noall +comments @${NS} ${DOMAIN} | grep -q "EDNS"
if [ $? -eq 0 ]; then
    echo "✓ EDNS supported"
else
    echo "✗ EDNS not detected"
fi
echo

# Test 2: Buffer size negotiation
echo "[2/8] Testing buffer size (4096 bytes)..."
dig +edns=0 +bufsize=4096 +noall +comments @${NS} ${DOMAIN} | grep "EDNS.*udp:4096"
echo

# Test 3: DNSSEC validation
echo "[3/8] Testing DNSSEC validation..."
delv @${NS} ${DOMAIN} > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✓ DNSSEC validates successfully"
else
    echo "✗ DNSSEC validation failed"
fi
echo

# Test 4: DNSKEY records
echo "[4/8] Checking DNSKEY records..."
dig +dnssec DNSKEY @${NS} ${DOMAIN} | grep "DNSKEY.*256\|257"
echo

# Test 5: DS record in parent
echo "[5/8] Checking DS record in parent (.org)..."
dig +dnssec DS @a.gtld-servers.net ${DOMAIN} | grep "^${DOMAIN}.*DS"
echo

# Test 6: RRSIG signatures
echo "[6/8] Verifying RRSIG signatures..."
dig +dnssec A @${NS} ${DOMAIN} | grep "RRSIG.*A"
echo

# Test 7: Chain of trust
echo "[7/8] Validating chain of trust..."
drill -D -T ${DOMAIN} | grep -c "VALID"
echo

# Test 8: DNSViz check
echo "[8/8] Generating DNSViz report..."
echo "Visit: https://dnsviz.net/d/${DOMAIN}/dnssec/"
echo

echo "=== Validation Complete ==="
```

---

## Troubleshooting

### Common Issues

#### 1. EDNS Not Supported

**Symptom:**
```
dig +edns=0 palimpsest-license.org
; EDNS: version: 0, flags:; udp: 512
```

**Cause:** DNS server not configured for EDNS

**Solution:**
```conf
# Enable EDNS in BIND
edns-udp-size 4096;
```

#### 2. DNSSEC Validation Fails

**Symptom:**
```
delv palimpsest-license.org
; validating palimpsest-license.org/A: unable to find a DNSKEY which verifies the DNSKEY RRset
```

**Causes:**
- DS record not in parent zone
- Incorrect DNSKEY
- Signature expired
- Clock skew

**Solutions:**
```bash
# Check DS record
dig +dnssec DS palimpsest-license.org @a.gtld-servers.net

# Verify signatures not expired
dig +dnssec +multi DNSKEY palimpsest-license.org

# Check system time
date -u
```

#### 3. Truncated Responses

**Symptom:**
```
;; Truncated, retrying in TCP mode.
```

**Cause:** Response exceeds UDP buffer size

**Solution:**
- Increase buffer size: `+bufsize=4096`
- Enable TCP fallback (automatic in most resolvers)
- Reduce response size (fewer records)

#### 4. Amplification Attacks

**Symptom:** High DNS query volume, large responses

**Solution:**
```conf
# Enable response rate limiting
rate-limit {
    responses-per-second 10;
    window 5;
};

# Log suspicious queries
logging {
    category rate-limit { default_log; };
};
```

#### 5. Key Rollover Issues

**Symptom:** Validation failures during key rollover

**Solution:**
- Follow proper rollover procedure (pre-publish, double-sign, remove old)
- Ensure sufficient TTL overlap
- Monitor DS record synchronisation
- Test before removing old key

### Debug Commands

```bash
# Detailed EDNS/DNSSEC information
dig +dnssec +multi +trace palimpsest-license.org

# Check specific nameserver
dig @ns1.palimpsest-license.org +dnssec palimpsest-license.org

# Validate DNSSEC chain
delv +vtrace palimpsest-license.org

# Visual DNSSEC analysis
drill -D -T palimpsest-license.org

# Query logs
tail -f /var/log/named/queries.log

# DNSSEC status
rndc dnssec -status palimpsest-license.org
```

---

## Use Cases

### 1. License Verification API

Query license status for a creative work:

```bash
# Query license for work hash
dig +dnssec TXT [work-hash].license.palimpsest-license.org

# Response (conceptual):
;; ANSWER SECTION:
[hash].license.palimpsest-license.org. 300 IN TXT "license=Palimpsest-v0.4"
[hash].license.palimpsest-license.org. 300 IN TXT "creator=Jane Doe"
[hash].license.palimpsest-license.org. 300 IN TXT "ni-consent=required"
[hash].license.palimpsest-license.org. 300 IN RRSIG TXT 13 5 300 ...
```

### 2. Attribution Chain Verification

Retrieve cryptographic attribution chain:

```bash
# Query attribution chain
dig +dnssec TXT attribution.[chain-id].palimpsest-license.org

# Response includes:
# - Original creator
# - Derivative works
# - Transformation history
# - Cryptographic signatures
```

### 3. DAO Governance Queries

Query DAO governance metadata:

```bash
# Query current governance state
dig +dnssec TXT governance.palimpsest-license.org

# Response:
;; ANSWER SECTION:
governance.palimpsest-license.org. 300 IN TXT "council-members=7"
governance.palimpsest-license.org. 300 IN TXT "current-vote=v0.5-proposal"
governance.palimpsest-license.org. 300 IN TXT "vote-status=active"
```

### 4. Quantum-Proof Signatures

Future: Query quantum-resistant signatures:

```bash
# Request post-quantum signature verification
dig +edns-opt=65102:[algo:SPHINCS+] +dnssec \
    TXT quantum-sig.[work-hash].palimpsest-license.org

# Response includes:
# - Classical ECDSA signature (current)
# - SPHINCS+ signature (quantum-resistant)
# - Dilithium signature (alternative PQC)
```

### 5. Geographic License Enforcement

Use EDNS Client Subnet for jurisdiction-aware licensing:

```bash
# Query with client subnet (EU)
dig +subnet=185.0.0.0/16 TXT license.palimpsest-license.org

# Response may vary based on jurisdiction:
# - EU: GDPR-compliant metadata handling
# - US: DMCA-specific provisions
# - NL: Dutch law primacy
```

---

## Future Directions

### Post-Quantum DNSSEC

**Timeline:** 2028-2035

**Algorithms Under Consideration:**
- **SPHINCS+:** Hash-based signatures (stateless)
- **Dilithium:** Lattice-based signatures
- **Falcon:** Lattice-based signatures (compact)
- **EdDSA:** Transition algorithm (not PQC, but efficient)

**Migration Strategy:**
1. **Phase 1 (2025-2027):** Monitor NIST PQC standardisation
2. **Phase 2 (2028-2030):** Experimental deployment
3. **Phase 3 (2030-2033):** Dual-signature mode (classical + PQC)
4. **Phase 4 (2033+):** Full PQC deployment

**Challenges:**
- Larger signature sizes (especially SPHINCS+, Dilithium)
- DNS message size constraints (may require TCP)
- Algorithm maturity and standardisation
- Resolver support

### Decentralised DNS

**Integration with Blockchain/IPFS:**

Palimpsest may integrate with decentralised naming systems:

- **Ethereum Name Service (ENS):** palimpsest-license.eth
- **Handshake:** palimpsest-license/ (TLD)
- **IPFS:** Immutable content addressing
- **Namecoin:** Decentralised .bit domains

**Benefits:**
- Censorship resistance
- Immutable attribution records
- DAO-native governance
- No single point of failure

**Challenges:**
- Performance (blockchain latency)
- Adoption and tooling
- Interoperability with traditional DNS
- Cost (gas fees)

### AI-Specific EDNS Options

**Proposed EDNS Options for AI Systems:**

- **Option 65200:** AI Training Consent Flag
  - Indicates whether content may be used for AI training
  - Queryable by crawlers before scraping

- **Option 65201:** LLM Attribution Requirement
  - Specifies attribution format for LLM outputs
  - Machine-readable metadata for AI systems

- **Option 65202:** Emotional Lineage Metadata
  - Conveys emotional/cultural context
  - Helps AI preserve narrative intent

**Implementation:**
```bash
# Query AI training consent
dig +edns-opt=65200 ai-consent.palimpsest-license.org TXT

# Response:
;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags: do; udp: 4096
; OPT=65200: [consent=required; ni-clause=1.2]
```

### Integration with Compliance Tools

**DNS-Based Compliance API:**

Develop comprehensive DNS-based license verification:

```bash
# Compliance check endpoint
dig +dnssec TXT compliance.[content-hash].palimpsest-license.org

# Response includes:
# - License version
# - Consent requirements
# - Metadata preservation rules
# - Attribution format
# - Cryptographic proofs
```

**Benefits:**
- Automated compliance checking
- Integration with CI/CD pipelines
- Real-time verification
- Decentralised trust

---

## Resources

### RFCs and Standards

- **RFC 6891:** Extension Mechanisms for DNS (EDNS0)
  - https://www.rfc-editor.org/rfc/rfc6891
- **RFC 4033-4035:** DNSSEC Protocol Documents
  - https://www.rfc-editor.org/rfc/rfc4033 (Introduction)
  - https://www.rfc-editor.org/rfc/rfc4034 (Resource Records)
  - https://www.rfc-editor.org/rfc/rfc4035 (Protocol Modifications)
- **RFC 7873:** Domain Name System (DNS) Cookies
  - https://www.rfc-editor.org/rfc/rfc7873
- **RFC 7871:** Client Subnet in DNS Queries (ECS)
  - https://www.rfc-editor.org/rfc/rfc7871
- **RFC 8914:** Extended DNS Errors
  - https://www.rfc-editor.org/rfc/rfc8914

### DNSSEC Resources

- **DNSSEC Guide:** https://www.dnssec-tools.org/
- **ICANN DNSSEC:** https://www.icann.org/resources/pages/dnssec
- **Cloudflare DNSSEC:** https://www.cloudflare.com/dns/dnssec/
- **NIST DNSSEC Guide:** https://csrc.nist.gov/publications/detail/sp/800-81/2/final

### Tools

- **BIND:** https://www.isc.org/bind/
- **PowerDNS:** https://www.powerdns.com/
- **Knot DNS:** https://www.knot-dns.cz/
- **DNSViz:** https://dnsviz.net/
- **DNSSEC Analyzer:** https://dnssec-debugger.verisignlabs.com/
- **Zonemaster:** https://zonemaster.net/

### Post-Quantum Cryptography

- **NIST PQC:** https://csrc.nist.gov/projects/post-quantum-cryptography
- **SPHINCS+:** https://sphincs.org/
- **Dilithium:** https://pq-crystals.org/dilithium/
- **Falcon:** https://falcon-sign.info/

### Palimpsest Resources

- **Project Website:** https://palimpsest-license.org
- **Repository:** https://github.com/palimpsest-license/palimpsest-license
- **Documentation:** https://palimpsest-license.org/docs/
- **Technical Contact:** technical@palimpsest-license.org
- **Security Contact:** security@palimpsest-license.org

---

## Conclusion

EDNS and DNSSEC provide critical infrastructure for the Palimpsest License Project's mission of protecting creators through cryptographic attribution and metadata preservation. By implementing robust DNS extensions, we enable:

- **Secure verification** of license metadata
- **Cryptographic attribution** chains
- **Quantum-resistant** future-proofing
- **Decentralised** trust mechanisms
- **Machine-readable** compliance checking

As we move toward formal release and potential integration with decentralised systems, EDNS will remain a foundational technology enabling trustworthy, tamper-proof license verification.

### Next Steps

1. **Enable EDNS:** Configure DNS servers with appropriate buffer sizes
2. **Implement DNSSEC:** Deploy keys, sign zones, publish DS records
3. **Test Thoroughly:** Validate using DNSViz, delv, and other tools
4. **Monitor Continuously:** Track signature expiration, validation, attacks
5. **Plan for Future:** Prepare for post-quantum migration

### Questions or Assistance

For help with EDNS/DNSSEC implementation:
- **Technical:** technical@palimpsest-license.org
- **Security:** security@palimpsest-license.org
- **General:** contact@palimpsest-license.org

### Feedback

This document is living and evolving. Please contribute improvements via:
- GitHub Issues: https://github.com/palimpsest-license/palimpsest-license/issues
- Pull Requests: https://github.com/palimpsest-license/palimpsest-license/pulls
- Email: documentation@palimpsest-license.org

---

**Document Information**

- **Version:** 1.0
- **Last Updated:** 2025-11-22
- **Next Review:** 2026-06-01
- **Maintained By:** Palimpsest Stewardship Council
- **License:** Palimpsest License v0.4

**Changelog:**
- **2025-11-22:** Initial version created

---

*"This is a license born not just from copyright, but from care."*

**Palimpsest License Project**
palimpsest-license.org
