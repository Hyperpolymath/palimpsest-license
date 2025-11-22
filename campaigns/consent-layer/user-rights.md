# User Rights and Benefits: The Consent Layer for Everyone

## Introduction

The Consent Layer isn't just for creators—it protects everyone who uses the internet. This document explains how consent infrastructure benefits users, what rights it preserves, and how it makes the internet more transparent, fair, and sustainable.

**For:** General public, internet users, digital rights advocates, policymakers

---

## 1. What Users Gain

### 1.1 Transparency: Know How Your Content Is Used

**Before Consent Layer:**
- Upload photo to social media → No idea if/how AI companies use it
- Write blog post → Might be in ChatGPT's training data, might not
- Post code on GitHub → Copilot trains on it without notification

**With Consent Layer:**
- **Clear labelling:** Works show "Consent required for AI training" badge
- **Audit trails:** Consent registries track who requested permission, for what
- **Public accountability:** AI companies disclose training datasets

**Example:**
You upload a photo to Flickr with Palimpsest license. Six months later, Midjourney requests permission to train on it. You receive notification, review terms (they offer £10), decide yes/no. Either way, you know.

**User benefit:** **Control replaces uncertainty.**

---

### 1.2 Fair Compensation: Get Paid for AI Training

**Before Consent Layer:**
- AI companies scrape your work for free
- You get nothing (no money, no credit)
- Billion-dollar models built on unpaid labour

**With Consent Layer:**
- **Consent = negotiation opportunity:** AI company requests, you set price
- **Market rates emerge:** "Most writers charge £50-£500 per work for training"
- **Collective bargaining:** DAOs/unions negotiate on behalf of creators

**Example:**
You wrote a novel. OpenAI wants to train GPT-6 on it. Via Consent Registry, they offer £100. You counter: £500 + attribution in model card. They accept. You just monetised your creativity.

**User benefit:** **Labour is compensated, not extracted.**

---

### 1.3 Attribution: Your Name Stays With Your Work

**Before Consent Layer:**
- AI generates "similar" work → No credit to original creator
- Social media reposts strip metadata → "Artist unknown"
- Code snippets copied → Original author forgotten

**With Consent Layer:**
- **Metadata travels:** Emotional lineage embedded in files, preserved through sharing
- **Cryptographic binding:** Signatures prove authorship
- **Platform requirements:** ToS prohibit metadata stripping

**Example:**
Your photograph is shared 10,000 times on Twitter. Because Consent Layer metadata is embedded and platforms preserve it, every share includes: "Photo by [Your Name], Palimpsest License v0.4."

**User benefit:** **Recognition, not erasure.**

---

### 1.4 Revocation: Take Back Permission If Misused

**Before Consent Layer:**
- Grant permission once → Stuck with it forever
- Discover misuse → No recourse except lawsuit

**With Consent Layer:**
- **Revocable consent:** You can withdraw permission (if terms allow)
- **Use-case specific:** Grant for research but not commercial use
- **Time-limited:** Permission expires after 5 years

**Example:**
You granted consent for academic research. The researcher sells the trained model commercially (violating terms). You revoke consent via Consent Registry. They must stop using your work in future versions.

**User benefit:** **Ongoing control, not one-time surrender.**

---

## 2. Rights Preserved

### 2.1 Fair Use Is Untouched

**Concern:** "Does Consent Layer restrict my ability to use others' work?"

**Answer:** **No. Fair use, fair dealing, and personal use are preserved.**

| Use Case | Consent Required? |
|----------|------------------|
| **Read a Palimpsest-licensed article** | ❌ No (personal use) |
| **Quote article in your own writing** | ❌ No (fair use/fair dealing) |
| **Teach from article in classroom** | ❌ No (educational use) |
| **Create parody or critique** | ❌ No (transformative use) |
| **Train AI on article to generate similar content** | ✅ **Yes (non-interpretive system use)** |
| **Sell article commercially without permission** | ✅ **Yes (copyright law already requires this)** |

**Consent Layer targets specific uses (AI training, commercial exploitation), not general reading, sharing, or remixing.**

---

### 2.2 Privacy Is Enhanced, Not Compromised

**Concern:** "Do consent registries track my reading habits?"

**Answer:** **No. Registries only track consent requests/grants, not consumption.**

| What's Tracked | What's NOT Tracked |
|----------------|-------------------|
| ✅ "OpenAI requested consent for Work X" | ❌ Who read Work X |
| ✅ "Creator granted consent on [date]" | ❌ Where readers are located |
| ✅ "Consent terms: £500 + attribution" | ❌ How many times work was viewed |

**Analogy:** Copyright law tracks who publishes your book (publishers request permission), not who reads it (readers don't).

**Privacy safeguards:**
- Registries use end-to-end encryption for consent details
- Only creator and requester see terms (not public)
- Zero-knowledge proofs: Verify "consent exists" without revealing details

**User benefit:** **Consent infrastructure doesn't surveil—it documents permission.**

---

### 2.3 Accessibility Remains Paramount

**Concern:** "Will Consent Layer break screen readers, format conversions, accessibility tools?"

**Answer:** **No. These are considered 'interpretive' uses (human-directed), not 'non-interpretive' (AI-autonomous).**

| Accessibility Tool | Consent Required? |
|-------------------|-------------------|
| **Screen reader** (reads text aloud for visually impaired) | ❌ No |
| **Format conversion** (EPUB → audiobook for dyslexia) | ❌ No |
| **Translation** (English → Spanish via Google Translate) | ❌ No |
| **AI summarisation** (ChatGPT summarises article at user's request) | ⚠️ **Grey area** (arguably interpretive) |
| **AI training** (bulk ingestion to train model) | ✅ **Yes** |

**Palimpsest Clause 1.2 (Non-Interpretive Systems) explicitly exempts accessibility uses.**

**User benefit:** **Disability rights protected.**

---

### 2.4 Remix Culture Thrives

**Concern:** "Does Consent Layer kill remix culture, fan art, mash-ups?"

**Answer:** **No. Human-created derivatives are encouraged (with attribution).**

| Remix Type | Consent Required? |
|------------|-------------------|
| **Fan fiction** based on Palimpsest-licensed novel | ❌ No (transformative human creativity) |
| **Mash-up** of two Palimpsest-licensed songs | ❌ No (human-directed editing) |
| **AI generates fan art** from Palimpsest-licensed image (user prompts AI) | ⚠️ **Grey area** (interpretive—user directs AI) |
| **AI trained on 10,000 fan arts to generate new art autonomously** | ✅ **Yes (non-interpretive training)** |

**Key distinction:** Human using AI as tool (like Photoshop) = OK. AI trained to replicate patterns autonomously = requires consent.

**User benefit:** **Creativity flourishes, exploitation is curtailed.**

---

## 3. How Users Interact With Consent Layer

### 3.1 As a Creator (You Make Things)

**Step 1: Choose License**
- Upload work to platform (GitHub, DeviantArt, Medium)
- Select "Palimpsest v0.4" from license picker
- Check "Require consent for: AI training"

**Step 2: Monitor Requests**
- Receive email: "OpenAI requests consent to train on your work"
- Review terms: £100 one-time payment + attribution
- Respond: Grant, deny, or negotiate

**Step 3: Track Usage**
- Dashboard shows: 5 consent requests (3 granted, 2 denied)
- Earnings: £1,500 from AI training consents
- Attribution: Your work cited in GPT-6 model card

---

### 3.2 As a Consumer (You Use Things)

**Step 1: Respect Metadata**
- See "Palimpsest License" badge on artwork
- Understand: "I can share this, but AI companies need permission"
- If you share: Preserve attribution, don't strip metadata

**Step 2: Support Ethical Platforms**
- Choose platforms that integrate Consent Layer (GitHub, DeviantArt+, Bandcamp)
- Vote with your wallet: Subscribe to creator-protective services

**Step 3: Audit AI Systems**
- When using AI tool (ChatGPT, Midjourney), ask: "Was this trained ethically?"
- Check model cards for consent documentation
- Prefer AI companies that respect consent (Anthropic, Hugging Face)

---

### 3.3 As an AI Developer (You Build AI)

**Step 1: Check Metadata Before Training**
- Scrape dataset → Parse consent metadata
- If `consentRequired: ai-training`, query Consent Registry

**Step 2: Request Consent**
- Use Registry API: Submit request with terms
- Wait for creator response (auto-granted, negotiated, denied)

**Step 3: Document Consent**
- Include consent log in dataset card:
  ```
  Dataset: 100,000 images
  Consented: 87,000 (87%)
  Denied: 8,000 (8%)
  No response: 5,000 (5%)—excluded
  ```
- Demonstrate ethical sourcing

---

## 4. Real-World Scenarios

### Scenario 1: Student Uses AI for Essay

**Situation:** University student asks ChatGPT to summarise a Palimpsest-licensed research paper.

**Consent Required?** ❌ **No.** This is interpretive use (student directs AI to perform specific task). Fair use applies.

**If OpenAI trained GPT on that paper:** ✅ **Yes, consent required for training.** But that's between OpenAI and the paper's author (not the student).

**Takeaway:** **Using AI tools is fine. Training AI on others' work requires permission.**

---

### Scenario 2: Photographer's Work Goes Viral

**Situation:** Photographer posts image to DeviantArt with Palimpsest license. Image goes viral (1M shares).

**What Happens:**
1. **Metadata travels:** Every share includes photographer's name, license info
2. **AI companies notice:** Stability AI wants to train on it for Stable Diffusion 4.0
3. **Consent request:** Stability AI offers £500 via Consent Registry
4. **Photographer decides:** Accepts (needs money) or declines (artistic integrity)

**Outcome (if accepted):** Photographer earns £500, credited in Stability AI's dataset documentation. Future AI-generated images owe partial inspiration to this photographer.

**Outcome (if declined):** Work excluded from training. Photographer's artistic vision remains uncompromised.

**Takeaway:** **Virality doesn't equal exploitation. Consent is required.**

---

### Scenario 3: Musician's Song Used by TikTok

**Situation:** Musician uploads song to Bandcamp with Palimpsest license. TikTok users want it for videos.

**TikTok Use (human-created videos):** ❌ **No consent required.** Users manually select song, create videos. This is transformative, human-directed use. (TikTok may still need performance license—that's separate from Palimpsest.)

**TikTok's AI training (e.g., recommendation algorithm):** ⚠️ **Grey area.** If TikTok trains AI on song to recommend similar music, consent may be required. Musician can specify in metadata.

**AI music generator (e.g., Jukebox) trains on song:** ✅ **Consent required.** This is non-interpretive use (AI replicates style autonomously).

**Takeaway:** **Context matters. Human use ≠ AI training.**

---

### Scenario 4: Accessibility Tool Needs Text

**Situation:** Blind user wants screen reader to vocalise Palimpsest-licensed article.

**Consent Required?** ❌ **No.** Accessibility is explicitly exempt under Palimpsest Clause 1.2. Screen readers are interpretive tools (human-directed).

**If text-to-speech company trains AI on article to improve voice synthesis:** ✅ **Consent required.** Training = non-interpretive use.

**Takeaway:** **Disability access is sacred. Consent Layer protects it.**

---

## 5. The Bigger Picture: A Fairer Internet

### 5.1 From Extraction to Exchange

**Old model (Web 2.0):**
- Platforms extract value from user-generated content
- Users get "exposure" (non-monetary)
- AI companies scrape freely
- Wealth concentrates (trillion-dollar tech companies, underpaid creators)

**New model (Consent Layer):**
- Platforms facilitate consent, take small fee (10%)
- Users negotiate compensation directly
- AI companies pay creators (or build on consented datasets)
- Wealth distributes (creators earn, platforms earn, AI earns—everyone benefits)

**Analogy:** Spotify pays musicians per stream (albeit poorly). Consent Layer could establish "per-train" payments for AI.

---

### 5.2 Restoring Power Imbalances

**Currently:**
- **AI companies:** Infinite resources, legal teams, scrape freely
- **Individual creators:** No leverage, can't negotiate

**With Consent Layer:**
- **Creators:** Collective bargaining (DAOs, unions), consent registries amplify voice
- **AI companies:** Must ask permission, offer fair terms, compete for consented data

**Example:**
Writers Guild DAO: 10,000 writers collectively license their works. OpenAI wants access → negotiates with DAO (not 10,000 individuals). DAO demands: £50M + attribution + profit-sharing. OpenAI pays or finds other data.

**User benefit:** **Collective strength.**

---

### 5.3 Trustworthy AI

**Problem:** Current AI is opaque ("black box" models, secret training data)

**Solution:** Consent Layer creates transparency
- **Model cards disclose:** "Trained on 1M consented works"
- **Auditors verify:** "Yes, consent records exist"
- **Users trust:** "This AI was built ethically"

**Example:**
- **Ethical AI:** "Anthropic Claude—trained on consented datasets (see consent log)"
- **Questionable AI:** "Mystery Model X—no consent documentation"

**Consumer choice:** People/businesses prefer ethical AI (like fair-trade coffee).

**User benefit:** **Accountability.**

---

## 6. Addressing Concerns

### "This will make AI worse."

**Concern:** Restricting training data limits AI capabilities.

**Response:**
1. **Quality > Quantity:** Consented, curated datasets produce better models than indiscriminate scraping
2. **Incentive to pay:** AI companies will pay for good data (already happening—some buy datasets)
3. **Many will consent:** Especially with compensation, many creators will opt in

**Historical analogue:** Copyright didn't kill music industry—it created sustainable ecosystem (artists earn, labels distribute, listeners access).

---

### "Only rich people benefit."

**Concern:** Consent Layer helps professional creators, not hobbyists.

**Response:**
1. **Hobbyists choose:** License under CC0 (public domain) if you want free AI training. Palimpsest is opt-in.
2. **Collective models:** DAOs let small creators pool bargaining power
3. **Freemium registries:** Consent Layer Foundation offers free tier (up to 100 works)

**Goal:** Consent Layer expands options (CC0, CC BY, Palimpsest, proprietary). More choice = more freedom.

---

### "It's too complicated."

**Concern:** Users won't understand metadata, consent registries, etc.

**Response:**
1. **Platforms simplify:** GitHub shows "🔒 Consent Required" badge—user clicks, reads explainer
2. **Defaults matter:** Platform pre-selects "Require consent for AI training" (user can uncheck)
3. **Education:** Webinars, guides, tooltips (like GDPR cookie notices—awkward at first, now normal)

**Adoption curve:** Early adopters (tech-savvy) → Mainstream (platforms make it easy) → Ubiquitous (like HTTPS).

---

## 7. How to Support Consent Layer

### As a User

**1. Adopt Palimpsest for Your Work**
- License your blog, photos, code, music under Palimpsest
- Register in Consent Layer registry (free tier)
- Share experience: "I used Palimpsest and earned £500 from AI training consent!"

**2. Choose Ethical Platforms**
- Support platforms integrating Consent Layer (GitHub, DeviantArt, Bandcamp)
- Request integration: Email platform saying "Please add Consent Layer support"

**3. Demand Transparency from AI Companies**
- Ask: "Was your model trained on consented data?"
- Prefer ethical AI (Anthropic, Hugging Face) over opaque models

---

### As an Advocate

**4. Educate Others**
- Write blog posts, create videos explaining Consent Layer
- Speak at conferences, community events
- Join advocacy groups (EFF, Open Rights Group, Creative Commons)

**5. Lobby for Regulation**
- Contact representatives: "Support Consent Layer in AI Act, Online Safety Bill"
- Sign petitions, join campaigns
- Participate in public consultations

---

### As a Developer

**6. Build Consent Layer Tools**
- Metadata validators, consent registry clients, browser extensions
- Open source your work (help ecosystem grow)
- Contribute to Consent Layer Foundation projects

**7. Integrate into Your Platform**
- If you run a platform, add Consent Layer support
- Follow technical architecture spec
- Share learnings with community

---

## 8. The Future With Consent Layer

**5 years from now:**
- 100M+ works protected by Consent Layer
- Major platforms (GitHub, DeviantArt, Medium, YouTube) integrate consent infrastructure
- AI companies routinely pay creators for training data
- "Ethically trained AI" is standard expectation (like "organic food" or "fair-trade coffee")

**Consent Layer becomes invisible infrastructure**—like HTTPS, you don't think about it, but it's always working to protect you.

**Result:**
- **Creators:** Fairly compensated, properly attributed, in control
- **Users:** Transparent AI, trustworthy platforms, sustainable internet
- **AI developers:** Legal clarity, ethical differentiation, higher-quality datasets
- **Society:** Fairer distribution of AI's benefits

---

## Conclusion

The Consent Layer is not about restricting the internet. It's about making the internet **sustainable, fair, and transparent**.

**You have rights:**
- The right to know how your work is used
- The right to be compensated for AI training
- The right to attribution
- The right to revoke consent if misused

**You have choices:**
- License freely (CC0, public domain)
- Require consent (Palimpsest, similar licenses)
- Negotiate terms (via Consent Registry)

**The Consent Layer gives you those rights and choices.**

Join us in building an internet where permission is infrastructure, not an afterthought.

---

## Resources

**Learn More:**
- https://consent-layer.org
- https://palimpsest.license

**Get Started:**
- Adopt Palimpsest: https://palimpsest.license/adopt
- Join Consent Registry: https://consent-layer.org/registry

**Connect:**
- Forum: https://discuss.consent-layer.org
- Chat: #consent-layer on Matrix/Discord
- Email: hello@consent-layer.org

**Support:**
- Donate: https://consent-layer.org/donate
- Volunteer: https://consent-layer.org/volunteer

---

**Document Version:** 1.0
**Date:** November 2025
**Authors:** Consent Layer Community Outreach Team
**License:** CC BY 4.0

**Your internet. Your consent. Your rights.**
