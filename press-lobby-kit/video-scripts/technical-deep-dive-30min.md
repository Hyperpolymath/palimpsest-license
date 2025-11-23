# Technical Deep Dive: "Implementing Palimpsest Licence Infrastructure" (30 Minutes)

**For Developer Audience: Architecture, Protocols, and Integration**

---

## Video Overview

**Title:** "Palimpsest Licence: Technical Deep Dive - From Protocol Buffers to Production"

**Target Audience:** Software developers, DevOps engineers, platform architects, open-source contributors

**Format:** Technical presentation with live coding demonstrations

**Tone:** Professional, detailed, practical, code-heavy

**Total Runtime:** 30:00 (1800 seconds)

**Presenter:** Lead developer or technical architect from Palimpsest project

**Technical Level:** Intermediate to Advanced (assumes familiarity with:)
- REST APIs and HTTP protocols
- JSON/Protocol Buffers
- Git/GitHub workflows
- Basic Haskell or functional programming concepts (helpful but not required)
- ReScript/JavaScript/TypeScript
- CI/CD pipelines

---

## Learning Objectives

By the end of this deep dive, developers will be able to:

1. **Understand** the technical architecture of Palimpsest consent infrastructure
2. **Implement** licence metadata in Protocol Buffers schemas
3. **Deploy** Haskell validators for consent verification
4. **Integrate** ReScript components for web-based consent requests
5. **Build** CI/CD pipelines that respect Palimpsest licences
6. **Contribute** to open-source Palimpsest tooling

---

## Production Requirements

**Equipment:**
- **Screen Recording:** OBS Studio (1920×1080, 60fps)
- **Code Editor:** VS Code with syntax highlighting, large font (18-20pt for readability)
- **Terminal:** High-contrast theme (light text on dark background)
- **Microphone:** Professional quality (clear technical explanations)
- **Webcam (optional):** Picture-in-picture for presenter

**Pre-Production:**
- Set up demo repositories (public GitHub repos for examples)
- Prepare code samples (tested, working, documented)
- Build demo applications (consent registry API, validator service)
- Create diagrams (architecture, data flow, protocol sequence)

**Timeline:** 6-8 weeks
**Budget:** £5,000-£8,000

---

## Technical Deep Dive Structure & Timing

### PART 1: ARCHITECTURE OVERVIEW (0:00-5:00 / 300 seconds)

#### Segment 1A: Introduction & Motivation (0:00-1:30)

**Screen:**
- Title slide: "Palimpsest Technical Deep Dive"
- Presenter introduction (if using PiP)

**Voiceover:**
> "Welcome to the Palimpsest Licence technical deep dive. I'm [Name], lead developer on the Palimpsest infrastructure project."
>
> "In this 30-minute session, we'll go deep into the technical implementation of consent-layer licensing. We'll cover protocol design, validation logic, integration patterns, and real-world deployment strategies."
>
> "This isn't a beginner tutorial—I assume you're comfortable with APIs, protocol design, and reading code. We'll move quickly, but everything I show you is open source and available on GitHub."
>
> "Let's start with the big picture: Why does Palimpsest need technical infrastructure?"

**Graphics:**
- Bullet points: Today's Topics
  - Protocol Buffer schemas
  - Haskell validators
  - ReScript UI components
  - CI/CD integration
  - Production deployment

**Timing:** 90 seconds (0:00-1:30)

---

#### Segment 1B: The Problem Statement (1:30-3:00)

**Screen:**
- Diagram: AI training pipeline (scraper → dataset → model)
- Overlay: Where Palimpsest intervenes

**Voiceover:**
> "Here's the problem: AI training pipelines scrape content from the internet, ingest it into datasets, and train models—all without checking creator consent."
>
> "Existing copyright tools don't help. A `robots.txt` file can block crawlers, but it's not legally binding for AI training. Licence text in a README is human-readable, but AI scrapers can't automatically respect it."
>
> "Palimpsest solves this with machine-readable consent metadata. When a scraper encounters a Palimpsest-licensed work, it must:"
>
> "One: Detect the licence metadata."
>
> "Two: Check if consent has been granted."
>
> "Three: Respect the creator's decision—use only if consent is explicit."
>
> "To make this work at internet scale, we need three layers of infrastructure:"
>
> "First: Metadata format—how consent requirements are expressed."
>
> "Second: Validation logic—how scrapers verify consent."
>
> "Third: Consent registry—how creators grant or deny requests."
>
> "Let's build each layer."

**Graphics:**
- Flow diagram:
  1. Creator adds Palimpsest metadata → File/repo
  2. AI scraper detects metadata → Checks consent registry
  3. Registry returns: Granted / Denied / Pending
  4. Scraper respects decision

**Timing:** 90 seconds (1:30-3:00)

---

#### Segment 1C: Architecture Components (3:00-5:00)

**Screen:**
- Architecture diagram (high-level)

**Components:**
1. **Palimpsest Metadata Schema** (Protocol Buffers)
   - Embedded in files, repositories, websites
   - Machine-readable consent requirements

2. **Validation Service** (Haskell)
   - Checks metadata validity
   - Queries consent registry
   - Returns consent status

3. **Consent Registry API** (REST/GraphQL)
   - Stores consent grants/denials
   - Manages creator accounts
   - Issues consent receipts

4. **Web UI** (ReScript + React)
   - Creator dashboard (grant/deny consent)
   - AI company request interface
   - Audit logs

5. **Integration Libraries** (Python, JavaScript, Rust)
   - SDKs for scrapers, platforms, tools
   - CI/CD plugins (GitHub Actions, GitLab CI)

**Voiceover:**
> "Here's the full architecture."
>
> "At the bottom: Palimpsest metadata, embedded in files using Protocol Buffers or JSON-LD."
>
> "In the middle: Validation service, written in Haskell for correctness and type safety. It parses metadata and queries the consent registry."
>
> "At the top: Consent Registry API, a REST/GraphQL service that manages consent grants, denials, and receipts."
>
> "On the sides: Web UI for creators and AI companies, built with ReScript and React for a modern, type-safe frontend."
>
> "And surrounding everything: Integration libraries—Python, JavaScript, Rust—so scrapers, platforms, and CI/CD tools can easily integrate Palimpsest checks."
>
> "Each component is open source. You can deploy your own instance or use the public infrastructure."
>
> "Now let's dive into the code."

**Graphics:**
- Layered architecture diagram (components stacked)
- GitHub links to repos (overlay text)

**Timing:** 120 seconds (3:00-5:00)

---

### PART 2: PROTOCOL BUFFERS SCHEMA (5:00-10:00 / 300 seconds)

#### Segment 2A: Why Protocol Buffers? (5:00-6:00)

**Screen:**
- Comparison: JSON vs. Protocol Buffers

**Voiceover:**
> "First question: Why Protocol Buffers for metadata?"
>
> "We started with JSON—it's human-readable, ubiquitous, easy to parse. But it has downsides:"
>
> "No schema validation. A typo in a field name breaks everything."
>
> "Verbose. JSON adds overhead, especially for embedded metadata."
>
> "No versioning. When we update the schema, old parsers break."
>
> "Protocol Buffers solve all three:"
>
> "Schemas are strictly typed. The compiler catches errors."
>
> "Binary format is compact. Metadata adds minimal overhead."
>
> "Backward compatibility is built in. Old parsers can read new schemas."
>
> "For a licence that needs to last decades, Protocol Buffers are the right choice."

**Graphics:**
- Side-by-side comparison table:

| Feature | JSON | Protocol Buffers |
|---------|------|------------------|
| Schema validation | No | Yes |
| Size | Verbose | Compact |
| Versioning | Manual | Built-in |
| Tooling | Universal | Good (growing) |

**Timing:** 60 seconds (5:00-6:00)

---

#### Segment 2B: Palimpsest Schema Definition (6:00-8:00)

**Screen:**
- VS Code with `palimpsest.proto` file open

**Code:**
```protobuf
syntax = "proto3";

package palimpsest.v1;

// Palimpsest Licence Metadata
message LicenceMetadata {
  // Licence version (e.g., "v0.4")
  string version = 1;

  // Creator information
  CreatorInfo creator = 2;

  // Consent requirements
  ConsentPolicy consent_policy = 3;

  // Optional: Contact for consent requests
  string consent_contact = 4;

  // Timestamp when licence was applied
  int64 timestamp = 5;

  // Optional: Link to full licence text
  string licence_url = 6;
}

message CreatorInfo {
  // Creator's name (person or organisation)
  string name = 1;

  // Optional: Creator identifier (ORCID, GitHub username, etc.)
  string identifier = 2;

  // Optional: Creator website
  string website = 3;
}

message ConsentPolicy {
  // AI training consent requirement
  ConsentRequirement ai_training = 1;

  // Optional: Commercial use consent
  ConsentRequirement commercial_use = 2;

  // Optional: Derivative works consent
  ConsentRequirement derivative_works = 3;
}

enum ConsentRequirement {
  // Not specified (default to consent required)
  UNSPECIFIED = 0;

  // Explicit consent required
  CONSENT_REQUIRED = 1;

  // Consent granted (open use)
  CONSENT_GRANTED = 2;

  // Consent denied (no use)
  CONSENT_DENIED = 3;
}
```

**Voiceover:**
> "Here's the Palimpsest Protocol Buffer schema."
>
> "At the top: `LicenceMetadata` message. This is the root structure."
>
> "Field 1: Version. String. Specifies the licence version—'v0.4', for example."
>
> "Field 2: CreatorInfo. Nested message with creator's name, identifier (like an ORCID or GitHub username), and website."
>
> "Field 3: ConsentPolicy. This is where consent requirements live. AI training, commercial use, derivative works—each can be independently specified."
>
> "Field 4: Consent contact. Email or URL where AI companies can request consent."
>
> "Field 5: Timestamp. When the licence was applied, as a Unix timestamp."
>
> "Field 6: Licence URL. Link to the full licence text."
>
> "The `ConsentPolicy` message uses an enum: `ConsentRequirement`. Four values:"
>
> "UNSPECIFIED: Default to consent required."
>
> "CONSENT_REQUIRED: Explicit consent needed."
>
> "CONSENT_GRANTED: Open use allowed."
>
> "CONSENT_DENIED: No use permitted."
>
> "This schema is versioned—`palimpsest.v1`. When we release v2, old parsers still work."

**Screen:**
- Highlight each message and field as mentioned
- Show enum definition clearly

**Timing:** 120 seconds (6:00-8:00)

---

#### Segment 2C: Embedding Metadata (8:00-10:00)

**Screen:**
- Terminal: Generate code from `.proto` file
- Command: `protoc --python_out=. palimpsest.proto`
- Output: `palimpsest_pb2.py` generated

**Voiceover:**
> "To use this schema, generate code for your language. I'll use Python."

**Command:**
```bash
protoc --python_out=. palimpsest.proto
```

**Voiceover:**
> "This generates `palimpsest_pb2.py`, a Python module with all the message classes."

**Screen:**
- VS Code: `add_licence_metadata.py` script

**Code:**
```python
#!/usr/bin/env python3
import palimpsest_pb2
import time

def create_palimpsest_metadata(creator_name, consent_contact):
    """Create Palimpsest licence metadata."""
    metadata = palimpsest_pb2.LicenceMetadata()
    metadata.version = "v0.4"

    # Creator info
    metadata.creator.name = creator_name
    metadata.creator.identifier = "github.com/jane-doe"
    metadata.creator.website = "https://janedoe.art"

    # Consent policy
    metadata.consent_policy.ai_training = palimpsest_pb2.ConsentRequirement.CONSENT_REQUIRED
    metadata.consent_policy.commercial_use = palimpsest_pb2.ConsentRequirement.CONSENT_GRANTED

    # Consent contact
    metadata.consent_contact = consent_contact

    # Timestamp
    metadata.timestamp = int(time.time())

    # Licence URL
    metadata.licence_url = "https://palimpsest.licence"

    return metadata

# Create metadata
meta = create_palimpsest_metadata("Jane Doe", "consent@janedoe.art")

# Serialise to binary
binary_metadata = meta.SerializeToString()

# Embed in file (example: as a comment block)
print(f"# Palimpsest Metadata (base64): {binary_metadata.hex()}")
```

**Voiceover:**
> "Here's a Python script that creates Palimpsest metadata."
>
> "We instantiate `LicenceMetadata`, fill in the fields—version, creator name, consent policy."
>
> "AI training: consent required. Commercial use: consent granted. This is fine-grained control."
>
> "Add the consent contact email and timestamp."
>
> "Then serialise to binary with `SerializeToString`. The output is compact—usually 50-100 bytes."
>
> "You can embed this in a file comment, HTTP header, EXIF metadata, or a sidecar `.palimpsest` file."
>
> "The key: It's machine-readable. Scrapers can parse it automatically."

**Screen:**
- Run script, show output (hex-encoded metadata)
- Demonstrate embedding in a file comment

**Timing:** 120 seconds (8:00-10:00)

---

### PART 3: HASKELL VALIDATORS (10:00-17:00 / 420 seconds)

#### Segment 3A: Why Haskell for Validation? (10:00-11:00)

**Screen:**
- Slide: "Why Haskell?"

**Voiceover:**
> "Next: Validation logic. Why Haskell?"
>
> "Three reasons:"
>
> "First: Type safety. Haskell's type system prevents entire classes of bugs. When validating legal consent, correctness is non-negotiable."
>
> "Second: Immutability. Haskell's pure functions make testing and reasoning easier. No side effects means predictable behaviour."
>
> "Third: Performance. Haskell compiles to fast native code. Validation must be low-latency for real-time scraping."
>
> "If you're not a Haskell developer, don't worry. We also provide validators in Python, Rust, and JavaScript. But Haskell is our reference implementation."

**Graphics:**
- Haskell logo
- Code snippet (simple, illustrative)

**Timing:** 60 seconds (10:00-11:00)

---

#### Segment 3B: Validator Architecture (11:00-13:00)

**Screen:**
- Architecture diagram: Validator components

**Components:**
1. **Metadata Parser:** Reads Protocol Buffer or JSON-LD
2. **Schema Validator:** Checks metadata structure
3. **Consent Checker:** Queries consent registry
4. **Result Formatter:** Returns decision (grant/deny/pending)

**Voiceover:**
> "The validator has four stages."
>
> "Stage 1: Parse metadata. Read Protocol Buffer binary or JSON-LD from a file, HTTP header, or database."
>
> "Stage 2: Validate schema. Ensure required fields are present, values are correct."
>
> "Stage 3: Check consent. Query the consent registry: Has the creator granted consent for this use case?"
>
> "Stage 4: Return result. Grant, deny, or pending. Include reason and audit trail."
>
> "Let's walk through a Haskell implementation."

**Graphics:**
- Flow diagram: Input → Parser → Validator → Checker → Output

**Timing:** 120 seconds (11:00-13:00)

---

#### Segment 3C: Haskell Code Walkthrough (13:00-16:00)

**Screen:**
- VS Code: `PalimpsestValidator.hs`

**Code:**
```haskell
{-# LANGUAGE OverloadedStrings #-}

module PalimpsestValidator
  ( validateLicence
  , ConsentDecision(..)
  ) where

import Data.Text (Text)
import Data.Time.Clock (UTCTime, getCurrentTime)
import qualified Data.ByteString as BS
import qualified Data.ProtoLens as PL
import Proto.Palimpsest (LicenceMetadata, ConsentRequirement(..))

-- | Consent decision result
data ConsentDecision
  = Granted   { reason :: Text, timestamp :: UTCTime }
  | Denied    { reason :: Text, timestamp :: UTCTime }
  | Pending   { reason :: Text, timestamp :: UTCTime }
  | Invalid   { reason :: Text, timestamp :: UTCTime }
  deriving (Show, Eq)

-- | Validate Palimpsest licence metadata
validateLicence
  :: BS.ByteString          -- ^ Serialised Protocol Buffer metadata
  -> IO ConsentDecision     -- ^ Consent decision
validateLicence metadataBytes = do
  now <- getCurrentTime

  case PL.decodeMessage metadataBytes of
    Left err -> pure $ Invalid
      { reason = "Invalid Protocol Buffer format: " <> err
      , timestamp = now
      }

    Right metadata -> validateParsedMetadata metadata now

-- | Validate parsed metadata
validateParsedMetadata
  :: LicenceMetadata
  -> UTCTime
  -> IO ConsentDecision
validateParsedMetadata meta now = do
  -- Check version
  if meta ^. #version /= "v0.4"
    then pure $ Invalid
      { reason = "Unsupported licence version"
      , timestamp = now
      }
    else do
      -- Check consent policy
      let aiTrainingPolicy = meta ^. #consentPolicy . #aiTraining

      case aiTrainingPolicy of
        CONSENT_GRANTED -> pure $ Granted
          { reason = "Creator has granted consent for AI training"
          , timestamp = now
          }

        CONSENT_DENIED -> pure $ Denied
          { reason = "Creator has denied consent for AI training"
          , timestamp = now
          }

        CONSENT_REQUIRED -> checkConsentRegistry meta now

        _ -> pure $ Pending
          { reason = "Consent requirement unspecified, defaulting to required"
          , timestamp = now
          }

-- | Query consent registry (stub—implement with HTTP call)
checkConsentRegistry
  :: LicenceMetadata
  -> UTCTime
  -> IO ConsentDecision
checkConsentRegistry meta now = do
  -- TODO: Make HTTP request to consent registry
  -- For now, return Pending
  pure $ Pending
    { reason = "Consent request must be submitted to registry"
    , timestamp = now
    }
```

**Voiceover:**
> "Here's the Haskell validator."
>
> "At the top: Data type `ConsentDecision`. Four constructors: Granted, Denied, Pending, Invalid. Each includes a reason and timestamp for audit trails."
>
> "Main function: `validateLicence`. Takes serialised Protocol Buffer metadata as a ByteString, returns an `IO ConsentDecision`."
>
> "Step 1: Parse the Protocol Buffer. If parsing fails, return `Invalid` with an error message."
>
> "Step 2: Validate the parsed metadata. Check the version—if it's not v0.4, return `Invalid`."
>
> "Step 3: Examine the consent policy. Specifically, `aiTraining` field."
>
> "If `CONSENT_GRANTED`: Return `Granted`. The creator allows AI training."
>
> "If `CONSENT_DENIED`: Return `Denied`. No AI training permitted."
>
> "If `CONSENT_REQUIRED`: Call `checkConsentRegistry`. This queries the registry to see if consent has been explicitly granted."
>
> "If unspecified: Default to `Pending`—consent is required but not yet granted."
>
> "The `checkConsentRegistry` function is a stub. In production, it makes an HTTP request to the consent registry API, passing the creator's identifier and the requester's details."
>
> "The registry responds: 'Consent granted on [date]' or 'No consent on record.'"
>
> "This validator is pure logic—no side effects except the registry query. It's testable, reliable, and fast."

**Screen:**
- Highlight each function as explained
- Step through code flow with arrows

**Timing:** 180 seconds (13:00-16:00)

---

#### Segment 3D: Running the Validator (16:00-17:00)

**Screen:**
- Terminal: Compile and run Haskell validator

**Commands:**
```bash
# Compile
ghc -O2 PalimpsestValidator.hs -o palimpsest-validator

# Run with sample metadata
./palimpsest-validator sample-metadata.pb

# Output:
# Denied: Creator has denied consent for AI training (2025-11-23T14:32:10Z)
```

**Voiceover:**
> "Compile with GHC, optimisations enabled."
>
> "Run the validator with sample metadata."
>
> "Output: 'Denied: Creator has denied consent for AI training,' with a timestamp."
>
> "This decision can be logged, audited, and enforced. If an AI scraper receives 'Denied,' it must not use the work."
>
> "The validator is also available as a REST API—we'll cover deployment later."

**Screen:**
- Show compilation, execution, output

**Timing:** 60 seconds (16:00-17:00)

---

### PART 4: RESCRIPT UI COMPONENTS (17:00-22:00 / 300 seconds)

#### Segment 4A: Why ReScript for the Frontend? (17:00-18:00)

**Screen:**
- Slide: "Why ReScript?"

**Voiceover:**
> "Now let's build the creator dashboard—the web UI where creators grant or deny consent."
>
> "We're using ReScript. Why?"
>
> "ReScript is a typed language that compiles to JavaScript. It combines the safety of Haskell with the ecosystem of React."
>
> "Type safety prevents UI bugs. Sound type system, zero runtime errors."
>
> "React interop is seamless. Use existing React components, libraries, and tools."
>
> "Fast compilation. ReScript compiles instantly—no slow TypeScript builds."
>
> "If you know TypeScript or Reason, ReScript will feel familiar."

**Graphics:**
- ReScript logo
- Comparison: TypeScript vs. ReScript (type safety, performance)

**Timing:** 60 seconds (17:00-18:00)

---

#### Segment 4B: Consent Request Component (18:00-20:30)

**Screen:**
- VS Code: `ConsentRequest.res` (ReScript file)

**Code:**
```rescript
// ConsentRequest.res
module ConsentRequest = {
  type consentStatus =
    | Pending
    | Granted
    | Denied

  type consentRequest = {
    id: string,
    requesterName: string,
    purpose: string,
    offerAmount: float,
    status: consentStatus,
  }

  @react.component
  let make = (~request: consentRequest, ~onGrant, ~onDeny) => {
    let statusBadge = switch request.status {
    | Pending => <span className="badge badge-warning"> {"Pending"->React.string} </span>
    | Granted => <span className="badge badge-success"> {"Granted"->React.string} </span>
    | Denied => <span className="badge badge-danger"> {"Denied"->React.string} </span>
    }

    <div className="consent-request-card">
      <h3> {request.requesterName->React.string} </h3>
      <p> <strong> {"Purpose: "->React.string} </strong> {request.purpose->React.string} </p>
      <p> <strong> {"Offer: "->React.string} </strong> {`£${Float.toString(request.offerAmount)}`->React.string} </p>
      {statusBadge}

      {switch request.status {
      | Pending =>
        <div className="action-buttons">
          <button onClick={_ => onGrant(request.id)} className="btn btn-success">
            {"Grant Consent"->React.string}
          </button>
          <button onClick={_ => onDeny(request.id)} className="btn btn-danger">
            {"Deny Consent"->React.string}
          </button>
        </div>
      | _ => React.null
      }}
    </div>
  }
}
```

**Voiceover:**
> "Here's a ReScript component for displaying consent requests."
>
> "First: Define types. `consentStatus` is a variant: Pending, Granted, or Denied."
>
> "`consentRequest` is a record with fields: ID, requester name, purpose, offer amount, and status."
>
> "The component takes a `request` prop and two callbacks: `onGrant` and `onDeny`."
>
> "We render the requester's name, purpose, and offer amount. Then a status badge—colour-coded: yellow for pending, green for granted, red for denied."
>
> "If the status is Pending, show action buttons: 'Grant Consent' and 'Deny Consent.' When clicked, they call the callbacks."
>
> "If status is already Granted or Denied, no buttons—just show the status."
>
> "This is type-safe. If I try to access a field that doesn't exist, the compiler catches it. If I forget to handle a status variant, the compiler warns me."
>
> "Pattern matching on `consentStatus` is exhaustive—no missing cases."

**Screen:**
- Highlight type definitions
- Show component render logic
- Point out pattern matching

**Timing:** 150 seconds (18:00-20:30)

---

#### Segment 4C: Integrating with API (20:30-22:00)

**Screen:**
- VS Code: `ConsentAPI.res` (API integration)

**Code:**
```rescript
// ConsentAPI.res
module ConsentAPI = {
  type apiResponse =
    | Success(string)
    | Error(string)

  let grantConsent = async (requestId: string): apiResponse => {
    try {
      let response = await Fetch.fetch(
        `https://api.palimpsest.licence/v1/consent/${requestId}/grant`,
        {
          method: #POST,
          headers: {"Content-Type": "application/json"},
          body: Js.Json.stringify({"status": "granted"}),
        }
      )

      if response.ok {
        Success("Consent granted successfully")
      } else {
        Error("Failed to grant consent")
      }
    } catch {
    | _ => Error("Network error")
    }
  }

  let denyConsent = async (requestId: string): apiResponse => {
    try {
      let response = await Fetch.fetch(
        `https://api.palimpsest.licence/v1/consent/${requestId}/deny`,
        {
          method: #POST,
          headers: {"Content-Type": "application/json"},
          body: Js.Json.stringify({"status": "denied"}),
        }
      )

      if response.ok {
        Success("Consent denied successfully")
      } else {
        Error("Failed to deny consent")
      }
    } catch {
    | _ => Error("Network error")
    }
  }
}
```

**Voiceover:**
> "To handle consent decisions, we call the Palimpsest API."
>
> "The `ConsentAPI` module has two functions: `grantConsent` and `denyConsent`. Both are async."
>
> "`grantConsent` makes a POST request to `/v1/consent/{id}/grant`. If successful, returns `Success`. If it fails, returns `Error`."
>
> "Same for `denyConsent`—POST to `/v1/consent/{id}/deny`."
>
> "Error handling is explicit. Network errors, HTTP errors—all caught and returned as `Error` variants."
>
> "In the UI component, we call these functions when the user clicks 'Grant' or 'Deny.'"
>
> "The type system ensures we handle both success and error cases. No forgotten error handling."

**Screen:**
- Show API call structure
- Highlight error handling

**Timing:** 90 seconds (20:30-22:00)

---

### PART 5: CI/CD INTEGRATION (22:00-26:00 / 240 seconds)

#### Segment 5A: Why CI/CD Matters for Palimpsest (22:00-23:00)

**Screen:**
- Diagram: CI/CD pipeline with Palimpsest check

**Voiceover:**
> "Let's talk CI/CD integration. Why does this matter?"
>
> "Many developers use datasets for testing—training small ML models, running benchmarks, building search indices."
>
> "If those datasets contain Palimpsest-licensed works, your CI pipeline should check consent before using them."
>
> "Example: You're building an open-source code search tool. Your test suite indexes GitHub repos. Some are Palimpsest-licensed."
>
> "Your CI pipeline should:"
>
> "One: Detect Palimpsest licences in the dataset."
>
> "Two: Check if consent has been granted for indexing."
>
> "Three: Fail the build if consent is missing."
>
> "This ensures your project respects creator rights automatically."

**Graphics:**
- CI pipeline flowchart: Build → Test → **Licence Check** → Deploy

**Timing:** 60 seconds (22:00-23:00)

---

#### Segment 5B: GitHub Actions Example (23:00-25:00)

**Screen:**
- VS Code: `.github/workflows/palimpsest-check.yml`

**Code:**
```yaml
name: Palimpsest Licence Check

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  licence-check:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Install Palimpsest CLI
        run: |
          curl -L https://palimpsest.licence/cli/install.sh | sh
          echo "$HOME/.palimpsest/bin" >> $GITHUB_PATH

      - name: Scan repository for Palimpsest licences
        id: scan
        run: |
          palimpsest scan --format json > scan-results.json
          cat scan-results.json

      - name: Check consent status
        run: |
          palimpsest validate scan-results.json --fail-on-denied
        env:
          PALIMPSEST_API_KEY: ${{ secrets.PALIMPSEST_API_KEY }}

      - name: Upload scan results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: palimpsest-scan-results
          path: scan-results.json
```

**Voiceover:**
> "Here's a GitHub Actions workflow that checks Palimpsest licences."
>
> "Step 1: Checkout code. Standard."
>
> "Step 2: Install the Palimpsest CLI. We provide a one-line installer."
>
> "Step 3: Scan the repository. The `palimpsest scan` command finds all Palimpsest-licensed files and outputs a JSON report."
>
> "Step 4: Validate consent status. The `palimpsest validate` command checks the consent registry. If any file is denied consent, the build fails."
>
> "We pass an API key via secrets for authentication."
>
> "Step 5: Upload scan results as an artefact. Even if the build fails, you can see which files were flagged."
>
> "This workflow runs on every push and pull request. If a contributor adds a Palimpsest-licensed file without consent, the CI fails—preventing unauthorised use."

**Screen:**
- Highlight each step in YAML
- Show example CI run (passing and failing builds)

**Timing:** 120 seconds (23:00-25:00)

---

#### Segment 5C: Integration Libraries (25:00-26:00)

**Screen:**
- Terminal: Python integration example

**Code:**
```python
# Python SDK example
from palimpsest import Validator

validator = Validator(api_key="your-api-key")

# Check a file
result = validator.check_file("path/to/file.py")

if result.consent_status == "denied":
    print(f"ERROR: {result.reason}")
    exit(1)
elif result.consent_status == "pending":
    print(f"WARNING: Consent pending for {result.creator}")
else:
    print("OK: Consent granted or not required")
```

**Voiceover:**
> "We provide integration libraries for Python, JavaScript, and Rust."
>
> "Here's Python. Install the `palimpsest` package, create a `Validator`, and check files."
>
> "The validator returns a result with consent status: granted, denied, or pending."
>
> "You can integrate this into your data pipeline, scraper, or build process."
>
> "Same pattern in JavaScript and Rust—consistent API across languages."

**Screen:**
- Show package installation, code execution, output

**Timing:** 60 seconds (25:00-26:00)

---

### PART 6: PRODUCTION DEPLOYMENT & BEST PRACTICES (26:00-29:00 / 180 seconds)

#### Segment 6A: Deploying Consent Registry (26:00-27:30)

**Screen:**
- Architecture diagram: Production deployment

**Voiceover:**
> "Finally, let's talk production deployment."
>
> "The Palimpsest Consent Registry is a critical service. You can use the public instance at `api.palimpsest.licence`, or deploy your own."
>
> "Recommended stack:"
>
> "API: REST/GraphQL server (Node.js, Go, or Rust)"
>
> "Database: PostgreSQL for relational data (creators, consent grants, audit logs)"
>
> "Cache: Redis for low-latency consent lookups"
>
> "Authentication: OAuth 2.0 for creator accounts, API keys for scrapers"
>
> "Hosting: Cloud provider (AWS, GCP, Azure) with auto-scaling"
>
> "Monitoring: Prometheus + Grafana for metrics, Sentry for error tracking"
>
> "Deployment:"
>
> "One: Containerise with Docker."
>
> "Two: Orchestrate with Kubernetes or Docker Compose."
>
> "Three: Set up CI/CD for automated deployments (GitHub Actions, GitLab CI)."
>
> "Four: Enable HTTPS with Let's Encrypt."
>
> "Five: Implement rate limiting to prevent abuse."
>
> "The reference implementation is open source on GitHub."

**Graphics:**
- Deployment architecture diagram (load balancer → API servers → DB + cache)
- Tech stack logos (Docker, Kubernetes, PostgreSQL, Redis)

**Timing:** 90 seconds (26:00-27:30)

---

#### Segment 6B: Best Practices (27:30-29:00)

**Screen:**
- Slide: Best Practices checklist

**Voiceover:**
> "Key best practices:"
>
> "One: Version your metadata schema. Use Protocol Buffers' versioning. Never break backward compatibility."
>
> "Two: Validate on both client and server. Don't trust user input—validate metadata before accepting it."
>
> "Three: Audit everything. Log all consent grants, denials, and requests. Creators need audit trails."
>
> "Four: Rate-limit consent checks. AI scrapers might query millions of times per day. Implement caching and rate limits."
>
> "Five: Provide SDKs in multiple languages. Lower the barrier for integration."
>
> "Six: Document extensively. Developers need clear docs, examples, and troubleshooting guides."
>
> "Seven: Test rigorously. Licences are legal documents—bugs could have serious consequences."
>
> "Eight: Engage the community. Open source the tooling. Accept contributions. Build trust."

**Graphics:**
- Checklist appears item by item
- Checkmarks for emphasis

**Timing:** 90 seconds (27:30-29:00)

---

### CLOSING (29:00-30:00 / 60 seconds)

**Screen:**
- Summary slide: Key Takeaways

**Voiceover:**
> "Let's recap."
>
> "We covered the full Palimpsest technical stack:"
>
> "Protocol Buffers for metadata—typed, compact, versioned."
>
> "Haskell validators for correctness—pure, reliable, fast."
>
> "ReScript UI for creator dashboards—type-safe React."
>
> "CI/CD integration—automated consent checks in your pipeline."
>
> "Production deployment—scalable, secure, auditable."
>
> "All of this is open source. Visit github.com/palimpsest-licence to explore the code, contribute, or deploy your own instance."
>
> "If you're building AI tools, platforms, or scrapers—integrate Palimpsest. It's the right thing to do, and it's technically straightforward."
>
> "Questions? Join our Discord, open GitHub issues, or email dev@palimpsest.licence."
>
> "Thank you for diving deep with me. Let's build ethical AI infrastructure together."

**Graphics:**
- GitHub repo link
- Discord invite
- Email contact
- Final text: "Build Ethically. Respect Creators."

**Timing:** 60 seconds (29:00-30:00)

---

## Production Notes

### Code Repositories to Prepare

**GitHub Repos (Public):**
1. `palimpsest-protocol` - Protocol Buffer schemas
2. `palimpsest-validator-haskell` - Haskell validation library
3. `palimpsest-ui-rescript` - ReScript UI components
4. `palimpsest-sdk-python` - Python integration SDK
5. `palimpsest-sdk-javascript` - JavaScript integration SDK
6. `palimpsest-sdk-rust` - Rust integration SDK
7. `palimpsest-ci-actions` - GitHub Actions and CI/CD examples

**Each repo should include:**
- README with installation, usage, examples
- Comprehensive test suite
- CI/CD pipeline (GitHub Actions)
- API documentation (generated from code comments)
- Licence: Apache 2.0 or MIT (permissive for tooling)

---

### Accessibility

**Subtitles:**
- Code snippets included in captions (with monospace formatting if platform supports)
- Technical terms spelled out (e.g., "API" as "A-P-I" in audio description)

**Audio Description:**
- Describe diagrams ("A flowchart shows three components: metadata parser, validator, and consent checker, connected by arrows from left to right.")
- Describe code structure ("The function signature on line 12 shows...")

---

### Follow-Up Content

**Based on viewer feedback, create:**
1. **"Palimpsest CLI Deep Dive" (20 min):** Command-line tools for creators and developers
2. **"Building a Scraper with Palimpsest Checks" (25 min):** Practical integration for AI companies
3. **"Palimpsest Security Audit" (15 min):** Threat modeling, attack vectors, mitigations
4. **"Contributing to Palimpsest" (10 min):** How to contribute code, docs, translations

---

**Document Version:** 1.0
**Last Updated:** 2025-11-23
**Author:** Palimpsest Technical Team
**Licence:** CC BY 4.0

---

**Ready for Technical Deep Dive. Let's build the infrastructure for consent-layer licensing.**
