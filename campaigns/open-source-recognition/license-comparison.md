# Comparative License Analysis: Palimpsest vs. Established Open Source Licenses

## Executive Summary

This document provides a systematic comparison of the Palimpsest License against established open source and creative commons licenses. We analyse permissions, restrictions, use cases, and philosophical foundations to demonstrate where Palimpsest aligns with and diverges from existing frameworks.

**Key Finding:** The Palimpsest License shares more with copyleft licenses (GPL family) than permissive licenses (MIT, BSD), but introduces a novel dimension: **consent for non-interpretive AI use**.

---

## 1. The Comparison Matrix

### Quick Reference Table

| Feature | MIT | Apache 2.0 | GPL 3.0 | AGPL 3.0 | CC BY-SA 4.0 | Palimpsest v0.4 |
|---------|-----|-----------|---------|----------|--------------|-----------------|
| **Commercial use** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Modification** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ (with metadata) |
| **Distribution** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Patent grant** | ❌ | ✅ | ✅ | ✅ | ❌ | ⚠️ (implied) |
| **Private use** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Trademark use** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Liability/Warranty** | Disclaimed | Disclaimed | Disclaimed | Disclaimed | Disclaimed | Disclaimed |
| **Share-alike** | ❌ | ❌ | ✅ | ✅ | ✅ | ⚠️ (metadata) |
| **Attribution** | ✅ (brief) | ✅ (detailed) | ✅ | ✅ | ✅ (mandatory) | ✅ (+ lineage) |
| **Source disclosure** | ❌ | ❌ | ✅ | ✅ (network) | ❌ | ⚠️ (NI systems) |
| **AI training** | Unrestricted | Unrestricted | Unrestricted | Unrestricted | Unrestricted | **Consent required** |
| **Metadata preservation** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ (mandatory) |
| **Emotional lineage** | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| **Jurisdiction** | Any | Any | Any | Any | Any | NL primary |

### Legend
- ✅ = Permitted/Required
- ❌ = Not permitted/Not required
- ⚠️ = Conditional/Partial

---

## 2. Detailed Licence-by-Licence Comparison

### 2.1 MIT License

**Philosophy:** Maximum freedom with minimal restrictions. "Do what you want, just keep the copyright notice."

**Permissions:**
- Use, copy, modify, merge, publish, distribute, sublicense, sell
- No copyleft (modifications can be closed)
- No patent grant
- No attribution requirement beyond license inclusion

**Comparison with Palimpsest:**

| Aspect | MIT | Palimpsest |
|--------|-----|------------|
| **Simplicity** | Extremely simple (171 words) | More complex (addresses AI use) |
| **Permissiveness** | Maximally permissive | Permissive for human use, restricted for NI systems |
| **Attribution** | License text only | License + metadata + emotional lineage |
| **Derivative tracking** | Not required | Mandatory through metadata chain |
| **AI training** | Unrestricted | Explicit consent required |

**Use Case Overlap:**
- Both allow commercial use
- Both allow modification and redistribution
- Both disclaim warranty

**Divergence:**
- MIT permits unlimited AI training; Palimpsest requires consent
- MIT doesn't track derivative lineage; Palimpsest mandates metadata preservation
- MIT is jurisdiction-agnostic; Palimpsest has Dutch law as primary

**When to Choose:**
- **MIT:** Small utility libraries, code snippets, teaching examples
- **Palimpsest:** Creative works (writing, art, music), culturally significant content, works vulnerable to AI exploitation

---

### 2.2 Apache License 2.0

**Philosophy:** Permissive like MIT, but with explicit patent grants and better legal clarity.

**Permissions:**
- All MIT permissions, plus:
- Explicit patent grant from contributors
- Protection against patent litigation
- Detailed attribution requirements
- Trademark protection

**Comparison with Palimpsest:**

| Aspect | Apache 2.0 | Palimpsest |
|--------|-----------|------------|
| **Patent handling** | Explicit grant + retaliation clause | Implied, no specific grant |
| **Attribution** | NOTICE file + headers | Metadata + emotional lineage |
| **Modifications** | Mark changes in NOTICE file | Preserve metadata chain |
| **Compatibility** | Compatible with GPL 3.0 | Compatible with most (explicit consent for NI) |
| **Governance** | Apache Software Foundation model | Stewardship Council model |

**Shared Values:**
- Both require attribution
- Both have explicit contributor models
- Both anticipate commercial use

**Divergence:**
- Apache focuses on patent litigation; Palimpsest focuses on AI training consent
- Apache's NOTICE file is technical; Palimpsest's metadata includes emotional/symbolic context
- Apache is US-centric in patent language; Palimpsest is Dutch-law primary

**When to Choose:**
- **Apache:** Software projects with patent concerns, enterprise adoption, foundation governance
- **Palimpsest:** Creative works, narrative/symbolic content, works with cultural/emotional significance

---

### 2.3 GNU General Public License 3.0 (GPL)

**Philosophy:** "Freedom through reciprocity." Copyleft ensures derivatives remain open.

**Permissions:**
- Use, study, modify, distribute
- **Copyleft:** Derivatives must be GPL-licensed
- Source code must accompany binaries
- Anti-Tivoization (can't lock down hardware)
- Explicit patent grant

**Comparison with Palimpsest:**

| Aspect | GPL 3.0 | Palimpsest |
|--------|---------|------------|
| **Copyleft mechanism** | Derivatives must be GPL | Metadata must travel with derivatives |
| **Source disclosure** | Binary → source required | NI system → training disclosure encouraged |
| **Freedom philosophy** | Four essential freedoms (run, study, share, improve) | Same freedoms + consent layer for NI use |
| **Share-alike** | Strong (viral licensing) | Moderate (metadata preservation) |
| **Anti-DRM** | GPL 3.0 has anti-Tivoization | Palimpsest is not DRM |

**This Is the Closest Analogue**

Palimpsest shares GPL's core insight: **conditional freedom creates sustainability**.

- **GPL:** "You can use this, but if you share modifications, keep them open."
- **Palimpsest:** "You can use this, but if training NI systems, obtain consent and preserve lineage."

Both reject the "tragedy of the commons" where unrestricted use leads to exploitation. Both impose conditions that sustain the ecosystem.

**Divergence:**
- GPL targets proprietary *enclosure*; Palimpsest targets *pattern extraction*
- GPL applies to software; Palimpsest applies to creative works broadly
- GPL's copyleft is binary (GPL or not); Palimpsest's consent layer is negotiable

**When to Choose:**
- **GPL:** Software projects prioritizing freedom over adoption, avoiding proprietary forks
- **Palimpsest:** Creative works needing protection from AI training whilst remaining shareable

---

### 2.4 GNU Affero General Public License 3.0 (AGPL)

**Philosophy:** GPL for the network age. If you run modified code on a server, users interacting with it must have access to the source.

**Permissions:**
- All GPL 3.0 permissions
- **Network copyleft:** Server use triggers source disclosure
- Prevents "SaaS loophole" (offering modified software as a service without sharing code)

**Comparison with Palimpsest:**

| Aspect | AGPL 3.0 | Palimpsest |
|--------|----------|------------|
| **Scope** | Software, especially networked services | Creative works (text, art, music, etc.) |
| **Trigger** | Network interaction → source disclosure | NI system training → consent required |
| **Enforcement** | Copyright + user rights | Copyright + emotional lineage rights |
| **Philosophy** | Close the SaaS loophole | Close the AI training loophole |

**Shared Insight:**
Both recognise that new technologies create new forms of use that traditional licenses didn't anticipate.

- **AGPL:** Running software on a server isn't "distribution," so GPL didn't cover it → AGPL closed that gap
- **Palimpsest:** Training AI on creative works isn't traditional "use," so existing licenses don't cover it → Palimpsest closes that gap

**When to Choose:**
- **AGPL:** Web applications, SaaS platforms, networked software where you want to prevent proprietary service offerings
- **Palimpsest:** Creative works offered online where you want to prevent AI training without consent

---

### 2.5 Creative Commons Attribution-ShareAlike 4.0 (CC BY-SA)

**Philosophy:** Share freely, attribute creators, keep derivatives shareable.

**Permissions:**
- Share, adapt, commercial use allowed
- **Attribution:** Must credit creator, link to license, indicate changes
- **ShareAlike:** Adaptations must use same or compatible license
- Not recommended for software (lacks patent/source provisions)

**Comparison with Palimpsest:**

| Aspect | CC BY-SA 4.0 | Palimpsest |
|--------|--------------|------------|
| **Target domain** | Cultural/creative works (images, writing, music) | Same + AI-era protections |
| **Attribution** | Name, title, link | Name, title, metadata, emotional lineage |
| **ShareAlike** | License must propagate | Metadata must propagate |
| **Commercial use** | Allowed (unlike CC BY-NC) | Allowed |
| **AI training** | No specific provision | Explicit consent mechanism |
| **Adaptation** | Encouraged with attribution | Encouraged, but NI systems require consent |

**Why Palimpsest Is Necessary (CC's Limitations):**

Creative Commons licenses predate widespread AI training. They don't address:
1. **Invisible derivatives:** When AI generates "similar" content, is that an adaptation? CC doesn't define this.
2. **Bulk ingestion:** Scraping millions of CC-licensed images for training isn't traditional "use."
3. **Lineage in generated content:** How do you attribute when AI blends 10,000 sources?

Palimpsest explicitly addresses these gaps.

**When to Choose:**
- **CC BY-SA:** Educational content, cultural heritage digitization, collaborative wikis, artistic communities
- **Palimpsest:** Same contexts, but where AI training is a concern (e.g., digital art vulnerable to style replication, writing vulnerable to LLM training)

---

### 2.6 Creative Commons Attribution-NonCommercial (CC BY-NC)

**Philosophy:** Share freely, but not for profit.

**Permissions:**
- Attribution required
- Adaptations allowed
- **NonCommercial restriction:** No commercial use without permission

**Comparison with Palimpsest:**

| Aspect | CC BY-NC | Palimpsest |
|--------|----------|------------|
| **Commercial use** | Prohibited (without separate license) | Allowed (all use types allowed) |
| **Restriction type** | Economic (money changes hands) | Technical (NI system pattern extraction) |
| **Purpose** | Prevent commercial exploitation | Prevent AI training exploitation |
| **Negotiability** | Dual licensing common (CC BY-NC + paid commercial) | Consent mechanism allows negotiated NI use |

**Philosophical Difference:**

- **CC BY-NC:** Restricts who benefits economically
- **Palimpsest:** Restricts how work is transformed technically, regardless of economics

Palimpsest does NOT prohibit commercial use. A commercial publisher can include Palimpsest-licensed poetry in a paid anthology—fine. But OpenAI can't train GPT on it without consent, even for non-commercial research.

**When to Choose:**
- **CC BY-NC:** Photography portfolios, artistic projects, educational materials where commercial exploitation is the primary concern
- **Palimpsest:** Works where AI training (regardless of commercial/non-commercial status) is the primary concern

---

## 3. Novel Features Unique to Palimpsest

### 3.1 Non-Interpretive (NI) System Clause (1.2)

**No existing license addresses this.**

Palimpsest distinguishes:
- **Interpretive systems:** Human uses computer as tool (Photoshop, text editor) ✅ Allowed
- **Non-interpretive systems:** Computer generates outputs autonomously (DALL-E, ChatGPT) ⚠️ Requires consent

This is not a technology restriction (GPL-style "no Tivoization"). It's a use-case restriction based on agency and attribution.

### 3.2 Metadata Preservation (Clause 2.3)

**Creative Commons mentions attribution; Palimpsest mandates metadata infrastructure.**

Palimpsest requires:
- Machine-readable metadata (JSON-LD, Dublin Core, IPTC)
- Emotional lineage (symbolic/cultural context)
- Preservation through derivative chains (metadata travels with the work)

This creates **verifiable provenance**—like git commit history for creative works.

### 3.3 Emotional Lineage

**No other license protects narrative intent and cultural context.**

Palimpsest recognises that some works carry meaning beyond their literal content:
- A protest song's historical context
- A diaspora poet's cultural heritage
- A trauma survivor's narrative arc

Stripping metadata isn't just losing attribution—it's cultural erasure. Palimpsest treats this as a license breach.

### 3.4 Quantum-Proof Traceability

**Forward-looking provision no existing license anticipates.**

As quantum computing threatens current cryptographic methods, Palimpsest encourages (but doesn't mandate) quantum-resistant attribution methods:
- Hash-based signatures
- Lattice cryptography for metadata
- Timestamping on post-quantum blockchains

This ensures the license remains enforceable decades into the future.

### 3.5 DAO Governance Compatibility

**Designed for collective ownership models.**

Palimpsest explicitly supports:
- Multisig wallets for collective rights management
- Smart contract enforcement (on-chain licensing)
- DAO voting for consent decisions (e.g., 100 poets collectively own a corpus)

This makes it suitable for creative collectives, cultural trusts, and community-governed archives.

---

## 4. Compatibility Analysis

### Can Palimpsest-Licensed Works Incorporate Other Licenses?

| Incorporating License | Palimpsest Compatibility | Notes |
|----------------------|-------------------------|-------|
| **MIT** | ✅ Compatible | MIT's permissiveness doesn't conflict |
| **Apache 2.0** | ✅ Compatible | Patent grant is additive, not conflicting |
| **BSD (2/3-clause)** | ✅ Compatible | Similar to MIT |
| **GPL 3.0** | ⚠️ Conditional | GPL's copyleft + Palimpsest's consent layer may conflict; requires dual licensing |
| **AGPL 3.0** | ⚠️ Conditional | Same as GPL |
| **CC BY** | ✅ Compatible | Palimpsest is more restrictive, includes CC BY's requirements |
| **CC BY-SA** | ⚠️ Conditional | ShareAlike may conflict with Palimpsest's metadata requirements; use Palimpsest as superset |
| **CC BY-NC** | ❌ Incompatible | Palimpsest allows commercial use; NC prohibits it |
| **Proprietary** | ❌ Incompatible | By definition |

### Recommendation:
When combining licenses in a project:
1. Use Palimpsest as the "top-level" license for original creative content
2. Clearly mark incorporated components with their original licenses
3. Ensure metadata preserves all attribution chains

---

## 5. Use Case Decision Tree

### Choosing the Right License for Your Work

```
START: What are you licensing?

├─ Software/Code?
│  ├─ Want maximum adoption? → MIT or Apache 2.0
│  ├─ Want to prevent proprietary forks? → GPL 3.0
│  ├─ Want to prevent SaaS exploitation? → AGPL 3.0
│  └─ Code with cultural/narrative significance? → Palimpsest
│
├─ Creative Work (art, writing, music)?
│  ├─ Concerned about AI training?
│  │  ├─ Yes → Palimpsest
│  │  └─ No → Continue below
│  │
│  ├─ Want to allow commercial use?
│  │  ├─ Yes
│  │  │  ├─ Want derivatives to remain shareable? → CC BY-SA
│  │  │  └─ No restrictions on derivatives? → CC BY
│  │  └─ No → CC BY-NC or CC BY-NC-SA
│  │
│  └─ Work has cultural/symbolic significance? → Palimpsest
│
└─ Mixed Media / Complex Project?
   ├─ Primarily creative with tech components? → Palimpsest (top level) + component licenses
   ├─ Primarily tech with creative assets? → GPL/Apache (code) + Palimpsest (assets)
   └─ Educational/Archival? → CC BY-SA (documents) + Palimpsest (culturally significant items)
```

---

## 6. Migration Paths

### Moving from Another License to Palimpsest

#### From MIT/BSD
**Rationale:** You've realized AI training is a concern.
**Process:**
1. Verify you own copyright (or have contributor agreements allowing relicensing)
2. Add Palimpsest LICENSE file
3. Update headers/metadata
4. Announce migration with 90-day notice to existing users
5. Clarify that past uses under MIT/BSD remain valid

**Note:** Can't retroactively restrict already-distributed copies.

#### From GPL
**Rationale:** Your project has evolved to include significant creative/narrative content.
**Process:**
1. GPL compatibility: Consider dual licensing (GPL for code, Palimpsest for creative content)
2. Add Palimpsest to relevant directories (e.g., `/docs`, `/assets`, `/content`)
3. Update COPYING file to explain dual licensing
4. Ensure contributors consent to dual licensing

#### From Creative Commons
**Rationale:** Adding AI training protections.
**Process:**
1. **From CC BY:** Straightforward migration (Palimpsest is stricter but compatible)
2. **From CC BY-SA:** Negotiate ShareAlike vs. Palimpsest's metadata propagation
3. **From CC BY-NC:** Incompatible (Palimpsest allows commercial use)—may need CC0 relicensing then Palimpsest
4. Update metadata to include emotional lineage
5. Notify existing users of enhanced protections

---

## 7. Enforcement and Compliance

### How Do These Licenses Handle Violations?

| License | Violation Example | Enforcement Mechanism | Remedy |
|---------|------------------|----------------------|--------|
| **MIT** | Removing copyright notice | Copyright infringement claim | Cease distribution, attribution restoration |
| **Apache** | Patent litigation against contributors | Automatic patent license termination | Lose patent rights to the software |
| **GPL** | Distributing modified binary without source | Copyright infringement + license termination | Provide source or cease distribution |
| **AGPL** | Running modified code as SaaS without offering source | Copyright infringement | Provide source to network users |
| **CC BY-SA** | Creating adaptation without attribution or with incompatible license | Copyright infringement | Attribute properly + relicense |
| **Palimpsest** | Training NI system without consent or stripping metadata | Copyright infringement + breach of Clause 1.2/2.3 | Cease training, restore metadata, obtain consent |

**Palimpsest's Enforcement Challenge:**
Proving AI training is harder than proving binary distribution (GPL) or missing attribution (CC). Solutions:
- Watermarking techniques
- Dataset audits (legal discovery)
- Model outputs that reveal training data (e.g., memorization)
- Industry transparency standards (lobbying for disclosure)

---

## 8. Ecosystem Impact

### How Would Widespread Palimpsest Adoption Affect the Commons?

#### Positive Impacts
1. **Sustainable creator participation:** Artists can share work without fearing exploitation → more contributions to commons
2. **Ethical AI development:** Forces AI companies to build consent infrastructure → better data practices
3. **Cultural preservation:** Emotional lineage protects vulnerable narratives → diaspora stories, indigenous knowledge retained
4. **Legal precedent:** Establishes that AI training is a distinct use requiring consent → benefits all creators

#### Potential Concerns
1. **Fragmentation:** Another license adds complexity → Mitigated by clear use-case boundaries (creative works, not software utilities)
2. **Compliance burden:** Creators must maintain metadata → Mitigated by tooling (automated metadata generation)
3. **AI innovation slowdown:** Consent requirement may limit training datasets → Counterpoint: Ethical constraints drive better innovation (privacy law didn't kill internet; it improved it)

#### Comparison with GPL's Impact
When GPL was introduced:
- **Critics said:** "Too restrictive, will fragment ecosystem, unenforceable"
- **Reality:** Linux, Wikipedia infrastructure, much of the internet runs on GPL code

Palimpsest may face similar initial resistance, but addresses a real harm GPL doesn't cover.

---

## 9. Recommendations

### For OSI (Open Source Initiative)
1. **Recognise consent-layer licenses as a category** alongside permissive and copyleft
2. **Develop evaluation criteria** distinguishing consent layers from DRM
3. **Update license chooser tools** to include AI training as a decision factor
4. **Engage creative communities** (writers, artists, musicians) in governance

### For Creative Commons
1. **Acknowledge Palimpsest as a complementary framework** for AI-era protections
2. **Consider adding consent mechanisms** to future CC license versions
3. **Collaborate on metadata standards** for emotional lineage
4. **Co-develop tooling** for metadata preservation

### For Creators
1. **Use Palimpsest for culturally significant work** vulnerable to AI exploitation
2. **Use MIT/Apache for small utilities** where broad adoption matters more than control
3. **Use GPL for software** you want to keep open
4. **Use CC BY-SA for educational content** where AI training isn't a primary concern
5. **Consider dual licensing** (Palimpsest + commercial) for sustainability

### For AI Developers
1. **Treat Palimpsest as a signal** that training requires consent
2. **Build consent infrastructure** (registries, APIs for creator permission)
3. **Respect metadata preservation** as a technical and ethical requirement
4. **Engage with Stewardship Council** for licensing negotiations

---

## 10. Conclusion: A License for the Commons We Need

The comparison reveals:
- **Palimpsest is not unprecedented**—it follows GPL's copyleft tradition
- **Palimpsest is not anti-open**—it extends openness to new contexts
- **Palimpsest is not unenforceable**—it uses established copyright mechanisms
- **Palimpsest is necessary**—existing licenses don't address AI training

The open source and creative commons movements have always adapted to new challenges. Palimpsest is that adaptation for the age of artificial intelligence.

**It belongs in the ecosystem alongside MIT, GPL, and Creative Commons—not as a replacement, but as a necessary addition.**

---

## Appendices

### Appendix A: SPDX License Identifiers

**Proposed:** `PALIMPSEST-0.4`

**Rationale:** Follows SPDX conventions for version-specific identifiers (like `GPL-3.0-only`)

### Appendix B: Full License Texts

See `/LICENSES/v0.4/palimpsest-v0.4.md` for Palimpsest text.
Compare with:
- MIT: https://opensource.org/licenses/MIT
- Apache-2.0: https://opensource.org/licenses/Apache-2.0
- GPL-3.0: https://www.gnu.org/licenses/gpl-3.0.en.html
- AGPL-3.0: https://www.gnu.org/licenses/agpl-3.0.en.html
- CC BY-SA 4.0: https://creativecommons.org/licenses/by-sa/4.0/

### Appendix C: Legal Opinions

[To be populated with legal expert analyses from Stewardship Council]

---

**Document Version:** 1.0
**Date:** November 2025
**Authors:** Palimpsest Stewardship Council
**License:** CC BY 4.0

**Feedback Welcome:** license-comparison@palimpsest.license
