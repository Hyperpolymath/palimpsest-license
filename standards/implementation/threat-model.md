# Creative Works Consent Framework: Threat Model Analysis

**Version**: 1.0
**Date**: 2025-11-22
**Status**: Draft

## Executive Summary

This document provides a comprehensive threat model analysis for the Creative Works Consent Framework (CWCF). It identifies potential security threats, privacy risks, attack vectors, and mitigation strategies to ensure the framework protects creator rights whilst enabling responsible AI development.

**Key Findings**:
* **Primary threats**: Consent declaration tampering, lineage tag stripping, governance impersonation
* **Attack surface**: HTTP endpoints, JSON parsing, cryptographic verification, blockchain integration
* **Risk level**: Moderate to high for high-value creative works
* **Mitigation status**: Most threats have technical and legal countermeasures

---

## Table of Contents

1. [Threat Modelling Methodology](#1-threat-modelling-methodology)
2. [Assets and Trust Boundaries](#2-assets-and-trust-boundaries)
3. [Threat Categories](#3-threat-categories)
4. [Detailed Threat Analysis](#4-detailed-threat-analysis)
5. [Attack Scenarios](#5-attack-scenarios)
6. [Mitigations](#6-mitigations)
7. [Residual Risks](#7-residual-risks)
8. [Security Recommendations](#8-security-recommendations)

---

## 1. Threat Modelling Methodology

### 1.1. Framework

This analysis uses the **STRIDE** methodology:

* **Spoofing**: Impersonating creators or governance bodies
* **Tampering**: Modifying consent declarations or lineage tags
* **Repudiation**: Denying actions (e.g., consent granted or revoked)
* **Information Disclosure**: Exposing sensitive creator data
* **Denial of Service**: Preventing consent verification
* **Elevation of Privilege**: Gaining unauthorised permissions

### 1.2. Scope

**In Scope**:
* Consent declaration creation, storage, and retrieval
* Lineage tag generation and verification
* Governance mechanisms (individual, collective, DAO)
* HTTP/HTTPS transport
* Cryptographic signatures and verification
* Blockchain integration

**Out of Scope**:
* AI model architecture security
* Content hosting infrastructure (except consent endpoints)
* Payment processing systems
* User authentication on creator websites (beyond consent signing)

### 1.3. Assumptions

* **Creators use HTTPS**: HTTP transport is deprecated
* **Browsers enforce CORS**: Cross-origin requests follow CORS policies
* **DNS is reasonably secure**: DNSSEC and HTTPS mitigate most DNS attacks
* **Certificate authorities are trustworthy**: TLS certificate validation works
* **Blockchain networks function**: Ethereum and similar chains are operational

---

## 2. Assets and Trust Boundaries

### 2.1. Assets to Protect

| Asset | Value | Threat |
|-------|-------|--------|
| **Consent declarations** | High | Tampering, spoofing |
| **Lineage tags** | High | Stripping, falsification |
| **Creator identities** | Medium-High | Impersonation |
| **Governance credentials** | High | Forgery |
| **Private keys** | Critical | Theft, misuse |
| **Audit logs** | Medium | Deletion, tampering |
| **Cultural heritage metadata** | High | Unauthorised disclosure |

### 2.2. Trust Boundaries

```
┌─────────────────────────────────────────┐
│         Creator's Domain                │
│  ┌────────────────────────────────┐    │
│  │   Consent Declaration          │    │ ← Trust Boundary 1
│  │   (creator controls)           │    │
│  └────────────────────────────────┘    │
└─────────────────────────────────────────┘
                 ↓ HTTPS
┌─────────────────────────────────────────┐
│         Public Internet                 │ ← Trust Boundary 2
│         (untrusted)                     │
└─────────────────────────────────────────┘
                 ↓ Fetch
┌─────────────────────────────────────────┐
│      AI System / Verifier               │
│  ┌────────────────────────────────┐    │ ← Trust Boundary 3
│  │   Consent Verification         │    │
│  │   (AI company controls)        │    │
│  └────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

**Trust Boundary 1**: Creator's infrastructure
* **Trusted**: Creator can modify consent declarations
* **Risk**: Compromised web server could serve malicious declarations

**Trust Boundary 2**: Public internet
* **Untrusted**: Man-in-the-middle, DNS hijacking, BGP attacks
* **Mitigation**: HTTPS, DNSSEC, certificate pinning

**Trust Boundary 3**: AI system infrastructure
* **Semi-trusted**: AI company controls verification logic
* **Risk**: AI company could ignore consent or falsify compliance

---

## 3. Threat Categories

### 3.1. High Severity Threats

| ID | Threat | Impact | Likelihood |
|----|--------|--------|------------|
| T-01 | Consent declaration tampering by attacker | Critical | Medium |
| T-02 | Lineage tag stripping in AI outputs | High | High |
| T-03 | Governance body impersonation | High | Low |
| T-04 | Private key theft for signed declarations | Critical | Low |
| T-05 | Consent bypass by AI systems | Critical | Medium |

### 3.2. Medium Severity Threats

| ID | Threat | Impact | Likelihood |
|----|--------|--------|------------|
| T-06 | Denial of service on consent endpoints | Medium | Medium |
| T-07 | Consent confusion due to conflicting declarations | Medium | Medium |
| T-08 | Privacy leak of creator identity | Medium | Low |
| T-09 | Audit log tampering | Medium | Low |
| T-10 | Revocation notice suppression | Medium | Low |

### 3.3. Low Severity Threats

| ID | Threat | Impact | Likelihood |
|----|--------|--------|------------|
| T-11 | Declaration cache poisoning | Low | Low |
| T-12 | Metadata format confusion | Low | Medium |
| T-13 | Cross-site scripting in consent UI | Low | Medium |
| T-14 | Timezone manipulation in timestamps | Low | Low |

---

## 4. Detailed Threat Analysis

### Threat T-01: Consent Declaration Tampering

**Category**: Tampering
**STRIDE**: T (Tampering)

#### Description

An attacker modifies a consent declaration to change creator permissions:
* **Scenario 1**: Attacker compromises web server and changes `training: deny` to `training: allow`
* **Scenario 2**: Man-in-the-middle attack intercepts HTTP (not HTTPS) and modifies declaration
* **Scenario 3**: Attacker performs DNS hijacking to serve fake declaration

#### Attack Vectors

1. **Web server compromise**
   * Exploit: Unpatched CMS vulnerability
   * Access: SSH credential theft, SQL injection
   * Modification: Direct file edit or database update

2. **Man-in-the-middle**
   * Prerequisite: HTTP (not HTTPS) or compromised certificate authority
   * Method: ARP spoofing, rogue Wi-Fi, BGP hijacking
   * Modification: On-the-fly JSON rewriting

3. **DNS hijacking**
   * Exploit: Compromised DNS registrar account
   * Method: Change DNS records to point to attacker's server
   * Serve: Fake consent declaration

#### Impact

* **Creators**: Work used without consent, loss of control
* **AI systems**: Unknowingly violate creator rights
* **Legal**: Potential liability for AI companies relying on tampered declarations

#### Mitigations

1. **Cryptographic signatures** (Primary)
   * Sign declarations with creator's private key (JWS, PGP)
   * AI systems verify signature before trusting declaration
   * Prevents tampering by anyone without private key

2. **HTTPS enforcement** (Required)
   * TLS encrypts transport, prevents MITM
   * Certificate validation ensures authenticity
   * HTTP Strict Transport Security (HSTS) prevents downgrade attacks

3. **DNSSEC** (Recommended)
   * Cryptographically sign DNS records
   * Prevents DNS hijacking
   * Not universally deployed but increasingly common

4. **Content Security Policy** (Defense in depth)
   * Prevent XSS attacks on creator websites
   * Reduce server compromise risk

5. **Blockchain attestation** (Optional, high-value works)
   * Store declaration hash on immutable blockchain
   * Verifiers check on-chain hash matches fetched declaration
   * Expensive but tamper-proof

#### Likelihood: Medium
* Web compromises common
* HTTPS widely deployed (reduces risk)
* Signatures not yet mandatory (increases risk)

#### Residual Risk: Low (with signatures), Medium (without)

---

### Threat T-02: Lineage Tag Stripping

**Category**: Tampering
**STRIDE**: T (Tampering)

#### Description

An actor removes or obscures lineage tags from AI-generated outputs to hide provenance:
* **Scenario 1**: AI company strips JSON-LD lineage tags before publishing outputs
* **Scenario 2**: End user copies AI output and removes metadata
* **Scenario 3**: Platform hosting AI outputs strips structured data

#### Attack Vectors

1. **Intentional removal by AI operator**
   * Motivation: Avoid attribution obligations, hide training sources
   * Method: Delete `<script type="application/ld+json">` blocks
   * Detection: Difficult without watermarking

2. **Unintentional removal by platform**
   * Example: Medium, Twitter sanitise HTML and remove scripts
   * Method: Content Security Policy blocks inline scripts
   * Collateral damage: Lineage tags lost

3. **Copy-paste by end users**
   * Method: User copies rendered text, not HTML source
   * Result: Metadata lost in plain text copy

#### Impact

* **Creators**: Attribution lost, cannot trace influence
* **Provenance**: Breaks lineage chain
* **Legal**: Enforcement difficulty without evidence

#### Mitigations

1. **Multi-layer watermarking** (Primary)
   * **Visible**: Attribution in output text itself
   * **Invisible**: Steganographic watermarks in generated images/audio
   * **Metadata**: JSON-LD lineage tags
   * Redundancy ensures at least one survives

2. **Platform integration** (Recommended)
   * Work with major platforms (Medium, Twitter, LinkedIn) to preserve lineage tags
   * Standardised `<meta>` tags as alternative to `<script>`
   * API-level lineage propagation

3. **Blockchain lineage registry** (Optional)
   * Register all AI outputs on-chain with lineage data
   * Outputs include registry ID
   * Provenance verifiable even if metadata stripped

4. **Legal enforcement** (Defense in depth)
   * License terms prohibit lineage tag removal
   * Copyright law protection for metadata (varies by jurisdiction)
   * DMCA §1202 (US) prohibits removal of copyright management information

5. **User education** (Long-term)
   * Teach users to preserve attribution
   * Browser extensions auto-include lineage when copying
   * "Copy with attribution" functionality

#### Likelihood: High
* Easy to do (delete metadata)
* Incentives exist (avoid attribution)
* Detection difficult

#### Residual Risk: Medium
* Multi-layer watermarking reduces but doesn't eliminate risk
* Legal deterrence helps but not perfect

---

### Threat T-03: Governance Body Impersonation

**Category**: Spoofing
**STRIDE**: S (Spoofing)

#### Description

An attacker falsely claims to represent a collective governance body (e.g., DAO, Indigenous council):
* **Scenario 1**: Fake DAO smart contract address in declaration
* **Scenario 2**: Impersonated cultural steward grants consent without authority
* **Scenario 3**: Attacker creates lookalike domain for governance body

#### Attack Vectors

1. **Fake smart contract**
   * Attacker deploys smart contract with similar name
   * Lists fake contract address in consent declaration
   * AI system queries contract, gets fake approval

2. **Domain typosquatting**
   * Register `indigenous-counсil.org` (Cyrillic 'c')
   * Serve governance approval from fake domain
   * AI system doesn't detect subtle domain difference

3. **Compromised steward credentials**
   * Phish elder council member's signing key
   * Issue false consent approvals
   * Appears legitimate to verifiers

#### Impact

* **Communities**: Cultural works exploited without true consent
* **AI systems**: Unknowingly violate community rights
* **Trust**: Undermines governance framework credibility

#### Mitigations

1. **Verifiable Credentials** (Primary)
   * W3C Verifiable Credentials standard
   * Governance bodies issue signed credentials
   * AI systems verify credential signature and issuer DID
   * Prevents impersonation without private key

2. **Public registry** (Recommended)
   * Maintain registry of recognised governance bodies
   * DAOs: List verified smart contract addresses
   * Cultural bodies: List authorised steward DIDs
   * AI systems check registry before trusting

3. **Multi-signature requirements** (Defense in depth)
   * Require 3-of-5 steward signatures for high-value approvals
   * Reduces risk of single compromised key

4. **Domain verification** (Required)
   * Enforce HTTPS with valid certificates
   * Check for typosquatting (Levenshtein distance, IDN homographs)
   * Use ENS (Ethereum Name Service) for DAO identification

5. **Social verification** (Long-term)
   * Out-of-band verification for first consent
   * Phone call, video conference with governance body
   * Establish trusted relationship

#### Likelihood: Low
* Verifiable Credentials prevent most attacks
* Requires sophisticated attacker
* High-profile targets at higher risk

#### Residual Risk: Low (with Verifiable Credentials), High (without)

---

### Threat T-04: Private Key Theft

**Category**: Spoofing, Elevation of Privilege
**STRIDE**: S, E

#### Description

Attacker steals creator's or governance body's private key used to sign consent declarations:
* **Scenario 1**: Malware exfiltrates key from creator's device
* **Scenario 2**: Cloud service compromise exposes stored keys
* **Scenario 3**: Social engineering tricks creator into revealing key

#### Attack Vectors

1. **Malware**
   * Keylogger captures passphrase
   * File stealer exfiltrates `.pem` or `.key` files
   * Clipboard hijacker intercepts private key during copy

2. **Cloud compromise**
   * Creator stores key in Google Drive, Dropbox
   * Account hijacked via password reuse or phishing
   * Attacker downloads private key

3. **Social engineering**
   * Fake "technical support" requests key
   * Phishing email: "Verify your CWCF key"
   * Scam: "We need your key to publish your work"

#### Impact

* **Creators**: Attacker can issue false consent declarations
* **AI systems**: May unknowingly trust forged declarations
* **Revocation**: Difficult to revoke compromised key quickly
* **Reputation**: Creator's credibility undermined

#### Mitigations

1. **Hardware security keys** (Primary, high-value)
   * YubiKey, Ledger, Trezor
   * Private key never leaves hardware
   * Requires physical access to sign

2. **Key management best practices** (Required)
   * Never store unencrypted keys in cloud
   * Use password manager for passphrases
   * Generate keys on secure, offline device
   * Regular key rotation

3. **Key revocation mechanism** (Required)
   * CWCF specification includes key revocation
   * Creator publishes revocation certificate
   * AI systems check Certificate Revocation List (CRL)

4. **Multi-factor authentication** (Defense in depth)
   * Require second factor for key usage
   * Hardware token + passphrase
   * Biometric on mobile devices

5. **Short-lived keys** (Recommended)
   * Issue time-limited signing keys (90 days)
   * Reduces window of compromise
   * Automated rotation via key management service

6. **Transparency logs** (Optional, high-value)
   * Publish all signed declarations to public log (à la Certificate Transparency)
   * Creators monitor for unauthorised signatures
   * Rapid detection of key misuse

#### Likelihood: Low
* Requires targeted attack on creator
* Good key hygiene prevents most attacks
* High-value works more at risk

#### Residual Risk: Low (with hardware keys), Medium (with software keys)

---

### Threat T-05: Consent Bypass by AI Systems

**Category**: Elevation of Privilege
**STRIDE**: E

#### Description

AI system intentionally or unintentionally ignores consent declarations:
* **Scenario 1**: AI company scrapes content despite `training: deny`
* **Scenario 2**: Bug in verification code allows bypass
* **Scenario 3**: AI system uses cached content after consent revoked

#### Attack Vectors

1. **Intentional bypass**
   * Motivation: Acquire more training data, competitive advantage
   * Method: Disable consent checking in scraper
   * Detection: Forensic analysis of AI model (difficult)

2. **Implementation bugs**
   * Example: Verification library doesn't handle `conditional` correctly
   * Result: Content used despite unsatisfied requirements
   * Cause: Insufficient testing, misunderstanding spec

3. **Stale cache**
   * AI system caches consent declaration for 30 days
   * Creator revokes consent
   * AI system still uses cached `allow` declaration

4. **Fallback to permissive**
   * Specification recommends: if declaration unavailable, assume `deny`
   * Buggy implementation: if declaration unavailable, assume `allow`
   * Result: Consent violations

#### Impact

* **Creators**: Work exploited despite explicit denial
* **Legal**: Copyright infringement, license breach
* **Trust**: Undermines entire framework if widely ignored

#### Mitigations

1. **Legal enforcement** (Primary)
   * License breach provisions with statutory damages
   * Copyright infringement lawsuits
   * Regulatory enforcement (GDPR, AI Act, etc.)
   * Deterrence via high-profile cases

2. **Technical detection** (Recommended)
   * Watermarking: Embed invisible marks in content
   * Honeypot works: Publish canary documents with unique patterns
   * Model forensics: Analyse AI outputs for influence of denied works
   * Blockchain audit: Compare on-chain consent vs. actual usage

3. **Compliance transparency** (Required)
   * AI companies publish quarterly compliance reports
   * Statistics: % allowed, % denied, % conditional, % complied
   * Third-party audits verify reports
   * Public accountability

4. **Automated monitoring** (Defense in depth)
   * Consent registry notifies creator when declarations fetched
   * Anomaly detection: "Your deny declaration fetched 10,000 times by AICompany"
   * Investigate potential violations

5. **Cache invalidation** (Required)
   * Specification mandates cache revalidation within 24 hours
   * Creators can force cache bust via version number increment
   * Short cache TTL for revocation notices

6. **Test suite and conformance** (Required)
   * Comprehensive test suite for verification libraries
   * Certification program for compliant implementations
   * Public conformance reports

#### Likelihood: Medium
* Economic incentives to bypass
* Most companies will comply (legal risk)
* Some bad actors will ignore

#### Residual Risk: Medium
* Cannot force compliance technically
* Legal enforcement reactive, not preventive
* Requires robust legal framework

---

### Threat T-06: Denial of Service on Consent Endpoints

**Category**: Availability
**STRIDE**: D (Denial of Service)

#### Description

Attacker floods consent declaration endpoints, preventing legitimate AI systems from verifying consent:
* **Scenario 1**: DDoS attack on `/.well-known/creative-works-consent.json`
* **Scenario 2**: Slowloris attack exhausts server connections
* **Scenario 3**: Amplification attack via misconfigured verifiers

#### Attack Vectors

1. **Volumetric DDoS**
   * Botnet floods endpoint with requests (Gb/s)
   * Exhausts bandwidth, crashes server
   * CDN mitigation required

2. **Application-layer DDoS**
   * Expensive queries (if consent linked to database)
   * Complex JSON-LD resolution
   * CPU/memory exhaustion

3. **Amplification via verifiers**
   * Attacker triggers AI systems to fetch declarations from victim
   * AI system acts as amplifier
   * Victim overwhelmed by legitimate-looking traffic

#### Impact

* **Creators**: Consent declaration unavailable
* **AI systems**: Cannot verify consent, must assume deny (safe) or allow (risky)
* **Availability**: Service disruption

#### Mitigations

1. **CDN deployment** (Primary)
   * Cloudflare, Fastly, Akamai
   * DDoS mitigation built-in
   * Edge caching reduces origin load
   * Cost: Low for static JSON files

2. **Rate limiting** (Required)
   * Per-IP rate limits (e.g., 60 requests/minute)
   * Exponential backoff for repeated violators
   * CAPTCHA for suspicious traffic

3. **Caching headers** (Required)
   * `Cache-Control: public, max-age=86400`
   * Consent declarations cacheable for 24 hours
   * Reduces origin requests by 99%+

4. **Static file serving** (Recommended)
   * No database queries, no dynamic generation
   * Serve from disk or object storage (S3)
   * Minimal CPU/memory per request

5. **Fail-safe defaults** (Specification)
   * If declaration unavailable, assume `deny`
   * AI systems must handle 5xx, timeout gracefully
   * Retry with exponential backoff

#### Likelihood: Medium
* DDoS common on internet
* High-profile creators more at risk
* CDNs mitigate well

#### Residual Risk: Low (with CDN), Medium (without)

---

### Threat T-07: Consent Confusion

**Category**: Tampering, Repudiation
**STRIDE**: T, R

#### Description

Conflicting consent declarations lead to confusion about creator's intent:
* **Scenario 1**: Creator publishes on personal site (deny) and Medium (allow) — which wins?
* **Scenario 2**: Old consent declaration cached; new declaration denies
* **Scenario 3**: HTML meta tag says "allow", JSON-LD says "deny"

#### Attack Vectors

1. **Accidental conflict**
   * Creator updates website but forgets to update HTML meta tags
   * JSON-LD and meta tags disagree
   * AI system doesn't know which to trust

2. **Platform override**
   * Creator publishes to Medium with `training: deny`
   * Medium's TOS grants training rights
   * Conflict between creator intent and platform TOS

3. **Stale cache**
   * AI system cached old `allow` declaration
   * Creator updates to `deny` but cache not invalidated
   * AI system uses stale permission

4. **Canonical vs. syndicated**
   * Creator has canonical declaration on personal site
   * Syndicated copy on Medium has different declaration
   * AI system fetches syndicated version

#### Impact

* **Creators**: Intent not honoured due to confusion
* **AI systems**: Unclear which declaration to follow, legal risk
* **Disputes**: Difficult to determine true consent

#### Mitigations

1. **Conflict resolution rules** (Specification)
   * **Most restrictive wins**: If any source says `deny`, treat as deny
   * **Canonical precedence**: Personal site declaration overrides syndicated
   * **JSON-LD over meta tags**: Structured data more authoritative
   * **Newest wins**: Timestamp determines precedence

2. **Canonical declaration references** (Recommended)
   * Syndicated content links to canonical declaration:
     ```json
     {"canonicalConsent": "https://creator.com/.well-known/creative-works-consent.json"}
     ```
   * AI systems fetch canonical source

3. **Version control** (Required)
   * Include version number and timestamp in declarations
   * Increment version on every update
   * AI systems prefer higher version

4. **Cache invalidation** (Required)
   * Short TTL for consent declarations (24 hours)
   * Revalidation on every fetch if conflicting versions detected

5. **Consistency validation** (Recommended)
   * Tools warn creator if meta tags and JSON-LD conflict
   * Pre-flight check before publishing
   * Automated sync across platforms

#### Likelihood: Medium
* Accidental conflicts common (human error)
* Platforms may override creator intent

#### Residual Risk: Low (with clear rules), Medium (without)

---

### Threat T-08: Privacy Leak of Creator Identity

**Category**: Information Disclosure
**STRIDE**: I

#### Description

Consent declarations or verification process leaks sensitive information about creators:
* **Scenario 1**: Pseudonymous creator's real identity revealed via consent metadata
* **Scenario 2**: Cultural heritage declaration exposes sensitive community information
* **Scenario 3**: Verification logs reveal creator's personal data

#### Attack Vectors

1. **Metadata oversharing**
   * Creator includes real name in pseudonymous work's declaration
   * Cultural coordinates in heritage metadata
   * Personal contact info publicly accessible

2. **Inference attacks**
   * AI system correlates pseudonym across multiple declarations
   * Links identity via unique governance body membership
   * Blockchain address deanonymisation

3. **Log analysis**
   * AI company logs creator IP addresses during verification
   * Correlates with other data to identify creator
   * Third-party analytics on consent endpoints

#### Impact

* **Creators**: Loss of anonymity, potential harassment or persecution
* **Communities**: Sacred site locations exposed, cultural exploitation
* **GDPR**: Privacy violations, potential fines

#### Mitigations

1. **Pseudonymous declarations** (Supported)
   * No requirement to include real name
   * Verifiable Credentials allow pseudonymous verification
   * DID resolution without identity disclosure

2. **Privacy-preserving governance** (Recommended)
   * Zero-knowledge proofs for governance membership
   * "This person is an authorised steward" without revealing who
   * Cryptographic accumulators for anonymous collective consent

3. **Minimal metadata** (Principle)
   * Include only necessary fields
   * Sensitive cultural information via access-controlled endpoint
   * Contact via anonymous remailer or DAO multi-sig

4. **Access control** (Optional)
   * Require authentication to view full consent declaration
   * Public: Basic deny/allow
   * Authenticated: Detailed requirements, governance info
   * Prevents casual snooping

5. **GDPR compliance** (Required)
   * No logging of personal data without consent
   * Aggregated analytics only
   * Right to erasure for creator data

#### Likelihood: Low
* Creators control metadata disclosure
* GDPR enforces privacy

#### Residual Risk: Low

---

### Threat T-09: Audit Log Tampering

**Category**: Tampering, Repudiation
**STRIDE**: T, R

#### Description

AI company or attacker modifies audit logs to hide consent violations:
* **Scenario 1**: AI company deletes log entries showing use of denied content
* **Scenario 2**: Compliance report falsified to show higher compliance rate
* **Scenario 3**: Blockchain audit trail manipulated (if using private chain)

#### Attack Vectors

1. **Internal manipulation**
   * Privileged employee deletes incriminating logs
   * Compliance engineer modifies report before publication
   * No external verification

2. **Database compromise**
   * SQL injection or credential theft
   * Direct database modification
   * Log integrity not cryptographically protected

3. **Private blockchain manipulation**
   * If using private/permissioned blockchain
   * 51% attack or validator collusion
   * Rewrite audit history

#### Impact

* **Creators**: Violations undetected, no enforcement
* **Trust**: Audit framework credibility undermined
* **Legal**: Compliance evidence destroyed

#### Mitigations

1. **Append-only logs** (Required)
   * Write-once storage (WORM)
   * Immutable log architecture
   * No deletion or modification allowed

2. **Cryptographic log integrity** (Recommended)
   * Hash chain: Each entry includes hash of previous entry
   * Merkle tree: Aggregate hash verifiable
   * Tampering breaks chain, immediately detectable

3. **Third-party log custody** (Defense in depth)
   * AI company streams logs to independent auditor
   * Auditor stores copy, AI company cannot delete
   * Court-admissible evidence

4. **Public blockchain** (Optional, high-assurance)
   * Ethereum, Polygon for audit trail
   * Immutable, publicly verifiable
   * Expensive but tamper-proof

5. **Transparency reports** (Required)
   * Quarterly compliance reports published publicly
   * Third-party audit attestation
   * Statistical analysis detects anomalies

#### Likelihood: Low
* Internal controls prevent most cases
* Third-party audit provides check
* High legal risk if caught

#### Residual Risk: Low (with third-party custody), Medium (self-custody)

---

### Threat T-10: Revocation Notice Suppression

**Category**: Denial of Service, Repudiation
**STRIDE**: D, R

#### Description

AI company or attacker prevents creator's revocation notice from being seen:
* **Scenario 1**: AI company's cache ignores revocation, continues using old `allow`
* **Scenario 2**: Attacker DDoS creator's website during revocation notice period
* **Scenario 3**: Email notification of revocation blocked by spam filter

#### Attack Vectors

1. **Cache abuse**
   * AI company sets long cache TTL (30+ days)
   * Revocation published but cache not invalidated
   * Company claims "we never saw it"

2. **DDoS during revocation**
   * Attacker times DDoS to coincide with revocation notice
   * Consent endpoint unavailable
   * AI company cannot fetch updated declaration

3. **Communication blocking**
   * Email to AI company blocked by spam filter
   * Contact form on AI company website broken
   * No acknowledgement of revocation

#### Impact

* **Creators**: Revocation ineffective, continued unauthorised use
* **Legal**: Difficult to prove AI company received notice
* **Trust**: Revocation mechanism undermined

#### Mitigations

1. **Short cache TTL** (Required)
   * Specification mandates 24-hour max TTL
   * Revalidate on every fetch if revocation header present
   * `Cache-Control: must-revalidate` for revocations

2. **Revocation registry** (Recommended)
   * Public registry of revocations (blockchain or centralised)
   * AI companies poll registry daily
   * Cannot claim ignorance if in registry

3. **Multi-channel notification** (Best practice)
   * Update consent declaration (primary)
   * Email to AI company compliance contact
   * Post to public registry
   * Certified mail (legal proof)
   * At least one channel likely to succeed

4. **Notice period grace** (Specification)
   * 30-day notice period after revocation
   * AI company has time to respond despite temporary outages
   * Reduces impact of transient DDoS

5. **Legal presumption** (Policy recommendation)
   * AI company responsible for monitoring consent status
   * Cannot claim "we didn't know" if declaration updated
   * Burden of proof on AI company

#### Likelihood: Low
* Multi-channel notification robust
* Legal presumption discourages suppression

#### Residual Risk: Low

---

## 5. Attack Scenarios

### 5.1. High-Profile Creator Targeted Attack

**Attacker**: Competitor or troll
**Target**: Best-selling author
**Objective**: Discredit author or steal work

#### Attack Chain

1. **Reconnaissance**: Identify author's website and consent declaration
2. **Phishing**: Send fake "CWCF key verification" email to author
3. **Credential theft**: Steal private key from author's device
4. **Consent manipulation**: Issue fake declaration `training: allow`
5. **AI training**: Submit to AI companies claiming author granted consent
6. **AI generation**: AI generates works "in author's style"
7. **Market flooding**: Flood market with AI-generated knock-offs
8. **Reputation damage**: Author's unique voice diluted

#### Mitigations Applied

* **Hardware key**: Private key in YubiKey, phishing ineffective
* **Transparency log**: Fake declaration detected, flagged publicly
* **Revocation**: Author revokes compromised key within hours
* **Legal action**: Impersonation and fraud charges against attacker

#### Outcome

* Attack detected within 24 hours
* Minimal damage (few AI outputs generated)
* Attacker prosecuted
* Author's reputation intact

### 5.2. Cultural Heritage Exploitation

**Attacker**: Unethical AI startup
**Target**: Indigenous community's sacred stories
**Objective**: Train AI model on cultural knowledge without consent

#### Attack Chain

1. **Scraping**: Ignore `training: deny` in consent declaration
2. **Training**: Include stories in LLM training dataset
3. **Generation**: AI generates content derived from sacred stories
4. **Commercialisation**: Sell AI model without attribution
5. **Cultural harm**: Sacred context lost, stories commodified

#### Mitigations Applied

* **Watermarking**: Stories contain invisible watermarks
* **Forensic analysis**: Community analyses AI model, detects influence
* **Blockchain provenance**: Lineage registry shows no legitimate consent
* **Legal action**: Copyright infringement + cultural heritage violation
* **Public exposure**: Media coverage damages AI startup's reputation

#### Outcome

* Violation detected 6 months post-launch
* Court orders model retrained without cultural content
* Substantial damages awarded to community
* AI startup reputation destroyed, shuts down

### 5.3. DAO Governance Compromise

**Attacker**: Disgruntled DAO member
**Target**: Musicians DAO with 1,000 members
**Objective**: Grant unauthorised consent to preferred AI company

#### Attack Chain

1. **Accumulation**: Attacker buys governance tokens on secondary market
2. **Proposal**: Submit "Allow AICompany to train on catalogue"
3. **Vote manipulation**: Sybil attack with accumulated tokens
4. **Approval**: Proposal passes with 51% (attacker + allies)
5. **Consent issuance**: Smart contract updates consent status
6. **AI training**: AICompany trains on catalogue

#### Mitigations Applied

* **Token lock-up**: Votes require 90-day token holding period (prevents flash attacks)
* **Quorum requirement**: 66% of members must participate (low turnout invalidates vote)
* **Time delay**: 7-day delay after vote before execution (enables challenge)
* **Veto power**: Cultural stewards can veto votes violating heritage protocols
* **Transparency**: All votes public, members alerted to suspicious proposals

#### Outcome

* Proposal flagged due to unusual token concentration
* Vote challenged during 7-day delay
* Stewards veto proposal as violating cultural protocols
* Attacker's tokens slashed (DAO penalty mechanism)
* No AI training occurs

---

## 6. Mitigations Summary

### 6.1. Technical Mitigations

| Mitigation | Threats Addressed | Priority | Deployment |
|------------|-------------------|----------|------------|
| **Cryptographic signatures** | T-01, T-03, T-04 | Critical | Optional (should be required for high-value) |
| **HTTPS enforcement** | T-01 | Critical | Required |
| **Multi-layer watermarking** | T-02 | High | Recommended |
| **Verifiable Credentials** | T-03 | High | Recommended |
| **Hardware security keys** | T-04 | Medium | Optional (high-value) |
| **CDN deployment** | T-06 | High | Recommended |
| **Append-only logs** | T-09 | Medium | Recommended |
| **Short cache TTL** | T-07, T-10 | High | Required (24 hours max) |

### 6.2. Legal/Policy Mitigations

| Mitigation | Threats Addressed | Priority |
|------------|-------------------|----------|
| **License breach provisions** | T-05 | Critical |
| **Statutory damages** | T-05 | High |
| **Compliance transparency** | T-05, T-09 | High |
| **Third-party audits** | T-05, T-09 | Medium |
| **Revocation registry** | T-10 | Medium |

### 6.3. Operational Mitigations

| Mitigation | Threats Addressed | Priority |
|------------|-------------------|----------|
| **User education** | T-02, T-04, T-08 | Medium |
| **Monitoring and alerting** | T-05, T-10 | High |
| **Incident response plan** | All | High |
| **Key rotation** | T-04 | Medium |

---

## 7. Residual Risks

### 7.1. Accepted Risks

| Risk | Rationale |
|------|-----------|
| **Determined attacker with nation-state resources** | Out of scope; no technical mitigation possible |
| **AI company ignoring consent despite legal risk** | Requires legal enforcement, cannot prevent technically |
| **Creator key management failure** | Creator responsibility; education and tools provided |
| **Platform TOS conflicts** | Out of scope; creators must review platform terms |

### 7.2. Mitigated but Non-Zero Risks

| Risk | Residual Likelihood | Residual Impact |
|------|---------------------|-----------------|
| **Consent tampering** | Low (with signatures) | High |
| **Lineage stripping** | Medium | Medium |
| **Governance impersonation** | Low (with VC) | High |
| **Privacy leak** | Low | Medium |

---

## 8. Security Recommendations

### 8.1. For Creators

1. **Use HTTPS**: Required, non-negotiable
2. **Sign high-value declarations**: Prevent tampering
3. **Store keys securely**: Hardware key or password manager
4. **Monitor consent fetches**: Detect unusual activity
5. **Revoke compromised keys immediately**: Don't delay

### 8.2. For AI Companies

1. **Verify signatures**: Don't trust unsigned declarations
2. **Implement test suite**: Ensure correct consent handling
3. **Log all decisions**: Append-only, third-party custody
4. **Publish compliance reports**: Quarterly transparency
5. **Honour revocations**: 24-hour revalidation

### 8.3. For Specification Authors

1. **Mandate HTTPS**: No HTTP support
2. **Require short cache TTL**: 24-hour maximum
3. **Specify conflict resolution**: Clear rules
4. **Support Verifiable Credentials**: Enable governance verification
5. **Privacy by design**: Minimal metadata disclosure

### 8.4. For Platform Providers

1. **Preserve lineage tags**: Don't sanitise metadata
2. **Support canonical declarations**: Link to creator's source
3. **Enforce HTTPS**: No mixed content
4. **Provide creator tools**: Easy consent management UI
5. **CDN integration**: DDoS mitigation built-in

---

## 9. Conclusion

The Creative Works Consent Framework faces significant security and privacy challenges, but most threats have effective mitigations:

**Strengths**:
* Cryptographic signatures prevent tampering
* HTTPS widely deployed for transport security
* Decentralised architecture (no single point of failure)
* Legal enforcement provides deterrence

**Weaknesses**:
* Cannot technically force AI company compliance (requires legal enforcement)
* Lineage tag stripping difficult to prevent (multi-layer watermarking helps)
* Creator key management complexity (hardware keys mitigate)

**Overall Risk Level**: **Moderate** (with recommended mitigations)

With proper implementation of cryptographic signatures, HTTPS enforcement, multi-layer watermarking, and compliance transparency, CWCF provides robust protection for creators whilst enabling responsible AI development.

---

**Document Version**: 1.0
**Last Updated**: 2025-11-22
**License**: CC-BY 4.0
**Contributors**: Palimpsest Stewardship Council, Security Review Team
