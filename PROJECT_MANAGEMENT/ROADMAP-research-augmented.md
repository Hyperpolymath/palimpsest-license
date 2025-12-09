# Palimpsest Augmented Research Track

**Status:** Conceptual / In Development
**Focus:** Deep philosophical foundations, VoID network, neurosymbolic systems
**Relationship to v0.7:** Parallel but distinct; informs but doesn't block practical adoption

---

## Overview

The Augmented Research Track explores the deeper philosophical, technical, and systemic foundations of ethical content licensing. While the Practical Track (v0.7) focuses on adoption and tooling, this track investigates:

1. **Ontological foundations** of consent, attribution, and creative lineage
2. **VoID (Vocabulary of Interlinked Datasets)** for federated license networks
3. **Neurosymbolic reasoning** for license interpretation and compliance
4. **Quantum-proof attribution** mechanisms
5. **Collective/DAO governance** models for shared creative assets

This is the space for ideas that may take years to mature but could fundamentally reshape how we think about creative rights in the AI era.

---

## Core Research Areas

### 1. Philosophical Foundations

**Emotional Lineage & Narrative Debt**

The Palimpsest License is built on the premise that creative works carry emotional and cultural debt that simple attribution cannot discharge. Research questions:

- How do we formalize "emotional lineage" in ways that are both meaningful and enforceable?
- What constitutes "narrative debt" and how is it accumulated/discharged?
- Can symbolic attribution capture the full weight of cultural inheritance?

**Thematic Integrity**

- What makes a remix "honor" vs "violate" thematic integrity?
- How do we reason about intent across transformations?
- Can AI systems be trained to recognize thematic integrity violations?

**The Palimpsest Metaphor**

The license name invokes manuscripts where earlier text remains visible beneath new writing. Research into:

- Layered attribution models (attribution through transformation)
- "Ghost text" - the invisible influence of training data
- Visibility vs erasure in derivative works

### 2. VoID Network Architecture

**Vision:** A federated network of license registries where:

- Creators register works and consent preferences
- AI systems query consent status before training
- Attribution chains are maintained across the network
- Compliance can be verified cryptographically

**Technical Components:**

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           VoID Network Layer                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌────────────────────┐    ┌────────────────────┐    ┌─────────────────┐  │
│  │   Registry Node    │◄──►│   Registry Node    │◄──►│ Registry Node   │  │
│  │  ┌──────────────┐  │    │  ┌──────────────┐  │    │ ┌─────────────┐ │  │
│  │  │  SurrealDB   │  │    │  │  SurrealDB   │  │    │ │  SurrealDB  │ │  │
│  │  │  (VoID RDF)  │  │    │  │  (VoID RDF)  │  │    │ │  (VoID RDF) │ │  │
│  │  └──────┬───────┘  │    │  └──────┬───────┘  │    │ └──────┬──────┘ │  │
│  │         │          │    │         │          │    │        │        │  │
│  │  ┌──────▼───────┐  │    │  ┌──────▼───────┐  │    │ ┌──────▼──────┐ │  │
│  │  │  IPFS Node   │◄─┼────┼──►  IPFS Node   │◄─┼────┼─►  IPFS Node  │ │  │
│  │  │ (Content +   │  │    │  │ (Content +   │  │    │ │ (Content +  │ │  │
│  │  │  VoID Shards)│  │    │  │  VoID Shards)│  │    │ │ VoID Shards)│ │  │
│  │  └──────────────┘  │    │  └──────────────┘  │    │ └─────────────┘ │  │
│  └────────────────────┘    └────────────────────┘    └─────────────────┘  │
│           │                         │                        │             │
│           └─────────────────────────┼────────────────────────┘             │
│                                     │                                       │
│                     ┌───────────────┴───────────────┐                      │
│                     │    Distributed VoID Index     │                      │
│                     │  (IPFS + SurrealDB Replicas)  │                      │
│                     │                               │                      │
│                     │  - Consent records (CIDs)     │                      │
│                     │  - Attribution chains         │                      │
│                     │  - Work metadata              │                      │
│                     │  - Provenance graphs          │                      │
│                     └───────────────────────────────┘                      │
│                                                                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                         Protocol Layer                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────┐  ┌──────────────────┐  ┌────────────────────────┐   │
│   │ VoID Vocabulary │  │ Palimpsest       │  │ IPFS Content          │   │
│   │ + Extensions    │  │ Ontology (OWL)   │  │ Addressing (CIDs)     │   │
│   └─────────────────┘  └──────────────────┘  └────────────────────────┘   │
│                                                                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                         Content Layer                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌───────────────┐  ┌───────────────┐  ┌───────────────┐  ┌────────────┐ │
│  │ Creator Site  │  │ Creator Site  │  │ Creator Site  │  │ AI System  │ │
│  │               │  │               │  │               │  │            │ │
│  │ ┌───────────┐ │  │ ┌───────────┐ │  │ ┌───────────┐ │  │ ┌────────┐ │ │
│  │ │IPFS Pinned│ │  │ │IPFS Pinned│ │  │ │IPFS Pinned│ │  │ │  IPFS  │ │ │
│  │ │ Content   │ │  │ │ Content   │ │  │ │ Content   │ │  │ │  CIDs  │ │ │
│  │ └───────────┘ │  │ └───────────┘ │  │ └───────────┘ │  │ └────────┘ │ │
│  └───────┬───────┘  └───────┬───────┘  └───────┬───────┘  └─────┬──────┘ │
│          │                  │                  │                │         │
│          └──────────────────┴──────────────────┴────────────────┘         │
│                                    │                                       │
│                     ┌──────────────┴──────────────┐                       │
│                     │  AIBDP + HTTP 430 + CID     │                       │
│                     │  + Provenance + SurrealDB   │                       │
│                     └─────────────────────────────┘                       │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

**Data Layer: SurrealDB + IPFS Integration**

Each registry node runs:

1. **SurrealDB** - Multi-model database for:
   - Graph queries (RDF/VoID relationships)
   - Document storage (JSON-LD metadata)
   - Real-time subscriptions (consent changes)
   - Full-text search (work discovery)
   - SQL-like queries with graph traversal

2. **IPFS Node** - Content-addressed storage for:
   - License text (immutable, content-addressed)
   - Work metadata snapshots
   - VoID dataset shards
   - Provenance chains
   - Consent tokens

**SurrealDB Schema for Palimpsest VoID:**

```surql
-- Define the Palimpsest namespace
DEFINE NAMESPACE palimpsest;
USE NS palimpsest;

-- Define database
DEFINE DATABASE void_registry;
USE DB void_registry;

-- Work records (content-addressed via IPFS CID)
DEFINE TABLE work SCHEMAFULL;
DEFINE FIELD cid ON work TYPE string ASSERT $value != NONE;
DEFINE FIELD title ON work TYPE string;
DEFINE FIELD creator ON work TYPE record(creator);
DEFINE FIELD license ON work TYPE string DEFAULT "Palimpsest-0.7";
DEFINE FIELD consent ON work TYPE object;
DEFINE FIELD provenance ON work TYPE array;
DEFINE FIELD emotional_lineage ON work TYPE array;
DEFINE FIELD created_at ON work TYPE datetime DEFAULT time::now();
DEFINE FIELD ipfs_pinned ON work TYPE bool DEFAULT true;

-- Creator records
DEFINE TABLE creator SCHEMAFULL;
DEFINE FIELD name ON creator TYPE string;
DEFINE FIELD type ON creator TYPE string ASSERT $value IN ["human", "ai", "collective"];
DEFINE FIELD contact ON creator TYPE string;
DEFINE FIELD public_key ON creator TYPE string;

-- Attribution chain (graph edges)
DEFINE TABLE derives_from SCHEMAFULL;
DEFINE FIELD in ON derives_from TYPE record(work);
DEFINE FIELD out ON derives_from TYPE record(work);
DEFINE FIELD transformation_type ON derives_from TYPE string;
DEFINE FIELD thematic_integrity ON derives_from TYPE bool;
DEFINE FIELD attribution_preserved ON derives_from TYPE bool;

-- Consent records
DEFINE TABLE consent SCHEMAFULL;
DEFINE FIELD work ON consent TYPE record(work);
DEFINE FIELD scope ON consent TYPE array;
DEFINE FIELD granted_to ON consent TYPE string;
DEFINE FIELD token_cid ON consent TYPE string;
DEFINE FIELD expires_at ON consent TYPE datetime;
DEFINE FIELD revoked ON consent TYPE bool DEFAULT false;

-- Real-time consent change subscriptions
DEFINE EVENT consent_change ON TABLE consent WHEN $event = "UPDATE" OR $event = "DELETE" THEN {
    -- Notify subscribers of consent changes
    CREATE notification SET
        type = "consent_change",
        work = $after.work,
        timestamp = time::now()
};

-- Graph query: find all works in an attribution chain
DEFINE FUNCTION fn::attribution_chain($work_id: record) {
    RETURN SELECT
        ->derives_from->work AS ancestors,
        <-derives_from<-work AS descendants
    FROM $work_id
    FETCH ancestors, descendants
};
```

**IPFS Integration:**

```typescript
// Deno/TypeScript - IPFS + SurrealDB integration
import { create } from "ipfs-http-client";
import Surreal from "surrealdb.js";

const ipfs = create({ url: "http://localhost:5001" });
const db = new Surreal();

// Register a work with IPFS + SurrealDB
async function registerWork(work: WorkMetadata): Promise<string> {
  // 1. Pin content to IPFS
  const contentCid = await ipfs.add(work.content);

  // 2. Create metadata with CID reference
  const metadata = {
    ...work,
    contentCid: contentCid.path,
    registeredAt: new Date().toISOString(),
  };

  // 3. Pin metadata to IPFS
  const metadataCid = await ipfs.add(JSON.stringify(metadata));

  // 4. Store in SurrealDB for querying
  await db.create("work", {
    cid: metadataCid.path,
    title: work.title,
    creator: work.creator,
    consent: work.consent,
    ipfs_pinned: true,
  });

  // 5. Return the content-addressed identifier
  return metadataCid.path;
}

// Query attribution chain via SurrealDB graph
async function getAttributionChain(workCid: string) {
  return await db.query(`
    SELECT
      ->derives_from->work.* AS ancestors,
      <-derives_from<-work.* AS descendants
    FROM work WHERE cid = $cid
  `, { cid: workCid });
}
```

**VoID Extensions for Palimpsest:**

```turtle
@prefix void: <http://rdfs.org/ns/void#> .
@prefix palimpsest: <https://palimpsest.license/ontology#> .
@prefix dcat: <http://www.w3.org/ns/dcat#> .

# Palimpsest extensions to VoID
palimpsest:ConsentRegistry a void:Dataset ;
    void:feature palimpsest:ConsentTracking ;
    palimpsest:consentProtocol "HTTP-430" ;
    palimpsest:licenseVersion "0.7" .

palimpsest:Work a rdfs:Class ;
    rdfs:subClassOf dcat:Dataset ;
    palimpsest:hasAttributionChain palimpsest:AttributionChain ;
    palimpsest:hasEmotionalLineage palimpsest:EmotionalLineage ;
    palimpsest:hasConsentStatus palimpsest:ConsentStatus .

palimpsest:AttributionChain a rdfs:Class ;
    rdfs:comment "Chain of attributions through transformations" ;
    palimpsest:originWork palimpsest:Work ;
    palimpsest:derivativeWork palimpsest:Work ;
    palimpsest:transformationType xsd:string .
```

**Network Governance:**

- Decentralized registry nodes
- No single point of control
- Cross-registry queries via SPARQL federation
- Node operators agree to Palimpsest Stewardship principles

### 3. Neurosymbolic License Reasoning

**Goal:** AI systems that can *reason* about license compliance, not just pattern-match.

**OCanren/miniKanren Integration:**

Using relational logic programming for license reasoning:

```ocaml
(* OCanren logic for Palimpsest compliance *)
let rec compliant work =
  conde [
    (* Base case: original work with explicit consent *)
    fresh (creator consent) (
      work === Work.original ~creator ~consent:true
    );
    (* Derivative case: must honor thematic integrity *)
    fresh (original derivative transformation) (
      work === Work.derivative ~original ~transformation &&
      compliant original &&
      honors_thematic_integrity transformation original
    );
    (* AI derivative: must maintain attribution *)
    fresh (training_data output) (
      work === Work.ai_generated ~training_data ~output &&
      List.for_all compliant training_data &&
      maintains_attribution output training_data
    )
  ]

let honors_thematic_integrity transformation original =
  (* Symbolic reasoning about thematic preservation *)
  fresh (original_themes transformed_themes) (
    extract_themes original original_themes &&
    extract_themes (apply transformation original) transformed_themes &&
    themes_preserved original_themes transformed_themes
  )
```

**Applications:**

- Automated compliance checking for AI training pipelines
- License compatibility reasoning
- Derivative work classification
- Attribution chain validation

### 4. Quantum-Proof Attribution

**The Problem:** Current cryptographic attribution (signatures, hashes) may be broken by quantum computers.

**Research Directions:**

- Post-quantum signature schemes for content provenance
- Lattice-based attribution tokens
- Quantum key distribution for high-value works
- Hash-based signatures (SPHINCS+) for long-term attribution

**Implementation Considerations:**

- Hybrid classical/post-quantum schemes during transition
- Backward compatibility with existing provenance chains
- Performance trade-offs for real-time verification

### 5. Collective Governance (DAO Models)

**Scenario:** A community collectively owns cultural narratives (diaspora stories, traditional knowledge).

**DAO Structure for Collective Works:**

```
┌─────────────────────────────────────────┐
│         Palimpsest DAO                  │
├─────────────────────────────────────────┤
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      Governance Token           │   │
│  │  (Cultural Stake / Voice)       │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      Consent Voting             │   │
│  │  - AI training permissions      │   │
│  │  - Derivative approvals         │   │
│  │  - License version adoption     │   │
│  └─────────────────────────────────┘   │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │      Treasury                    │   │
│  │  - Attribution royalties        │   │
│  │  - Legal defense fund           │   │
│  │  - Community grants             │   │
│  └─────────────────────────────────┘   │
│                                         │
└─────────────────────────────────────────┘
```

**Questions to Resolve:**

- How do you represent cultural stake without commodifying identity?
- What voting mechanisms preserve minority voice?
- How do you handle intergenerational transfer of cultural rights?
- Interface between DAO governance and legal systems

---

## Research Outputs

### Academic Papers (Planned)

1. "Emotional Lineage: Formalizing Narrative Debt in Content Licensing"
2. "VoID Networks for Federated Consent Management"
3. "Neurosymbolic Approaches to License Compliance Verification"
4. "Post-Quantum Attribution for Long-Lived Creative Works"
5. "DAO Governance Models for Collective Cultural Assets"

### Software Artifacts

- OCanren license reasoning library
- VoID network reference implementation
- Post-quantum provenance prototype
- DAO smart contract templates (Solidity + formal verification)

### Standards Contributions

- VoID vocabulary extension proposal (W3C)
- Palimpsest ontology (OWL/RDF)
- Post-quantum provenance protocol specification
- IndieWeb microformat extensions for licensing

---

## VoID + IndieWeb: The Parallel Web

The VoID network and IndieWeb share a fundamental philosophy: **user-owned, decentralized, interoperable**. Together they form the backbone of an alternative consent infrastructure.

### Why IndieWeb is Essential

IndieWeb principles align perfectly with Palimpsest goals:

| IndieWeb Principle | Palimpsest Alignment |
|-------------------|----------------------|
| **Own your data** | Own your consent declarations |
| **Own your identity** | Own your attribution identity |
| **POSSE** (Publish Own Site, Syndicate Elsewhere) | Consent originates from your domain |
| **Backfeed** | Attribution notifications return to you |
| **Plurality** | Multiple frameworks (Zola/Serum/ReScript/WP) |

### The Parallel VoID/IndieWeb Network

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        PARALLEL CONSENT WEB                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌─────────────────────┐         ┌─────────────────────┐               │
│  │  IndieWeb Sites     │◄───────►│  VoID Registry      │               │
│  │  (user-owned)       │         │  Nodes              │               │
│  │                     │         │                     │               │
│  │  - h-card identity  │   IPFS  │  - SurrealDB        │               │
│  │  - h-entry works    │◄───────►│  - Consent records  │               │
│  │  - Webmention       │   CIDs  │  - Attribution      │               │
│  │  - Micropub         │         │    graphs           │               │
│  └─────────────────────┘         └─────────────────────┘               │
│           │                               │                             │
│           │         ┌─────────────────────┘                             │
│           │         │                                                    │
│           ▼         ▼                                                    │
│  ┌─────────────────────────────────────┐                               │
│  │     Federated Consent Discovery      │                               │
│  │                                       │                               │
│  │  "Is work X licensed under          │                               │
│  │   Palimpsest? What consent          │                               │
│  │   exists for AI training?"          │                               │
│  │                                       │                               │
│  │  → Query IndieWeb site's AIBDP      │                               │
│  │  → Cross-reference VoID registry    │                               │
│  │  → Return consent status + CID      │                               │
│  └─────────────────────────────────────┘                               │
│                     │                                                    │
│                     ▼                                                    │
│  ┌─────────────────────────────────────┐                               │
│  │          AI Systems                  │                               │
│  │                                       │                               │
│  │  Before training on content:        │                               │
│  │  1. Check .well-known/ai-boundary   │                               │
│  │  2. Query VoID network              │                               │
│  │  3. Verify Webmention trail         │                               │
│  │  4. Record provenance (IPFS CID)    │                               │
│  └─────────────────────────────────────┘                               │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### IndieWeb Building Blocks for VoID

**Microformat Extensions:**

```html
<!-- Proposed: p-consent for Palimpsest consent metadata -->
<div class="h-entry">
  <h1 class="p-name">Creative Work</h1>

  <!-- Consent block (proposed microformat) -->
  <div class="p-consent h-consent">
    <data class="p-license" value="Palimpsest-0.7">
    <data class="p-ai-training" value="allowed">
    <data class="p-attribution-required" value="true">
    <data class="p-ethical-use-required" value="true">
    <a class="u-void-registry" href="ipfs://Qm...">VoID Record</a>
    <time class="dt-expires" datetime="2027-01-01">Consent valid until</time>
  </div>
</div>
```

**Webmention as Attribution Protocol:**

Every derivative work sends a Webmention, creating a distributed attribution graph without centralized infrastructure.

**IndieAuth for Consent Issuance:**

Use your own domain as identity to issue consent tokens:

```
Authorization: Bearer <IndieAuth token>
X-Consent-Domain: example.com
X-Consent-Scope: ai-training,derivatives
```

### Research Questions

1. How do we bridge IndieWeb's "small web" ethos with corporate AI systems?
2. Can Webmention scale to attribution chains with millions of derivatives?
3. How do we handle consent for works that predate IndieWeb adoption?
4. What's the governance model for VoID node operators?
5. How do we prevent Sybil attacks on the consent registry?

---

## Relationship to Practical Track

```
                    ┌─────────────────────┐
                    │                     │
                    │   Augmented         │
                    │   Research          │
                    │                     │
                    │  - Philosophy       │
                    │  - VoID Network     │
                    │  - Neurosymbolic    │
                    │  - Quantum          │
                    │  - DAO              │
                    │                     │
                    └──────────┬──────────┘
                               │
                               │ Informs (long-term)
                               │
                               ▼
┌────────────────────────────────────────────────────────┐
│                                                        │
│                 Palimpsest v0.7+                       │
│                 Practical Track                        │
│                                                        │
│  - License text                                        │
│  - Ejectable tooling                                   │
│  - Consent-aware HTTP                                  │
│  - Adoption pathways                                   │
│                                                        │
└────────────────────────────────────────────────────────┘
                               │
                               │ Available today
                               │
                               ▼
                    ┌─────────────────────┐
                    │                     │
                    │      Users          │
                    │   Creators          │
                    │   Developers        │
                    │   Organizations     │
                    │                     │
                    └─────────────────────┘
```

The practical track should not wait for research breakthroughs. However:

- Research insights may influence future license versions (v0.8+)
- VoID network can be adopted incrementally as it matures
- Neurosymbolic tools can augment (not replace) manual compliance
- DAO governance is optional for communities that need it

---

## Getting Involved

This research track benefits from interdisciplinary collaboration:

- **Philosophers** - Ethical foundations, narrative theory
- **Legal Scholars** - IP law, collective rights, jurisdiction
- **Computer Scientists** - Logic programming, cryptography, distributed systems
- **Cultural Theorists** - Diaspora studies, indigenous rights, collective memory
- **AI Researchers** - Training practices, attribution in models

Contact: jonathan.jewell@open.ac.uk / jjewell23@rvc.ac.uk

---

## Timeline

Unlike the practical track, research doesn't follow strict milestones. Current priorities:

**Near-term (2025-2026):**
- VoID vocabulary extension draft
- OCanren proof-of-concept
- First academic paper submission

**Medium-term (2026-2027):**
- VoID network testnet
- Post-quantum prototype
- DAO governance experiments

**Long-term (2027+):**
- Production VoID network
- Standardization efforts
- Legal framework alignment

---

## Related Documents

- [Practical Track (v0.7)](./ROADMAP-v0.7-practical.md)
- [Research Documents](../RESEARCH/)
- [Governance Model](../GOVERNANCE.md)
- [OCanren Notes](../RESEARCH/logic-reasoning/)
