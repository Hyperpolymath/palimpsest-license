// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Embeddable license verification widget
// Provides a complete, interactive license information display

open PalimpsestTypes

// Widget configuration
type widgetConfig = {
  showBadge: bool,
  showMetadata: bool,
  showCompliance: bool,
  showConsents: bool,
  expandable: bool,
  theme: [#light | #dark | #auto],
}

let defaultConfig: widgetConfig = {
  showBadge: true,
  showMetadata: true,
  showCompliance: false,
  showConsents: true,
  expandable: true,
  theme: #light,
}

// Generate CSS for widget
let generateWidgetCSS = (theme: [#light | #dark | #auto]): string => {
  let (bgColour, textColour, borderColour, accentColour) = switch theme {
  | #light => ("#ffffff", "#333333", "#e0e0e0", "#663399")
  | #dark => ("#1e1e1e", "#e0e0e0", "#333333", "#9966cc")
  | #auto =>
    // Use CSS variables that can be customised
    ("var(--palimpsest-bg, #ffffff)", "var(--palimpsest-text, #333333)", "var(--palimpsest-border, #e0e0e0)", "var(--palimpsest-accent, #663399)")
  }

  `
.palimpsest-widget {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  background: ${bgColour};
  color: ${textColour};
  border: 1px solid ${borderColour};
  border-radius: 8px;
  padding: 1rem;
  margin: 1rem 0;
  max-width: 600px;
}

.palimpsest-widget h3 {
  margin: 0 0 0.5rem 0;
  color: ${accentColour};
  font-size: 1.1rem;
}

.palimpsest-widget h4 {
  margin: 1rem 0 0.5rem 0;
  font-size: 0.95rem;
  color: ${textColour};
}

.palimpsest-widget dl {
  display: grid;
  grid-template-columns: auto 1fr;
  gap: 0.5rem;
  margin: 0;
}

.palimpsest-widget dt {
  font-weight: bold;
  color: ${accentColour};
}

.palimpsest-widget dd {
  margin: 0;
}

.palimpsest-widget a {
  color: ${accentColour};
  text-decoration: none;
}

.palimpsest-widget a:hover {
  text-decoration: underline;
}

.palimpsest-badge {
  margin-bottom: 1rem;
  display: inline-block;
}

.palimpsest-consent-list {
  list-style: none;
  padding: 0;
  margin: 0.5rem 0;
}

.palimpsest-consent-item {
  padding: 0.5rem;
  margin: 0.25rem 0;
  border-left: 3px solid;
  background: rgba(0, 0, 0, 0.02);
}

.palimpsest-consent-granted {
  border-left-color: #4caf50;
}

.palimpsest-consent-denied {
  border-left-color: #f44336;
}

.palimpsest-consent-conditional {
  border-left-color: #ff9800;
}

.palimpsest-consent-unspecified {
  border-left-color: #9e9e9e;
}

.palimpsest-expandable {
  cursor: pointer;
  user-select: none;
}

.palimpsest-expandable::before {
  content: "▼ ";
  display: inline-block;
  transition: transform 0.2s;
}

.palimpsest-expandable.collapsed::before {
  transform: rotate(-90deg);
}

.palimpsest-content {
  max-height: 1000px;
  overflow: hidden;
  transition: max-height 0.3s ease;
}

.palimpsest-content.collapsed {
  max-height: 0;
}

.palimpsest-timestamp {
  font-size: 0.85rem;
  color: #888;
  margin-top: 0.5rem;
}

.palimpsest-compliance {
  margin-top: 1rem;
  padding: 0.75rem;
  border-radius: 4px;
}

.palimpsest-compliant {
  background: #e8f5e9;
  border-left: 4px solid #4caf50;
}

.palimpsest-non-compliant {
  background: #ffebee;
  border-left: 4px solid #f44336;
}

.palimpsest-issues {
  list-style: none;
  padding: 0;
  margin: 0.5rem 0;
}

.palimpsest-issues li {
  padding: 0.5rem;
  margin: 0.25rem 0;
  background: rgba(0, 0, 0, 0.05);
  border-radius: 4px;
}

.palimpsest-critical {
  border-left: 3px solid #f44336;
}

.palimpsest-major {
  border-left: 3px solid #ff9800;
}

.palimpsest-minor {
  border-left: 3px solid #ffc107;
}
`
}

// Generate HTML for metadata section
let generateMetadataHTML = (metadata: metadata): string => {
  let creatorsHTML = if Belt.Array.length(metadata.attribution.creators) > 0 {
    let creatorsList = metadata.attribution.creators
      ->Belt.Array.map(creator => {
        let identifierLink = switch creator.identifier {
        | Some(id) => ` (<a href="${id}" target="_blank">profile</a>)`
        | None => ""
        }
        creator.name ++ identifierLink
      })
      ->Js.Array.joinWith(", ")

    `<dt>Creator(s):</dt><dd>${creatorsList}</dd>`
  } else {
    ""
  }

  let sourceHTML = switch metadata.attribution.source {
  | Some(source) => `<dt>Source:</dt><dd><a href="${source}" target="_blank">${source}</a></dd>`
  | None => ""
  }

  let workIdentifierHTML = switch metadata.workIdentifier {
  | Some(id) => `<dt>Work ID:</dt><dd><a href="${id}" target="_blank">${id}</a></dd>`
  | None => ""
  }

  `
<h4>Metadata</h4>
<dl>
  <dt>Work Title:</dt>
  <dd>${metadata.workTitle}</dd>
  ${creatorsHTML}
  ${sourceHTML}
  ${workIdentifierHTML}
  <dt>License:</dt>
  <dd><a href="${metadata.licenseUri}" target="_blank">Palimpsest License v${versionToString(
    metadata.version,
  )}</a></dd>
  <dt>Language:</dt>
  <dd>${languageToString(metadata.language)}</dd>
</dl>
`
}

// Generate HTML for consents section
let generateConsentsHTML = (consents: array<consent>): string => {
  if Belt.Array.length(consents) === 0 {
    "<p><em>No consent records specified.</em></p>"
  } else {
    let consentItems = consents
      ->Belt.Array.map(consent => {
        let (statusText, statusClass) = switch consent.status {
        | Granted => ("Granted", "palimpsest-consent-granted")
        | Denied => ("Denied", "palimpsest-consent-denied")
        | ConditionallyGranted(cond) => ("Conditional: " ++ cond, "palimpsest-consent-conditional")
        | NotSpecified => ("Not Specified", "palimpsest-consent-unspecified")
        }

        let expiryText = switch consent.expiryDate {
        | Some(date) => ` (expires: ${date})`
        | None => ""
        }

        let revocableText = if consent.revocable {
          " • Revocable"
        } else {
          ""
        }

        `<li class="palimpsest-consent-item ${statusClass}">
          <strong>${usageTypeToString(consent.usageType)}</strong>: ${statusText}${expiryText}${revocableText}
        </li>`
      })
      ->Js.Array.joinWith("")

    `
<h4>Usage Consents</h4>
<ul class="palimpsest-consent-list">
  ${consentItems}
</ul>
`
  }
}

// Generate HTML for compliance section
let generateComplianceHTML = (result: complianceResult): string => {
  let statusClass = if result.isCompliant {
    "palimpsest-compliant"
  } else {
    "palimpsest-non-compliant"
  }

  let statusText = if result.isCompliant {
    "✓ Compliant"
  } else {
    "✗ Non-Compliant"
  }

  let issuesHTML = if Belt.Array.length(result.issues) > 0 {
    let issuesList = result.issues
      ->Belt.Array.map(issue => {
        let severityClass = switch issue.severity {
        | #critical => "palimpsest-critical"
        | #major => "palimpsest-major"
        | #minor => "palimpsest-minor"
        }

        `<li class="${severityClass}">
          <strong>${issue.clause}</strong>: ${issue.description}
        </li>`
      })
      ->Js.Array.joinWith("")

    `<ul class="palimpsest-issues">${issuesList}</ul>`
  } else {
    "<p>No compliance issues found.</p>"
  }

  `
<div class="palimpsest-compliance ${statusClass}">
  <h4>${statusText}</h4>
  ${issuesHTML}
  <p class="palimpsest-timestamp">Checked: ${result.checkedAt}</p>
</div>
`
}

// Generate complete widget HTML
let generateWidgetHTML = (
  ~metadata: metadata,
  ~config: widgetConfig=defaultConfig,
  ~complianceResult: option<complianceResult>=?,
): string => {
  let badgeHTML = if config.showBadge {
    let badge = BadgeGenerator.generateVersionBadge(metadata)
    `<div class="palimpsest-badge">${badge}</div>`
  } else {
    ""
  }

  let metadataHTML = if config.showMetadata {
    generateMetadataHTML(metadata)
  } else {
    ""
  }

  let consentsHTML = if config.showConsents {
    generateConsentsHTML(metadata.consents)
  } else {
    ""
  }

  let complianceHTML = switch (config.showCompliance, complianceResult) {
  | (true, Some(result)) => generateComplianceHTML(result)
  | _ => ""
  }

  let expandableClass = if config.expandable {
    " palimpsest-expandable"
  } else {
    ""
  }

  `
<div class="palimpsest-widget">
  ${badgeHTML}
  <h3 class="${expandableClass}">License Information</h3>
  <div class="palimpsest-content">
    ${metadataHTML}
    ${consentsHTML}
    ${complianceHTML}
  </div>
</div>
`
}

// Generate complete widget with CSS
let generateWidget = (
  ~metadata: metadata,
  ~config: widgetConfig=defaultConfig,
  ~complianceResult: option<complianceResult>=?,
  ~includeCSS: bool=true,
): string => {
  let css = if includeCSS {
    "<style>" ++ generateWidgetCSS(config.theme) ++ "</style>"
  } else {
    ""
  }

  let html = generateWidgetHTML(~metadata, ~config, ~complianceResult?)

  css ++ html
}

// Generate JavaScript for interactive widget
let generateWidgetJS = (): string => {
  `
(function() {
  // Make widget sections expandable
  document.querySelectorAll('.palimpsest-expandable').forEach(function(header) {
    header.addEventListener('click', function() {
      this.classList.toggle('collapsed');
      var content = this.nextElementSibling;
      if (content && content.classList.contains('palimpsest-content')) {
        content.classList.toggle('collapsed');
      }
    });
  });

  // Auto-expand if window.location.hash includes 'palimpsest'
  if (window.location.hash.includes('palimpsest')) {
    document.querySelectorAll('.palimpsest-expandable.collapsed').forEach(function(header) {
      header.click();
    });
  }
})();
`
}

// Generate embeddable snippet (HTML + CSS + JS)
let generateEmbeddableSnippet = (
  ~metadata: metadata,
  ~config: widgetConfig=defaultConfig,
  ~complianceResult: option<complianceResult>=?,
): string => {
  let widget = generateWidget(~metadata, ~config, ~complianceResult?, ~includeCSS=true)
  let js = "<script>" ++ generateWidgetJS() ++ "</script>"

  widget ++ js
}
