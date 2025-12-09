# Palimpsest License v0.7 Roadmap: Practical License Track

**Status:** Planning
**Target:** Q1-Q2 2026
**Focus:** Practical adoption, consent-aware HTTP integration, ejectable tooling

---

## Overview

The v0.7 "Practical" track focuses on making the Palimpsest License easy to adopt, integrate, and enforce. This version emphasizes:

1. **Tight integration with consent-aware-http** protocols
2. **Ejectable tooling** for self-hosting
3. **Simplified adoption** for developers/creators
4. **Machine-readable compliance** infrastructure

This track is distinct from the "Augmented Research" track, which explores deeper philosophical and technical foundations.

---

## Core Goals

### 1. Consent-Aware HTTP Integration

**Repository:** https://github.com/hyperpolymath/consent-aware-http

Palimpsest v0.7 will provide first-class integration with the consent-aware HTTP protocol suite:

- **HTTP 430 Consent Required**
  - License-aware consent tokens
  - Palimpsest-specific consent flows
  - Token format specification for `Palimpsest-0.7`

- **AI Boundary Declaration Protocol (AIBDP)**
  - Standard `/.well-known/ai-boundary.json` templates
  - Palimpsest-specific boundary declarations
  - Training consent flags

- **Content Provenance Protocol**
  - Provenance chain for derivatives
  - AI involvement tracking
  - Attribution metadata standards

### 2. Ejectable Site Generator

Create a standalone, portable Zola-based site generator that users can:

- **Drop into any repository** as a submodule or copy
- **Run offline** without external dependencies
- **Self-host** on any static hosting platform
- **Customize** with their own branding/styling

**Package Structure:**
```
palimpsest-site-kit/
├── config.toml.template      # Zola config template
├── content/
│   └── _index.md             # Landing page template
├── templates/
│   ├── base.html
│   ├── page.html
│   ├── license.html          # License display template
│   └── shortcodes/
│       └── palimpsest-notice.html
├── sass/
│   └── main.scss
├── static/
│   ├── .well-known/
│   │   └── ai-boundary.json.template
│   └── licenses/
│       └── palimpsest-v0.7.txt
├── scripts/
│   ├── setup.sh              # One-command setup
│   └── eject.sh              # Extract from main repo
├── README.md
└── LICENSE                   # Meta: Palimpsest-0.7
```

**Installation:**
```bash
# Option 1: Git submodule
git submodule add https://github.com/hyperpolymath/palimpsest-site-kit.git palimpsest

# Option 2: Direct copy
curl -L https://palimpsest.license/site-kit.tar.gz | tar xz

# Option 3: Deno script
deno run https://palimpsest.license/install.ts
```

### 3. Simplified License Selection

Create a "license wizard" that helps users choose the right configuration:

- **Base Palimpsest-0.7** (standard terms)
- **+ Dual License** (Palimpsest + AGPL/MIT/Apache)
- **+ Jurisdiction Selection** (Scottish/EU/International)
- **+ Custom Ethical Use Clauses**

Output: Ready-to-use license file + metadata + AIBDP config

### 4. Integration Ecosystem

**Platform Integrations:**
- GitHub Actions workflow templates
- GitLab CI templates
- Netlify/Vercel deployment configs
- WordPress plugin (updated for v0.7)

**Framework Integrations:**
- Zola (native, primary)
- Hugo (templates)
- Jekyll (templates)
- Astro (integration)
- Next.js (middleware)

**Registry/Package Manager Support:**
- SPDX identifier registration (Palimpsest-0.7)
- npm package metadata guidelines
- Cargo.toml support
- pyproject.toml support

---

## Technical Specifications

### License Metadata Format (v0.7)

```json
{
  "@context": "https://palimpsest.license/schema/v0.7",
  "@type": "PalimpsestLicense",
  "version": "0.7",
  "jurisdiction": "scottish|eu|international",
  "dualLicense": "AGPL-3.0-or-later",
  "aiTraining": {
    "allowed": true,
    "requiresAttribution": true,
    "requiresEthicalUse": true,
    "requiresConsent": false
  },
  "attribution": {
    "name": "Creator Name",
    "url": "https://example.com",
    "format": "html_meta"
  },
  "provenance": {
    "created": "2026-01-15T00:00:00Z",
    "aiInvolved": false,
    "contentType": "human-created"
  }
}
```

### HTTP Header Format (v0.7)

```http
Content-License: Palimpsest-0.7; jurisdiction=scottish
Content-Creator: type=human; name="Creator Name"
Content-Provenance: type=human-created; ai-involved=false; verified=true
Link: </.well-known/ai-boundary.json>; rel="ai-boundary"
Link: </licenses/palimpsest-v0.7.txt>; rel="license"
```

### Consent Token Format

```json
{
  "iss": "https://consent.palimpsest.license",
  "sub": "https://example.com/article",
  "aud": "ai-system-identifier",
  "iat": 1704067200,
  "exp": 1735689600,
  "scope": ["training", "generation"],
  "license": "Palimpsest-0.7",
  "constraints": {
    "attribution_required": true,
    "ethical_use_required": true
  }
}
```

---

## Adoption Pathways

### For Individual Creators

1. Visit palimpsest.license
2. Use license wizard to configure options
3. Download license + metadata bundle
4. Add to project root
5. (Optional) Deploy ejectable site for public documentation

### For Organizations

1. Review license with legal team
2. Configure organizational defaults
3. Deploy internal license server (optional)
4. Integrate into CI/CD pipelines
5. Train teams on compliance requirements

### For AI Developers

1. Implement AIBDP boundary checking
2. Add consent token handling
3. Integrate provenance tracking
4. Configure attribution in outputs
5. Document compliance mechanisms

---

## Milestones

### Phase 1: Foundation (Q1 2026)
- [ ] Finalize v0.7 license text
- [ ] Complete SPDX registration
- [ ] Launch ejectable site kit
- [ ] Basic consent-aware-http integration

### Phase 2: Tooling (Q2 2026)
- [ ] License wizard web app
- [ ] CI/CD integration templates
- [ ] Framework integrations (top 5)
- [ ] Documentation site relaunch

### Phase 3: Ecosystem (Q3-Q4 2026)
- [ ] Package manager support
- [ ] Enterprise features
- [ ] Compliance verification tools
- [ ] Community governance activation

---

## Dependencies

- consent-aware-http protocol stabilization
- SPDX license list inclusion
- Community feedback on v0.6

---

## Related Documents

- [Augmented Research Track](./ROADMAP-research-augmented.md)
- [Governance Model](../GOVERNANCE.md)
- [License Text v0.6](../LICENSES/v0.6/palimpsest-v0.6.md)
