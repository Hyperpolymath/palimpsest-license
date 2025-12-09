# The Palimpsest License v0.6

**Human-Centered Content Licensing in the AI Era**

- **License Version:** 0.6
- **Effective Date:** 2025-10-31
- **Previous Version:** 0.5 (superseded)

---

## Preamble

The Palimpsest License creates a framework for ethical content use in an era of artificial intelligence and automated systems. Named after manuscripts written over erased earlier text—where traces of the original remain visible—this license ensures that creators maintain attribution and ethical use rights even as their work is transformed, remixed, or used in AI training.

This license is designed to:

- Protect human creators while enabling beneficial AI development
- Maintain attribution through transformation and derivative works
- Establish clear ethical boundaries for content use
- Support technical enforcement through web protocols
- Balance openness with responsibility

### Integration with Web Protocols

This license works alongside standardized web protocols for AI interaction:

- **AI Agent Identification Protocol** (for AI system transparency)
- **AI Boundary Declaration Protocol / AIBDP** (for machine-readable access rules)
- **HTTP 430 Consent Required** (for explicit permission management)
- **Content Provenance Protocol** (for attribution tracking)

These protocols are optional but recommended for technical enforcement of license terms.

### Note on Open Source Compatibility

This license includes ethical use requirements that mean it does not meet the Open Source Initiative (OSI) definition of "open source." When dual-licensed with OSI-approved licenses (MIT, Apache-2.0, GPL, AGPL), users may choose the OSI license for standard open source rights, or this license for additional ethical protections.

---

## 1. Definitions

### 1.1 Core Terms

**Work:** The original creation being licensed.

**Remix:** Any adaptation, transformation, or modification of the Work.

**Attribution:** Credit to the original creator as specified by them, including:

- Name or pseudonym
- Link to original Work (if applicable)
- Statement that changes were made (if applicable)
- Reference to this license

**Ethical Use:** Use that satisfies ALL of the following:

a) **Attribution Integrity:** Does not falsely claim authorship or remove/obscure the original creator's attribution

b) **Contextual Integrity:** Does not present the Work in a context that would reasonably mislead recipients about its origin, purpose, or the creator's views

c) **Reputational Protection:** Does not use the Work in association with content or purposes that would:

- Violate applicable laws (including but not limited to laws against hate speech, harassment, or fraud)
- Damage the creator's professional reputation through knowing misrepresentation
- Associate the creator with causes, products, or views they have publicly documented as opposing

d) **Good Faith Interpretation:** When the original intent is ambiguous, the user has made reasonable efforts to understand and respect the creator's documented intent, or has clearly marked their interpretation as their own

**Safe Harbor:** Use is considered Ethical if the user:

- Provides clear and accurate attribution
- Clearly distinguishes their modifications from the original
- Does not violate subsections (a), (b), or (c) of Ethical Use
- Responds in good faith to creator concerns within 30 days of notice

### 1.2 AI and Technical Terms

**AI System:** Any artificial intelligence, machine learning system, large language model, or automated system capable of content generation, transformation, or learning from data.

**AI Training:** The process of using the Work as training data for machine learning models, including but not limited to:

- Initial model training
- Fine-tuning and adaptation
- Retrieval-augmented generation (RAG)
- Few-shot learning examples
- Knowledge base population

**AI-Generated Derivative:** Content produced by an AI System where the Work was used as training data, reference material, or generation input.

**Content Provenance:** The documented history of content creation and modification, as defined by the Content Provenance Protocol (if implemented).

**Consent Token:** A cryptographic token indicating that explicit consent has been obtained for specific uses, as defined by HTTP 430 Consent Required (if implemented).

---

## 2. Grant of Rights

The licensor grants you a worldwide, royalty-free, non-exclusive, perpetual license to:

- **Share:** Copy and redistribute the Work in any medium or format
- **Remix:** Adapt, transform, or build upon the Work for any purpose, including commercially
- **Train:** Use the Work for AI training and machine learning purposes
- **Generate:** Create AI-generated derivatives using the Work

---

## 3. Conditions

You must comply with ALL of the following:

### 3.1 Attribution

You must give appropriate credit as defined in Section 1.1, provide a link to this license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

**For AI-Generated Derivatives:** Attribution must be maintained in any publicly shared outputs that substantially reproduce or are substantially derived from the Work. "Substantially" means that a reasonable person would recognize significant portions or core elements of the Work in the output.

### 3.2 Ethical Use

You must use and distribute the Work in accordance with the Ethical Use requirements defined in Section 1.1.

### 3.3 ShareAlike

If you remix, transform, or build upon the Work, you must distribute your contributions under:

- This license (same version or later), OR
- A compatible license (see Section 7)

This requirement applies to:

- Direct derivatives (translations, adaptations, etc.)
- AI-generated content that substantially reproduces the Work
- Compilations where the Work is a substantial component

### 3.4 Notice Preservation

You must retain all copyright, license, and attribution notices in any copies or derivatives of the Work.

---

## 4. AI and Automated Systems

### 4.1 Permitted AI Use

Use of the Work for training machine learning models, large language models, or other AI systems is explicitly permitted under this license, provided you comply with all other license terms, particularly:

- Ethical Use requirements are maintained in any outputs or derivatives
- Attribution is maintained in any publicly shared outputs that substantially reproduce the Work
- The AI system itself is not used to circumvent the Ethical Use requirements

### 4.2 AI System Identification (Recommended)

When accessing Palimpsest-licensed content programmatically, AI systems SHOULD identify themselves using the AI Agent Identification Protocol headers:

```http
AI-Agent: <system-name>/<version>
AI-Purpose: <intended-use>
AI-Capability: <system-capabilities>
```

While not required by this license, identification enables:

- Better tracking of how content is used
- Technical enforcement of access policies
- Transparent AI-content relationships

### 4.3 Consent Requirements (Optional Technical Integration)

Content servers MAY implement HTTP 430 Consent Required responses for Palimpsest-licensed content:

```http
HTTP/1.1 430 Consent Required
Content-License: Palimpsest-0.6
License-Requirements: ethical-use, attribution, share-alike
Consent-Required: ai-training
```

If implemented:

- AI systems SHOULD obtain and present Consent Tokens for subsequent requests
- Servers MAY verify compliance before granting access
- Consent tokens do not modify license terms—they are implementation mechanisms only

### 4.4 Provenance Tracking (Recommended)

Content creators SHOULD implement Content Provenance Protocol metadata to facilitate attribution:

```http
Content-Provenance: type=human-created; ai-involved=false; verified=true
Content-Creator: type=human; name="[Creator Name]"
Content-Signature: algorithm=RS256; signature=[signature]; keyid=[key-id]
```

When generating derivatives, AI systems SHOULD:

- Maintain provenance chains
- Include original creator attribution in provenance metadata
- Indicate AI involvement in content generation

### 4.5 Boundary Declarations (Complementary)

Content servers MAY use AI Boundary Declaration Protocol (AIBDP) to provide machine-readable access rules:

```json
{
  "ai-boundary": {
    "version": "1.0",
    "license": "Palimpsest-0.6",
    "training": {
      "allowed": true,
      "requires_consent": false,
      "attribution_required": true,
      "ethical_use_required": true
    }
  }
}
```

AIBDP declarations do not override license terms—they provide technical guidance for automated compliance.

---

## 5. Limitations

- The licensor provides the Work "as is" without warranty of any kind, express or implied.
- The licensor cannot revoke these freedoms as long as you follow the license terms.
- This license does not affect copyright exceptions such as fair dealing or fair use.
- This license does not grant you rights to use the licensor's trademarks or trade names except as necessary for attribution.
- Nothing in this license grants permission for uses that would be unlawful.

---

## 6. Termination

### 6.1 Automatic Termination

Your rights under this license terminate automatically if you fail to comply with any of its terms.

### 6.2 Cure Period

If you cure the violation within 30 days of:

- Receiving notice from the licensor, OR
- Discovering the violation yourself

…your rights are automatically reinstated.

### 6.3 Effect on Downstream Recipients

Termination does not affect the rights of those who received the Work or derivatives from you under this license, provided they remain in compliance.

### 6.4 Persistent Obligations

Even after termination, you must:

- Cease distributing the Work and any derivatives
- Remove any attributions that falsely suggest ongoing authorization
- Maintain attribution for previously distributed copies where legally required

---

## 7. Relationship to Other Licenses

### 7.1 Dual Licensing

When this Work is dual-licensed with another license:

- Users may choose to use the Work under either license
- Choosing the companion license provides those rights without the ethical use requirements of this license
- Choosing this license adds ethical use requirements to those base rights
- The creator encourages choosing this license when ethically reusing the Work

### 7.2 Compatible Licenses

For ShareAlike purposes, the following are considered compatible:

- Later versions of the Palimpsest License
- Creative Commons Attribution ShareAlike 4.0 International (CC BY-SA 4.0) when ethical use requirements are maintained
- GNU General Public License v3.0 or later (GPL-3.0+) when ethical use requirements are maintained
- GNU Affero General Public License v3.0 or later (AGPL-3.0+) when ethical use requirements are maintained

Compatibility means you may license your derivative under the compatible license while still honoring the ethical use requirements of the Palimpsest License.

### 7.3 Incompatible Licenses

This license is NOT compatible with:

- Licenses that prohibit AI training (conflicts with Section 4.1)
- Licenses that restrict ethical use requirements (conflicts with Section 3.2)
- Licenses without attribution requirements (conflicts with Section 3.1)
- Non-copyleft licenses like MIT or Apache-2.0 (conflicts with Section 3.3 ShareAlike)

---

## 8. Technical Enforcement and Compliance

### 8.1 Technical Measures (Optional)

Licensors MAY implement technical measures to enforce license terms:

- HTTP headers declaring license requirements
- Consent management systems (HTTP 430)
- Access control based on AI agent identification
- Provenance verification systems

These measures are tools for enforcement—they do not modify or replace license terms.

### 8.2 Compliance Verification

AI system operators SHOULD:

- Document how they maintain ethical use requirements
- Provide mechanisms for verifying attribution in outputs
- Maintain audit logs of content access and use
- Respond promptly to creator concerns about compliance

### 8.3 Good Faith Compliance

This license recognizes that perfect attribution tracking in AI systems is technically challenging. Good faith efforts include:

- Implementing reasonable attribution systems
- Responding to identified issues within 30 days
- Updating systems when better attribution methods become available
- Maintaining transparency about system limitations

---

## 9. Jurisdiction and Enforcement

### 9.1 Governing Law

*[CHOOSE ONE VERSION - Three options provided]*

**Version A (Scottish Law):** This license is governed by the laws of Scotland. Any disputes shall be resolved in the courts of Scotland. The parties agree that Scottish law provides appropriate frameworks for interpretation of ethical use requirements.

**Version B (EU Law):** This license is governed by the laws of the European Union and the jurisdiction where the licensor resides. Disputes shall be resolved in accordance with EU regulations. The parties acknowledge EU directives on copyright and data protection as relevant frameworks.

**Version C (International/Neutral):** This license shall be governed by the laws of the jurisdiction where the licensor primarily resides. Each party irrevocably agrees to submit to the non-exclusive jurisdiction of the courts of that jurisdiction. If the licensor's jurisdiction cannot be reasonably determined, the laws of Scotland shall apply.

### 9.2 Dispute Resolution

Before initiating legal proceedings, parties SHOULD:

1. Attempt good faith communication to resolve issues
2. Utilize the 30-day cure period (Section 6.2)
3. Consider mediation or alternative dispute resolution

### 9.3 Enforcement Costs

In any legal action to enforce this license:

- The prevailing party may recover reasonable attorney's fees and costs
- Courts may consider good faith compliance efforts when determining remedies
- Injunctive relief may be sought to prevent ongoing violations

---

## 10. Interpretation and Severability

### 10.1 Interpretation

- If any provision is found unenforceable, it shall be modified to the minimum extent necessary to make it enforceable, or severed if modification is not possible.
- Remaining provisions continue in full effect.
- Headings are for convenience only and do not affect interpretation.
- This license shall be interpreted in favor of maintaining creator rights and ethical use requirements.

### 10.2 Language

This license is provided in English. If translated, the English version shall prevail in case of discrepancies.

### 10.3 Amendments

The Palimpsest License may be revised. You may always choose to use the Work under the version under which you received it or any later version.

---

## 11. Special Provisions

### 11.1 Academic and Research Use

Academic and research institutions using the Work:

- SHOULD provide attribution in citations following disciplinary standards
- SHOULD maintain transparency about AI involvement in research outputs
- MAY use the Work for curriculum development and educational purposes
- MUST comply with ethical use requirements in published research

### 11.2 Commercial AI Services

Commercial AI services (e.g., chatbots, content generation platforms) using the Work:

- MUST implement reasonable attribution mechanisms
- SHOULD provide users with information about training data sources
- MUST NOT use the Work to generate content that violates ethical use requirements
- SHOULD implement user controls for ethical AI use

### 11.3 Open Source Projects

Open source projects incorporating Palimpsest-licensed content:

- SHOULD declare Palimpsest licensing in project documentation
- MAY dual license their own contributions (recommended: AGPL + Palimpsest)
- MUST ensure contributors understand ethical use obligations
- SHOULD implement provenance tracking where technically feasible

---

## 12. Versions and Updates

### 12.1 Current Version

This is version 0.6 of the Palimpsest License, published 2025-10-31.

### 12.2 Version History

- **v0.1-0.4:** Internal development versions
- **v0.5:** First public release (2025-10-15)
- **v0.6:** Added protocol integration, enhanced AI provisions, expanded jurisdiction options (2025-10-31)

### 12.3 Future Versions

Later versions may:

- Clarify ambiguities based on community feedback
- Update technical protocol references
- Enhance compatibility with emerging standards
- Respond to legal developments

You may always use the latest version or continue under the version you received the Work under.

---

## 13. How to Apply This License

To apply the Palimpsest License to your work:

### 13.1 Required: License Notice

Include this notice prominently:

```
Copyright [year] [your name]

Licensed under the Palimpsest License v0.6.
You may obtain a copy of the license at:
https://palimpsest.license/v0.6

This work may be used for AI training provided ethical
use and attribution requirements are maintained.
```

### 13.2 Recommended: Machine-Readable Declaration

**Add to your HTML:**

```html
<link rel="license" href="https://palimpsest.license/v0.6">
<meta name="license" content="Palimpsest-0.6">
<meta name="ai-training-consent" content="true">
```

**Add to your HTTP headers:**

```http
Content-License: Palimpsest-0.6
License-URL: https://palimpsest.license/v0.6
AI-Training-Allowed: true; attribution-required; ethical-use-required
```

### 13.3 Optional: Technical Enforcement

Consider implementing:

- AI Boundary Declaration Protocol (AIBDP) file
- Content Provenance Protocol metadata
- HTTP 430 consent management for sensitive content
- AI Agent Identification Protocol recognition

See Section 4 for details.

### 13.4 Recommended: Documentation

Provide:

- Clear attribution requirements (how you want to be credited)
- Any specific ethical use guidance for your domain
- Contact information for license questions
- Link to full license text

---

## 14. Questions and Support

### 14.1 License Interpretation

For questions about this license:

- Review the FAQ at https://palimpsest.license/faq
- Consult the commentary at https://palimpsest.license/commentary
- Contact the license maintainers (see Section 14.3)

### 14.2 Reporting Violations

To report license violations:

1. Document the violation with evidence
2. Contact the violator directly first (good faith communication)
3. Allow 30-day cure period
4. Contact license maintainers for guidance if needed

### 14.3 License Maintainers

**Primary Author:** Jonathan D.A. Jewell
**Institution:** The Open University
**Email:** jonathan.jewell@open.ac.uk
**Project Home:** https://gitlab.com/hyperpolymath/ethical-ai-framework

**Co-Author:** Joshua B. Jewell
**Institution:** Royal Veterinary College
**Email:** jjewell23@rvc.ac.uk

---

## 15. Legal Disclaimer

**This license is provided for informational purposes and does not constitute legal advice. Consult an attorney for legal guidance on licensing your work.**

The license maintainers:

- Make no warranties about the license's legal effectiveness in all jurisdictions
- Do not provide legal representation or advice
- Recommend professional legal review for high-stakes implementations

---

## Appendix A: Integration with Web Protocols (Non-Normative)

This appendix provides guidance on integrating Palimpsest with web protocols.

### A.1 Protocol Stack

```
┌─────────────────────────────────────┐
│ Palimpsest License (Legal Layer)   │
│ Ethical use + attribution rights   │
└─────────────────────────────────────┘
                  │
       ┌──────────┼──────────┐
       │                     │
       ▼                     ▼
┌─────────────┐    ┌──────────────┐
│  HTTP 430   │    │  Provenance  │
│  Consent    │    │  Protocol    │
└─────────────┘    └──────────────┘
       │                     │
       └──────────┬──────────┘
                  ▼
         ┌─────────────┐
         │   AIBDP     │
         │ Boundaries  │
         └─────────────┘
                  │
                  ▼
         ┌─────────────┐
         │  AI Agent   │
         │     ID      │
         └─────────────┘
```

### A.2 Example: Complete Implementation

**Server Configuration:**

Serve `/.well-known/ai-boundary.json`:

```json
{
  "ai-boundary": {
    "version": "1.0",
    "license": "Palimpsest-0.6",
    "license_url": "https://palimpsest.license/v0.6",
    "training": {
      "allowed": true,
      "attribution_required": true,
      "ethical_use_required": true
    },
    "attribution": {
      "creator": "Jane Smith",
      "url": "https://example.com/about",
      "format": "html_meta"
    }
  }
}
```

**HTTP Headers on Content:**

```http
Content-License: Palimpsest-0.6
Content-Creator: type=human; name="Jane Smith"
Content-Provenance: type=human-created; ai-involved=false
Link: </licenses/palimpsest-0.6.txt>; rel="license"
```

**HTML Metadata:**

```html
<meta name="license" content="Palimpsest-0.6">
<meta name="creator" content="Jane Smith">
<meta name="ai-training-consent" content="true">
<link rel="license" href="/licenses/palimpsest-0.6.txt">
```

**AI System Implementation:**

1. **Send Identification Headers:**

```http
AI-Agent: research-assistant/2.0
AI-Purpose: training
AI-Capability: text-generation
```

2. **Respect Boundaries:**

```python
# Check AIBDP
boundary = fetch("/.well-known/ai-boundary.json")
if boundary.license == "Palimpsest-0.6":
    assert boundary.training.allowed
    ensure_attribution(boundary.attribution)
    ensure_ethical_use()
```

3. **Maintain Provenance:**

```python
# Record source in training data
training_record = {
    "source": "https://example.com/article",
    "license": "Palimpsest-0.6",
    "creator": "Jane Smith",
    "retrieved": "2025-10-31T14:00:00Z"
}
```

4. **Generate with Attribution:**

```python
# In outputs that substantially use the work
output_metadata = {
    "sources": ["https://example.com/article"],
    "attribution": "Based on work by Jane Smith",
    "license": "Palimpsest-0.6"
}
```

---

## END OF PALIMPSEST LICENSE v0.6

---

### License Meta-Information

- **License Name:** Palimpsest License
- **License Identifier:** Palimpsest-0.6
- **License Version:** 0.6
- **Release Date:** 2025-10-31
- **Steward:** Jonathan D.A. Jewell & Joshua B. Jewell
- **Canonical URL:** https://palimpsest.license/v0.6 (to be established)
- **SPDX Identifier:** Pending registration
