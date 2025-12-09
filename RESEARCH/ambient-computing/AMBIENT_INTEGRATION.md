# Ambient Computing Integration

**Status:** FIRST PASS / RESEARCH
**Purpose:** Palimpsest in ubiquitous/pervasive computing environments

---

## The Ambient Computing Challenge

As computing becomes ambient—embedded in environments, wearables, IoT devices, smart spaces—the boundaries of "using" creative work blur. A song playing in a smart space, an image displayed on ambient screens, a poem read by a home assistant: all involve complex chains of consent and context that current licensing frameworks ignore.

---

## Ambient Computing Landscape

### Computing Modalities

```
AMBIENT COMPUTING SPECTRUM
──────────────────────────

┌─────────────────────────────────────────────────────────────┐
│                    EXPLICIT COMPUTING                        │
│  ─────────────────────────────────────────────────────────  │
│  User explicitly requests content                            │
│  • "Play this song"                                          │
│  • "Show me this image"                                      │
│  • "Read this article"                                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   RESPONSIVE COMPUTING                       │
│  ─────────────────────────────────────────────────────────  │
│  System responds to user context                             │
│  • "Play something relaxing" → system chooses                │
│  • "What should I know?" → curated feed                      │
│  • Personalized recommendations                              │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    AMBIENT COMPUTING                         │
│  ─────────────────────────────────────────────────────────  │
│  System acts without explicit request                        │
│  • Background music in smart spaces                          │
│  • Dynamic art displays                                      │
│  • Environmental mood adjustment                             │
│  • Ubiquitous information surfaces                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   INVISIBLE COMPUTING                        │
│  ─────────────────────────────────────────────────────────  │
│  Computing embedded in environment                           │
│  • Smart materials with embedded content                     │
│  • Environmental AI processing                               │
│  • Biometric-responsive systems                              │
│  • Predictive/anticipatory systems                           │
└─────────────────────────────────────────────────────────────┘
```

### Key Ambient Platforms

| Platform | Use Case | Consent Challenge |
|----------|----------|-------------------|
| Smart Home | Background media, ambient displays | Who consents in shared spaces? |
| Wearables | Personal audio, AR overlays | Micro-interactions, passive consumption |
| Smart Cities | Public displays, environmental media | Public space, collective presence |
| Automotive | In-vehicle entertainment | Driver vs. passenger consent |
| Healthcare | Ambient assistance, therapeutic media | Patient capacity, caregiver role |
| Retail | Background music, digital signage | Employee vs. customer exposure |
| Education | Smart classrooms, learning environments | Minor consent, institutional context |

---

## Consent in Ambient Contexts

### The Problem

Traditional consent models assume:
- Discrete usage events
- Single identifiable user
- Conscious choice to engage
- Clear start/end of use

Ambient computing violates all of these:
- Continuous background presence
- Multiple people in space
- Passive exposure
- Always-on environment

### Proposed Model: Layered Ambient Consent

```
LAYERED AMBIENT CONSENT MODEL
─────────────────────────────

Layer 1: SPACE CONSENT
├── Smart space operator declares capabilities
├── Users entering space have notice
├── Opt-out mechanisms available
└── Default settings for different space types

Layer 2: DEVICE CONSENT
├── Device owner configures consent preferences
├── Device announces its consent state
├── Interoperability with space consent
└── User profile propagation

Layer 3: CONTENT CONSENT
├── Content declares ambient use terms
├── Palimpsest metadata includes ambient flags
├── Restrictions propagate through chain
└── Context requirements for ambient use

Layer 4: INDIVIDUAL CONSENT
├── Personal consent profiles
├── Device/wearable carries preferences
├── Override mechanisms
└── Emergency/safety exceptions
```

### Metadata Extension for Ambient Use

```json
{
  "@context": "https://palimpsestlicense.org/context/ambient",
  "@type": "AmbientUseTerms",

  "ambientPermissions": {
    "backgroundAudio": true,
    "ambientDisplay": true,
    "environmentalIntegration": "conditional",
    "biometricResponse": false
  },

  "spaceRestrictions": {
    "commercial": "prohibited",
    "public": "attribution-required",
    "private": "permitted",
    "healthcare": "therapeutic-context-only"
  },

  "contextRequirements": {
    "traumaMarkers": {
      "ambientUse": "prohibited",
      "reason": "Requires conscious engagement context"
    },
    "culturalContext": {
      "preservationRequired": true,
      "decontextualizedAmbient": "prohibited"
    }
  },

  "presenceConsent": {
    "singleUser": "standard",
    "multiUser": "highest-restriction-wins",
    "minors": "guardian-consent-required",
    "public": "notice-required"
  }
}
```

---

## Technical Architecture

### 1. Space Declaration Protocol

Smart spaces declare their capabilities and policies:

```
SPACE DECLARATION RECORD
────────────────────────

Space: "Coffee Shop Alpha"
Type: commercial-public
Operator: AlphaCafe Inc.

Capabilities:
├── Background audio: yes
├── Ambient displays: yes (4 screens)
├── AR overlay support: no
├── Biometric sensing: no

Content Policies:
├── License requirements: CC-BY, Palimpsest
├── Trauma content: prohibited
├── Political content: permitted
├── Religious content: neutral-only

Consent Mechanisms:
├── Entry notice: posted signage + QR
├── Opt-out: noise-canceling zone available
├── Personal override: via AlphaCafe app
└── Employee policy: separate consent form

Palimpsest Compliance:
├── Metadata preservation: yes
├── Context display: on-demand (QR per track)
├── Consent chain verification: real-time
└── Emotional lineage respect: yes
```

### 2. Device Consent Broadcast

Devices announce their consent configuration:

```
DEVICE CONSENT PROFILE
──────────────────────

Device: "User's Smart Earbuds"
Owner: [anonymized ID]

Ambient Content Preferences:
├── Accept Palimpsest-licensed: yes
├── Accept AI-generated: no
├── Accept trauma-marked: explicit-consent-only
├── Accept commercial-space background: yes

Context Requirements:
├── Attribution display: device notification
├── Emotional lineage: preserve in history
├── Cultural context: display on request

Override Capabilities:
├── Manual skip: yes
├── Space policy override: no (respect space)
├── Emergency bypass: yes (safety content)

Privacy:
├── Consent profile sharing: anonymous aggregate only
├── Usage logging: local device only
└── Cross-space tracking: prohibited
```

### 3. Content-Space Negotiation

Real-time negotiation between content and space:

```
NEGOTIATION FLOW
────────────────

Space Request: "Can I play this track as background?"

Content Response:
┌─────────────────────────────────────────────────────────────┐
│ Track: "Evening Meditation" by Maya Chen                     │
│ License: Palimpsest v0.4                                     │
├─────────────────────────────────────────────────────────────┤
│ Ambient Use: PERMITTED with conditions                       │
│                                                              │
│ Conditions:                                                  │
│ 1. Space type must be: private, wellness, or neutral-public │
│ 2. Attribution must be: displayed within 30 seconds         │
│ 3. Trauma flag: none (no restrictions)                      │
│ 4. Cultural context: Buddhist meditation tradition          │
│    → preserve in any metadata/display                       │
│ 5. AI derivation: this is original human creation           │
└─────────────────────────────────────────────────────────────┘

Space Check:
├── Space type: commercial-public (Coffee Shop) → COMPATIBLE
├── Attribution capability: yes (screen + QR) → SATISFIED
├── No trauma restrictions → OK
├── Cultural context: will display → SATISFIED
└── AI policy: accepts human-created → OK

RESULT: PLAY PERMITTED
```

### 4. Multi-User Consent Resolution

When multiple users are present:

```ocaml
(* Multi-user ambient consent resolution *)

type consent_level =
  | FullConsent
  | ConditionalConsent of condition list
  | NoConsent
  | Unknown

type user_presence = {
  id: anonymized_id;
  consent_profile: consent_level option;
  override_active: bool;
}

let resolve_multi_user_consent users content =
  (* Highest restriction wins *)
  let restrictions = List.map (fun u ->
    match u.consent_profile with
    | Some NoConsent -> `Block
    | Some (ConditionalConsent conds) -> `Conditional conds
    | Some FullConsent -> `Allow
    | None -> `Unknown
  ) users in

  if List.mem `Block restrictions then
    `Blocked
  else if List.exists (fun r -> r = `Unknown) restrictions then
    (* Unknown users: apply space default policy *)
    apply_space_default content
  else
    (* Merge all conditions *)
    let all_conditions = List.concat_map (function
      | `Conditional c -> c
      | _ -> []
    ) restrictions in
    if all_conditions = [] then `Allowed
    else `Conditional all_conditions
```

---

## IoT and Edge Computing

### Edge Processing for Consent

Consent checking must happen at the edge for:
- Latency (real-time ambient environments)
- Privacy (minimal data transmission)
- Resilience (offline operation)

```
EDGE CONSENT ARCHITECTURE
─────────────────────────

┌─────────────────────────────────────────────────────────────┐
│                    CLOUD LAYER                               │
│  ────────────────────────────────────────────────────────── │
│  • Consent registry synchronization                          │
│  • Policy updates                                            │
│  • Aggregate analytics (privacy-preserving)                  │
│  • Cross-space consent verification                          │
└──────────────────────┬──────────────────────────────────────┘
                       │ Sync (periodic, on-change)
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    SPACE EDGE                                │
│  ────────────────────────────────────────────────────────── │
│  • Local consent cache                                       │
│  • Real-time content-space negotiation                       │
│  • Multi-user consent resolution                             │
│  • Attribution display control                               │
│  • Usage logging (local)                                     │
└──────────────────────┬──────────────────────────────────────┘
                       │ Real-time
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                    DEVICE EDGE                               │
│  ────────────────────────────────────────────────────────── │
│  • Personal consent profile                                  │
│  • User override interface                                   │
│  • Local notification                                        │
│  • Privacy-preserving presence signal                        │
└─────────────────────────────────────────────────────────────┘
```

### Embedded Systems Considerations

Minimal consent checking for constrained devices:

```c
/* Minimal Palimpsest consent check for embedded systems */

typedef struct {
    uint8_t ambient_audio : 1;
    uint8_t ambient_display : 1;
    uint8_t trauma_content : 1;
    uint8_t ai_generated : 1;
    uint8_t commercial_use : 1;
    uint8_t attribution_required : 1;
    uint8_t reserved : 2;
} palimpsest_flags_t;

typedef struct {
    uint8_t accept_trauma : 1;
    uint8_t accept_ai : 1;
    uint8_t is_commercial_space : 1;
    uint8_t can_display_attribution : 1;
    uint8_t reserved : 4;
} space_config_t;

bool can_play_ambient(palimpsest_flags_t content, space_config_t space) {
    // Quick bitfield checks for constrained devices
    if (!content.ambient_audio) return false;
    if (content.trauma_content && !space.accept_trauma) return false;
    if (content.ai_generated && !space.accept_ai) return false;
    if (content.commercial_use && !space.is_commercial_space) return false;
    if (content.attribution_required && !space.can_display_attribution) return false;
    return true;
}
```

---

## AR/VR/XR Considerations

Mixed reality adds layers of complexity:

### The Overlay Problem

```
REALITY LAYERS
──────────────

Physical Space
├── Real objects and people
├── Physical artwork, installations
└── Ambient sounds in space

Digital Overlay (AR)
├── Virtual objects anchored to space
├── Information displays
├── Filtered/augmented perception
└── AI-generated enhancements

Virtual Space (VR)
├── Entirely synthetic environment
├── Avatars representing users
├── Virtual creative works
└── AI-populated environments

Mixed Reality (MR)
├── Blend of physical and digital
├── Virtual objects interacting with physical
├── Augmented humans
└── Reality as palette for digital art
```

### XR Content Licensing

```json
{
  "@type": "PalimpsestXRTerms",

  "physicalWorldOverlay": {
    "permitted": true,
    "restrictions": {
      "publicSpace": "attribution-visible",
      "privateSpace": "owner-consent",
      "facialOverlay": "prohibited"
    }
  },

  "virtualWorldEmbedding": {
    "permitted": "conditional",
    "conditions": {
      "contextPreservation": "required",
      "attributionPersistence": "throughout-session",
      "derivativeVirtualWorks": "with-consent"
    }
  },

  "aiAugmentation": {
    "styleTransfer": "prohibited",
    "contentEnhancement": "original-only",
    "generativeExtension": "prohibited"
  }
}
```

---

## Smart City Implications

When the city itself is ambient:

### Public Space Challenge

```
PUBLIC AMBIENT COMPUTING
────────────────────────

Scenario: Digital billboard network in smart city

Participants:
├── City authority (space operator)
├── Advertising network (content curator)
├── Content creators (license holders)
├── Pedestrians (passive viewers)
├── Residents (repeat exposure)
└── Workers (involuntary audience)

Consent complexity:
├── Opt-out not feasible (public infrastructure)
├── Multiple stakeholders with different interests
├── Content changes dynamically
├── No single "user" to consent
└── Vulnerable populations (homeless, children)
```

### Proposed Public Space Protocol

```
PUBLIC AMBIENT CONTENT PROTOCOL
───────────────────────────────

Tier 1: Universal Public Content
├── No trauma markers
├── No cultural sensitivity flags
├── Attribution not required (implied public)
├── AI content: must be marked

Tier 2: Restricted Public Content
├── Time/location restrictions
├── Content warnings displayed
├── Cultural context preserved
├── Community consultation required

Tier 3: Prohibited Public Ambient
├── Trauma-marked content
├── Sacred/ceremonial content
├── Explicit consent-required content
├── Targeting vulnerable populations
```

---

## Integration with Consent Registry

Ambient systems need real-time consent verification:

```
AMBIENT CONSENT REGISTRY API
────────────────────────────

GET /consent/ambient/{content_id}
├── Returns: Ambient use terms
├── Latency: <10ms (edge-cached)
└── Auth: Space certification required

POST /consent/ambient/negotiate
├── Body: {space_config, content_id, user_presence[]}
├── Returns: Negotiation result + conditions
└── Latency: <50ms

GET /consent/ambient/stream
├── WebSocket for real-time updates
├── Pushed: Consent revocations
└── Pushed: Policy changes

POST /consent/ambient/usage
├── Body: {content_id, space_id, duration, user_count}
├── Privacy: Aggregate only, no individual tracking
└── Purpose: Creator compensation, analytics
```

---

## Questions Emerged

1. **Who is liable for ambient consent violations?**
   - Space operator? Device manufacturer? Content platform?
   - Joint and several liability?
   - Safe harbor provisions?

2. **How do we handle consent withdrawal in ambient context?**
   - Someone enters space who doesn't consent
   - Revocation while content is playing
   - Graceful degradation vs. hard stop

3. **What about recording and replay?**
   - Smart space records include licensed content
   - Security footage with background music
   - Ambient content in user-generated recordings

4. **How do we prevent consent theater?**
   - Unreadable terms on entry
   - Impossible opt-out mechanisms
   - Dark patterns in ambient consent

5. **What's the role of AI in ambient curation?**
   - AI selects content for ambient playback
   - AI generates ambient content
   - AI interprets user presence for consent

6. **How do we respect cultural contexts in public space?**
   - Sacred content in secular public space
   - Diaspora communities in hostile environments
   - Cultural appropriation at scale

7. **What about children and vulnerable populations?**
   - Cannot consent for themselves
   - Involuntary presence in ambient spaces
   - Exploitation through ambient targeting

---

## Design Principles for Ambient Palimpsest

1. **Default to restriction:** If unsure, don't play
2. **Highest restriction wins:** Multi-user → most restrictive consent applies
3. **Graceful degradation:** If consent unclear, fall back to safer content
4. **Attribution persistence:** Even ambient use requires findable attribution
5. **Context preservation:** Ambient doesn't mean decontextualized
6. **Exit possible:** Opt-out must be meaningful and accessible
7. **Transparency:** What's playing, why, and under what terms
8. **Accountability:** Clear responsibility chain for violations

---

## Implementation Roadmap

### Phase 1: Specification
- Ambient consent metadata schema
- Space declaration protocol
- Multi-user consent resolution algorithm

### Phase 2: Reference Implementation
- Edge consent checking library (OCaml → C via Melange alternative)
- Space declaration service
- Device consent profile manager

### Phase 3: Integration Partners
- Smart home platforms (Home Assistant, etc.)
- Commercial ambient systems
- Public space operators

### Phase 4: Standards Track
- IETF draft for ambient consent protocol
- W3C community group for XR licensing
- IEEE standards liaison

