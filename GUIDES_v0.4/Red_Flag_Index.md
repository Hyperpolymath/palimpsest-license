# Palimpsest License v0.4 — Red Flag Index

## Common Violations and How to Avoid Them

This index helps identify, understand, and prevent common violations of the Palimpsest License. It's organised by violation type with examples, detection methods, and remediation strategies.

---

## Table of Contents

1. [Using This Index](#using-this-index)
2. [Critical Violations (License-Breaking)](#critical-violations-license-breaking)
3. [Major Violations (Significant Breach)](#major-violations-significant-breach)
4. [Minor Violations (Compliance Issues)](#minor-violations-compliance-issues)
5. [Edge Cases and Grey Areas](#edge-cases-and-grey-areas)
6. [AI-Specific Red Flags](#ai-specific-red-flags)
7. [Cultural Appropriation Red Flags](#cultural-appropriation-red-flags)
8. [Metadata and Attribution Red Flags](#metadata-and-attribution-red-flags)
9. [Platform-Specific Red Flags](#platform-specific-red-flags)
10. [Detection and Prevention Strategies](#detection-and-prevention-strategies)

---

## Using This Index

### Severity Levels

🔴 **Critical**: License-terminating violations that require immediate cessation
🟠 **Major**: Significant breaches requiring prompt remediation
🟡 **Minor**: Compliance issues that should be corrected but don't terminate rights
⚪ **Edge Case**: Ambiguous situations requiring creator consultation

### How to Read Entries

Each red flag includes:
- **Description**: What the violation is
- **Example**: Real-world scenario
- **Why It's a Problem**: Legal and ethical implications
- **Detection**: How to identify this violation
- **Remediation**: How to fix it
- **Prevention**: How to avoid it in the first place

---

## Critical Violations (License-Breaking)

### 🔴 RF-001: Unauthorised Interpretive AI Training

**Description**: Using Palimpsest-licensed works to train interpretive AI systems without explicit written consent.

**Example**:
```
A tech company scrapes creative writing from a website licensed under Palimpsest
and includes it in their LLM training dataset without checking permissions or
contacting creators.
```

**Why It's a Problem**:
- Violates Clause 1.2 (Non-Interpretive systems require consent)
- Undermines core purpose of the license
- May enable AI to reproduce cultural/emotional context without attribution
- Potentially creates derivative works without permission

**Detection**:
- Check if your work appears in training dataset disclosures
- Use tools like "Have I Been Trained?" (for images)
- Monitor for AI outputs that suspiciously resemble your work
- Check `.palimpsest.json` for `permissions.interpretiveAI: false`

**Remediation**:
1. Immediately cease training on the work
2. Remove work from existing datasets
3. Retrain models without the infringing content (or provide attribution mechanism)
4. Contact creator to request consent (may require licensing fee)
5. Provide compensation for past unauthorised use

**Prevention**:
- Always check `permissions.interpretiveAI` before including in datasets
- Implement automated license filtering in data pipelines
- Maintain dataset provenance documentation
- Create consent tracking database
- When in doubt, contact the creator

---

### 🔴 RF-002: Complete Metadata Stripping

**Description**: Removing all attribution and metadata from a work, making it impossible to trace back to the original creator.

**Example**:
```
A platform downloads Palimpsest-licensed images, strips EXIF data and watermarks,
and redistributes them with no attribution or license information.
```

**Why It's a Problem**:
- Violates Clause 2.3 (Metadata Preservation)
- Erases emotional and cultural lineage
- Makes it impossible for others to comply with attribution requirements
- May constitute wilful infringement

**Detection**:
- Compare original file metadata to redistributed version
- Check if `.palimpsest.json` is missing from derivatives
- Look for EXIF/XMP/ID3 tag removal
- Verify attribution information is absent

**Remediation**:
1. Stop distributing the stripped version immediately
2. Restore full metadata from original source
3. Re-add attribution information prominently
4. Issue correction notice explaining the error
5. Contact creator to apologise and confirm restoration

**Prevention**:
- Configure build tools to preserve metadata (e.g., `exiftool -TagsFromFile`)
- Include metadata files explicitly in distribution manifests
- Add CI/CD checks to verify metadata presence
- Document metadata preservation requirements for team
- Test that metadata survives all transformation steps

---

### 🔴 RF-003: Misrepresentation of Cultural Origin

**Description**: Falsely claiming a work has no cultural context, or attributing it to a different cultural origin.

**Example**:
```
A game developer uses music from the Maori diaspora (licensed under Palimpsest
with documented cultural context) and credits it as "generic tribal music" in
their game, erasing the specific cultural origin.
```

**Why It's a Problem**:
- Violates Clause 5 (Symbolic Integrity)
- Constitutes cultural appropriation
- Harms the represented community
- Undermines the license's purpose of protecting cultural narratives

**Detection**:
- Compare attribution to original metadata emotional lineage
- Check if cultural context has been genericised or erased
- Look for vague terms like "tribal," "ethnic," "exotic" replacing specific cultural references
- Verify cultural elements are accurately credited

**Remediation**:
1. Immediately correct all attribution to reflect accurate cultural origin
2. Add full cultural context from original metadata
3. Public acknowledgement of the error
4. Consult with affected cultural community
5. Consider additional actions (donations, educational content) as appropriate

**Prevention**:
- Always include full `emotionalLineage.culturalOrigins` in attribution
- Train team on cultural sensitivity and appropriation
- Create attribution templates that preserve cultural context
- Review all credits with cultural competency consultant
- When unsure about cultural context, consult the creator

---

### 🔴 RF-004: Commercial Exploitation Without Attribution

**Description**: Using Palimpsest-licensed works in commercial products without any attribution whatsoever.

**Example**:
```
A streaming service includes a Palimpsest-licensed documentary soundtrack in
their platform's ambient music without crediting the composer, title, or license.
```

**Why It's a Problem**:
- Violates basic attribution requirements
- Denies creator economic recognition
- May confuse others about the work's licensing
- Potentially fraudulent (claiming others' work as your own)

**Remediation**:
1. Add full attribution immediately
2. Contact creator to acknowledge the violation
3. Offer compensation for the period of non-attribution
4. Issue public correction if work was widely distributed
5. Implement attribution verification process

**Prevention**:
- Create attribution checklist for all commercial products
- Require legal review before commercial release
- Implement automated attribution verification
- Train team on attribution requirements
- Build attribution into product from the start (not as afterthought)

---

## Major Violations (Significant Breach)

### 🟠 RF-005: Incomplete Attribution

**Description**: Providing attribution but omitting critical elements (creator name, license, cultural context).

**Example**:
```
A website credits: "Licensed under Palimpsest" but omits:
- Creator's name
- Work title
- Link to license
- Cultural context
```

**Why It's a Problem**:
- Fails minimum attribution requirements
- Doesn't allow users to understand cultural context
- Makes it difficult to contact creator for permissions
- Undermines traceability

**Detection**:
- Check if attribution includes all required elements:
  - [ ] Creator's name
  - [ ] Work title
  - [ ] License name and version
  - [ ] Link to license (digital) or full text (physical)
  - [ ] Cultural context (if provided by creator)

**Remediation**:
1. Immediately update attribution to include all elements
2. If already published widely, issue update/erratum
3. Verify all instances of the work have complete attribution

**Prevention**:
- Use attribution templates from User Guide
- Create attribution checklist
- Automate attribution generation from `.palimpsest.json`
- Review all public-facing attributions before launch

---

### 🟠 RF-006: Ignoring Non-Interpretive AI Restrictions

**Description**: Assuming all AI use is permitted without checking `permissions.nonInterpretiveAI`.

**Example**:
```
A developer uses Palimpsest-licensed text in a translation tool without checking
permissions. The creator has set `nonInterpretiveAI: false` because the work
contains sacred or sensitive content that should not be machine-processed.
```

**Why It's a Problem**:
- Violates creator's explicit permissions
- May expose sensitive content to inappropriate processing
- Shows lack of due diligence
- Erodes trust in the license

**Detection**:
- Check `.palimpsest.json` for `permissions.nonInterpretiveAI`
- Verify AI tools used respect permission flags
- Look for creator's stated AI preferences

**Remediation**:
1. Stop non-interpretive AI processing immediately
2. Contact creator to explain the error and request permission
3. If permission denied, remove from AI systems
4. Document consent if permission granted

**Prevention**:
- Always check both `interpretiveAI` AND `nonInterpretiveAI` permissions
- Don't assume permission based on AI type
- Implement permission checks in automated systems
- Create consent verification workflow

---

### 🟠 RF-007: Derivative Works Without Cultural Context

**Description**: Creating adaptations that remove or dilute the original's cultural and emotional context.

**Example**:
```
A theatre company adapts a Palimpsest-licensed play about refugee experiences.
The adaptation removes all specific cultural references, genericising the story
into a "universal" narrative about "people facing hardship."
```

**Why It's a Problem**:
- Violates Clause 6 (Emotional Lineage)
- Erases specific cultural experiences
- May constitute cultural appropriation
- Defeats the purpose of the license's cultural protections

**Detection**:
- Compare derivative to original's `emotionalLineage`
- Check if specific cultural references have been removed
- Look for genericisation of culturally specific elements
- Verify symbolic elements are preserved

**Remediation**:
1. Restore original cultural context to adaptation
2. Add creator's notes about cultural significance
3. Consult with communities represented in original work
4. If restoration impossible, discontinue derivative
5. Public acknowledgement of the error

**Prevention**:
- Study original work's cultural context before adapting
- Consult with cultural communities represented
- Preserve `emotionalLineage` in derivative metadata
- Add notes explaining how derivative honours original context
- When unsure, ask the original creator

---

### 🟠 RF-008: Sublicensing Under Incompatible Terms

**Description**: Attempting to relicense Palimpsest works under terms that contradict or dilute original protections.

**Example**:
```
A publisher compiles Palimpsest-licensed essays into an anthology and licenses
the anthology under CC0 (public domain), effectively stripping all protections
from the individual essays.
```

**Why It's a Problem**:
- Violates license terms (sublicensing restrictions)
- Undermines creator's chosen protections
- Creates confusion about applicable license
- May expose works to uses creator explicitly prohibited

**Detection**:
- Check if compilation/anthology license contradicts component licenses
- Verify each work's individual license is preserved
- Look for attempts to "override" Palimpsest with more permissive terms

**Remediation**:
1. Correct compilation license to respect component licenses
2. Clearly mark each work with its individual license
3. Update distribution to include per-work metadata
4. Issue correction notice for already-distributed copies

**Prevention**:
- Use dual-licensing for compilations: "Compilation as a whole: [license], individual works: [their respective licenses]"
- Preserve each work's metadata in compilations
- Don't attempt to homogenise licenses across disparate works
- Consult IP lawyer for complex licensing scenarios

---

## Minor Violations (Compliance Issues)

### 🟡 RF-009: Outdated License Version

**Description**: Continuing to use or reference an outdated version of the license when a new version exists.

**Example**:
```
A project licensed under Palimpsest v0.3 hasn't updated to v0.4, and is missing
new protections around AI training that would benefit the creator.
```

**Why It's a Problem**:
- May lack important new protections
- Can cause confusion about applicable terms
- Misses improvements in license clarity
- May not interoperate with newer Palimpsest works

**Detection**:
- Check current license version against latest release
- Review changelog for breaking changes
- Verify SPDX identifier reflects current version

**Remediation**:
1. Review v0.4 license terms
2. Update LICENSE file and SPDX identifiers
3. Update `.palimpsest.json` version field
4. Notify users of license update
5. Consider dual-licensing during transition period

**Prevention**:
- Subscribe to Palimpsest license updates
- Review license annually
- Set calendar reminder to check for updates
- Follow Palimpsest repository for announcements

---

### 🟡 RF-010: Missing SPDX Identifiers

**Description**: Omitting SPDX license identifiers from source files.

**Example**:
```
A software project has LICENSE file but no headers in individual source files,
making it unclear which files are covered by the license.
```

**Why It's a Problem**:
- Reduces clarity about license coverage
- Makes it harder for automated tools to detect license
- May cause confusion if files are distributed separately
- Not compliant with best practices

**Detection**:
- Run automated check: `find src -name "*.py" -exec grep -L "SPDX-License-Identifier" {} \;`
- Review source files for license headers
- Check CI/CD for SPDX verification

**Remediation**:
1. Add SPDX headers to all source files
2. Create template for new files
3. Add pre-commit hook to enforce headers

**Prevention**:
- Use code templates with SPDX headers
- Add to coding standards documentation
- Implement automated SPDX header checking in CI
- Include in code review checklist

---

### 🟡 RF-011: Broken License Links

**Description**: Attribution includes links to license that are dead, moved, or incorrect.

**Example**:
```
Attribution reads: "Licensed under Palimpsest v0.4: https://old-domain.com/license"
but old-domain.com no longer exists.
```

**Why It's a Problem**:
- Users can't verify license terms
- Undermines transparency
- May appear as attempt to hide license
- Reduces trust

**Detection**:
- Test all license links periodically
- Check for 404 errors
- Verify links point to correct license version

**Remediation**:
1. Update links to current canonical URL
2. Use persistent identifiers when possible
3. Include fallback URLs or full text
4. Issue correction for widely distributed works

**Prevention**:
- Use official Palimpsest URLs
- Include full license text as backup
- Periodically audit all license links
- Use URL monitoring tools

---

## Edge Cases and Grey Areas

### ⚪ EDGE-001: AI-Assisted Creation (Not Training)

**Description**: Using AI tools to help create work that will be licensed under Palimpsest.

**Example**:
```
A writer uses GPT-4 to help brainstorm ideas and refine drafts for a poem they
want to license under Palimpsest. Is this permitted? How should it be disclosed?
```

**Guidance**:
- **Permitted**: Using AI as a creative tool (like spell check, thesaurus)
- **Required**: Disclose AI involvement in metadata
- **Key distinction**: You maintain creative control; AI is tool, not author
- **Attribution**: Credit AI tool and describe its role

**Example metadata**:
```json
{
  "aiDisclosure": {
    "toolsUsed": ["GPT-4"],
    "role": "Brainstorming and draft refinement",
    "creativeControl": "Human (author name)",
    "finalDecisions": "100% human"
  }
}
```

**When in doubt**: Contact Palimpsest Stewardship Council for guidance.

---

### ⚪ EDGE-002: Search Engine Indexing

**Description**: Is Google indexing Palimpsest-licensed web content a violation of AI restrictions?

**Guidance**:
- **Not a violation** if: Indexing for search/retrieval (non-interpretive)
- **Potential violation** if: Using indexed content for generative AI training
- **Grey area**: Google's AI features (summaries, suggested text)

**Recommended approach**:
- Allow non-interpretive indexing (search, accessibility)
- Use `robots.txt` to block specific AI crawlers if desired:
  ```
  User-agent: GPTBot
  Disallow: /

  User-agent: ChatGPT-User
  Disallow: /
  ```
- Include AI permissions in meta tags:
  ```html
  <meta name="palimpsest:permissions.interpretiveAI" content="false">
  ```

**When in doubt**: Contact search engine directly about their AI use policies.

---

### ⚪ EDGE-003: Cultural Context Ambiguity

**Description**: Uncertainty about what counts as "cultural context" worth preserving.

**Example**:
```
A developer creates a small utility script and licenses it under Palimpsest.
Is there meaningful "cultural context" for a technical script? Or is this
license overkill?
```

**Guidance**:
- **Palimpsest is best suited for**: Works with emotional, cultural, or narrative weight
- **May be overkill for**: Purely functional code with no cultural significance
- **Consider instead**: MIT, Apache, GPL for purely technical works
- **Appropriate if**: Even technical work has meaningful context (e.g., accessibility tool created by disabled developer to serve their community)

**Questions to ask**:
- Does this work carry emotional or cultural meaning beyond its function?
- Is there a community or tradition this represents?
- Would I be hurt if someone stripped context and claimed it as generic?

If all answers are "no," consider a simpler license. Palimpsest's power is in protecting meaning, not just code.

---

### ⚪ EDGE-004: Parody and Critique

**Description**: Creating parodies or critical works based on Palimpsest-licensed content.

**Example**:
```
A satirist wants to create a parody of a Palimpsest-licensed political artwork.
Does this violate the license, or is it fair use/fair dealing?
```

**Guidance**:
- **Likely permitted**: Genuine parody and critique are often protected by fair use/fair dealing
- **Still required**: Acknowledge the original work and its cultural context
- **Don't**: Strip cultural context to make parody easier
- **Do**: Engage with the work's cultural meaning, even critically

**Palimpsest-compatible parody**:
- Credits original work and creator
- Acknowledges cultural context
- Engages critically with that context (doesn't erase it)
- Clearly marked as parody/critique

**Not compatible**:
- Stripping cultural context to mock generic version
- Misrepresenting original's cultural origin
- Using parody as excuse to violate license

**When in doubt**: Consult with IP lawyer about fair use/fair dealing in your jurisdiction.

---

## AI-Specific Red Flags

### 🔴 AI-001: Training Dataset Laundering

**Description**: Using intermediary steps to obscure that Palimpsest-licensed works are in training data.

**Example**:
```
An AI company creates "summaries" of Palimpsest-licensed works, then claims
they're training on summaries (not original works), circumventing consent requirements.
```

**Why It's a Problem**:
- Deliberately evades license restrictions
- May constitute wilful infringement
- Undermines entire licensing framework
- Bad faith interpretation of terms

**Detection**:
- Audit training dataset provenance
- Check for derivative works of Palimpsest content
- Look for suspiciously similar "paraphrased" versions

**Remediation**:
- Remove all derivatives of Palimpsest works from training
- Retrain models without laundered content
- Potential legal liability for wilful infringement

**Prevention**:
- Maintain clear dataset provenance
- Don't use "tricks" to avoid license compliance
- When unsure, get legal advice
- Respect intent of license, not just letter

---

### 🟠 AI-002: Inadequate Source Attribution in AI Outputs

**Description**: AI system generates content based on Palimpsest training data but provides no source attribution.

**Example**:
```
An LLM trained (with consent) on Palimpsest-licensed poetry generates new poems
but doesn't credit the training sources or preserve cultural context.
```

**Why It's a Problem**:
- Violates attribution requirements
- Erases cultural lineage from AI outputs
- Users don't know generated content draws from protected works
- May enable downstream violations

**Detection**:
- Check if AI outputs include source attributions
- Verify cultural context from training data preserved
- Look for mechanism to trace outputs to training sources

**Remediation**:
1. Add attribution mechanism to AI outputs
2. Include source credits in generated content metadata
3. Provide way for users to query training sources
4. Preserve cultural context in output metadata

**Prevention**:
- Design attribution system from the start
- Store training data metadata with models
- Include attribution in generated output structure
- Make traceability a core feature, not afterthought

---

### 🟠 AI-003: Ambiguous "Fine-Tuning" Claims

**Description**: Claiming that fine-tuning on Palimpsest works is different from training and doesn't require consent.

**Example**:
```
A company fine-tunes GPT-4 on a corpus of Palimpsest-licensed creative writing,
arguing this isn't "training" so consent isn't required.
```

**Guidance**:
- **Fine-tuning is training**: Requires same consent as initial training
- **No loopholes**: Intent of license is to control interpretive AI use
- **Interpretive AI** includes: Training, fine-tuning, RLHF, prompt engineering with examples, any learning from content

**Prevention**:
- Treat fine-tuning same as training
- Request consent for any AI learning from Palimpsest works
- Don't look for technicalities to avoid compliance

---

## Cultural Appropriation Red Flags

### 🔴 CA-001: Decontextualisation for Commercial Use

**Description**: Removing cultural context from work to make it more "marketable" or "universal."

**Example**:
```
A publisher wants to use a Palimpsest-licensed story from the Indigenous Australian
community but asks the author to remove specific cultural references to appeal to
a "broader audience."
```

**Why It's a Problem**:
- Violates Clause 5 (Symbolic Integrity) and Clause 6 (Emotional Lineage)
- Cultural appropriation/erasure
- Commodifies culture while erasing its source
- Harms represented communities

**Detection**:
- Compare published version to original cultural context
- Look for pressure on creators to "tone down" cultural specificity
- Check if marketing erases cultural origins

**Remediation**:
- Restore full cultural context
- Public acknowledgement of error
- Consult with affected cultural communities
- Consider whether commercial use is appropriate at all

**Prevention**:
- Respect cultural context as integral, not optional
- Don't treat cultural specificity as "niche"
- Market works with their full cultural richness
- Educate audiences rather than diluting content

---

### 🟠 CA-002: False Equivalence of Cultural Contexts

**Description**: Treating all cultural contexts as interchangeable or equivalent.

**Example**:
```
A streaming platform creates a "World Music" category that lumps together
Palimpsest-licensed works from Māori, Sami, Quechua, and Irish traditions,
treating them as generically "ethnic" rather than distinct cultures.
```

**Why It's a Problem**:
- Erases specific cultural identities
- Creates false equivalences
- Fails to honour distinct cultural origins
- Reduces cultures to aesthetic category

**Detection**:
- Check if works from different cultures are genericised
- Look for vague categorisation (e.g., "tribal," "ethnic," "world")
- Verify specific cultural origins are preserved

**Remediation**:
- Separate works by specific cultural origin
- Use specific names (Māori, Sami, Quechua, Irish)
- Include cultural context in descriptions
- Consult with cultural communities about appropriate categorisation

**Prevention**:
- Treat each cultural context as distinct
- Use specific cultural identifiers
- Avoid generic "diversity" categories
- Let cultural communities define their own categories

---

### 🟡 CA-003: Symbolic Appropriation in Derivatives

**Description**: Using culturally significant symbols from original work in derivatives without understanding or honouring their meaning.

**Example**:
```
A game designer uses a sacred symbol from a Palimpsest-licensed artwork as a
generic "power-up" icon without understanding its cultural significance or
crediting its origin.
```

**Why It's a Problem**:
- Trivialises sacred or culturally significant symbols
- Disrespects represented cultures
- May cause harm to communities
- Violates emotional lineage requirements

**Detection**:
- Check if symbolic elements are used appropriately in derivatives
- Verify cultural significance is understood and respected
- Look for trivialisation of sacred or significant symbols

**Remediation**:
- Remove inappropriately used symbols, or
- Add full cultural context and obtain community consent
- Consult with cultural communities
- Provide education about symbol's significance

**Prevention**:
- Research cultural significance before using symbols
- Consult with cultural communities
- Include symbol meanings in derivative metadata
- When in doubt, don't use culturally significant symbols decoratively

---

## Metadata and Attribution Red Flags

### 🟠 META-001: Attribution Buried in Inaccessible Locations

**Description**: Providing attribution but making it extremely difficult for users to find.

**Example**:
```
A website includes full attribution... in white text on white background at the
bottom of a 500-page document that only appears after clicking through 5 menus.
```

**Why It's a Problem**:
- Technically complies but violates spirit of license
- Users unlikely to see attribution
- Effectively erases creator recognition
- Bad faith compliance

**Detection**:
- Test how many clicks to reach attribution
- Check if attribution is visually obscured
- Verify attribution is in logical, expected location

**Remediation**:
- Move attribution to prominent, accessible location
- Make attribution easily findable (e.g., main Credits page, footer)
- Ensure attribution is visually readable

**Prevention**:
- Put attribution in standard locations (Credits, About, Footer)
- Make attribution visible without scrolling/clicking
- Test with actual users to ensure findability

---

### 🟡 META-002: JSON Metadata Errors

**Description**: Malformed or invalid `.palimpsest.json` metadata.

**Example**:
```json
{
  "author": "Jane Doe"
  "license": "Palimpsest-0.4"  // Missing comma!
  "emotionalLineage": {
    "intent": Broken string format
  }
}
```

**Why It's a Problem**:
- Automated tools can't parse metadata
- Breaks machine-readable compliance checking
- May cause metadata to be ignored entirely

**Detection**:
- Run `python -m json.tool .palimpsest.json`
- Use JSON validator
- Check CI/CD validation

**Remediation**:
- Fix JSON syntax errors
- Validate with schema
- Test parsing with multiple tools

**Prevention**:
- Use JSON-aware editor with validation
- Add JSON linting to pre-commit hooks
- Include metadata validation in CI/CD

---

### 🟡 META-003: Metadata Lost in Transformations

**Description**: Converting works between formats strips metadata.

**Example**:
```
Converting a JPEG with XMP metadata to PNG strips all embedded attribution,
leaving no trace of the Palimpsest license or cultural context.
```

**Why It's a Problem**:
- Downstream users don't know work is licensed
- Attribution and context lost
- Violates metadata preservation requirement

**Detection**:
- Compare metadata before and after transformation
- Use `exiftool` to verify metadata preservation
- Test all conversion tools for metadata handling

**Remediation**:
- Re-add metadata to converted files
- Use metadata-preserving conversion tools
- Create sidecar metadata files if embedding not possible

**Prevention**:
- Test conversion workflows for metadata preservation
- Use tools like `exiftool -TagsFromFile source.jpg target.png`
- Document metadata preservation requirements
- Add metadata verification to QA process

---

## Platform-Specific Red Flags

### 🟠 PLAT-001: Package Registry Metadata Stripping

**Description**: Publishing packages to npm/PyPI/etc. without including Palimpsest metadata files.

**Example**:
```
An npm package has `.palimpsest.json` in the repository but it's excluded from
the published package due to default `.npmignore` rules.
```

**Why It's a Problem**:
- Users of package don't receive metadata
- Can't verify license terms or cultural context
- Attribution information lost
- Downstream compliance impossible

**Detection**:
- Check published package contents: `npm pack --dry-run`
- Verify metadata files included in distribution
- Test installed package for metadata presence

**Remediation**:
- Update package manifest to explicitly include metadata
- Re-publish with correct files
- Issue notice about previous versions

**Prevention**:
```json
// package.json
{
  "files": [
    "dist",
    "LICENSE",
    ".palimpsest.json",      // ← Explicitly include
    "PALIMPSEST_CONTEXT.md"  // ← Explicitly include
  ]
}
```

---

### 🟡 PLAT-002: Docker Container Attribution Opacity

**Description**: Docker containers include Palimpsest-licensed software but attribution is buried or inaccessible.

**Example**:
```
A Docker image includes Palimpsest-licensed libraries but has no visible
attribution and no easy way for users to discover licenses of included software.
```

**Why It's a Problem**:
- Users don't know what licenses apply
- Attribution not visible
- Difficult to verify compliance

**Detection**:
- Run container and check for attribution display
- Inspect image for LICENSE files: `docker run <image> cat /app/LICENSE`
- Check image labels for license metadata

**Remediation**:
- Add license information to container labels
- Display attribution on startup
- Create `/licenses` directory with all license files
- Include attribution in health check endpoint

**Prevention**:
```dockerfile
# Add labels
LABEL org.opencontainers.image.licenses="Palimpsest-0.4"
LABEL org.palimpsest.cultural-context="Brief description"

# Copy metadata
COPY LICENSE .palimpsest.json PALIMPSEST_CONTEXT.md /app/

# Display attribution on startup
CMD echo "=== Palimpsest Licensed Software ===" && cat /app/LICENSE && node index.js
```

---

## Detection and Prevention Strategies

### Automated Detection Tools

**1. License Header Checker**
```bash
#!/bin/bash
# check-spdx-headers.sh

find src -name "*.py" -o -name "*.js" -o -name "*.ts" | while read file; do
  if ! grep -q "SPDX-License-Identifier: Palimpsest-0.4" "$file"; then
    echo "❌ Missing SPDX header: $file"
  fi
done
```

**2. Metadata Validator**
```python
#!/usr/bin/env python3
# validate-metadata.py

import json
import sys
from pathlib import Path

def validate():
    if not Path('.palimpsest.json').exists():
        print("❌ .palimpsest.json not found")
        return False

    try:
        with open('.palimpsest.json') as f:
            metadata = json.load(f)
    except json.JSONDecodeError as e:
        print(f"❌ Invalid JSON: {e}")
        return False

    required = ['@type', 'name', 'author', 'license', 'permissions']
    missing = [f for f in required if f not in metadata]

    if missing:
        print(f"❌ Missing required fields: {missing}")
        return False

    print("✅ Metadata valid")
    return True

if __name__ == '__main__':
    sys.exit(0 if validate() else 1)
```

**3. Attribution Link Checker**
```python
#!/usr/bin/env python3
# check-attribution-links.py

import requests
import sys

def check_links():
    with open('ATTRIBUTION.md') as f:
        content = f.read()

    # Extract URLs (simple regex)
    import re
    urls = re.findall(r'https?://[^\s\)]+', content)

    broken = []
    for url in urls:
        try:
            response = requests.head(url, timeout=5, allow_redirects=True)
            if response.status_code >= 400:
                broken.append((url, response.status_code))
        except Exception as e:
            broken.append((url, str(e)))

    if broken:
        print("❌ Broken attribution links:")
        for url, error in broken:
            print(f"  {url}: {error}")
        return False

    print("✅ All attribution links valid")
    return True

if __name__ == '__main__':
    sys.exit(0 if check_links() else 1)
```

---

### Prevention Checklists

**Pre-Release Checklist**
- [ ] LICENSE file present and correct version
- [ ] `.palimpsest.json` present and valid
- [ ] All source files have SPDX headers
- [ ] Attribution complete and accessible
- [ ] Cultural context preserved in derivatives
- [ ] Metadata included in distribution packages
- [ ] AI permissions clearly specified
- [ ] Links to license are valid
- [ ] Automated compliance checks passing

**Derivative Work Checklist**
- [ ] Original work's cultural context studied
- [ ] Cultural context preserved in adaptation
- [ ] Emotional lineage honoured
- [ ] Symbolic elements used appropriately
- [ ] Attribution includes original creator
- [ ] Attribution includes cultural origins
- [ ] Metadata inherited/created for derivative
- [ ] Creator contacted if changes are significant

**AI Use Checklist**
- [ ] Checked `permissions.interpretiveAI` flag
- [ ] Checked `permissions.nonInterpretiveAI` flag
- [ ] Obtained written consent if required
- [ ] Attribution mechanism designed for outputs
- [ ] Cultural context preservation planned
- [ ] Traceability to training sources implemented

---

## Reporting Violations

If you discover a violation of your Palimpsest-licensed work:

1. **Document**: Screenshot, archive, save evidence
2. **Verify**: Confirm it's actually a violation (check this index)
3. **Contact**: Reach out to violator (friendly first)
4. **Escalate**: Formal notice if friendly contact fails
5. **Community**: Consider reporting to Palimpsest Stewardship Council
6. **Legal**: Consult IP lawyer if needed

**Resources**:
- User Guide: Enforcement section
- Compliance Roadmap: Remediation procedures
- GOVERNANCE.md: Dispute resolution process

---

## Conclusion

The Palimpsest License exists to protect meaning, not just content. Many violations stem from not understanding the license's cultural purpose, not malice. When in doubt:

1. **Read the cultural context**: What does this work mean?
2. **Preserve that meaning**: How can I honour it?
3. **Ask the creator**: When unsure, just ask
4. **Act in good faith**: The spirit matters as much as the letter

**Most violations are preventable**. Use this index to educate your team, audit your practices, and build compliance into your workflows from the start.

---

**Document Version**: 1.0
**Last Updated**: 2025-11-22
**License**: This guide is licensed under CC BY-SA 4.0
**Maintainer**: Palimpsest Stewardship Council
