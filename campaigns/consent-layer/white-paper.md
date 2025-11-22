# The Consent Layer for the Internet: A White Paper

## Abstract

The internet was built on protocols for data transmission, not human agency. As a result, we have infrastructure for moving files but no infrastructure for moving *permission*. This white paper proposes a **Consent Layer**—a suite of technical standards, protocols, and social practices that make consent propagate with content across the internet.

The Palimpsest License demonstrates one application: requiring consent for AI training on creative works. But the Consent Layer has broader implications: advertising tracking, data collection, content reuse, platform sharing, and any context where "Can I use this?" should have a machine-readable, enforceable answer.

**This is not about restricting the internet. It's about making permission legible.**

---

## 1. The Problem: Consent Doesn't Scale

### 1.1 The Current State

When you publish creative work online:
- **You lose control immediately.** Anyone can scrape, copy, train AI on it.
- **Attribution disappears.** Reposters strip metadata. AI systems erase origins.
- **Enforcement is reactive.** You find violations, send takedown notices, maybe sue.
- **Consent is implicit.** "Publicly available" is treated as "free for any use."

**None of this is sustainable.**

Creators either:
1. **Don't share** (cultural loss—knowledge hoarded)
2. **Share anyway** (exploitation—AI companies scrape freely)
3. **Use DRM** (user-hostile—breaks fair use, accessibility)

We need a fourth option: **structured, enforceable, propagatable consent**.

---

### 1.2 Why Existing Solutions Fail

**Copyright law:**
- Reactive (sue after the fact)
- Expensive (lawyers, courts)
- Slow (years of litigation)
- Jurisdiction-bound (US law ≠ EU law)

**Creative Commons licenses:**
- Not machine-enforceable (just legal text)
- No consent tracking (can't verify "permission granted")
- No propagation infrastructure (metadata lost in sharing)

**Terms of Service (ToS):**
- Platform-specific (every site different)
- Unreadable (10,000 words of legalese)
- Non-negotiable (take it or leave it)
- No cross-platform interoperability

**Digital Rights Management (DRM):**
- User-hostile (breaks devices, restricts fair use)
- Fragile (easily circumvented)
- Legally protected (DMCA makes bypassing illegal, even for legitimate reasons)

**What we need instead:** A consent layer that is:
- **Proactive** (prevents violations before they happen)
- **Scalable** (works for 1 work or 1 billion)
- **Interoperable** (cross-platform, cross-jurisdiction)
- **Transparent** (users know what they're consenting to)
- **Enforceable** (violations have consequences)
- **Non-DRM** (doesn't restrict technical capabilities, just legal permissions)

---

## 2. What Is a Consent Layer?

### 2.1 Definition

A **Consent Layer** is infrastructure that makes permission statements:
1. **Machine-readable** (computers can parse them)
2. **Cryptographically verifiable** (can't be forged)
3. **Propagatable** (travel with content as it moves)
4. **Auditable** (can verify "Did they have permission?")
5. **Revocable** (permission can be withdrawn)

### 2.2 Analogy: HTTPS for Consent

| Problem | Solution | How It Works |
|---------|----------|--------------|
| **HTTP (pre-2010s):** Data transmitted in plaintext; anyone can intercept | **HTTPS:** Encryption makes data private during transmission | TLS certificates, key exchange, encrypted channels |
| **Current internet:** Consent transmitted informally; anyone can ignore | **Consent Layer:** Structured permissions make consent enforceable | Metadata standards, consent registries, cryptographic signatures |

HTTPS didn't *prevent* interception—it made interception **visible and prosecutable**. Similarly, a Consent Layer doesn't prevent misuse—it makes misuse **detectable and actionable**.

---

### 2.3 Components of the Consent Layer

#### A. Metadata Standards
- **What:** Machine-readable permissions embedded in files/webpages
- **Formats:** JSON-LD, Schema.org, Dublin Core, IPTC
- **Example:**
  ```json
  {
    "@context": "https://schema.org",
    "@type": "CreativeWork",
    "name": "My Novel",
    "author": "Jane Doe",
    "license": "https://palimpsest.license/v0.4",
    "aiTrainingConsent": "required",
    "consentContact": "jane@example.com"
  }
  ```

#### B. Consent Registries
- **What:** Centralised/decentralised databases tracking permissions
- **Function:** "Has Jane Doe granted permission for OpenAI to train on 'My Novel'?"
- **Implementation:** RESTful APIs, blockchain-based ledgers, distributed hash tables
- **Privacy:** Opt-in (creators register explicitly)

#### C. Cryptographic Signatures
- **What:** Digital signatures proving authorship and permission grants
- **Function:** Prevents forgery ("This permission is really from Jane Doe")
- **Standards:** PGP/GPG, WebAuthn, blockchain signatures

#### D. Protocol Extensions
- **What:** Updates to HTTP, DNS, email protocols to carry consent metadata
- **Examples:**
  - HTTP headers: `X-License: Palimpsest-0.4`
  - DNS TXT records: `_license.example.com TXT "palimpsest-0.4"`
  - Email headers: `X-Copyright: Jane Doe; Consent-Required: AI-training`

#### E. Platform APIs
- **What:** Standard interfaces for requesting/granting consent
- **Function:** "YouTube, can I train on videos tagged #palimpsest?" → API checks consent, returns yes/no
- **Benefit:** Scalable (no manual emailing thousands of creators)

---

## 3. How the Consent Layer Works (End-to-End Example)

### Scenario: AI Company Wants to Train on Creative Works

**Step 1: Creator Publishes Work**
- Jane writes a novel, licenses it under Palimpsest
- She embeds metadata in EPUB file and webpage:
  ```html
  <meta name="license" content="https://palimpsest.license/v0.4">
  <meta name="consent-required" content="ai-training">
  <meta name="consent-contact" content="jane@example.com">
  ```
- She registers work in Consent Registry (optional but recommended)

**Step 2: AI Company Scrapes Web**
- OpenAI's crawler finds Jane's novel
- Checks metadata: `consent-required: ai-training`
- Queries Consent Registry: "Has Jane granted permission?"
- Result: No permission → Skip this work (or request consent)

**Step 3: AI Company Requests Consent**
- OpenAI sends request via Consent Registry API:
  ```json
  {
    "requester": "OpenAI",
    "work": "My Novel by Jane Doe",
    "use": "Training GPT-5",
    "terms": "Attribution in model card, $100 one-time fee"
  }
  ```
- Jane receives notification (email, dashboard)

**Step 4: Creator Grants (or Denies) Consent**
- Jane reviews request
- **Option A:** Grants consent → Registry updated, OpenAI can proceed
- **Option B:** Denies → Registry logs denial, OpenAI cannot use work
- **Option C:** Negotiates → "I want $500, not $100"

**Step 5: Verification and Audit**
- OpenAI trains GPT-5, includes consent log in dataset documentation
- Auditors (regulators, researchers, advocacy groups) can verify: "Did OpenAI have permission for all training data?"
- Registry provides proof: "Yes, Jane consented on [date], terms [link]"

**Step 6: Revocation (If Needed)**
- Jane later decides to revoke consent
- Updates Registry: "Consent withdrawn as of [date]"
- OpenAI must remove work from future training runs (per consent terms)

---

## 4. Technical Architecture

### 4.1 Layered Design

```
┌─────────────────────────────────────────┐
│  User Interface Layer                   │
│  (Creator dashboards, consent forms,    │
│   platform integrations)                │
└─────────────────────────────────────────┘
             ↕
┌─────────────────────────────────────────┐
│  Application Layer                      │
│  (Consent Registry APIs, validation     │
│   services, notification systems)       │
└─────────────────────────────────────────┘
             ↕
┌─────────────────────────────────────────┐
│  Protocol Layer                         │
│  (HTTP headers, DNS records, metadata   │
│   standards, cryptographic signing)     │
└─────────────────────────────────────────┘
             ↕
┌─────────────────────────────────────────┐
│  Storage Layer                          │
│  (Consent databases, blockchain ledgers,│
│   distributed hash tables)              │
└─────────────────────────────────────────┘
```

### 4.2 Consent Registry Architecture

**Design Principles:**
- **Decentralised:** No single point of failure or control
- **Federated:** Multiple registry providers (like email servers)
- **Interoperable:** Standard API (any client can query any registry)
- **Privacy-preserving:** Only creator, requester, and auditors see consent details

**Implementation Options:**

#### Option A: Federated Registry (Email Model)
- Each organisation runs a registry (e.g., `consent.creativecommons.org`, `consent.eff.org`)
- Creators choose a registry provider
- Registries sync via standard protocol (like SMTP for email)

**Pros:** Decentralised, privacy-preserving, no single authority
**Cons:** Complex to implement, requires coordination

#### Option B: Blockchain-Based Registry
- Consent records stored on blockchain (Ethereum, Arweave, etc.)
- Smart contracts enforce consent logic
- Immutable audit trail

**Pros:** Transparent, tamper-proof, globally accessible
**Cons:** Scalability issues, energy consumption (if proof-of-work), public visibility

#### Option C: Hybrid Model
- Public index on blockchain (work ID, consent status: yes/no)
- Private details in federated databases (who, what terms, when)
- Best of both: transparency + privacy

**Recommendation:** Start with centralised MVP, transition to hybrid by Year 2.

---

### 4.3 Metadata Embedding

**Where Metadata Lives:**

| Content Type | Metadata Location | Standard |
|--------------|------------------|----------|
| **Webpages** | `<meta>` tags, JSON-LD in `<script>` | Schema.org, Dublin Core |
| **Images** | EXIF, IPTC, XMP fields | IPTC Photo Metadata |
| **PDFs** | XMP metadata, document properties | Adobe XMP |
| **EPUBs** | `metadata.xml` in OPF package | EPUB 3 spec |
| **Audio/Video** | ID3 tags (MP3), XMP (MP4) | ID3v2, Adobe XMP |
| **Code** | Headers in source files, `LICENSE.md` | SPDX, Reuse.software |

**Example: Image with Consent Metadata**

```xml
<rdf:Description rdf:about=""
    xmlns:palimpsest="https://palimpsest.license/ns/">
  <dc:creator>Jane Doe</dc:creator>
  <dc:title>Sunset Over Mountains</dc:title>
  <dc:rights>Palimpsest License v0.4</dc:rights>
  <palimpsest:consentRequired>ai-training</palimpsest:consentRequired>
  <palimpsest:consentContact>jane@example.com</palimpsest:consentContact>
  <palimpsest:signature>sha256:a3f2b8...</palimpsest:signature>
</rdf:Description>
```

**Metadata Preservation:**
- Platforms (Flickr, DeviantArt, Medium) must not strip metadata
- File conversions must carry metadata forward
- Social media shares must include metadata (e.g., Twitter embeds license info in tweets linking to work)

---

### 4.4 Consent Request/Grant Protocol

**RESTful API Example:**

**Request Consent:**
```http
POST /consent/request
Content-Type: application/json

{
  "workId": "urn:isbn:978-0-123456-78-9",
  "requester": {
    "name": "OpenAI",
    "contact": "legal@openai.com",
    "publicKey": "ssh-rsa AAAAB3..."
  },
  "use": {
    "type": "ai-training",
    "description": "Training GPT-5 language model",
    "duration": "perpetual",
    "scope": "worldwide"
  },
  "terms": {
    "compensation": "$100 USD one-time",
    "attribution": "Model card and dataset documentation",
    "revocable": true
  }
}
```

**Grant Consent:**
```http
POST /consent/grant
Content-Type: application/json

{
  "requestId": "req-12345",
  "decision": "granted",
  "conditions": {
    "compensation": "$500 USD one-time",
    "attribution": "Model card, dataset docs, and public acknowledgment",
    "revocable": true,
    "auditTrail": "Annual reports on model usage"
  },
  "signature": "sig-abc123...",
  "timestamp": "2025-11-22T14:30:00Z"
}
```

**Query Consent:**
```http
GET /consent/status?workId=urn:isbn:978-0-123456-78-9&requester=OpenAI

Response:
{
  "status": "granted",
  "grantedOn": "2025-11-22T14:30:00Z",
  "terms": {...},
  "expiresOn": null,
  "revocable": true
}
```

---

## 5. Benefits for Stakeholders

### 5.1 For Creators

**Control:**
- Decide who uses your work, for what, under what terms
- Revoke consent if circumstances change
- Track where your work is used (consent logs show all requests)

**Sustainability:**
- Negotiate compensation for AI training (or other uses)
- Attribution preserved (metadata travels with work)
- Legal standing (consent records prove violations)

**Simplicity:**
- One-time metadata embedding → automatic enforcement
- No need to chase down violators manually
- Platform APIs handle consent requests at scale

---

### 5.2 For Platforms (GitHub, DeviantArt, Medium, etc.)

**Compliance:**
- Avoid legal risk (respecting consent reduces DMCA claims, lawsuits)
- Align with regulations (EU AI Act, UK Online Safety Bill)
- Demonstrate ethical leadership

**User Trust:**
- "We protect creators" → competitive advantage
- Transparent consent processes → user satisfaction
- Reduced moderation burden (automated consent checks)

**Technical Standards:**
- Interoperability with other platforms (consent metadata is standard)
- Easy integration (APIs, libraries, plugins available)

---

### 5.3 For AI Developers

**Legal Clarity:**
- No ambiguity: "Did I have permission?" → Query registry
- Defensible datasets: "Yes, here's proof of consent"
- Reduced litigation risk

**Ethical Differentiation:**
- "We only train on consented data" → trust signal
- Public consent logs → transparency
- Attracts ethical investors, customers

**Higher-Quality Datasets:**
- Curated, not scraped (creators opt in)
- Better metadata (provenance, context)
- Sustainable supply (creators keep contributing)

---

### 5.4 For Users/Public

**Transparency:**
- Know how your data/content is used
- Audit AI training datasets ("What was GPT-5 trained on?")
- Hold companies accountable

**Fair Use Preserved:**
- Consent Layer ≠ DRM (doesn't restrict reading, sharing, personal use)
- Only affects specific uses (AI training, commercial exploitation)
- Supports remix culture (consent can be "yes, freely" for derivatives)

**Cultural Commons:**
- More creators share (knowing they won't be exploited)
- Richer public domain (consent expires, works enter commons)
- Diverse voices (marginalised creators have tools to protect work)

---

## 6. Industry Adoption Roadmap

### Phase 1: Standards Development (Months 1-12)

**Goals:**
- Finalise metadata specifications
- Publish Consent Registry API v1.0
- Develop reference implementations (libraries, tools)

**Activities:**
- W3C Community Group: "Creative Works Consent Layer"
- IETF draft: "HTTP Extensions for License and Consent Metadata"
- SPDX working group: Integrate Palimpsest identifiers
- ISO/IEC liaison: Position as international standard

**Deliverables:**
- Metadata spec v1.0
- Consent Registry API spec v1.0
- Reference libraries (JavaScript, Python, Rust)
- W3C/IETF draft standards

---

### Phase 2: Pilot Programmes (Months 13-24)

**Goals:**
- 5 platforms adopt Consent Layer
- 10,000 creators use consent infrastructure
- 3 AI companies integrate with consent registries

**Activities:**
- Partner with early adopters:
  - **Platforms:** Hugging Face (dataset hosting), Archive.org (cultural preservation), Bandcamp (music)
  - **AI Companies:** Anthropic (ethical AI), Stability AI (open models), Cohere (NLP)
- Case studies documenting benefits
- User feedback and iteration

**Deliverables:**
- 5 platform integrations live
- 10,000 works with consent metadata
- 3 AI company partnerships
- Pilot evaluation report

---

### Phase 3: Mainstream Adoption (Months 25-36)

**Goals:**
- Major platforms (GitHub, DeviantArt, Medium, YouTube) integrate
- Industry standards ratified (W3C, IETF)
- Regulatory alignment (EU, UK, US recognise Consent Layer)

**Activities:**
- Enterprise sales to platforms (pitch legal/ethical benefits)
- Regulatory engagement (position as compliance tool for AI Act)
- Public awareness campaigns (media, conferences, advocacy)

**Deliverables:**
- 20+ platform integrations
- W3C Recommendation or IETF RFC published
- 1 million works with consent metadata
- Regulatory guidance referencing Consent Layer

---

### Phase 4: Global Standard (Years 4-5)

**Goals:**
- Consent Layer is default infrastructure (like HTTPS)
- 100+ million works protected
- Consent metadata routinely audited in AI systems

**Activities:**
- International expansion (Asia, Africa, South America)
- Education (universities teach consent infrastructure)
- Enforcement (legal precedents, regulatory fines)

**Deliverables:**
- ISO/IEC standard adopted
- Consent Layer in school curricula
- Legal precedents in 10+ jurisdictions

---

## 7. Addressing Concerns

### "This will break the open internet."

**Response:**
- Consent Layer is opt-in (creators choose to require consent)
- Doesn't prevent reading, sharing, or remixing for human purposes
- Only affects automated pattern extraction (AI training) and similar uses
- Analogy: HTTPS didn't "break" the internet—it improved it

---

### "It's technically infeasible."

**Response:**
- Metadata embedding: Already works (EXIF, IPTC, ID3 tags)
- Consent registries: Proven tech (OAuth, federated auth, blockchain)
- Protocol extensions: Standard process (HTTP/2, DNSSEC evolved this way)
- Interoperability: REST APIs are ubiquitous

**Challenges exist, but they're engineering problems, not fundamental impossibilities.**

---

### "No one will adopt it."

**Response:**
- Regulatory pressure (EU AI Act will require training data transparency)
- Legal risk (AI companies face lawsuits for unauthorised training)
- Market demand (creators want protection; 10,000+ already using Palimpsest)
- Network effects (once GitHub adopts, others follow)

**Adoption follows incentives. We're creating them.**

---

### "It's just DRM by another name."

**Response:**

| DRM | Consent Layer |
|-----|--------------|
| **Technical restriction** (prevents file opening/copying) | **Legal framework** (metadata states permissions) |
| **User-hostile** (breaks devices, accessibility) | **User-neutral** (doesn't restrict technical capabilities) |
| **Proprietary** (vendor lock-in) | **Open standard** (anyone can implement) |
| **Opaque** (hidden enforcement mechanisms) | **Transparent** (public metadata, auditable registries) |
| **Legally protected** (DMCA prohibits circumvention) | **Not protected as DRM** (you can ignore metadata—but face legal consequences under copyright law, not DMCA) |

**Consent Layer is permission infrastructure, not access control.**

---

## 8. Business Models

### 8.1 For Consent Registry Providers

**Revenue Sources:**
1. **Freemium Model:**
   - Free: Basic consent tracking (100 works)
   - Paid: Advanced features (unlimited works, analytics, API access) → £5/month
2. **Enterprise Licensing:**
   - Platforms pay for API access → £10,000/year per platform
3. **Transaction Fees:**
   - Charge 5% of consent payments (e.g., creator gets £500 from AI company, registry takes £25)

**Example Providers:**
- Creative Commons (non-profit, donor-funded)
- Internet Archive (mission-aligned)
- For-profit startups (venture-backed)

---

### 8.2 For Platforms

**Cost:**
- Integration: £50,000-£200,000 (API development, UI changes, metadata infrastructure)
- Ongoing: £20,000/year (registry subscription, maintenance)

**Benefit:**
- Reduced legal risk (fewer DMCA claims, lawsuits)
- Competitive advantage ("We protect creators")
- Regulatory compliance (EU AI Act, UK Online Safety Bill)

**ROI:**
- Legal savings alone justify cost (one lawsuit costs £100,000+)

---

### 8.3 For AI Developers

**Cost:**
- Registry integration: £30,000 (API client, consent workflow)
- Consent payments: Variable (£100-£1,000 per work, depending on negotiation)

**Benefit:**
- Legal defensibility (no "unauthorised training" lawsuits)
- Ethical branding (attracts customers, investors)
- Better datasets (curated, not scraped)

**ROI:**
- Litigation avoidance (Stability AI, GitHub Copilot face multi-million-pound lawsuits)
- Market differentiation (ethical AI commands premium pricing)

---

## 9. Technical Specifications (Summary)

**Full specs available at:**
- Metadata: https://palimpsest.license/specs/metadata
- Consent Registry API: https://palimpsest.license/specs/registry-api
- Protocol Extensions: https://palimpsest.license/specs/protocols

**Key Standards:**
- **Metadata:** JSON-LD + Schema.org + Dublin Core
- **API:** RESTful, OpenAPI 3.0 spec
- **Cryptography:** Ed25519 signatures, SHA-256 hashing
- **Identifiers:** URNs (ISBN, DOI, ISNI) + content hashes

---

## 10. Call to Action

### For Platforms
**Integrate consent infrastructure:**
1. Add license/consent metadata fields to uploads
2. Display consent requirements on work pages
3. Connect to Consent Registry API for permission checks
4. Preserve metadata in shares, embeds, downloads

**Contact:** integrations@palimpsest.license

---

### For AI Companies
**Adopt ethical data sourcing:**
1. Check consent metadata before training
2. Request permission via Consent Registry
3. Document consent in dataset cards
4. Support creator compensation models

**Contact:** ai-partnerships@palimpsest.license

---

### For Creators
**Protect your work:**
1. License under Palimpsest (or add consent metadata)
2. Register in Consent Registry (optional)
3. Respond to consent requests
4. Track how your work is used

**Get started:** https://palimpsest.license/adopt

---

### For Standards Bodies
**Formalise consent infrastructure:**
1. W3C: Community Group → Working Group → Recommendation
2. IETF: Internet-Draft → RFC
3. ISO/IEC: Liaison for international standard

**Contact:** standards@palimpsest.license

---

## 11. Conclusion

The internet needs a Consent Layer.

We built infrastructure for moving data, but not for moving permission. The result: exploitation, extraction, and erosion of trust.

A Consent Layer doesn't restrict sharing—it makes sharing *sustainable*. Creators can contribute to the commons knowing they won't be exploited. Platforms can host content knowing they're respecting rights. AI developers can build models knowing their datasets are ethical.

**This is the next evolution of internet architecture.**

It's not about control. It's about **consent**. It's not about enclosure. It's about **legibility**.

**Join us in building the Consent Layer for the internet.**

---

## Appendices

### Appendix A: Technical Architecture

See companion document: `technical-architecture.md`

### Appendix B: Business Case for Platforms

See companion document: `business-case.md`

### Appendix C: User Rights and Benefits

See companion document: `user-rights.md`

### Appendix D: Industry Adoption Roadmap

See companion document: `adoption-roadmap.md`

---

**Document Version:** 1.0
**Date:** November 2025
**Authors:** Palimpsest Stewardship Council + Consent Layer Working Group
**License:** CC BY 4.0

**Website:** https://consent-layer.org
**Contact:** hello@consent-layer.org
