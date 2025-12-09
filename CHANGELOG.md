# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0] - 2025-12-09

### Added
- **Palimpsest License v0.6** - Major version with enhanced AI provisions
  - Comprehensive ethical use requirements with Safe Harbor provisions
  - AI training explicitly permitted with attribution and ethical use conditions
  - Protocol integration (HTTP 430, AIBDP, Content Provenance)
  - Three jurisdiction options (Scottish, EU, International)
  - Academic, Commercial AI, and Open Source special provisions
- **Zola Static Site Generator** integration
  - Full template system (base, page, section, index)
  - SASS stylesheet with parchment/manuscript aesthetic
  - Content structure for licenses, guides, research
- **Zola Integration Guide** for static site generators
- **Deno Migration** - Replaced npm with Deno for JavaScript/TypeScript tooling
- **Two-Track Roadmap**
  - Practical Track (v0.7): Consent-aware HTTP, ejectable tooling, adoption
  - Augmented Research Track: VoID network, IPFS/SurrealDB, neurosymbolic systems
- **VoID Network Architecture** with IPFS nodes and SurrealDB schema

### Changed
- **Build System**: Justfile now uses Deno instead of npm
- **Version**: Updated to 0.6.0 across all configuration files
- **GitHub Linguist**: Updated .gitattributes for Zola output and TypeScript
- **Validation**: License checks now reference v0.6

### Removed
- npm dependencies (package.json, package-lock.json moved to ARCHIVE/)
- Old Deno config from config/ directory (now at root)

## [0.4.0] - 2025-12-09

### Added
- **Professional Integration Guides** for archivists, museum curators, educators, translators, psychologists, and marginalised communities
- **Research Documents** covering OCanren logic programming, neurosymbolic AI architecture, PKP integration, ambient computing, and trans-perceptual representation
- **Philosophy Documentation** articulating the founding question ("history written by winners") and blockchain's role in immutable consent
- **Platform Infrastructure**: Nix flake, Guix package definition, Wolfi container, Nickel configuration schema
- **Document Review System** for tracking freshness and consistency across the repository
- **Podcast Series Plan** ("Layers") for public outreach
- **Funding Strategy** and target organisation research

### Changed
- **Language Consolidation**: OCaml as primary implementation language (Melange for browser, OCanren for logic)
- **CI/CD Overhaul**: Workflows made resilient with conditional execution and graceful degradation
- **Repository Structure**: Major cleanup following APM-level project management framework
- **Archived**: Elixir experiment moved to ARCHIVE/elixir-experiment/

### Fixed
- Merge conflict resolution for PR #41
- GitHub/GitLab repository reconciliation (GitHub now canonical)
- CI workflow failures blocking PRs

### Removed
- Elixir/Ecto schemas (archived, superseded by OCaml)
- Redundant workflow files (release.yml, jekyll-gh-pages.yml)

## [0.3.0] - 2025-04-05

### Added
- **Full Dutch Translation** for all core legal texts and documentation.
- **AI Governance Audits** clause to the AGI Training Consent Template.
- **Collective Licensing & Cultural Heritage** safeguards and compliance protocols.
- Explicit protections and definitions for **Autonomous, Agentic, Ambient, NI, and QAI systems**.
- **AIBDP Compliance Clause**, making a Procedural Breach of AIBDP a direct breach of the license.
- `GOVERNANCE.md` file outlining the project's decision-making process.

### Changed
- **Restructured Repository** for better clarity and separation of concerns.
- **AGI Consent Template** updated to be a comprehensive, standalone legal document.
- Refined the legal language in the core license to improve enforceability under Dutch/Scottish law.

## [0.2.0] - 2024-12-15

### Added
- **Initial Dutch Translations** for key documents.
- `explainme.md` and `jurisdiction-comparison.md`.
- WCAG 2.3 compliance for all web-based assets.

### Changed
- Formalized the Dutch Law + Scottish Courts legal framework.

## [0.1.0] - 2024-08-01

### Added
- Initial release of the Palimpsest License (v0.1).
- Core principles of symbolic attribution and emotional integrity.