# BIMI Implementation Guide
**Brand Indicators for Message Identification**

**Palimpsest License Project**
Version 1.0 | Last Updated: 2025-11-22

---

## Table of Contents

1. [Introduction](#introduction)
2. [What is BIMI?](#what-is-bimi)
3. [Why BIMI Matters for Palimpsest](#why-bimi-matters-for-palimpsest)
4. [Prerequisites](#prerequisites)
5. [Implementation Steps](#implementation-steps)
6. [DNS Configuration](#dns-configuration)
7. [Logo Requirements](#logo-requirements)
8. [Verification Mark Certificate (VMC)](#verification-mark-certificate-vmc)
9. [Testing and Validation](#testing-and-validation)
10. [Troubleshooting](#troubleshooting)
11. [Maintenance](#maintenance)
12. [Security Considerations](#security-considerations)
13. [Palimpsest-Specific Considerations](#palimpsest-specific-considerations)
14. [Resources](#resources)

---

## Introduction

This guide provides comprehensive instructions for implementing Brand Indicators for Message Identification (BIMI) for the Palimpsest License Project. BIMI is an email authentication standard that allows organisations to display their logos in email clients, providing visual verification of email authenticity.

### Purpose

For the Palimpsest License Project, BIMI serves critical functions:
- **Trust verification:** Confirms official communications from the project
- **Brand protection:** Prevents impersonation and phishing
- **Professional presentation:** Enhances recognition and credibility
- **Anti-exploitation:** Aligns with our mission to prevent identity theft and misrepresentation

---

## What is BIMI?

**Brand Indicators for Message Identification (BIMI)** is an email specification that enables mail transfer agents (MTAs) and mail user agents (MUAs) to display brand logos alongside authenticated emails.

### Key Features

- **Logo Display:** Shows organisation logo in email inbox
- **Authentication Required:** Requires DMARC, SPF, and DKIM implementation
- **Trust Signal:** Provides visual confirmation of sender authenticity
- **Industry Standard:** Supported by major email providers (Gmail, Yahoo, Apple Mail, etc.)

### How BIMI Works

1. **Email Sent:** Organisation sends email with proper authentication
2. **Authentication Check:** Receiving server validates DMARC, SPF, DKIM
3. **BIMI Lookup:** Server queries BIMI DNS record
4. **Logo Retrieval:** Server fetches logo from specified location
5. **Logo Display:** Email client displays logo if all checks pass

---

## Why BIMI Matters for Palimpsest

### Alignment with Project Mission

The Palimpsest License exists to protect creators from exploitation, metadata stripping, and misattribution. BIMI directly supports these goals:

1. **Prevents Impersonation**
   - Stops bad actors from posing as official Palimpsest communications
   - Protects community from phishing attacks
   - Maintains integrity of governance communications

2. **Preserves Identity Metadata**
   - Visual logo is a form of identity metadata
   - Demonstrates our commitment to attribution
   - Practices what we preach regarding metadata preservation

3. **Builds Trust**
   - Community members can visually verify official emails
   - Security advisories are more trustworthy
   - Governance announcements are authenticated

4. **Professional Credibility**
   - Shows we're serious about our mission
   - Demonstrates technical competence
   - Increases adoption confidence

### Use Cases for Palimpsest

- **Governance Announcements:** Council votes, policy changes
- **Security Advisories:** Vulnerability disclosures, urgent warnings
- **Community Updates:** Newsletters, major milestones
- **Legal Notices:** License updates, compliance information
- **Partnership Communications:** Outreach to organisations

---

## Prerequisites

Before implementing BIMI, ensure the following are in place:

### 1. Email Authentication (Required)

#### SPF (Sender Policy Framework)
```dns
palimpsest-license.org. IN TXT "v=spf1 include:_spf.google.com ~all"
```
- **Status:** Must be configured
- **Purpose:** Authorises mail servers to send on behalf of domain
- **Requirement:** Must pass SPF alignment

#### DKIM (DomainKeys Identified Mail)
```dns
default._domainkey.palimpsest-license.org. IN TXT "v=DKIM1; k=rsa; p=[public-key]"
```
- **Status:** Must be configured
- **Purpose:** Cryptographically signs emails
- **Requirement:** Must pass DKIM alignment

#### DMARC (Domain-based Message Authentication)
```dns
_dmarc.palimpsest-license.org. IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc-reports@palimpsest-license.org; ruf=mailto:dmarc-forensics@palimpsest-license.org; pct=100; adkim=s; aspf=s"
```
- **Status:** Must be configured with enforcement policy
- **Policy Required:** `p=quarantine` or `p=reject` (not `p=none`)
- **Alignment:** Strict alignment recommended (`adkim=s; aspf=s`)

### 2. Domain Control

- **Verified Ownership:** Must control DNS for palimpsest-license.org
- **DNS Access:** Ability to add TXT records
- **DNSSEC (Optional but Recommended):** Enhanced security

### 3. Logo Assets

- **SVG Format:** Tiny Portable/Secure (SVG Tiny PS) required
- **Square Aspect Ratio:** 1:1 ratio
- **Size:** Minimum 32px × 32px, recommended 512px × 512px or larger
- **File Size:** Under 32KB recommended
- **Hosting:** HTTPS-accessible URL

### 4. Verification Mark Certificate (VMC) - Optional but Recommended

- **Commercial CA:** DigiCert, Entrust offer VMC services
- **Trademark:** Requires registered trademark (or legal entity)
- **Cost:** Approximately $1,000-$1,500/year
- **Status for Palimpsest:** Deferred until formal entity established

---

## Implementation Steps

### Step 1: Verify Email Authentication

Before implementing BIMI, ensure all email authentication is working:

```bash
# Check SPF record
dig TXT palimpsest-license.org

# Check DKIM record (replace 'default' with actual selector)
dig TXT default._domainkey.palimpsest-license.org

# Check DMARC record
dig TXT _dmarc.palimpsest-license.org
```

**Validation Tools:**
- MXToolbox: https://mxtoolbox.com/
- DMARC Analyzer: https://www.dmarcanalyzer.com/
- Google Admin Toolbox: https://toolbox.googleapps.com/apps/checkmx/

### Step 2: Create BIMI Logo

#### Requirements

Create a logo meeting SVG Tiny PS specifications:

**SVG Tiny PS Profile:**
```xml
<svg version="1.2" baseProfile="tiny-ps"
     xmlns="https://www.w3.org/2000/svg"
     viewBox="0 0 512 512">
  <!-- Logo content here -->
</svg>
```

**Key Constraints:**
- No external resources (embedded fonts, linked images)
- No JavaScript
- No animations
- Limited filter effects
- Solid colours or simple gradients

#### Palimpsest Logo Specifications

For the Palimpsest License Project:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<svg version="1.2" baseProfile="tiny-ps"
     xmlns="https://www.w3.org/2000/svg"
     viewBox="0 0 512 512"
     width="512" height="512">
  <title>Palimpsest License Logo</title>
  <desc>
    Official logo for the Palimpsest License Project.
    Represents layered text (palimpsest) with preservation of
    underlying traces (emotional lineage and attribution).
  </desc>

  <!-- Background circle (optional) -->
  <circle cx="256" cy="256" r="240" fill="#2C3E50" />

  <!-- Layered text representation -->
  <!-- Layer 1: Faded background layer (older text) -->
  <text x="256" y="200"
        font-family="serif"
        font-size="120"
        text-anchor="middle"
        fill="#7F8C8D"
        opacity="0.3">
    P
  </text>

  <!-- Layer 2: Middle layer (partially visible) -->
  <text x="256" y="200"
        font-family="serif"
        font-size="120"
        text-anchor="middle"
        fill="#95A5A6"
        opacity="0.5"
        transform="rotate(10 256 256)">
    P
  </text>

  <!-- Layer 3: Top layer (current, most visible) -->
  <text x="256" y="200"
        font-family="serif"
        font-size="120"
        text-anchor="middle"
        fill="#ECF0F1">
    P
  </text>

  <!-- Subtitle text -->
  <text x="256" y="320"
        font-family="sans-serif"
        font-size="32"
        text-anchor="middle"
        fill="#ECF0F1">
    PALIMPSEST
  </text>

  <!-- Metadata preservation symbol (optional) -->
  <path d="M 220 360 L 292 360 M 256 360 L 256 400"
        stroke="#3498DB"
        stroke-width="4"
        fill="none" />
</svg>
```

**Note:** This is a conceptual example. The actual logo should be designed by a professional graphic designer and approved by the Stewardship Council.

#### Validation

Validate the SVG using the BIMI SVG validator:
- **BIMI Group Validator:** https://bimigroup.org/svg-conversion-tools/

### Step 3: Host the Logo

Host the validated SVG logo on a secure, publicly accessible URL:

**Requirements:**
- **Protocol:** HTTPS only (TLS 1.2 or higher)
- **URL:** Permanent, unchanging location
- **CORS:** Allow cross-origin requests
- **Cache:** Appropriate cache headers

**Recommended Locations:**

```
Option 1: Main domain
https://palimpsest-license.org/assets/brand/bimi-logo.svg

Option 2: Subdomain
https://bimi.palimpsest-license.org/logo.svg

Option 3: CDN (with fallback)
https://cdn.palimpsest-license.org/bimi/logo.svg
```

**HTTP Headers:**
```http
Content-Type: image/svg+xml
Access-Control-Allow-Origin: *
Cache-Control: public, max-age=86400
```

### Step 4: Configure DNS BIMI Record

Add a BIMI DNS TXT record:

#### Basic BIMI Record (Without VMC)

```dns
default._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg;"
```

#### BIMI Record with VMC (Future)

```dns
default._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg; a=https://palimpsest-license.org/assets/certs/vmc.pem;"
```

#### Multiple Selectors (If Needed)

```dns
# Default selector
default._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg;"

# Governance selector (for council communications)
governance._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-governance.svg;"

# Security selector (for security advisories)
security._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-security.svg;"
```

**Selector Usage:**

The selector matches the DKIM selector in the email header:
```
BIMI-Selector: v=BIMI1; s=default;
```

### Step 5: Update Email Headers

Configure your email sending system to include the BIMI-Selector header:

```
From: governance@palimpsest-license.org
BIMI-Selector: v=BIMI1; s=default;
Subject: Palimpsest License v0.4 Release Announcement
```

Most modern email systems support this through configuration.

---

## DNS Configuration

### Full DNS Record Set

Here's the complete DNS configuration for Palimpsest License email authentication and BIMI:

```dns
; SPF Record
palimpsest-license.org. IN TXT "v=spf1 include:_spf.google.com ~all"

; DKIM Record (example with Google Workspace)
google._domainkey.palimpsest-license.org. IN TXT "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC..."

; DMARC Record
_dmarc.palimpsest-license.org. IN TXT "v=DMARC1; p=quarantine; rua=mailto:dmarc-reports@palimpsest-license.org; ruf=mailto:dmarc-forensics@palimpsest-license.org; pct=100; adkim=s; aspf=s; fo=1"

; BIMI Record
default._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg;"

; Optional: DNSSEC (requires registrar support)
; palimpsest-license.org. DNSKEY, RRSIG, DS records
```

### DNS Propagation

After adding records:
- **Propagation Time:** 1-48 hours typical
- **TTL:** Set appropriate TTL (3600 seconds = 1 hour recommended)
- **Verification:** Use `dig` or online tools to confirm

```bash
# Verify BIMI record
dig TXT default._bimi.palimpsest-license.org
```

---

## Logo Requirements

### Technical Specifications

| Requirement | Specification |
|-------------|---------------|
| **Format** | SVG Tiny PS (Portable/Secure) |
| **Version** | SVG 1.2, baseProfile="tiny-ps" |
| **Aspect Ratio** | 1:1 (square) |
| **Minimum Size** | 32px × 32px |
| **Recommended Size** | 512px × 512px or larger |
| **File Size** | Under 32KB (smaller is better) |
| **Colours** | Solid colours or simple gradients |
| **Fonts** | Embedded or converted to paths |
| **External Resources** | Not allowed (no linked images/fonts) |
| **Scripts** | Not allowed (no JavaScript) |
| **Animations** | Not allowed |

### Design Guidelines

For the Palimpsest License Project:

1. **Symbolism:**
   - Represent layered text (palimpsest concept)
   - Show preservation of underlying traces
   - Convey protection and care

2. **Recognisability:**
   - Clear at small sizes (32px × 32px)
   - Distinct from other license logos
   - Memorable and unique

3. **Accessibility:**
   - Sufficient contrast for visibility
   - Works in monochrome
   - Clear alt text in SVG

4. **Brand Consistency:**
   - Matches other project branding
   - Consistent colour palette
   - Harmonises with website design

### Conversion Tools

If you have a logo in another format:

- **BIMI Group Converter:** https://bimigroup.org/svg-conversion-tools/
- **Inkscape:** Export to SVG Tiny (manual cleanup needed)
- **Adobe Illustrator:** Save as SVG Tiny (with manual validation)

**Important:** Always validate the final SVG against BIMI requirements.

---

## Verification Mark Certificate (VMC)

### What is a VMC?

A Verification Mark Certificate is an extended validation certificate that:
- Verifies legal ownership of trademark
- Provides additional trust signal
- Enables logo display in more email clients
- Demonstrates organisational legitimacy

### Obtaining a VMC

#### Current VMC Providers:
1. **DigiCert:** https://www.digicert.com/bimi
2. **Entrust:** https://www.entrust.com/bimi

#### Requirements:
- Registered trademark
- Legal business entity
- Domain ownership verification
- Organisation validation
- Cost: ~$1,000-$1,500 per year

### Palimpsest Status

**Current Status:** VMC deferred

**Rationale:**
- Palimpsest is currently a community project without legal entity
- No registered trademark yet
- Cost prohibitive at this stage
- Many email clients support BIMI without VMC (Gmail, Yahoo)

**Future Plan:**
- Establish legal entity (foundation or DAO)
- Register "Palimpsest License" trademark
- Obtain VMC to maximise trust
- Timeline: v1.0 formal release or later

### Implementing VMC (When Available)

1. **Obtain VMC from Provider:**
   - Submit trademark documentation
   - Verify organisation details
   - Complete validation process
   - Receive VMC in PEM format

2. **Host VMC Certificate:**
   ```
   https://palimpsest-license.org/assets/certs/vmc.pem
   ```

3. **Update BIMI DNS Record:**
   ```dns
   default._bimi.palimpsest-license.org. IN TXT "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg; a=https://palimpsest-license.org/assets/certs/vmc.pem;"
   ```

4. **Test and Validate:**
   - Use BIMI Inspector
   - Send test emails
   - Verify certificate chain

---

## Testing and Validation

### Validation Tools

1. **BIMI Inspector:**
   - https://bimigroup.org/bimi-generator/
   - Comprehensive BIMI record validator
   - Checks DNS, logo, authentication

2. **Google BIMI Checker:**
   - Send test email to Gmail address
   - Check "Show original" in Gmail
   - Look for BIMI-related headers

3. **MXToolbox BIMI Lookup:**
   - https://mxtoolbox.com/bimi.aspx
   - Quick DNS record verification

4. **Email on Acid:**
   - https://www.emailonacid.com/
   - Comprehensive email testing (paid service)

### Testing Procedure

#### Step 1: Validate DNS Records

```bash
# Check BIMI record
dig TXT default._bimi.palimpsest-license.org

# Expected output:
# "v=BIMI1; l=https://palimpsest-license.org/assets/brand/bimi-logo.svg;"

# Check DMARC enforcement
dig TXT _dmarc.palimpsest-license.org

# Verify p=quarantine or p=reject
```

#### Step 2: Validate Logo

1. Navigate to logo URL in browser
2. Verify HTTPS works and certificate is valid
3. Confirm SVG displays correctly
4. Use BIMI SVG validator

#### Step 3: Send Test Emails

Send authenticated emails to:
- Gmail account
- Yahoo account
- Apple Mail (iCloud)
- Outlook/Hotmail (limited support)

#### Step 4: Verify Logo Display

In Gmail:
1. Open test email
2. Look for logo next to sender name
3. Click "Show original" to see BIMI headers

Expected headers:
```
BIMI-Indicator: Verified
BIMI-Location: https://palimpsest-license.org/assets/brand/bimi-logo.svg
```

### Troubleshooting Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Logo not displaying | DMARC not enforcing | Set `p=quarantine` or `p=reject` |
| Logo 404 error | Incorrect URL | Verify logo URL is accessible |
| SSL error | HTTP instead of HTTPS | Use HTTPS for logo hosting |
| SVG invalid | Doesn't meet Tiny PS | Re-validate and fix SVG |
| DNS not found | Propagation delay | Wait 24-48 hours, check TTL |
| Authentication fail | SPF/DKIM/DMARC issues | Fix email authentication first |

---

## Maintenance

### Regular Checks

#### Monthly:
- Verify logo URL is still accessible
- Check DMARC reports for authentication issues
- Review BIMI DNS record for changes

#### Quarterly:
- Test BIMI display across email clients
- Update logo if branding changes
- Review BIMI Group for standard updates

#### Annually:
- Renew VMC (when applicable)
- Assess need for logo refresh
- Review compliance with latest BIMI standards

### Monitoring

Set up monitoring for:

1. **Logo Availability:**
   ```bash
   # Uptime monitoring (e.g., UptimeRobot)
   Monitor: https://palimpsest-license.org/assets/brand/bimi-logo.svg
   Frequency: Every 5 minutes
   Alert: If down > 5 minutes
   ```

2. **DNS Record Changes:**
   - Use DNS monitoring service
   - Alert on unexpected TXT record modifications

3. **DMARC Reports:**
   - Parse RUA/RUF reports
   - Alert on authentication failures
   - Track BIMI adoption rates

### Updates

When updating the logo:

1. Design new logo meeting SVG Tiny PS requirements
2. Validate new logo
3. Host new logo at temporary URL
4. Test new logo via BIMI Inspector
5. Update DNS record to point to new logo
6. Wait for DNS propagation
7. Verify new logo displays correctly
8. Archive old logo (maintain old URL for transition period)

---

## Security Considerations

### Threat Model

BIMI-related security concerns for Palimpsest:

1. **Logo Tampering:**
   - Attacker modifies hosted SVG
   - Mitigation: Integrity monitoring, HTTPS, access controls

2. **DNS Hijacking:**
   - Attacker modifies BIMI DNS record
   - Mitigation: DNSSEC, DNS provider security, 2FA

3. **Phishing with Similar Logo:**
   - Attacker creates similar logo for fake domain
   - Mitigation: Trademark protection, user education, VMC

4. **Man-in-the-Middle:**
   - Attacker intercepts logo requests
   - Mitigation: HTTPS, HSTS, certificate pinning

5. **SVG Exploits:**
   - Malicious SVG attempts client-side attacks
   - Mitigation: Strict SVG Tiny PS compliance, validation

### Security Best Practices

1. **Logo Hosting:**
   - Use HTTPS with strong TLS configuration
   - Implement HSTS
   - Consider CDN with DDoS protection
   - Regular security audits

2. **DNS Security:**
   - Enable DNSSEC
   - Use DNS provider with strong security
   - Enable 2FA on DNS management account
   - Monitor for unauthorised changes

3. **Access Control:**
   - Limit who can modify logo file
   - Limit who can modify DNS records
   - Log all changes
   - Regular access audits

4. **Monitoring:**
   - Alert on logo file modifications
   - Alert on DNS changes
   - Monitor for phishing attempts
   - Track DMARC authentication failures

5. **Incident Response:**
   - Have plan for compromised logo
   - Have plan for compromised DNS
   - Communication strategy for security incidents
   - Backup DNS provider

---

## Palimpsest-Specific Considerations

### Alignment with Project Values

BIMI implementation should reflect Palimpsest's core values:

1. **Metadata Preservation:**
   - SVG includes detailed `<title>` and `<desc>` tags
   - Logo file includes creation metadata
   - Attribution preserved in all contexts

2. **Transparency:**
   - Logo design process documented publicly
   - Community input on logo selection
   - Open discussion of BIMI implementation

3. **Accessibility:**
   - Logo works for colourblind users
   - Clear at all sizes
   - Semantic SVG structure
   - Alt text provided

4. **Cultural Sensitivity:**
   - Logo doesn't appropriate cultural symbols
   - Design respects diverse communities
   - Inclusive visual language

### Community Involvement

1. **Logo Design:**
   - Proposal process through GitHub Issues
   - Community vote on final designs
   - Stewardship Council approval required
   - Designer attribution preserved

2. **Implementation Review:**
   - Technical implementation reviewed by community
   - Security considerations discussed openly
   - Documentation maintained transparently

### Governance Integration

BIMI is part of Palimpsest's broader governance:

1. **Logo Changes:**
   - Require Stewardship Council vote (5/7 majority)
   - Community discussion period (minimum 30 days)
   - Version control for logo iterations

2. **DNS Management:**
   - Multi-signature approval for DNS changes
   - Documented in governance logs
   - Transparent decision-making

---

## Resources

### Official BIMI Resources

- **BIMI Group:** https://bimigroup.org/
- **BIMI Specification:** https://bimigroup.org/resources/
- **BIMI Inspector:** https://bimigroup.org/bimi-generator/
- **SVG Conversion Tools:** https://bimigroup.org/svg-conversion-tools/

### Email Authentication

- **DMARC.org:** https://dmarc.org/
- **SPF Record Syntax:** https://www.rfc-editor.org/rfc/rfc7208
- **DKIM Specification:** https://www.rfc-editor.org/rfc/rfc6376

### Testing Tools

- **MXToolbox:** https://mxtoolbox.com/
- **DMARC Analyzer:** https://www.dmarcanalyzer.com/
- **Google Admin Toolbox:** https://toolbox.googleapps.com/apps/checkmx/
- **Mail Tester:** https://www.mail-tester.com/

### VMC Providers

- **DigiCert BIMI:** https://www.digicert.com/bimi
- **Entrust BIMI:** https://www.entrust.com/bimi

### Email Client Support

- **Gmail:** Full BIMI support (with or without VMC)
- **Yahoo Mail:** Full BIMI support
- **Apple Mail:** BIMI support (iOS 16+, macOS Ventura+)
- **Outlook/Hotmail:** Partial support (evolving)
- **Fastmail:** BIMI support

### Palimpsest Resources

- **Project Website:** https://palimpsest-license.org
- **Repository:** https://github.com/palimpsest-license/palimpsest-license
- **Security Policy:** /SECURITY.md
- **Trust Information:** /trust.txt
- **Contact:** technical@palimpsest-license.org

---

## Implementation Checklist

Use this checklist to track BIMI implementation progress:

### Prerequisites
- [ ] SPF configured and passing
- [ ] DKIM configured and passing
- [ ] DMARC configured with `p=quarantine` or `p=reject`
- [ ] Domain control verified
- [ ] DNS access confirmed

### Logo Creation
- [ ] Logo designed meeting BIMI requirements
- [ ] SVG Tiny PS format validated
- [ ] Square aspect ratio (1:1)
- [ ] File size under 32KB
- [ ] Tested at multiple sizes
- [ ] Community approval obtained (if required)
- [ ] Stewardship Council approval obtained

### Hosting
- [ ] Logo uploaded to secure server
- [ ] HTTPS URL confirmed working
- [ ] CORS headers configured
- [ ] Cache headers configured
- [ ] Accessibility verified (HTTPS, uptime)

### DNS Configuration
- [ ] BIMI DNS TXT record created
- [ ] Selector chosen (default or custom)
- [ ] DNS propagation verified
- [ ] Record syntax validated

### Testing
- [ ] BIMI Inspector validation passed
- [ ] Test emails sent to Gmail
- [ ] Test emails sent to Yahoo
- [ ] Test emails sent to Apple Mail
- [ ] Logo displays correctly in inbox
- [ ] BIMI headers present in email source

### Monitoring
- [ ] Logo URL uptime monitoring configured
- [ ] DNS change monitoring configured
- [ ] DMARC reporting configured
- [ ] Alert system established

### Documentation
- [ ] Implementation documented
- [ ] Community notified
- [ ] Changelog updated
- [ ] Security policy updated (if needed)

### Future (VMC)
- [ ] Legal entity established
- [ ] Trademark registered
- [ ] VMC provider selected
- [ ] VMC obtained
- [ ] VMC certificate hosted
- [ ] BIMI DNS record updated with VMC URL
- [ ] VMC renewal calendar reminder set

---

## Conclusion

BIMI implementation for the Palimpsest License Project serves both practical and philosophical purposes. It protects our community from impersonation while demonstrating our commitment to metadata preservation and trust verification—core values of the license itself.

By following this guide, we establish a secure, authentic communication channel with our community, partners, and adopters. As the project evolves toward formal release and potential legal entity formation, BIMI will remain a critical component of our trust infrastructure.

### Next Steps

1. **Design Logo:** Engage community in logo design process
2. **Implement Authentication:** Ensure SPF, DKIM, DMARC are robust
3. **Deploy BIMI:** Follow implementation steps in this guide
4. **Test Thoroughly:** Validate across email clients
5. **Monitor Continuously:** Maintain vigilance on security
6. **Plan for VMC:** Prepare for trademark and legal entity

### Questions or Assistance

For help with BIMI implementation:
- **Technical:** technical@palimpsest-license.org
- **Security:** security@palimpsest-license.org
- **General:** contact@palimpsest-license.org

### Feedback

This guide is a living document. If you find errors, have suggestions for improvement, or encounter implementation challenges, please:
- Open an issue: https://github.com/palimpsest-license/palimpsest-license/issues
- Submit a pull request with improvements
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
