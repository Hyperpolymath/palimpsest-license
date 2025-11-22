// Web platform integration helpers
// Provides utilities for embedding Palimpsest License in web applications

open PalimpsestTypes

// DOM manipulation helpers
@val external document: 'a = "document"
@send external getElementById: ('a, string) => option<'b> = "getElementById"
@send external querySelector: ('a, string) => option<'b> = "querySelector"
@send external querySelectorAll: ('a, string) => array<'b> = "querySelectorAll"
@set external setInnerHTML: ('a, string) => unit = "innerHTML"
@set external setTextContent: ('a, string) => unit = "textContent"
@send external setAttribute: ('a, string, string) => unit = "setAttribute"
@send external appendChild: ('a, 'b) => unit = "appendChild"
@send external createElement: ('a, string) => 'b = "createElement"

// Extract metadata from page's script tag
let extractMetadataFromScript = (scriptId: string): option<metadata> => {
  try {
    getElementById(document, scriptId)
    ->Belt.Option.flatMap(element => {
      // Get text content of script tag
      let textContent = element["textContent"]
      switch textContent {
      | Some(content) => {
          switch MetadataParser.parseString(content) {
          | Ok(metadata) => Some(metadata)
          | Error(_) => None
          }
        }
      | None => None
      }
    })
  } catch {
  | _ => None
  }
}

// Extract metadata from meta tags
let extractMetadataFromMetaTags = (): option<metadata> => {
  try {
    // Look for meta tags with license information
    let versionMeta = querySelector(document, "meta[name='palimpsest:version']")
    let titleMeta = querySelector(document, "meta[name='palimpsest:title']")
    let uriMeta = querySelector(document, "meta[name='palimpsest:uri']")

    switch (titleMeta, uriMeta) {
    | (Some(title), Some(uri)) => {
        let version = versionMeta
          ->Belt.Option.flatMap(v => v["content"])
          ->Belt.Option.map(versionFromString)
          ->Belt.Option.getWithDefault(V04)

        Some({
          version: version,
          language: En,
          workTitle: title["content"]->Belt.Option.getWithDefault(""),
          workIdentifier: None,
          licenseUri: uri["content"]->Belt.Option.getWithDefault(""),
          attribution: {
            creators: [],
            source: None,
            originalTitle: None,
            dateCreated: None,
            mustPreserveLineage: false,
          },
          consents: [],
          emotionalLineage: None,
          traceability: None,
          customFields: None,
        })
      }
    | _ => None
    }
  } catch {
  | _ => None
  }
}

// Inject badge into DOM element
let injectBadge = (
  ~elementId: string,
  ~badge: string,
  ~format: [#svg | #html]=#html,
): result<unit, string> => {
  try {
    getElementById(document, elementId)
    ->Belt.Option.map(element => {
      switch format {
      | #svg => setTextContent(element, badge)
      | #html => setInnerHTML(element, badge)
      }
      Ok()
    })
    ->Belt.Option.getWithDefault(Error("Element not found: " ++ elementId))
  } catch {
  | Js.Exn.Error(e) => {
      let message = Js.Exn.message(e)->Belt.Option.getWithDefault("Unknown error")
      Error(message)
    }
  }
}

// Inject metadata display into DOM
let injectMetadataDisplay = (~elementId: string, ~metadata: metadata): result<unit, string> => {
  try {
    getElementById(document, elementId)
    ->Belt.Option.map(element => {
      // Create HTML for metadata display
      let html = `
        <div class="palimpsest-metadata">
          <h3>License Information</h3>
          <dl>
            <dt>License:</dt>
            <dd><a href="${metadata.licenseUri}" target="_blank">Palimpsest License v${versionToString(
          metadata.version,
        )}</a></dd>
            <dt>Work:</dt>
            <dd>${metadata.workTitle}</dd>
            ${switch Belt.Array.get(metadata.attribution.creators, 0) {
        | Some(creator) =>
          `<dt>Creator:</dt>
            <dd>${creator.name}</dd>`
        | None => ""
        }}
          </dl>
        </div>
      `
      setInnerHTML(element, html)
      Ok()
    })
    ->Belt.Option.getWithDefault(Error("Element not found: " ++ elementId))
  } catch {
  | Js.Exn.Error(e) => {
      let message = Js.Exn.message(e)->Belt.Option.getWithDefault("Unknown error")
      Error(message)
    }
  }
}

// Create and inject compliance notice
let injectComplianceNotice = (
  ~elementId: string,
  ~result: complianceResult,
): result<unit, string> => {
  try {
    getElementById(document, elementId)
    ->Belt.Option.map(element => {
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

      let issuesHtml = if Belt.Array.length(result.issues) > 0 {
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
        ""
      }

      let html = `
        <div class="palimpsest-compliance ${statusClass}">
          <h3>${statusText}</h3>
          ${issuesHtml}
          <p class="palimpsest-timestamp">Checked: ${result.checkedAt}</p>
        </div>
      `

      setInnerHTML(element, html)
      Ok()
    })
    ->Belt.Option.getWithDefault(Error("Element not found: " ++ elementId))
  } catch {
  | Js.Exn.Error(e) => {
      let message = Js.Exn.message(e)->Belt.Option.getWithDefault("Unknown error")
      Error(message)
    }
  }
}

// Generate structured data (JSON-LD) for search engines
let generateStructuredData = (metadata: metadata): string => {
  let creators = metadata.attribution.creators
    ->Belt.Array.map(creator => {
      let creatorJson = Js.Dict.empty()
      Js.Dict.set(creatorJson, "@type", Js.Json.string("Person"))
      Js.Dict.set(creatorJson, "name", Js.Json.string(creator.name))

      switch creator.identifier {
      | Some(id) => Js.Dict.set(creatorJson, "@id", Js.Json.string(id))
      | None => ()
      }

      Js.Json.object_(creatorJson)
    })

  let structuredData = Js.Dict.empty()
  Js.Dict.set(structuredData, "@context", Js.Json.string("https://schema.org"))
  Js.Dict.set(structuredData, "@type", Js.Json.string("CreativeWork"))
  Js.Dict.set(structuredData, "name", Js.Json.string(metadata.workTitle))
  Js.Dict.set(structuredData, "license", Js.Json.string(metadata.licenseUri))

  if Belt.Array.length(creators) > 0 {
    Js.Dict.set(structuredData, "creator", Js.Json.array(creators))
  }

  switch metadata.attribution.dateCreated {
  | Some(date) => Js.Dict.set(structuredData, "dateCreated", Js.Json.string(date))
  | None => ()
  }

  Js.Json.object_(structuredData)->Js.Json.stringify
}

// Inject structured data into page
let injectStructuredData = (~metadata: metadata): result<unit, string> => {
  try {
    let script = createElement(document, "script")
    setAttribute(script, "type", "application/ld+json")
    setTextContent(script, generateStructuredData(metadata))

    let head = querySelector(document, "head")
    switch head {
    | Some(headElement) => {
        appendChild(headElement, script)
        Ok()
      }
    | None => Error("Could not find head element")
    }
  } catch {
  | Js.Exn.Error(e) => {
      let message = Js.Exn.message(e)->Belt.Option.getWithDefault("Unknown error")
      Error(message)
    }
  }
}

// Auto-initialize license display on page load
let autoInitialize = (~metadataSource: [#scriptId(string) | #metaTags | #inline(metadata)]): unit => {
  try {
    let metadata = switch metadataSource {
    | #scriptId(id) => extractMetadataFromScript(id)
    | #metaTags => extractMetadataFromMetaTags()
    | #inline(m) => Some(m)
    }

    switch metadata {
    | Some(m) => {
        // Try to inject badge if element exists
        let _ = injectBadge(
          ~elementId="palimpsest-badge",
          ~badge=BadgeGenerator.generateVersionBadge(m)->BadgeGenerator.generateHtmlBadge(
            ~licenseUrl=Some(m.licenseUri),
          ),
        )

        // Try to inject metadata display if element exists
        let _ = injectMetadataDisplay(~elementId="palimpsest-metadata", ~metadata=m)

        // Inject structured data
        let _ = injectStructuredData(~metadata=m)

        ()
      }
    | None => ()
    }
  } catch {
  | _ => ()
  }
}

// Export for use in window.onload or DOMContentLoaded
@val external addEventListener: (string, unit => unit) => unit = "window.addEventListener"

let initializeOnLoad = (~metadataSource: [#scriptId(string) | #metaTags | #inline(metadata)]): unit => {
  addEventListener("DOMContentLoaded", () => autoInitialize(~metadataSource))
}
