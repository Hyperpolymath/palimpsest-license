// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Metadata display component
// Renders license metadata in various formats

open PalimpsestTypes

// Display format options
type displayFormat =
  | Compact  // Minimal information
  | Standard  // Normal detail level
  | Detailed  // Full information including lineage
  | Technical  // Raw metadata for developers

// Display style
type displayStyle = {
  format: displayFormat,
  showIcons: bool,
  showLinks: bool,
  highlightTrauma: bool,
}

let defaultStyle: displayStyle = {
  format: Standard,
  showIcons: true,
  showLinks: true,
  highlightTrauma: true,
}

// Generate compact display (single line or minimal)
let generateCompactDisplay = (metadata: metadata, ~style: displayStyle): string => {
  let creator = Belt.Array.get(metadata.attribution.creators, 0)
    ->Belt.Option.map(c => c.name)
    ->Belt.Option.getWithDefault("Unknown")

  let icon = if style.showIcons {
    "📄 "
  } else {
    ""
  }

  let link = if style.showLinks {
    `<a href="${metadata.licenseUri}">${icon}${metadata.workTitle}</a> by ${creator} — Palimpsest v${versionToString(
        metadata.version,
      )}`
  } else {
    `${icon}${metadata.workTitle} by ${creator} — Palimpsest v${versionToString(metadata.version)}`
  }

  `<span class="palimpsest-compact">${link}</span>`
}

// Generate standard display
let generateStandardDisplay = (metadata: metadata, ~style: displayStyle): string => {
  let icon = if style.showIcons {
    "📄"
  } else {
    ""
  }

  let creatorsHTML = if Belt.Array.length(metadata.attribution.creators) > 0 {
    let creators = metadata.attribution.creators
      ->Belt.Array.map(creator => {
        if style.showLinks {
          switch creator.identifier {
          | Some(id) => `<a href="${id}" target="_blank">${creator.name}</a>`
          | None => creator.name
          }
        } else {
          creator.name
        }
      })
      ->Js.Array.joinWith(", ")
    creators
  } else {
    "Unknown"
  }

  let licenseLink = if style.showLinks {
    `<a href="${metadata.licenseUri}" target="_blank">Palimpsest License v${versionToString(
        metadata.version,
      )}</a>`
  } else {
    `Palimpsest License v${versionToString(metadata.version)}`
  }

  let traumaWarning = switch metadata.emotionalLineage {
  | Some(lineage) if lineage.traumaMarker && style.highlightTrauma =>
    `<div class="palimpsest-trauma-notice">⚠️ This work contains trauma narratives</div>`
  | _ => ""
  }

  `
<div class="palimpsest-standard">
  <h4>${icon} ${metadata.workTitle}</h4>
  <p><strong>By:</strong> ${creatorsHTML}</p>
  <p><strong>License:</strong> ${licenseLink}</p>
  ${traumaWarning}
</div>
`
}

// Generate detailed display with emotional lineage
let generateDetailedDisplay = (metadata: metadata, ~style: displayStyle): string => {
  let standardDisplay = generateStandardDisplay(metadata, ~style)

  // Emotional lineage section
  let lineageHTML = switch metadata.emotionalLineage {
  | Some(lineage) => {
      let originHTML = switch lineage.origin {
      | Some(origin) => `<dt>Origin:</dt><dd>${origin}</dd>`
      | None => ""
      }

      let contextHTML = switch lineage.culturalContext {
      | Some(context) => `<dt>Cultural Context:</dt><dd>${context}</dd>`
      | None => ""
      }

      let intentHTML = switch lineage.narrativeIntent {
      | Some(intent) => `<dt>Narrative Intent:</dt><dd>${intent}</dd>`
      | None => ""
      }

      let symbolicHTML = switch lineage.symbolicWeight {
      | Some(weight) => `<dt>Symbolic Weight:</dt><dd>${weight}</dd>`
      | None => ""
      }

      let traumaHTML = if lineage.traumaMarker {
        `<dt>Trauma Marker:</dt><dd>⚠️ Yes - Handle with care</dd>`
      } else {
        ""
      }

      if originHTML !== "" || contextHTML !== "" || intentHTML !== "" {
        `
<div class="palimpsest-lineage">
  <h5>Emotional Lineage</h5>
  <dl>
    ${originHTML}
    ${contextHTML}
    ${intentHTML}
    ${symbolicHTML}
    ${traumaHTML}
  </dl>
</div>
`
      } else {
        ""
      }
    }
  | None => ""
  }

  // Traceability section
  let traceabilityHTML = switch metadata.traceability {
  | Some(hash) => {
      let blockchainHTML = switch hash.blockchainRef {
      | Some(ref) =>
        if style.showLinks {
          `<dt>Blockchain:</dt><dd><a href="${ref}" target="_blank">View on blockchain</a></dd>`
        } else {
          `<dt>Blockchain:</dt><dd>${ref}</dd>`
        }
      | None => ""
      }

      `
<div class="palimpsest-traceability">
  <h5>Traceability</h5>
  <dl>
    <dt>Algorithm:</dt><dd>${hash.algorithm}</dd>
    <dt>Hash:</dt><dd><code>${hash.value}</code></dd>
    <dt>Timestamp:</dt><dd>${hash.timestamp}</dd>
    ${blockchainHTML}
  </dl>
</div>
`
    }
  | None => ""
  }

  standardDisplay ++ lineageHTML ++ traceabilityHTML
}

// Generate technical display (JSON-LD)
let generateTechnicalDisplay = (metadata: metadata): string => {
  let json = MetadataParser.serialiseString(metadata)

  `
<div class="palimpsest-technical">
  <h4>Technical Metadata (JSON-LD)</h4>
  <pre><code>${json}</code></pre>
  <button class="palimpsest-copy-btn" onclick="navigator.clipboard.writeText(this.previousElementSibling.textContent)">
    Copy to Clipboard
  </button>
</div>
`
}

// Main display function
let display = (metadata: metadata, ~style: displayStyle=defaultStyle): string => {
  switch style.format {
  | Compact => generateCompactDisplay(metadata, ~style)
  | Standard => generateStandardDisplay(metadata, ~style)
  | Detailed => generateDetailedDisplay(metadata, ~style)
  | Technical => generateTechnicalDisplay(metadata)
  }
}

// Generate CSS for metadata display
let generateCSS = (): string => {
  `
.palimpsest-compact {
  display: inline;
  font-size: 0.95rem;
}

.palimpsest-standard {
  border-left: 4px solid #663399;
  padding-left: 1rem;
  margin: 1rem 0;
}

.palimpsest-standard h4 {
  margin: 0 0 0.5rem 0;
  color: #663399;
}

.palimpsest-standard p {
  margin: 0.25rem 0;
}

.palimpsest-trauma-notice {
  background: #fff3cd;
  border: 1px solid #ffc107;
  padding: 0.5rem;
  margin-top: 0.5rem;
  border-radius: 4px;
  font-size: 0.9rem;
}

.palimpsest-lineage,
.palimpsest-traceability {
  margin-top: 1rem;
  padding: 1rem;
  background: #f5f5f5;
  border-radius: 4px;
}

.palimpsest-lineage h5,
.palimpsest-traceability h5 {
  margin: 0 0 0.5rem 0;
  color: #663399;
  font-size: 1rem;
}

.palimpsest-lineage dl,
.palimpsest-traceability dl {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 0.5rem;
  margin: 0;
}

.palimpsest-lineage dt,
.palimpsest-traceability dt {
  font-weight: bold;
}

.palimpsest-lineage dd,
.palimpsest-traceability dd {
  margin: 0;
}

.palimpsest-technical {
  margin: 1rem 0;
}

.palimpsest-technical h4 {
  margin: 0 0 0.5rem 0;
  color: #663399;
}

.palimpsest-technical pre {
  background: #1e1e1e;
  color: #d4d4d4;
  padding: 1rem;
  border-radius: 4px;
  overflow-x: auto;
  margin: 0;
}

.palimpsest-technical code {
  font-family: 'Courier New', Courier, monospace;
  font-size: 0.9rem;
}

.palimpsest-copy-btn {
  background: #663399;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  margin-top: 0.5rem;
  font-size: 0.9rem;
}

.palimpsest-copy-btn:hover {
  background: #552288;
}
`
}

// Generate printable attribution text
let generateAttributionText = (metadata: metadata, ~includeLineage: bool=false): string => {
  let creators = if Belt.Array.length(metadata.attribution.creators) > 0 {
    metadata.attribution.creators->Belt.Array.map(c => c.name)->Js.Array.joinWith(", ")
  } else {
    "Unknown"
  }

  let basicAttribution = `"${metadata.workTitle}" by ${creators} is licensed under Palimpsest License v${versionToString(
      metadata.version,
    )} (${metadata.licenseUri})`

  if includeLineage && Belt.Option.isSome(metadata.emotionalLineage) {
    switch metadata.emotionalLineage {
    | Some(lineage) => {
        let lineageNote = switch lineage.origin {
        | Some(origin) => ` This work originates from ${origin}.`
        | None => ""
        }

        let traumaNote = if lineage.traumaMarker {
          " This work contains trauma narratives and should be handled with cultural sensitivity."
        } else {
          ""
        }

        basicAttribution ++ lineageNote ++ traumaNote
      }
    | None => basicAttribution
    }
  } else {
    basicAttribution
  }
}

// Generate machine-readable attribution (HTML microdata)
let generateMicrodataAttribution = (metadata: metadata): string => {
  let creators = metadata.attribution.creators
    ->Belt.Array.map(creator => {
      switch creator.identifier {
      | Some(id) =>
        `<span itemscope itemtype="http://schema.org/Person" itemprop="creator">
          <a itemprop="url" href="${id}"><span itemprop="name">${creator.name}</span></a>
        </span>`
      | None =>
        `<span itemscope itemtype="http://schema.org/Person" itemprop="creator">
          <span itemprop="name">${creator.name}</span>
        </span>`
      }
    })
    ->Js.Array.joinWith(", ")

  `<div itemscope itemtype="http://schema.org/CreativeWork">
  <span itemprop="name">"${metadata.workTitle}"</span> by ${creators}
  is licensed under
  <a itemprop="license" href="${metadata.licenseUri}">Palimpsest License v${versionToString(
    metadata.version,
  )}</a>
</div>`
}
