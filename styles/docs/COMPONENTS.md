# Component Documentation

This document provides detailed documentation for all components in the Palimpsest License styling system.

---

## Table of Contents

1. [Licence Display](#licence-display)
2. [Badges](#badges)
3. [Metadata Display](#metadata-display)
4. [Compliance Indicators](#compliance-indicators)

---

## Licence Display

The licence display component presents licence information in a structured, accessible format.

### Basic Usage

```html
<div class="license-display">
  <header class="license-display__header">
    <h2 class="license-display__title">
      Palimpsest License
      <span class="license-display__version">v0.4</span>
    </h2>
  </header>
  <div class="license-display__body">
    <p>Licence content goes here...</p>
  </div>
  <footer class="license-display__footer">
    <div class="license-actions">
      <a href="#" class="license-actions__button">Download</a>
      <a href="#" class="license-actions__button license-actions__button--secondary">
        View Source
      </a>
    </div>
  </footer>
</div>
```

### Variants

#### Compact

Reduced padding for space-constrained layouts.

```html
<div class="license-display license-display--compact">
  <!-- Content -->
</div>
```

#### Minimal

For embedding in other contexts with minimal styling.

```html
<div class="license-display license-display--minimal">
  <!-- Content -->
</div>
```

### Components

#### Licence Text with Clauses

```html
<div class="license-text">
  <div class="license-text__clause">
    <span class="license-text__clause-number">1.2</span>
    <strong class="license-text__clause-title">Non-Interpretive Systems</strong>
    <p>Content of the clause...</p>
  </div>

  <!-- Important clause -->
  <div class="license-text__clause license-text__clause--important">
    <span class="license-text__clause-number">2.3</span>
    <strong class="license-text__clause-title">Metadata Preservation</strong>
    <p>Content of the important clause...</p>
  </div>

  <!-- Critical clause -->
  <div class="license-text__clause license-text__clause--critical">
    <span class="license-text__clause-number">3.1</span>
    <strong class="license-text__clause-title">Attribution Requirements</strong>
    <p>Content of the critical clause...</p>
  </div>
</div>
```

#### Licence Summary

Quick overview of key licence information.

```html
<div class="license-summary">
  <div class="license-summary__item">
    <div class="license-summary__item-label">Version</div>
    <div class="license-summary__item-value">0.4</div>
  </div>
  <div class="license-summary__item">
    <div class="license-summary__item-label">Jurisdiction</div>
    <div class="license-summary__item-value">Netherlands</div>
  </div>
  <div class="license-summary__item">
    <div class="license-summary__item-label">Status</div>
    <div class="license-summary__item-value">Active</div>
  </div>
</div>
```

#### Bilingual Display

Side-by-side display of Dutch and English versions.

```html
<div class="license-bilingual">
  <div class="license-bilingual__column" lang="nl">
    <span class="license-bilingual__language-label">Nederlands</span>
    <h3>Nederlandse Titel</h3>
    <p>Nederlandse inhoud...</p>
  </div>
  <div class="license-bilingual__column" lang="en">
    <span class="license-bilingual__language-label">English</span>
    <h3>English Title</h3>
    <p>English content...</p>
  </div>
</div>
```

### Accessibility

- Uses semantic HTML (`article`, `header`, `footer`)
- Proper heading hierarchy
- ARIA labels where appropriate
- Keyboard navigable actions
- Print-friendly styling

---

## Badges

Badges provide visual indicators for status, version, and other metadata.

### Basic Badge

```html
<span class="badge">Default Badge</span>
```

### Semantic Variants

```html
<!-- Status badges -->
<span class="badge badge--success">Success</span>
<span class="badge badge--warning">Warning</span>
<span class="badge badge--error">Error</span>
<span class="badge badge--info">Info</span>
<span class="badge badge--accent">Accent</span>
```

### Licence Status Badges

Automatically include status icons.

```html
<span class="badge badge--compliant">Compliant</span>
<span class="badge badge--partial">Partial Compliance</span>
<span class="badge badge--violation">Violation</span>
<span class="badge badge--pending">Pending Review</span>
```

### Specialised Badges

#### Version Badge

```html
<span class="badge-version">0.4</span>
```

#### Language Badge

```html
<span class="badge-language badge-language--nl" lang="nl">NL</span>
<span class="badge-language badge-language--en" lang="en">EN</span>
```

#### AI Training Badge

```html
<!-- Allowed -->
<span class="badge-ai-training badge-ai-training--allowed">
  AI Training Allowed
</span>

<!-- Restricted (requires consent) -->
<span class="badge-ai-training badge-ai-training--restricted">
  AI Training Restricted
</span>

<!-- Prohibited -->
<span class="badge-ai-training badge-ai-training--prohibited">
  AI Training Prohibited
</span>
```

#### DAO Governance Badge

```html
<span class="badge-dao">DAO Governed</span>
```

#### Quantum-Proof Badge

```html
<span class="badge-quantum-proof">Quantum-Proof</span>
```

### Size Variants

```html
<span class="badge badge--sm">Small</span>
<span class="badge">Default</span>
<span class="badge badge--lg">Large</span>
```

### Style Variants

```html
<!-- Pill shape -->
<span class="badge badge--pill">Pill Badge</span>

<!-- Outline style -->
<span class="badge badge--outline badge--success">Outline</span>

<!-- Interactive (clickable) -->
<button class="badge badge--interactive">Clickable</button>

<!-- With pulse animation -->
<span class="badge badge--pulse badge--error">New</span>
```

### Badge Groups

```html
<div class="badge-group">
  <span class="badge-version">0.4</span>
  <span class="badge badge--compliant">Compliant</span>
  <span class="badge-language--nl">NL</span>
</div>
```

### Tooltip Badge

```html
<span class="badge badge--tooltip" data-tooltip="Additional information">
  Hover me
</span>
```

### Accessibility

- Sufficient colour contrast for all variants
- Icons supplement, not replace, text
- Interactive badges are keyboard accessible
- Tooltip content is screen reader accessible

---

## Metadata Display

Components for presenting licence metadata in various formats.

### Basic Metadata Container

```html
<div class="metadata">
  <header class="metadata__header">
    <h3>Licence Metadata</h3>
  </header>
  <div class="metadata__body">
    <!-- Metadata content -->
  </div>
</div>
```

### Metadata List

Key-value pairs in a list format.

```html
<dl class="metadata-list">
  <div class="metadata-list__item">
    <dt class="metadata-list__key">Creator</dt>
    <dd class="metadata-list__value">Jane Doe</dd>
  </div>
  <div class="metadata-list__item">
    <dt class="metadata-list__key">Created</dt>
    <dd class="metadata-list__value">2025-01-15</dd>
  </div>
  <div class="metadata-list__item">
    <dt class="metadata-list__key">Licence</dt>
    <dd class="metadata-list__value">Palimpsest v0.4</dd>
  </div>
</dl>
```

### Metadata Grid

Grid layout for multiple metadata items.

```html
<div class="metadata-grid">
  <div class="metadata-grid__item">
    <div class="metadata-grid__item-label">Creator</div>
    <div class="metadata-grid__item-value">Jane Doe</div>
  </div>
  <div class="metadata-grid__item">
    <div class="metadata-grid__item-label">Format</div>
    <div class="metadata-grid__item-value">Text</div>
  </div>
  <div class="metadata-grid__item">
    <div class="metadata-grid__item-label">Language</div>
    <div class="metadata-grid__item-value">English, Dutch</div>
  </div>
</div>
```

### JSON-LD Display

Display machine-readable metadata with copy functionality.

```html
<div class="metadata-jsonld">
  <button class="metadata-jsonld__copy-button" aria-label="Copy JSON-LD">
    Copy
  </button>
  <div class="metadata-jsonld__code">
    <pre><code>{
  "@context": "https://schema.org",
  "@type": "CreativeWork",
  "name": "Work Title",
  "license": "https://palimpsest.example/v0.4"
}</code></pre>
  </div>
</div>
```

### Metadata Tags

Clickable or display-only tags.

```html
<div class="metadata-tags">
  <span class="metadata-tags__tag">Creative Commons</span>
  <span class="metadata-tags__tag metadata-tags__tag--clickable">
    Attribution Required
  </span>
  <span class="metadata-tags__tag">Non-Commercial</span>
</div>
```

### Emotional Lineage Display

Special component for displaying emotional/cultural lineage.

```html
<div class="metadata-lineage">
  <header class="metadata-lineage__header">
    <span class="metadata-lineage__header-icon">🌿</span>
    <h4>Emotional Lineage</h4>
  </header>
  <p class="metadata-lineage__description">
    This work draws from protest traditions and cultural narratives
    spanning three generations of community activism.
  </p>
  <div class="metadata-lineage__sources">
    <div class="metadata-lineage__sources-label">Sources</div>
    <ul class="metadata-lineage__sources-list">
      <li>Traditional Folk Songs (1960s)</li>
      <li>Community Oral Histories</li>
      <li>Activist Poetry Collections</li>
    </ul>
  </div>
</div>
```

### Attribution Chain

Display chain of attribution for derivative works.

```html
<div class="metadata-attribution">
  <div class="metadata-attribution__chain">
    <div class="metadata-attribution__item">
      <div class="metadata-attribution__creator">Original Creator</div>
      <div class="metadata-attribution__date">2020-03-15</div>
      <div class="metadata-attribution__description">
        Original work created
      </div>
    </div>
    <div class="metadata-attribution__item">
      <div class="metadata-attribution__creator">Second Creator</div>
      <div class="metadata-attribution__date">2022-07-20</div>
      <div class="metadata-attribution__description">
        Adapted and translated
      </div>
    </div>
    <div class="metadata-attribution__item">
      <div class="metadata-attribution__creator">Current Creator</div>
      <div class="metadata-attribution__date">2025-01-10</div>
      <div class="metadata-attribution__description">
        Remixed with additional content
      </div>
    </div>
  </div>
</div>
```

### Quantum-Proof Hash

Display cryptographic hash with visual distinction.

```html
<div class="metadata-hash">
  <div class="metadata-hash__label">Quantum-Proof Hash</div>
  <code class="metadata-hash__value">
    a3f5c8d2e9b1f4a6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0
  </code>
</div>
```

### Collapsible Metadata

Expandable/collapsible section for lengthy metadata.

```html
<div class="metadata-collapsible">
  <button class="metadata-collapsible__toggle"
          aria-expanded="false"
          aria-controls="metadata-content">
    Additional Metadata
  </button>
  <div id="metadata-content"
       class="metadata-collapsible__content"
       hidden>
    <!-- Content here -->
  </div>
</div>
```

### Accessibility

- Semantic HTML (`dl`, `dt`, `dd` for lists)
- Proper labelling of interactive elements
- Keyboard accessible collapsible sections
- Copy buttons announce success to screen readers

---

## Compliance Indicators

Visual indicators for licence compliance status.

### Compliance Status Badge

```html
<div class="compliance-status compliance-status--compliant">
  <span class="compliance-status__icon"></span>
  <span class="compliance-status__text">Fully Compliant</span>
</div>

<div class="compliance-status compliance-status--partial">
  <span class="compliance-status__icon"></span>
  <span class="compliance-status__text">Partial Compliance</span>
</div>

<div class="compliance-status compliance-status--violation">
  <span class="compliance-status__icon"></span>
  <span class="compliance-status__text">Violation Detected</span>
</div>

<div class="compliance-status compliance-status--pending">
  <span class="compliance-status__icon"></span>
  <span class="compliance-status__text">Pending Review</span>
</div>
```

### Compliance Checklist

Interactive checklist for compliance verification.

```html
<div class="compliance-checklist">
  <header class="compliance-checklist__header">
    <h3>Compliance Checklist</h3>
    <div class="compliance-checklist__progress">
      <span>3 of 5 complete</span>
    </div>
  </header>
  <ul class="compliance-checklist__list">
    <li class="compliance-checklist__item compliance-checklist__item--checked">
      <div class="compliance-checklist__item-checkbox"></div>
      <div class="compliance-checklist__item-content">
        <div class="compliance-checklist__item-title">
          Attribution Provided
        </div>
        <div class="compliance-checklist__item-description">
          Proper attribution to original creator
        </div>
      </div>
    </li>
    <li class="compliance-checklist__item compliance-checklist__item--warning">
      <div class="compliance-checklist__item-checkbox"></div>
      <div class="compliance-checklist__item-content">
        <div class="compliance-checklist__item-title">
          Metadata Preserved
        </div>
        <div class="compliance-checklist__item-description">
          Some metadata fields missing
        </div>
      </div>
    </li>
    <li class="compliance-checklist__item">
      <div class="compliance-checklist__item-checkbox"></div>
      <div class="compliance-checklist__item-content">
        <div class="compliance-checklist__item-title">
          AI Training Consent
        </div>
        <div class="compliance-checklist__item-description">
          Not yet verified
        </div>
      </div>
    </li>
  </ul>
</div>
```

### Compliance Progress Bar

```html
<div class="compliance-progress">
  <div class="compliance-progress__label">
    <span>Overall Compliance</span>
    <span class="compliance-progress__percentage">75%</span>
  </div>
  <div class="compliance-progress__bar">
    <div class="compliance-progress__fill compliance-progress__fill--high"
         style="width: 75%">
      75%
    </div>
  </div>
</div>
```

Fill classes:
- `compliance-progress__fill--high` (≥80% - green)
- `compliance-progress__fill--medium` (50-79% - amber)
- `compliance-progress__fill--low` (<50% - red)

### Compliance Card

Detailed compliance information in a card format.

```html
<div class="compliance-card compliance-card--compliant">
  <div class="compliance-card__status">
    <span>✓</span> Compliant
  </div>
  <h4 class="compliance-card__title">Clause 1.2 Compliance</h4>
  <p class="compliance-card__description">
    This work meets all requirements for non-interpretive system usage.
  </p>
  <div class="compliance-card__actions">
    <button class="license-actions__button">View Details</button>
  </div>
</div>
```

Card variants:
- `compliance-card--compliant` (green)
- `compliance-card--partial` (amber)
- `compliance-card--violation` (red)
- `compliance-card--pending` (grey)

### Clause Compliance Indicator

Indicate compliance for specific licence clauses.

```html
<div class="clause-compliance clause-compliance--compliant">
  <div class="clause-compliance__indicator"></div>
  <div class="clause-compliance__content">
    <div class="clause-compliance__clause">Clause 1.2</div>
    <div class="clause-compliance__description">
      Non-interpretive systems: Explicit consent obtained
    </div>
  </div>
</div>
```

### Compliance Matrix

Table view of compliance across multiple criteria.

```html
<div class="compliance-matrix">
  <table>
    <thead>
      <tr>
        <th>Clause</th>
        <th>Requirement</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>1.2</td>
        <td>NI Systems Consent</td>
        <td>
          <span class="compliance-matrix__cell compliance-matrix__cell--compliant"></span>
        </td>
      </tr>
      <tr>
        <td>2.3</td>
        <td>Metadata Preservation</td>
        <td>
          <span class="compliance-matrix__cell compliance-matrix__cell--partial"></span>
        </td>
      </tr>
    </tbody>
  </table>
</div>
```

### Red Flag Alert

High-priority compliance warnings.

```html
<div class="red-flag-alert">
  <header class="red-flag-alert__header">
    <span class="red-flag-alert__header-icon">🚩</span>
    <h3>Compliance Violation</h3>
  </header>
  <p class="red-flag-alert__description">
    This work appears to violate Clause 2.3 by stripping required metadata.
  </p>
  <div class="red-flag-alert__actions">
    <button class="license-actions__button">View Details</button>
    <button class="license-actions__button license-actions__button--secondary">
      Report Issue
    </button>
  </div>
</div>
```

### Accessibility

- Clear visual indicators (colour + icon)
- Sufficient colour contrast
- Keyboard accessible interactive elements
- Screen reader announcements for status changes
- ARIA labels for status indicators

---

## Integration Examples

### Complete Licence Page

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="styles/css/main.css">
  <title>Palimpsest License</title>
</head>
<body>
  <nav class="language-switcher" aria-label="Language selection">
    <a href="?lang=en" aria-current="page">English</a>
    <a href="?lang=nl">Nederlands</a>
  </nav>

  <main class="container markdown-body">
    <div class="license-display">
      <header class="license-display__header">
        <h1 class="license-display__title">
          Palimpsest License
          <span class="license-display__version">v0.4</span>
        </h1>
        <div class="badge-group">
          <span class="badge-dao">DAO Governed</span>
          <span class="badge-quantum-proof">Quantum-Proof</span>
        </div>
      </header>

      <div class="license-display__body">
        <div class="license-summary mb-xl">
          <!-- Summary items -->
        </div>

        <div class="license-text">
          <!-- Licence clauses -->
        </div>
      </div>

      <footer class="license-display__footer">
        <div class="metadata">
          <!-- Metadata -->
        </div>
      </footer>
    </div>
  </main>
</body>
</html>
```

---

**Maintained by**: Palimpsest Stewardship Council
**Version**: 0.4.0
**Last Updated**: 2025-11-22
