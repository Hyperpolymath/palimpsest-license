# Creative Works Consent Framework: Use Cases and Requirements

**Version**: 1.0
**Date**: 2025-11-22
**Status**: Draft

## Document Purpose

This document captures the use cases driving the Creative Works Consent Framework (CWCF) development and derives functional and non-functional requirements from these use cases. It serves as the foundation for specification design and implementation priorities.

---

## Table of Contents

1. [Stakeholder Personas](#1-stakeholder-personas)
2. [Use Cases](#2-use-cases)
3. [Functional Requirements](#3-functional-requirements)
4. [Non-Functional Requirements](#4-non-functional-requirements)
5. [Priority Matrix](#5-priority-matrix)
6. [Out of Scope](#6-out-of-scope)

---

## 1. Stakeholder Personas

### 1.1. Individual Creator (Maya, Freelance Journalist)

**Background**: Maya writes investigative journalism and publishes on her personal website and Medium. She's concerned about AI systems training on her work without permission.

**Goals**:
* Prohibit AI training on her articles
* Allow search engines to index her content
* Require attribution if her work influences AI outputs
* Simple, non-technical setup

**Technical Proficiency**: Basic (can edit HTML, use WordPress plugins)

### 1.2. Collective Governance (Indigenous Community Council)

**Background**: The Coastal Tribe Council manages digital archives of traditional stories, songs, and cultural knowledge. Many items are sacred or sensitive.

**Goals**:
* Require approval from elders before any AI access
* Preserve cultural context in any derivatives
* Track lineage if stories are used despite restrictions
* Support community decision-making processes

**Technical Proficiency**: Moderate (tribal IT coordinator)

### 1.3. AI Company (TechCorp Labs, LLM Developer)

**Background**: TechCorp builds large language models and wants to be ethical about training data sourcing.

**Goals**:
* Verify creator consent before scraping content
* Comply with legal and ethical obligations
* Automate consent checking at scale (millions of URLs)
* Generate proper attribution for AI outputs

**Technical Proficiency**: High (ML engineers, web developers)

### 1.4. Platform Provider (CreativeHost, CMS Vendor)

**Background**: CreativeHost provides managed WordPress hosting for 500,000 creators.

**Goals**:
* Offer consent management as a platform feature
* Differentiate from competitors
* Protect creators without technical burden
* Scale to millions of websites

**Technical Proficiency**: High (platform engineering team)

### 1.5. Cultural Heritage Institution (National Archive)

**Background**: The National Archive digitises historical documents, photographs, and oral histories. Some are culturally sensitive or subject to donor restrictions.

**Goals**:
* Express nuanced consent (e.g., "research only, no commercial")
* Protect donor privacy and cultural protocols
* Enable academic AI research with proper safeguards
* Interoperate with existing metadata standards (Dublin Core, DCAT)

**Technical Proficiency**: High (digital archivists, IT staff)

### 1.6. Musicians Cooperative (SoundCollective DAO)

**Background**: 300 musicians pool rights in a DAO-governed collective. Revenue from AI licensing is split amongst members.

**Goals**:
* Democratic consent approval (66% vote required)
* Automated revenue sharing via smart contracts
* Transparency: members see which AI systems use their music
* Revocation if terms violated

**Technical Proficiency**: High (blockchain developers in team)

---

## 2. Use Cases

### UC-01: Individual Creator Prohibits AI Training

**Persona**: Maya (Journalist)

**Scenario**: Maya publishes a new investigative article and wants to ensure no AI systems train on it.

**Preconditions**:
* Maya has a website with HTTPS
* Maya can edit files or use a CMS plugin

**Steps**:
1. Maya creates a consent declaration file expressing `training: deny`
2. Maya places file at `/.well-known/creative-works-consent.json`
3. Maya adds HTML meta tag for redundancy
4. AI scraper visits Maya's article
5. AI scraper fetches consent declaration
6. AI scraper sees `training: deny`
7. AI scraper skips article in training dataset
8. AI scraper logs the exclusion for compliance

**Postconditions**:
* Article excluded from AI training
* Consent preference machine-readable
* Logged for audit trail

**Requirements Derived**:
* FR-01: Support deny consent value
* FR-02: Well-known URI discovery
* FR-03: HTML meta tag fallback
* FR-04: Machine-readable JSON format
* NFR-01: Simple creator setup (< 10 minutes)

---

### UC-02: Conditional Consent with Attribution

**Persona**: Maya (Journalist)

**Scenario**: Maya decides to allow AI training if she receives proper attribution in AI-generated content.

**Preconditions**:
* Maya has consent declaration infrastructure set up

**Steps**:
1. Maya updates consent declaration: `training: conditional, requirements: ["attribution"]`
2. Maya specifies attribution format: "Maya Chen, InvestigativeReports.com"
3. AI system fetches consent declaration
4. AI system sees conditional consent
5. AI system checks attribution requirement
6. AI system trains on article
7. AI system generates output derived from Maya's work
8. AI system embeds lineage tag with Maya's attribution
9. End user sees AI output with "Derived from: Maya Chen, InvestigativeReports.com"

**Postconditions**:
* Article included in training with attribution
* Lineage tag embedded in synthetic outputs
* Maya's contribution acknowledged

**Requirements Derived**:
* FR-05: Support conditional consent value
* FR-06: Requirements specification
* FR-07: Lineage tag generation
* FR-08: Attribution format specification
* FR-09: Human-readable attribution display

---

### UC-03: Cultural Heritage Protection with Steward Approval

**Persona**: Indigenous Community Council

**Scenario**: The Council publishes traditional stories online but requires elder approval before any AI access.

**Preconditions**:
* Council has digital archive website
* Elders have approval process defined

**Steps**:
1. Council creates consent declaration with:
   * `training: deny` (default)
   * `culturalHeritage.protected: true`
   * `culturalHeritage.stewards: [elder-council-url]`
   * `governance.approvalRequired: true`
2. AI company wants to use stories for cultural AI research
3. AI company contacts elder council via provided URL
4. Elders discuss and vote on request
5. If approved, elders issue time-limited consent token
6. AI company presents token when accessing content
7. System verifies token with elder council authority
8. Content accessed with cultural protocols enforced
9. Lineage tags include cultural context preservation requirement

**Postconditions**:
* Cultural content protected by default
* Approval process honoured
* Cultural context preserved
* Steward authority verified

**Requirements Derived**:
* FR-10: Cultural heritage protection flags
* FR-11: Steward identification (URLs/DIDs)
* FR-12: Governance approval mechanisms
* FR-13: Verifiable credentials integration
* FR-14: Cultural context preservation metadata
* NFR-02: Support non-Western governance models

---

### UC-04: DAO Collective Governance

**Persona**: SoundCollective DAO

**Scenario**: DAO members vote on whether to license their music catalogue to an AI music generation company.

**Preconditions**:
* DAO smart contract deployed on Ethereum
* 300 members with voting tokens
* Music catalogue metadata includes DAO as rights holder

**Steps**:
1. Consent declaration references DAO contract address: `governance.body: "0x123..."`
2. AI company submits consent request to DAO contract
3. Proposal created: "Allow TechCorp to train MusicGen AI on our catalogue"
4. Members vote over 7 days
5. Proposal passes with 72% approval
6. Smart contract updates consent status on-chain
7. AI company queries contract: `getConsent(workId)` returns `allow`
8. AI company trains on music
9. Smart contract monitors AI company's attribution compliance
10. Revenue sharing automatically distributes to members quarterly

**Postconditions**:
* Democratic decision recorded on-chain
* Consent cryptographically verifiable
* Revenue sharing automated
* Members have transparent audit trail

**Requirements Derived**:
* FR-15: Blockchain governance integration
* FR-16: Smart contract consent queries
* FR-17: On-chain/off-chain sync
* FR-18: Automated revenue sharing hooks
* FR-19: Transparent audit logs
* NFR-03: Support decentralised governance

---

### UC-05: Large-Scale Training Dataset Consent Verification

**Persona**: TechCorp Labs (AI Company)

**Scenario**: TechCorp is building a new LLM and needs to verify consent for 100 million URLs in their training dataset.

**Preconditions**:
* TechCorp has crawled 100M URLs
* Consent verification infrastructure deployed

**Steps**:
1. TechCorp batches URLs into chunks of 10,000
2. Parallel workers fetch consent declarations
3. Cache frequently-accessed domains
4. For each URL:
   * Check cache
   * If not cached, fetch `/.well-known/creative-works-consent.json`
   * If 404, check HTML meta tags
   * If no declaration, default to deny (conservative)
   * Parse consent for `ai-type: llm`
5. Classify URLs:
   * Allow: 15M URLs
   * Deny: 80M URLs
   * Conditional: 3M URLs
   * No declaration: 2M URLs (treated as deny)
6. For conditional URLs, check if requirements can be met
7. Generate compliance report
8. Train only on allowed + compliant conditional URLs
9. Log all decisions for audit

**Postconditions**:
* 18M URLs used in training (15M allow + 3M conditional)
* 82M URLs excluded
* Full audit trail maintained
* Compliance report generated

**Requirements Derived**:
* FR-20: Bulk verification API
* FR-21: Caching mechanisms
* FR-22: Fallback discovery methods
* FR-23: Conservative defaults (deny if uncertain)
* FR-24: Compliance reporting format
* NFR-04: Performance (< 100ms per URL)
* NFR-05: Scalability (millions of URLs)

---

### UC-06: Lineage Verification in AI Output

**Persona**: End User (Sarah, University Researcher)

**Scenario**: Sarah uses an AI writing assistant to draft a literature review. She wants to verify which sources influenced the AI's output.

**Preconditions**:
* AI system implements CWCF lineage tagging
* Sarah has access to lineage verification tools

**Steps**:
1. Sarah asks AI to "summarise recent climate research"
2. AI generates 500-word summary
3. AI embeds JSON-LD lineage tag in output
4. Sarah uses browser extension to extract lineage data
5. Extension displays source works:
   * "Climate Impacts 2024" by Dr. Jones (CC-BY)
   * "Arctic Ice Loss" by Dr. Smith (Palimpsest v0.4, conditional consent)
   * "IPCC Report 2024" (Public domain)
6. Sarah clicks through to original sources
7. Sarah verifies proper attribution in AI output
8. Sarah cites both AI tool and original sources in her paper

**Postconditions**:
* Sarah can trace AI knowledge back to sources
* Original creators receive attribution
* Academic integrity maintained

**Requirements Derived**:
* FR-25: JSON-LD lineage tag schema
* FR-26: Lineage extraction tools
* FR-27: Source work metadata (title, author, license)
* FR-28: Derivation chain tracking
* FR-29: Human-readable lineage display
* NFR-06: Accessibility (WCAG 2.1 AA)

---

### UC-07: Consent Revocation

**Persona**: Maya (Journalist)

**Scenario**: Maya discovers an AI company has violated her conditional consent by failing to provide attribution. She revokes consent.

**Preconditions**:
* Maya previously granted conditional consent
* Violation detected and documented

**Steps**:
1. Maya updates consent declaration: `training: deny`
2. Maya adds revocation notice:
   ```json
   {
     "revocation": {
       "date": "2025-12-01",
       "reason": "Attribution requirement violated",
       "previousConsent": "conditional",
       "noticePeriod": "P30D",
       "contact": "maya@example.com"
     }
   }
   ```
3. Maya notifies AI company via email with revocation details
4. AI company's monitoring system detects consent change
5. AI company flags Maya's content in training dataset
6. Within 30-day notice period, AI company:
   * Stops using content in new training runs
   * Documents revocation in compliance log
   * Contacts Maya to discuss resolution
7. If unresolved, content permanently removed from future models

**Postconditions**:
* Consent revocation recorded
* AI company notified
* Content excluded from future training
* Audit trail preserved

**Requirements Derived**:
* FR-30: Revocation notice support
* FR-31: Notice period specification
* FR-32: Change detection mechanisms
* FR-33: Compliance workflow integration
* NFR-07: Revocation detection latency (< 24 hours)

---

### UC-08: Privacy-Sensitive Content Protection

**Persona**: Dr. Patel (Therapist)

**Scenario**: Dr. Patel publishes anonymised case studies for professional development. She wants to prohibit neural interface AI and protect privacy.

**Preconditions**:
* Content published online with privacy safeguards
* Concerns about neural interface misuse

**Steps**:
1. Dr. Patel creates consent declaration:
   ```json
   {
     "consent": {
       "training": "deny",
       "generation": "deny"
     },
     "aiTypes": {
       "neural-interface": {
         "consent": "deny",
         "justification": "Mental privacy concerns"
       },
       "medical-ai": {
         "consent": "conditional",
         "requirements": ["ethics-board-approval", "anonymisation"]
       }
     },
     "privacy": {
       "sensitiveContent": true,
       "category": ["health", "personal-data"],
       "gdprCompliant": true,
       "minimumProtections": ["anonymisation", "access-control"]
     }
   }
   ```
2. Neural interface AI system checks consent
3. System sees `neural-interface: deny`
4. System blocks access and logs denial
5. Medical AI research system checks consent
6. System sees `medical-ai: conditional`
7. Researchers obtain ethics board approval
8. Researchers provide proof of approval
9. Access granted with anonymisation enforced

**Postconditions**:
* Neural interfaces blocked
* Medical research permitted with safeguards
* Privacy protections enforced
* GDPR compliance maintained

**Requirements Derived**:
* FR-34: AI type granularity (neural-interface, medical, etc.)
* FR-35: Privacy flags (GDPR, sensitive content)
* FR-36: Justification fields
* FR-37: Proof of compliance mechanisms
* NFR-08: GDPR compliance

---

### UC-09: Cross-Platform Consent Synchronisation

**Persona**: Alex (Multi-Platform Content Creator)

**Scenario**: Alex publishes on personal website, Medium, YouTube, and Twitter. Wants consistent consent across all platforms.

**Preconditions**:
* Content distributed across 4 platforms
* Each platform has different consent mechanisms

**Steps**:
1. Alex creates canonical consent declaration on personal website
2. Alex uses CWCF syndication tool to generate platform-specific formats:
   * Medium: Custom metadata fields
   * YouTube: Video description machine-readable block
   * Twitter: Profile bio link + pinned tweet
3. All platforms reference canonical declaration: `"canonicalConsent": "https://alex.example.com/.well-known/creative-works-consent.json"`
4. AI systems fetch canonical declaration
5. Platform-specific declarations verified against canonical
6. If conflict, canonical takes precedence
7. Alex updates consent once on personal site
8. Syndication tool pushes updates to all platforms

**Postconditions**:
* Consistent consent across platforms
* Single source of truth
* Automated synchronisation
* Reduced maintenance burden

**Requirements Derived**:
* FR-38: Canonical declaration references
* FR-39: Platform-specific format adapters
* FR-40: Conflict resolution (canonical precedence)
* FR-41: Syndication tools/APIs
* NFR-09: Interoperability with platforms

---

### UC-10: Quantum AI Future-Proofing

**Persona**: Research Institute (Quantum Computing Lab)

**Scenario**: The lab is developing quantum AI and needs to respect creator consent while ensuring lineage traceability in quantum states.

**Preconditions**:
* Quantum AI system under development
* Existing consent declarations may not anticipate quantum computing

**Steps**:
1. Creators add quantum AI consent:
   ```json
   {
     "aiTypes": {
       "quantum": {
         "consent": "conditional",
         "requirements": ["quantum-proof-lineage", "entanglement-disclosure"]
       }
     },
     "lineage": {
       "quantumProof": true,
       "algorithm": "SHA-512"
     }
   }
   ```
2. Quantum AI system fetches consent
3. System sees `quantum: conditional`
4. System implements quantum-proof lineage (hash chains resistant to quantum attacks)
5. System discloses when entanglement affects attribution
6. Quantum state collapses to classical output
7. Output includes quantum-proof lineage tag
8. Lineage verifiable even post-quantum

**Postconditions**:
* Quantum AI respects consent
* Lineage survives quantum processing
* Future-proof attribution

**Requirements Derived**:
* FR-42: Quantum AI type support
* FR-43: Quantum-proof cryptography
* FR-44: Extensibility for future AI paradigms
* NFR-10: Future-proof design

---

## 3. Functional Requirements

### 3.1. Core Consent Declaration (Priority: P0)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-01 | Support "deny" consent value | UC-01 |
| FR-02 | Support "allow" consent value | UC-05 |
| FR-03 | Support "conditional" consent value | UC-02 |
| FR-04 | Support "unspecified" consent value | UC-05 |
| FR-05 | Machine-readable JSON-LD format | UC-01, UC-05 |
| FR-06 | Well-known URI discovery (`/.well-known/creative-works-consent.json`) | UC-01, UC-05 |
| FR-07 | HTTP Link header discovery | UC-05 |
| FR-08 | HTML meta tag fallback | UC-01 |

### 3.2. Consent Granularity (Priority: P0)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-09 | Support operation types (training, generation, analysis, indexing, agentic) | UC-01, UC-02 |
| FR-10 | Support AI type granularity (llm, vision, audio, autonomous, agentic, ambient, neural-interface, quantum) | UC-08, UC-10 |
| FR-11 | Requirements specification for conditional consent | UC-02 |
| FR-12 | Support custom AI types via extensibility | UC-10 |

### 3.3. Attribution and Lineage (Priority: P0)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-13 | JSON-LD lineage tag schema | UC-06 |
| FR-14 | Minimum lineage fields (source work, author, license, derivation date, AI system) | UC-06 |
| FR-15 | Attribution format specification (human and machine) | UC-02 |
| FR-16 | Emotional context preservation metadata | UC-03 |
| FR-17 | Derivation chain tracking | UC-06 |

### 3.4. Governance (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-18 | Individual governance model support | UC-01, UC-02 |
| FR-19 | Collective governance model support | UC-03, UC-04 |
| FR-20 | DAO smart contract integration | UC-04 |
| FR-21 | Governance body identification (URLs, DIDs, smart contract addresses) | UC-03, UC-04 |
| FR-22 | Approval requirement flags | UC-03, UC-04 |
| FR-23 | Verifiable credentials integration | UC-03 |

### 3.5. Cultural Heritage (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-24 | Cultural heritage protection flags | UC-03 |
| FR-25 | Cultural steward identification | UC-03 |
| FR-26 | Cultural protocol references | UC-03 |
| FR-27 | Sensitive content categories | UC-08 |

### 3.6. Privacy (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-28 | Privacy sensitivity flags | UC-08 |
| FR-29 | GDPR compliance indicators | UC-08 |
| FR-30 | Minimum protection requirements | UC-08 |
| FR-31 | Personal data categories | UC-08 |

### 3.7. Revocation (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-32 | Consent revocation support | UC-07 |
| FR-33 | Revocation notice period specification | UC-07 |
| FR-34 | Revocation reason fields | UC-07 |
| FR-35 | Previous consent state recording | UC-07 |

### 3.8. Verification and Validation (Priority: P0)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-36 | JSON Schema validation | UC-05 |
| FR-37 | JSON-LD context validation | UC-05 |
| FR-38 | Cryptographic signature support | UC-04 |
| FR-39 | Tamper detection | UC-04 |

### 3.9. Discovery and Interoperability (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-40 | Canonical declaration references | UC-09 |
| FR-41 | Platform-specific format adapters | UC-09 |
| FR-42 | Conflict resolution rules | UC-09 |
| FR-43 | Protocol Buffers alternative format | UC-05 |
| FR-44 | RDF/Turtle alternative format | UC-05 |

### 3.10. Compliance and Reporting (Priority: P1)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-45 | Compliance logging format | UC-05 |
| FR-46 | Audit trail requirements | UC-04, UC-07 |
| FR-47 | Compliance report schema | UC-05 |
| FR-48 | Violation reporting mechanisms | UC-07 |

### 3.11. Tools and Libraries (Priority: P2)

| ID | Requirement | Derived From |
|----|-------------|--------------|
| FR-49 | Consent validation library | UC-05 |
| FR-50 | Lineage generation library | UC-06 |
| FR-51 | Browser extension for consent display | UC-06 |
| FR-52 | CMS plugins (WordPress, Drupal, etc.) | UC-01 |

---

## 4. Non-Functional Requirements

### 4.1. Usability (Priority: P0)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-01 | Creator setup time | < 10 minutes for basic declaration |
| NFR-02 | Technical barrier | Accessible to non-technical users via CMS plugins |
| NFR-03 | Documentation clarity | Comprehensible to average creator (Flesch Reading Ease > 60) |
| NFR-04 | Error messages | Clear, actionable guidance for validation errors |

### 4.2. Performance (Priority: P0)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-05 | Consent verification latency | < 100ms per URL (cached) |
| NFR-06 | Bulk verification throughput | > 10,000 URLs/second (with caching) |
| NFR-07 | Declaration file size | < 50KB typical |
| NFR-08 | CDN compatibility | Cacheable for 24+ hours |

### 4.3. Scalability (Priority: P0)

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-09 | Websites supported | Millions (decentralised, no central registry required) |
| NFR-10 | AI systems supported | Hundreds (via standardised protocol) |
| NFR-11 | Concurrent verifications | 1M+ simultaneous checks (distributed architecture) |

### 4.4. Security (Priority: P0)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-12 | Transport encryption | HTTPS required for declaration retrieval |
| NFR-13 | Signature verification | Support JWS, PGP, blockchain attestations |
| NFR-14 | Tamper resistance | Cryptographic signatures for high-value works |
| NFR-15 | Denial of service mitigation | Rate limiting, caching strategies |

### 4.5. Privacy (Priority: P0)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-16 | Creator anonymity | Support pseudonymous declarations |
| NFR-17 | Access logging | Aggregate only, no individual tracking |
| NFR-18 | GDPR compliance | Personal data minimisation, right to erasure |
| NFR-19 | Sensitive content protection | Enhanced encryption/access control options |

### 4.6. Accessibility (Priority: P1)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-20 | Web accessibility | WCAG 2.1 Level AA for human-readable presentations |
| NFR-21 | Screen reader support | Full compatibility with NVDA, JAWS, VoiceOver |
| NFR-22 | Keyboard navigation | Complete functionality without mouse |
| NFR-23 | Colour contrast | 4.5:1 minimum for text |

### 4.7. Internationalization (Priority: P1)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-24 | Language support | JSON-LD `@language` tags for multilingual content |
| NFR-25 | Unicode support | Full UTF-8 for all text fields |
| NFR-26 | Cultural adaptation | Support non-Western governance and attribution models |
| NFR-27 | RTL languages | Right-to-left text support in UI |

### 4.8. Extensibility (Priority: P1)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-28 | Custom fields | Namespace prefixes for extensions |
| NFR-29 | Future AI types | Registry for new AI paradigms |
| NFR-30 | Backward compatibility | Parsers ignore unknown fields |
| NFR-31 | Forward compatibility | Graceful degradation for old implementations |

### 4.9. Interoperability (Priority: P1)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-32 | License compatibility | Integration with CC, Palimpsest, OSI licenses |
| NFR-33 | Metadata standards | Compatible with Schema.org, Dublin Core, DCAT |
| NFR-34 | Platform integration | Works with WordPress, Drupal, Jekyll, Hugo, etc. |
| NFR-35 | Blockchain interop | Ethereum, Polygon, other L1/L2 chains |

### 4.10. Compliance (Priority: P1)

| ID | Requirement | Specification |
|----|-------------|---------------|
| NFR-36 | Legal enforceability | Compatible with copyright law in major jurisdictions |
| NFR-37 | Audit trail retention | 7+ years for compliance records |
| NFR-38 | Standards conformance | Follow W3C, IETF, ISO best practices |
| NFR-39 | Dispute resolution | Clear escalation paths for violations |

---

## 5. Priority Matrix

### 5.1. Feature Priorities

| Priority | Description | Deliverable Timeframe |
|----------|-------------|----------------------|
| **P0** | Must-have for MVP | Version 1.0 (Q2 2026) |
| **P1** | Important for adoption | Version 1.1 (Q4 2026) |
| **P2** | Nice-to-have | Version 2.0 (2027+) |

### 5.2. Use Case Priorities

| Use Case | Priority | Rationale |
|----------|----------|-----------|
| UC-01: Individual Prohibit | P0 | Most common scenario, core functionality |
| UC-02: Conditional Attribution | P0 | Critical for creator control |
| UC-05: Bulk Verification | P0 | Required for AI company adoption |
| UC-06: Lineage Verification | P0 | Core value proposition |
| UC-03: Cultural Heritage | P1 | Important for vulnerable communities |
| UC-04: DAO Governance | P1 | Differentiator for Web3 adoption |
| UC-07: Revocation | P1 | Essential for creator protection |
| UC-08: Privacy Protection | P1 | GDPR and ethical requirements |
| UC-09: Cross-Platform Sync | P2 | Convenience feature |
| UC-10: Quantum AI | P2 | Future-proofing |

---

## 6. Out of Scope

### 6.1. Explicitly Out of Scope

The following are **not** addressed by CWCF:

1. **Copyright law reform**: Legal frameworks are legislative domain
2. **Payment processing**: Financial transactions handled by external systems
3. **Content filtering/moderation**: Separate from consent declarations
4. **Digital Rights Management (DRM)**: Encryption-based access control
5. **AI model architecture**: How AI systems are built internally
6. **Content quality assessment**: Whether content is suitable for training
7. **Fair use determination**: Legal analysis remains in legal domain
8. **Hosting/storage**: Infrastructure for content itself

### 6.2. Deferred to Future Versions

These may be addressed in future specifications:

1. **Real-time consent negotiation**: Dynamic consent workflows
2. **Micropayment integration**: Standardised compensation protocols
3. **Federated consent verification**: P2P verification networks
4. **Ambient AI context preservation**: Environmental integration specifics
5. **Cross-border legal harmonisation**: International enforcement mechanisms

---

## 7. Requirements Traceability

| Requirement | Use Case(s) | Specification Section | Test Cases |
|-------------|-------------|----------------------|------------|
| FR-01 (deny) | UC-01 | 3.2 Consent Values | TC-001, TC-002 |
| FR-05 (JSON-LD) | UC-01, UC-05 | 3.2 Format | TC-010-015 |
| FR-13 (Lineage) | UC-06 | 3.5 Lineage | TC-030-035 |
| FR-20 (DAO) | UC-04 | 3.4 Governance | TC-050-052 |
| NFR-05 (Latency) | UC-05 | Performance | PERF-001 |

*(Full traceability matrix maintained separately)*

---

## 8. Acceptance Criteria

### 8.1. MVP Success Criteria

CWCF Version 1.0 is successful if:

1. **Creator adoption**: 100+ websites implement declarations
2. **AI adoption**: 5+ AI systems verify consent
3. **Interoperability**: 3+ independent implementations interoperate
4. **Performance**: < 100ms verification latency achieved
5. **Compliance**: Test suite 80%+ coverage of normative requirements

### 8.2. Long-Term Success Criteria

CWCF is successful if:

1. **Scale**: 10,000+ websites implement within 3 years
2. **Industry**: Major AI companies (OpenAI, Google, Anthropic) adopt
3. **Platforms**: WordPress, Drupal, Medium native support
4. **Legal**: Referenced in court cases and legislation
5. **Impact**: Measurable reduction in creator complaints about unauthorised use

---

**Document Version**: 1.0
**Last Updated**: 2025-11-22
**License**: CC-BY 4.0
**Contributors**: Palimpsest Stewardship Council, CWCF Community Group
