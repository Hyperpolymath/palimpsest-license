# Creative Works Consent Framework: Standards Track Roadmap

**Version**: 1.0
**Date**: 2025-11-22
**Status**: Planning Document

## Executive Summary

This roadmap outlines the path from the current Palimpsest License project to widely-adopted, internationally-recognised web standards for creative works consent in the AI age. It details the strategy for engaging with standards bodies (IETF, W3C), building community, developing implementations, and achieving mainstream adoption.

**Timeline**: 3-5 years to W3C Recommendation or IETF Standard
**Key Milestones**: IRTF publication, W3C Community Group, Working Group, implementations, adoption

---

## Table of Contents

1. [Current State](#1-current-state)
2. [Standards Track Options](#2-standards-track-options)
3. [Recommended Path](#3-recommended-path)
4. [Phase 1: Foundation (Months 1-6)](#4-phase-1-foundation-months-1-6)
5. [Phase 2: Community Building (Months 7-12)](#5-phase-2-community-building-months-7-12)
6. [Phase 3: Implementation and Validation (Months 13-24)](#6-phase-3-implementation-and-validation-months-13-24)
7. [Phase 4: Standardisation (Months 25-36)](#7-phase-4-standardisation-months-25-36)
8. [Phase 5: Adoption and Refinement (Months 37-48+)](#8-phase-5-adoption-and-refinement-months-37-48)
9. [Required Resources](#9-required-resources)
10. [Risk Mitigation](#10-risk-mitigation)
11. [Success Metrics](#11-success-metrics)
12. [Long-Term Vision](#12-long-term-vision)

---

## 1. Current State

### 1.1. Existing Work

**Palimpsest License Project** has established:
* Comprehensive license framework (v0.3, v0.4)
* AGI consent agreements
* AIBDP manifest guidance (JSON-based consent declarations)
* Emotional lineage and cultural heritage protections
* DAO governance and collective rights models

**Strengths**:
* Deep understanding of creator needs
* Ethical framework addressing AI harms
* Cultural sensitivity (Indigenous, marginalised communities)
* Technical specifications (JSON-LD, metadata)

**Gaps**:
* Not yet a formal standard (W3C, IETF)
* Limited implementation (primarily Palimpsest ecosystem)
* No official standards body backing
* Browser/platform integration absent

### 1.2. Current Documentation

Created as of 2025-11-22:
* **IRTF Internet-Draft**: `draft-creative-works-consent-00.md`
* **W3C Community Group Charter**: Charter and proposal
* **Implementation Guide**: Comprehensive developer documentation
* **Use Cases and Requirements**: 10 detailed use cases, 50+ requirements
* **Threat Model**: Security analysis and mitigations
* **Comparison Analysis**: How CWCF relates to robots.txt, CC, ODRL, etc.

**Status**: Draft documents ready for community review.

---

## 2. Standards Track Options

### 2.1. IETF (Internet Engineering Task Force)

#### Path

1. **IRTF (Research Group)**: Publish informational RFC via IRTF
2. **Individual Internet-Draft**: Submit to IETF as individual submission
3. **Working Group adoption**: Gain support for WG creation or existing WG adoption
4. **Standards Track**: RFC with normative status

#### Pros

* **HTTP integration**: IETF owns HTTP specifications (RFC 7231, etc.)
* **IANA registrations**: Well-known URIs, HTTP headers, status codes
* **Technical focus**: Protocol-level mechanisms (verification, caching, etc.)
* **Global reach**: IETF standards widely implemented

#### Cons

* **Less web-focused**: IETF focuses on network protocols, less on web platform APIs
* **No built-in governance for semantics**: JSON-LD/RDF vocabularies better at W3C
* **Slower process**: 2-5 years typical for standards track

#### Best For

* HTTP status codes (430 Consent Required)
* Well-known URI registration
* HTTP header specifications
* Protocol-level enforcement mechanisms

### 2.2. W3C (World Wide Web Consortium)

#### Path

1. **Community Group**: Create CWCF Community Group
2. **Community Group Specifications**: Publish CG specs (JSON-LD context, vocabulary)
3. **Working Group proposal**: Gain member support for WG creation
4. **Recommendation Track**: W3C Recommendation (official standard)

#### Pros

* **Web platform focus**: JSON-LD, RDF, Verifiable Credentials, DIDs
* **Semantic web expertise**: W3C invented JSON-LD, manages Schema.org relationship
* **Browser integration**: Potential for native browser APIs
* **Governance support**: VC/DID frameworks for collective governance
* **Accessibility/i18n**: Strong W3C review processes

#### Cons

* **Membership required for WG**: Working Groups require W3C membership ($$$)
* **Consensus-based**: Can be slow if controversial
* **Less protocol focus**: HTTP-level mechanisms may need IETF anyway

#### Best For

* JSON-LD vocabulary and context
* Semantic web integration
* Browser APIs and web platform features
* Accessibility and internationalisation
* Verifiable Credentials integration

### 2.3. Hybrid Approach (RECOMMENDED)

**Strategy**: Pursue both IETF and W3C in parallel for complementary aspects

| Aspect | Venue | Rationale |
|--------|-------|-----------|
| **HTTP integration** | IETF | HTTP status codes, headers, well-known URIs |
| **JSON-LD vocabulary** | W3C | Semantic web, Schema.org alignment |
| **Verification protocol** | IETF | Protocol-level consent checking |
| **Web platform APIs** | W3C | Browser integration, JavaScript APIs |
| **Verifiable Credentials** | W3C | Already W3C Recommendation |

---

## 3. Recommended Path

### 3.1. Parallel Tracks

```
IETF Track:                          W3C Track:
┌────────────────────┐              ┌────────────────────┐
│ IRTF Publication   │              │ Community Group    │
│ (Informational)    │              │ Formation          │
└─────────┬──────────┘              └─────────┬──────────┘
          │                                   │
          │ Months 1-6                        │ Months 1-6
          ▼                                   ▼
┌────────────────────┐              ┌────────────────────┐
│ Individual I-D     │              │ CG Specifications  │
│ Submission         │              │ Development        │
└─────────┬──────────┘              └─────────┬──────────┘
          │                                   │
          │ Months 7-12                       │ Months 7-18
          ▼                                   ▼
┌────────────────────┐              ┌────────────────────┐
│ WG Adoption        │              │ CG Final Report    │
│ Discussion         │              │                    │
└─────────┬──────────┘              └─────────┬──────────┘
          │                                   │
          │ Months 13-24                      │ Months 19-24
          ▼                                   ▼
┌────────────────────┐              ┌────────────────────┐
│ Standards Track    │              │ WG Proposal        │
│ RFC                │              │ & Creation         │
└────────────────────┘              └─────────┬──────────┘
                                              │
          Months 25-36+                       │ Months 25-36
                                              ▼
                                    ┌────────────────────┐
                                    │ W3C Recommendation │
                                    └────────────────────┘

                                    Months 37-48+
```

### 3.2. Coordination Points

* **Joint calls**: Quarterly meetings between IETF and W3C participants
* **Liaison**: Designate formal liaisons between groups
* **Consistent terminology**: Ensure IETF and W3C specs use aligned vocabulary
* **Reference each other**: IETF RFC cites W3C JSON-LD context; W3C Rec cites IETF HTTP spec

---

## 4. Phase 1: Foundation (Months 1-6)

**Timeline**: January 2026 - June 2026
**Status**: Preparation and launch

### 4.1. IRTF Track

#### 4.1.1. Prepare IRTF Submission

* **Month 1**: Convert existing draft to xml2rfc format
* **Month 1**: Submit to IRTF as informational document
* **Month 2-3**: IRTF review and feedback incorporation
* **Month 4**: Second draft submission
* **Month 5-6**: IRTF publication as informational RFC

**Deliverable**: RFC published (informational status)

#### 4.1.2. IETF Socialisation

* **Month 1-2**: Present at IETF mailing lists (httpapi, dispatch)
* **Month 3**: Side meeting at IETF 121 (Dublin, July 2026)
* **Month 4-6**: Gather feedback, refine for WG proposal

### 4.2. W3C Track

#### 4.2.1. Community Group Formation

* **Month 1**: Submit CG proposal to W3C
  * Finalise charter
  * Recruit initial participants (50+ target)
  * Identify co-chairs (creator rep + technical expert)

* **Month 2**: W3C approval and launch
  * Inaugural meeting
  * Elect chairs
  * Establish communication channels (mailing list, GitHub, IRC)

* **Month 3-6**: Initial specification work
  * Use cases and requirements refinement
  * JSON-LD context first draft
  * Core specification outline

**Deliverable**: Active W3C Community Group with 50+ participants

### 4.3. Outreach and Communication

#### 4.3.1. Stakeholder Engagement

* **Creators**: Recruit authors, artists, journalists (via guilds, unions)
* **Cultural heritage**: Engage Indigenous communities, museums, archives
* **AI companies**: Invite participation from OpenAI, Anthropic, Google, Meta
* **Platforms**: Engage WordPress, Medium, GitHub, Creative Commons
* **Academics**: AI ethics researchers, digital humanities scholars

**Target**: 100+ stakeholder expressions of interest

#### 4.3.2. Public Launch

* **Month 3**: Public announcement
  * Press release highlighting the problem and solution
  * Blog posts on Palimpsest and partner sites
  * Social media campaign (#CreativeConsent)
  * Webinar for creator education

**Target**: 10,000+ reach, 500+ engaged creators

### 4.4. Implementation

#### 4.4.1. Reference Implementation

* **Month 1-4**: Develop reference implementation libraries
  * JavaScript validator (@cwcf/validator on npm)
  * Python validator (pip install cwcf-validator)
  * JSON Schema and validation suite

* **Month 5-6**: WordPress plugin beta
  * UI for consent declaration creation
  * Automatic serving at well-known URI
  * Meta tag injection

**Deliverable**: 2+ reference implementations, 1 CMS plugin

---

## 5. Phase 2: Community Building (Months 7-12)

**Timeline**: July 2026 - December 2026
**Status**: Growth and validation

### 5.1. W3C Community Group

#### 5.1.1. Specification Development

* **Month 7-9**: Core specification first public working draft
  * Consent declaration schema
  * Discovery mechanisms
  * Validation rules
  * Examples

* **Month 10-12**: Supporting specifications
  * HTTP Integration spec
  * Lineage and Provenance spec
  * Implementation guide v2.0

**Deliverable**: 3 Community Group Specifications (draft status)

#### 5.1.2. Community Growth

* **Monthly calls**: Continue weekly technical calls, monthly stakeholder calls
* **Face-to-face**: TPAC 2026 attendance (September)
* **Recruitment**: Grow to 100+ participants across stakeholder groups

**Target**: 100+ CG participants, 10+ active contributors

### 5.2. IETF Track

#### 5.2.1. Working Group Proposal

* **Month 7-9**: Draft WG charter proposal
  * Scope: HTTP integration, well-known URIs, status codes
  * Deliverables: Standards-track RFC for CWCF HTTP protocol
  * Timeline: 18-24 months

* **Month 10**: Present at IETF 122 (November 2026)
  * BOF (Birds of a Feather) session
  * Gauge community interest
  * Refine charter based on feedback

* **Month 11-12**: Iterate on WG charter

**Deliverable**: WG charter proposal submitted to IESG

### 5.3. Implementation Expansion

#### 5.3.1. CMS Plugins

* **Month 7-8**: Drupal module
* **Month 9-10**: Ghost integration
* **Month 11-12**: Static site generators (Hugo, Jekyll, Gatsby)

**Target**: 5+ CMS/platform integrations

#### 5.3.2. AI System Integration

* **Month 7-12**: Engage AI companies to pilot verification
  * Provide reference implementation and support
  * Joint testing on sample datasets
  * Feedback loop for specification refinement

**Target**: 3+ AI companies piloting consent verification

#### 5.3.3. Tooling

* **Month 7-8**: Online validator (validator.palimpsestlicense.org/cwcf)
* **Month 9-10**: Browser extension (Chrome/Firefox) displaying consent status
* **Month 11-12**: CLI tool for bulk validation

**Deliverable**: 3+ creator/developer tools

### 5.4. Adoption Milestones

**By end of Month 12**:
* 100+ websites with CWCF declarations
* 5+ CMS integrations
* 3+ AI companies piloting verification
* 1,000+ creators aware of CWCF (via outreach)

---

## 6. Phase 3: Implementation and Validation (Months 13-24)

**Timeline**: January 2027 - December 2027
**Status**: Proof of concept at scale

### 6.1. W3C Track

#### 6.1.1. Community Group Maturation

* **Month 13-18**: Specification refinement based on implementation feedback
  * Incorporate lessons learned from pilots
  * Address edge cases and ambiguities
  * Expand test suite coverage

* **Month 19-24**: Community Group Final Report
  * Core specification reaches stable state
  * Multiple interoperable implementations demonstrated
  * Prepare for Working Group transition

**Deliverable**: Community Group Final Report status

#### 6.1.2. Working Group Proposal

* **Month 18**: Draft WG charter
  * Scope: CWCF vocabulary, web platform integration
  * Deliverables: W3C Recommendation for CWCF
  * Coordination with IETF HTTP work

* **Month 20**: Present WG proposal to W3C Advisory Committee
* **Month 22**: W3C member voting on WG creation
* **Month 24**: Working Group launch (if approved)

**Deliverable**: CWCF Working Group created (target)

### 6.2. IETF Track

#### 6.2.1. Working Group (if created)

* **Month 13**: HTTPAPI WG adoption (or new CWCF WG created)
* **Month 13-18**: Standards-track I-D development
  * HTTP status code 430 specification
  * Well-known URI registration
  * HTTP header specifications

* **Month 19-24**: IETF Last Call and IESG review

**Deliverable**: Standards-track RFC (Proposed Standard)

### 6.3. Implementation Scale-Up

#### 6.3.1. Creator Adoption

* **Target**: 1,000+ websites with CWCF declarations by Month 24
* **Strategy**:
  * Partnership with creator organisations (Authors Guild, NUJ, etc.)
  * CMS defaults (WordPress plugin pre-installed on select hosts)
  * Creator education campaigns (webinars, tutorials, case studies)

#### 6.3.2. AI System Adoption

* **Target**: 10+ AI systems verifying consent by Month 24
* **Strategy**:
  * Direct engagement with major AI companies
  * Publish compliance reports showing which companies respect consent
  * Public pressure campaigns via creator advocacy groups
  * Regulatory engagement (EU AI Act, etc.)

#### 6.3.3. Platform Integration

* **Target**: 3+ major platforms supporting CWCF by Month 24
* **Candidates**:
  * WordPress.com (hosting service, not just plugin)
  * Medium (consent declaration UI in post settings)
  * GitHub Pages (auto-generation for repository content)

**Strategy**:
* Developer relations outreach
* Offer implementation support
* Highlight competitive advantage ("We protect creators")

### 6.4. Research and Validation

#### 6.4.1. Academic Studies

* **Month 13-24**: Commission or collaborate on research
  * Effectiveness of consent declarations in reducing unauthorised AI training
  * Creator satisfaction and usability studies
  * AI company compliance measurement
  * Economic impact analysis (creator revenue, AI training costs)

**Deliverable**: 2+ peer-reviewed publications

#### 6.4.2. Security Audits

* **Month 18**: Third-party security audit of reference implementations
* **Month 20**: Penetration testing of consent verification infrastructure
* **Month 22**: Publish audit results and mitigations

**Deliverable**: Security audit report

---

## 7. Phase 4: Standardisation (Months 25-36)

**Timeline**: January 2028 - December 2028
**Status**: Formal standardisation

### 7.1. W3C Recommendation Track

#### 7.1.1. Working Group Specification Development

* **Month 25-30**: First Public Working Draft (FPWD)
  * Core CWCF specification
  * JSON-LD context and vocabulary
  * Web platform integration

* **Month 31-33**: Wide Review
  * TAG review (Technical Architecture Group)
  * PING review (Privacy Interest Group)
  * I18n review (Internationalization)
  * Accessibility review (AG WG)

* **Month 34-36**: Candidate Recommendation
  * Address wide review feedback
  * Demonstrate multiple interoperable implementations
  * Call for implementations

**Deliverable**: W3C Candidate Recommendation

### 7.2. IETF Standards Track

#### 7.2.1. RFC Publication

* **Month 25-28**: Address IESG comments
* **Month 29-30**: RFC Editor queue
* **Month 31**: RFC publication

**Deliverable**: RFC (Proposed Standard) for CWCF HTTP Protocol

### 7.3. IANA Registrations

#### 7.3.1. Formal Registrations

* **Well-known URI**: `creative-works-consent.json`
* **Link relation**: `consent-declaration`
* **HTTP headers**: `Creative-Works-Consent`, `AI-Training`, `AI-Generation`
* **Media type**: `application/creative-works-consent+json`

**Deliverable**: IANA registrations complete

### 7.4. Adoption Acceleration

#### 7.4.1. Major Platform Launches

* **Month 25-26**: WordPress.com announces native CWCF support (partnership)
* **Month 27-28**: Medium announces creator consent UI (partnership)
* **Month 29-30**: GitHub Pages auto-detection of CWCF (partnership)

**Target**: 10,000+ websites with declarations (via platform defaults)

#### 7.4.2. AI Company Commitments

* **Month 25-36**: Public commitments from AI companies
  * "We will honour CWCF declarations"
  * Integrate verification into scraping pipelines
  * Publish compliance reports

**Target**: 5+ major AI companies (OpenAI, Google, Anthropic, Meta, Mistral) publicly commit

#### 7.4.3. Regulatory Recognition

* **Month 25-36**: Engage with regulators
  * EU AI Act: CWCF as compliance mechanism for "consent" requirements
  * UK: Engage with IPO on TDM reservation and CWCF alignment
  * US: Engage with Copyright Office on AI and copyright issues

**Target**: CWCF referenced in 2+ regulatory frameworks or guidance documents

---

## 8. Phase 5: Adoption and Refinement (Months 37-48+)

**Timeline**: January 2029 onwards
**Status**: Mainstream adoption

### 8.1. W3C Recommendation

#### 8.1.1. Final Standardisation

* **Month 37-42**: Candidate Recommendation maintenance
  * Address implementation feedback
  * Clarify ambiguities
  * Test suite expansion

* **Month 43-45**: Proposed Recommendation
  * Advisory Committee review
  * Formal objection resolution (if any)

* **Month 46-48**: W3C Recommendation
  * Final vote and publication
  * Official W3C standard status

**Deliverable**: W3C Recommendation (full standard)

### 8.2. Ecosystem Maturity

#### 8.2.1. Universal Implementation

* **Browsers**: Native support in Chrome, Firefox, Safari, Edge
  * Display consent status in address bar or dev tools
  * JavaScript API: `navigator.consent.check(url)`

* **CMSs**: Default in WordPress, Drupal, Joomla, Ghost, Wix, Squarespace
  * Pre-configured consent declarations
  * UI for customisation

* **Platforms**: Medium, Substack, GitHub, GitLab, YouTube, Spotify
  * Creator consent settings in account preferences

**Target**: 50%+ of web publishing platforms support CWCF

#### 8.2.2. AI Industry Standard

* **AI companies**: All major LLM providers verify consent
  * Integrated into data pipelines
  * Compliance reports published quarterly
  * Third-party audits verify compliance

* **Industry coalitions**: Partnership on AI, AI Alliance adopt CWCF
  * Recommended practice for responsible AI
  * Certification programs for compliant AI systems

**Target**: 90%+ of major AI systems respect CWCF declarations

### 8.3. Version 2.0 Development

#### 8.3.1. Next-Generation Features

* **Real-time consent negotiation**: Dynamic consent workflows
* **Micropayment integration**: Standardised compensation for conditional consent
* **Federated verification**: P2P consent verification networks
* **Advanced AI paradigms**: AGI-specific protections, synthetic consciousness safeguards

#### 8.3.2. Community Group 2.0

* **Month 42+**: Launch CWCF v2.0 Community Group
* **Month 48+**: Begin v2.0 specification development

---

## 9. Required Resources

### 9.1. Personnel

| Role | Time Commitment | Phase |
|------|-----------------|-------|
| **Specification Editor** | 20 hrs/week | All phases |
| **IETF Liaison** | 10 hrs/week | Phases 1-4 |
| **W3C Liaison** | 10 hrs/week | Phases 1-5 |
| **Technical Lead** | 15 hrs/week | Phases 1-3 |
| **Community Manager** | 15 hrs/week | All phases |
| **Developer Relations** | 10 hrs/week | Phases 2-5 |
| **Legal/Policy Advisor** | 5 hrs/week | All phases |
| **Creator Advocate** | 10 hrs/week | All phases |

**Total**: ~3-4 FTE across 4 years

### 9.2. Infrastructure

| Resource | Cost (Annual) | Purpose |
|----------|---------------|---------|
| **W3C Membership** | $7,700 (affiliate) or $77,000 (full) | Required for WG participation |
| **Domain/Hosting** | $500 | palimpsestlicense.org, validator, docs |
| **CI/CD** | $1,000 | GitHub Actions, testing infrastructure |
| **Travel** | $10,000 | IETF/W3C meetings (2-3 per year) |
| **Design/Communications** | $5,000 | Marketing materials, outreach |

**Total**: ~$25,000-$95,000/year (depending on W3C membership tier)

### 9.3. Funding Sources

* **Grants**: Mozilla Foundation, Knight Foundation, Shuttleworth Foundation
* **Sponsorships**: AI companies, platforms, creator organisations
* **Crowdfunding**: Creator community contributions
* **In-kind**: Volunteer labour, organisational partnerships

---

## 10. Risk Mitigation

### 10.1. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **W3C WG not approved** | Medium | High | Focus on CG success; IETF as fallback |
| **AI companies refuse to implement** | Medium | Critical | Public pressure, regulatory engagement, legal enforcement |
| **Platform resistance** | Medium | High | Competitive advantage messaging, creator demand |
| **Specification fragmentation** | Low | High | Strong governance, clear roadmap, community consensus |
| **Adoption too slow** | Medium | Medium | Aggressive outreach, partnership with creator orgs |
| **Security vulnerabilities** | Low | High | Third-party audits, bug bounties, rapid response |
| **Legal challenges** | Low | Medium | Vetted legal framework, alignment with existing law |
| **Resource constraints** | High | Medium | Phased approach, volunteer community, grants |

### 10.2. Contingency Plans

**If W3C WG not approved**:
* Continue as CG indefinitely (CG specs are legitimate, just not "Recommendations")
* Focus on IETF standards track for HTTP aspects
* Build de facto standard through broad implementation

**If AI companies don't adopt**:
* Legal enforcement via license breach lawsuits (test cases)
* Regulatory mandates (lobby for CWCF in AI regulations)
* Public naming-and-shaming via compliance reports
* Watermarking and forensics to detect violations

**If funding insufficient**:
* Reduce scope (focus on core specification, defer v2.0 features)
* All-volunteer model (slower but sustainable)
* Partner with academic institutions for research support

---

## 11. Success Metrics

### 11.1. Technical Success

| Metric | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|--------|---------|---------|---------|---------|---------|
| **Specifications published** | 1 (IRTF) | 3 (CG) | 5 (CG Final) | 2 (RFC + CR) | 1 (W3C Rec) |
| **Implementations** | 2 | 5 | 10 | 20 | 50+ |
| **Test coverage** | 50% | 70% | 85% | 95% | 100% |

### 11.2. Adoption Success

| Metric | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|--------|---------|---------|---------|---------|---------|
| **Websites with declarations** | 100 | 500 | 5,000 | 50,000 | 500,000+ |
| **CMS integrations** | 1 | 5 | 10 | 15 | 25+ |
| **AI systems verifying** | 0 | 3 | 10 | 20 | 50+ |
| **Platform support** | 0 | 0 | 3 | 7 | 15+ |

### 11.3. Community Success

| Metric | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 |
|--------|---------|---------|---------|---------|---------|
| **CG participants** | 50 | 100 | 150 | 200 | 300+ |
| **Active contributors** | 5 | 10 | 20 | 30 | 50+ |
| **Creator awareness** | 1,000 | 10,000 | 100,000 | 500,000 | 5M+ |

### 11.4. Impact Success

| Metric | Target Timeline |
|--------|-----------------|
| **Unauthorised AI training reduced** | Measurable by Phase 4 (surveys, forensics) |
| **Creator revenue increased** | Measurable by Phase 5 (conditional consent payments) |
| **Legal cases won** | 2+ by Phase 4 (establish precedent) |
| **Regulatory adoption** | 3+ jurisdictions by Phase 5 |

---

## 12. Long-Term Vision

### 12.1. 2030 Vision

By 2030, CWCF is:
* **Universal**: Default on all major publishing platforms
* **Respected**: 95%+ of AI systems honour declarations
* **Enforceable**: Courts recognise CWCF in copyright cases
* **Inclusive**: Indigenous, marginalised communities protected
* **Dynamic**: v2.0 addresses AGI, synthetic consciousness
* **Empowering**: Creators earn revenue through conditional consent
* **Trusted**: Independent audits verify AI company compliance

### 12.2. Cultural Shift

CWCF enables a shift from:
* **Extraction culture**: AI companies take without asking
* **To consent culture**: Creators decide, AI companies respect

### 12.3. Beyond Web Standards

CWCF becomes foundation for:
* **Legal frameworks**: Referenced in copyright law, AI regulations
* **Economic models**: Consent-based creator compensation platforms
* **Ethical AI**: Industry standard for responsible development
* **Cultural preservation**: Indigenous knowledge protected at scale
* **Decentralised governance**: DAO-based collective rights management

---

## 13. Next Steps (Immediate Actions)

### 13.1. Month 1 (December 2025 / January 2026)

1. **Finalise IRTF draft**: Convert to xml2rfc, submit
2. **Submit W3C CG proposal**: Charter, recruit co-chairs, gather supporters
3. **Launch website**: palimpsestlicense.org/standards/
4. **Recruit participants**: Email 100 potential stakeholders
5. **Develop reference implementation**: JavaScript validator alpha

### 13.2. Month 2 (January/February 2026)

1. **W3C CG approval**: Respond to W3C questions, finalise charter
2. **Inaugural CG meeting**: Elect chairs, establish processes
3. **IETF socialisation**: Post to httpapi, dispatch mailing lists
4. **Implementation sprint**: Complete JavaScript validator beta
5. **Begin WordPress plugin**: Design UI mockups

### 13.3. Month 3 (February/March 2026)

1. **Public launch**: Press release, blog posts, social media
2. **First CG draft**: Use cases and requirements v1.0
3. **IETF side meeting**: Present at IETF 121 (if accepted)
4. **WordPress plugin beta**: Release for testing
5. **Creator webinar**: Education and onboarding (100+ attendees target)

---

## 14. Conclusion

This roadmap provides a clear, achievable path from the Palimpsest License project to widely-adopted international standards for creative works consent in the AI age. Success requires:

* **Multi-stakeholder collaboration**: Creators, AI companies, platforms, standards bodies
* **Parallel IETF/W3C engagement**: Leverage strengths of both organisations
* **Implementation-driven**: Prove the concept through real-world deployment
* **Community-centred**: Creator needs and voices guide development
* **Long-term commitment**: 3-5 years to full standardisation

**The stakes are high**: Without standardised consent mechanisms, creators lose control of their works in the AI era. With CWCF, we can build a future where AI development and creator rights coexist—where technology respects humanity.

---

**Roadmap Version**: 1.0
**Last Updated**: 2025-11-22
**Maintained By**: Palimpsest Stewardship Council
**License**: CC-BY 4.0

**Contact**: stewardship@palimpsestlicense.org

---

*This roadmap is a living document. Updates and progress tracking at: https://github.com/palimpsest-license/cwcf-standards*
