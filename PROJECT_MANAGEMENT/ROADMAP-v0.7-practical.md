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

**Multi-Framework Ejectable Kits:**

The ejectable site kit will be available in multiple flavors to meet users where they are:

```
palimpsest-site-kits/
├── zola/                     # Static, offline-first (Rust)
├── serum-liveview/           # Dynamic consent flows (Elixir/Phoenix)
├── rescript-tea/             # Functional web apps (ReScript)
└── wp-simple-theme/          # WordPress mainstream adoption
```

### Option 1: Zola (Static, Offline-First)
```
palimpsest-zola/
├── config.toml.template
├── content/
├── templates/
├── sass/
├── static/.well-known/
└── scripts/setup.sh
```

### Option 2: Serum + Phoenix LiveView (Dynamic Consent)
```
palimpsest-serum/
├── mix.exs
├── config/
├── lib/
│   ├── palimpsest_web/
│   │   ├── live/
│   │   │   ├── consent_live.ex      # Real-time consent UI
│   │   │   ├── attribution_live.ex  # Live attribution chain
│   │   │   └── void_dashboard.ex    # VoID network status
│   │   ├── channels/
│   │   │   └── consent_channel.ex   # WebSocket consent updates
│   │   └── controllers/
│   │       └── aibdp_controller.ex  # HTTP 430 handler
│   └── palimpsest/
│       ├── void/                    # VoID network client
│       ├── ipfs/                    # IPFS integration
│       └── consent/                 # Consent token logic
├── priv/static/.well-known/
├── posts/                           # Serum blog content
└── serum.exs
```

LiveView benefits for Palimpsest:
- Real-time consent revocation notifications
- Live attribution chain visualization
- Interactive license wizard
- VoID network status dashboard
- WebSocket-based consent negotiation

### Option 3: ReScript-TEA (Functional Web Apps)

Using https://github.com/hyperpolymath/rescript-tea:

```
palimpsest-rescript/
├── bsconfig.json
├── src/
│   ├── App.res                     # Main TEA app
│   ├── Consent.res                 # Consent state machine
│   ├── Attribution.res             # Attribution chain model
│   ├── VoidClient.res              # VoID network queries
│   ├── Palimpsest.res              # License metadata types
│   └── components/
│       ├── LicenseWizard.res
│       ├── ConsentBadge.res
│       └── AttributionChain.res
├── static/.well-known/
└── index.html
```

ReScript-TEA benefits:
- Strong typing for license metadata
- Elm-architecture for predictable consent state
- Compiles to efficient JS
- Functional approach aligns with license philosophy

### Option 4: WordPress (wp-simple-theme)

Using https://github.com/hyperpolymath/wp-simple-theme:

```
palimpsest-wp/
├── style.css
├── functions.php
│   └── palimpsest_meta_tags()      # License metadata
│   └── palimpsest_aibdp_headers()  # HTTP headers
│   └── palimpsest_consent_shortcode()
├── template-parts/
│   └── palimpsest-notice.php
├── .well-known/
│   └── ai-boundary.json
└── inc/
    └── class-palimpsest-consent.php
```

WordPress benefits:
- Massive existing user base
- Low barrier to entry
- Plugin ecosystem
- Bridges to mainstream web

**Installation (All Options):**
```bash
# Zola (static)
curl -L https://palimpsest.license/kits/zola.tar.gz | tar xz

# Serum/LiveView (dynamic)
mix archive.install hex palimpsest_serum
mix palimpsest.new my_site

# ReScript-TEA (functional)
npx degit hyperpolymath/palimpsest-rescript my-site

# WordPress (mainstream)
wp plugin install palimpsest-license --activate
```

### IndieWeb Integration

All site kits should support IndieWeb standards for decentralized, user-owned web presence:

**Core IndieWeb Building Blocks:**

```html
<!-- h-card: Machine-readable author identity -->
<div class="h-card">
  <a class="p-name u-url" href="https://example.com">Creator Name</a>
  <data class="p-license" value="Palimpsest-0.7">Palimpsest License v0.7</data>
</div>

<!-- h-entry with Palimpsest metadata -->
<article class="h-entry">
  <h1 class="p-name">My Creative Work</h1>
  <div class="e-content">...</div>
  <a class="u-license" href="https://palimpsest.license/v0.7">Palimpsest-0.7</a>
  <data class="p-ai-training-consent" value="true">AI Training Permitted</data>
  <data class="p-attribution-required" value="true">Attribution Required</data>
</article>

<!-- rel="me" for identity verification -->
<link rel="me" href="https://github.com/username">
<link rel="license" href="https://palimpsest.license/v0.7">
```

**IndieWeb Protocols + Palimpsest:**

| IndieWeb | Palimpsest Integration |
|----------|------------------------|
| **Webmention** | Attribution chain notifications - when derivative works link back |
| **Micropub** | Publish consent declarations to your own site |
| **IndieAuth** | Authenticate for consent token issuance |
| **Vouch** | Trust network for consent verification |
| **Microsub** | Subscribe to consent/attribution updates |

**VoID ↔ IndieWeb Bridge:**

```
┌────────────────────────────────────────────────────────────────┐
│                     User's IndieWeb Site                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐│
│  │   h-card    │  │  h-entry    │  │ .well-known/ai-boundary ││
│  │ (identity)  │  │ (works)     │  │ (AIBDP)                 ││
│  └──────┬──────┘  └──────┬──────┘  └────────────┬────────────┘│
│         │                │                       │             │
│         └────────────────┴───────────────────────┘             │
│                          │                                      │
│              ┌───────────┴───────────┐                         │
│              │     Webmention        │◄── Attribution notifs   │
│              │     endpoint          │                          │
│              └───────────┬───────────┘                         │
└──────────────────────────┼─────────────────────────────────────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ VoID Node 1  │  │ VoID Node 2  │  │ VoID Node 3  │
│  (SurrealDB  │  │  (SurrealDB  │  │  (SurrealDB  │
│  + IPFS)     │  │  + IPFS)     │  │  + IPFS)     │
└──────────────┘  └──────────────┘  └──────────────┘
```

**Webmention for Attribution Chains:**

When someone creates a derivative work:
1. They publish it with `u-license` and `u-in-reply-to` pointing to original
2. Webmention notifies original creator
3. VoID node records the attribution link
4. Both sites show the relationship

```elixir
# Serum/Phoenix: Webmention handler for attribution
defmodule PalimpsestWeb.WebmentionController do
  def receive(conn, %{"source" => source, "target" => target}) do
    with {:ok, derivative} <- fetch_h_entry(source),
         {:ok, license} <- extract_license(derivative),
         :ok <- verify_palimpsest_compliance(license, derivative) do

      # Record in VoID network
      VoID.record_attribution(%{
        original: target,
        derivative: source,
        license: license,
        thematic_integrity: analyze_integrity(derivative)
      })

      send_resp(conn, 202, "Accepted")
    end
  end
end
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
