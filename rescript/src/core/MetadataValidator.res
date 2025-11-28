// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Validator for Palimpsest License metadata
// Ensures metadata structure and content meets specification

open PalimpsestTypes

// Helper to create validation error
let makeError = (field: string, message: string, ~severity: [#error | #warning]=#error): validationError => {
  {field, message, severity}
}

// Validate URI format (basic check)
let isValidUri = (uri: string): bool => {
  Js.Re.test_(%re("/^https?:\/\/.+/i"), uri) || Js.Re.test_(%re("/^urn:.+/i"), uri)
}

// Validate ISO 8601 date format (basic check)
let isValidDate = (date: string): bool => {
  Js.Re.test_(%re("/^\d{4}-\d{2}-\d{2}/"), date)
}

// Validate email format (basic check)
let isValidEmail = (email: string): bool => {
  Js.Re.test_(%re("/^[^\s@]+@[^\s@]+\.[^\s@]+$/"), email)
}

// Validate creator
let validateCreator = (creator: creator, index: int): array<validationError> => {
  let errors = []

  // Name is required and should not be empty
  if Js.String.trim(creator.name) === "" {
    Js.Array.push(
      makeError(
        "attribution.creators[" ++ Belt.Int.toString(index) ++ "].name",
        "Creator name cannot be empty",
      ),
      errors,
    )->ignore
  }

  // Validate identifier if present (should be a URI)
  switch creator.identifier {
  | Some(id) if !isValidUri(id) => {
      Js.Array.push(
        makeError(
          "attribution.creators[" ++ Belt.Int.toString(index) ++ "].identifier",
          "Creator identifier should be a valid URI (e.g., ORCID, URL)",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  // Validate contact if present (should be email or URL)
  switch creator.contact {
  | Some(contact) if !isValidEmail(contact) && !isValidUri(contact) => {
      Js.Array.push(
        makeError(
          "attribution.creators[" ++ Belt.Int.toString(index) ++ "].contact",
          "Creator contact should be a valid email or URI",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  errors
}

// Validate attribution
let validateAttribution = (attribution: attribution): array<validationError> => {
  let errors = []

  // At least one creator is required
  if Belt.Array.length(attribution.creators) === 0 {
    Js.Array.push(
      makeError("attribution.creators", "At least one creator is required"),
      errors,
    )->ignore
  } else {
    // Validate each creator
    attribution.creators->Belt.Array.forEachWithIndex((index, creator) => {
      let creatorErrors = validateCreator(creator, index)
      Js.Array.pushMany(creatorErrors, errors)->ignore
    })
  }

  // Validate source URI if present
  switch attribution.source {
  | Some(source) if !isValidUri(source) => {
      Js.Array.push(
        makeError("attribution.source", "Source should be a valid URI", ~severity=#warning),
        errors,
      )->ignore
    }
  | _ => ()
  }

  // Validate dateCreated if present
  switch attribution.dateCreated {
  | Some(date) if !isValidDate(date) => {
      Js.Array.push(
        makeError(
          "attribution.dateCreated",
          "Date should be in ISO 8601 format (YYYY-MM-DD)",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  errors
}

// Validate emotional lineage
let validateEmotionalLineage = (lineage: emotionalLineage): array<validationError> => {
  let errors = []

  // If trauma marker is set, cultural context or narrative intent should be provided
  if lineage.traumaMarker &&
    Belt.Option.isNone(lineage.culturalContext) &&
    Belt.Option.isNone(lineage.narrativeIntent) {
    Js.Array.push(
      makeError(
        "emotionalLineage",
        "When trauma marker is set, cultural context or narrative intent should be specified",
        ~severity=#warning,
      ),
      errors,
    )->ignore
  }

  errors
}

// Validate consent
let validateConsent = (consent: consent, index: int): array<validationError> => {
  let errors = []

  // Validate dates if present
  switch consent.grantedDate {
  | Some(date) if !isValidDate(date) => {
      Js.Array.push(
        makeError(
          "consents[" ++ Belt.Int.toString(index) ++ "].grantedDate",
          "Date should be in ISO 8601 format (YYYY-MM-DD)",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  switch consent.expiryDate {
  | Some(date) if !isValidDate(date) => {
      Js.Array.push(
        makeError(
          "consents[" ++ Belt.Int.toString(index) ++ "].expiryDate",
          "Date should be in ISO 8601 format (YYYY-MM-DD)",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  // Check that granted/expiry dates make sense
  switch (consent.grantedDate, consent.expiryDate) {
  | (Some(granted), Some(expiry)) if granted > expiry => {
      Js.Array.push(
        makeError(
          "consents[" ++ Belt.Int.toString(index) ++ "]",
          "Expiry date should be after granted date",
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  // Conditional consent should have conditions
  switch consent.status {
  | ConditionallyGranted(_) if Belt.Option.isNone(consent.conditions) => {
      Js.Array.push(
        makeError(
          "consents[" ++ Belt.Int.toString(index) ++ "].conditions",
          "Conditionally granted consent should specify conditions",
          ~severity=#warning,
        ),
        errors,
      )->ignore
    }
  | _ => ()
  }

  errors
}

// Validate traceability hash
let validateTraceabilityHash = (hash: traceabilityHash): array<validationError> => {
  let errors = []

  // Algorithm should not be empty
  if Js.String.trim(hash.algorithm) === "" {
    Js.Array.push(makeError("traceability.algorithm", "Algorithm cannot be empty"), errors)->ignore
  }

  // Value should not be empty
  if Js.String.trim(hash.value) === "" {
    Js.Array.push(makeError("traceability.value", "Hash value cannot be empty"), errors)->ignore
  }

  // Timestamp should be valid ISO date
  if !isValidDate(hash.timestamp) && !Js.Re.test_(%re("/^\d{4}-\d{2}-\d{2}T/"), hash.timestamp) {
    Js.Array.push(
      makeError(
        "traceability.timestamp",
        "Timestamp should be in ISO 8601 format",
        ~severity=#warning,
      ),
      errors,
    )->ignore
  }

  errors
}

// Main validation function
let validate = (metadata: metadata): validationResult => {
  let allErrors = []

  // Validate work title
  if Js.String.trim(metadata.workTitle) === "" {
    Js.Array.push(makeError("workTitle", "Work title cannot be empty"), allErrors)->ignore
  }

  // Validate license URI
  if !isValidUri(metadata.licenseUri) {
    Js.Array.push(makeError("licenseUri", "License URI should be a valid URI"), allErrors)->ignore
  }

  // Validate work identifier if present
  switch metadata.workIdentifier {
  | Some(id) if !isValidUri(id) => {
      Js.Array.push(
        makeError("workIdentifier", "Work identifier should be a valid URI", ~severity=#warning),
        allErrors,
      )->ignore
    }
  | _ => ()
  }

  // Validate attribution
  let attributionErrors = validateAttribution(metadata.attribution)
  Js.Array.pushMany(attributionErrors, allErrors)->ignore

  // Validate emotional lineage if present
  switch metadata.emotionalLineage {
  | Some(lineage) => {
      let lineageErrors = validateEmotionalLineage(lineage)
      Js.Array.pushMany(lineageErrors, allErrors)->ignore
    }
  | None => {
      // Warning if lineage preservation is required but no lineage data
      if metadata.attribution.mustPreserveLineage {
        Js.Array.push(
          makeError(
            "emotionalLineage",
            "Lineage preservation is required but emotional lineage data is missing",
            ~severity=#warning,
          ),
          allErrors,
        )->ignore
      }
    }
  }

  // Validate consents
  metadata.consents->Belt.Array.forEachWithIndex((index, consent) => {
    let consentErrors = validateConsent(consent, index)
    Js.Array.pushMany(consentErrors, allErrors)->ignore
  })

  // Validate traceability if present
  switch metadata.traceability {
  | Some(hash) => {
      let hashErrors = validateTraceabilityHash(hash)
      Js.Array.pushMany(hashErrors, allErrors)->ignore
    }
  | None => {
      // Warning for v0.4+ without traceability
      switch metadata.version {
      | V04 | Custom(_) => {
          Js.Array.push(
            makeError(
              "traceability",
              "Traceability hash is recommended for v0.4+ licenses",
              ~severity=#warning,
            ),
            allErrors,
          )->ignore
        }
      | V03 => ()
      }
    }
  }

  // Return result
  if Belt.Array.length(allErrors) === 0 {
    Valid
  } else {
    Invalid(allErrors)
  }
}

// Quick validation check (returns true/false)
let isValid = (metadata: metadata): bool => {
  switch validate(metadata) {
  | Valid => true
  | Invalid(_) => false
  }
}

// Get only errors (not warnings)
let getErrors = (result: validationResult): array<validationError> => {
  switch result {
  | Valid => []
  | Invalid(errors) => errors->Belt.Array.keep(e => e.severity === #error)
  }
}

// Get only warnings
let getWarnings = (result: validationResult): array<validationError> => {
  switch result {
  | Valid => []
  | Invalid(errors) => errors->Belt.Array.keep(e => e.severity === #warning)
  }
}

// Generate validation report
let generateReport = (result: validationResult): string => {
  switch result {
  | Valid => "✓ Metadata is valid\n"
  | Invalid(errors) => {
      let errorCount = errors->Belt.Array.keep(e => e.severity === #error)->Belt.Array.length
      let warningCount = errors->Belt.Array.keep(e => e.severity === #warning)->Belt.Array.length

      let header = "Metadata Validation Report\n"
      let summary =
        "Errors: " ++
        Belt.Int.toString(errorCount) ++
        ", Warnings: " ++
        Belt.Int.toString(warningCount) ++ "\n\n"

      let issuesList = errors
        ->Belt.Array.mapWithIndex((idx, error) => {
          let severitySymbol = switch error.severity {
          | #error => "🔴"
          | #warning => "🟡"
          }

          Belt.Int.toString(idx + 1) ++
          ". " ++
          severitySymbol ++
          " " ++
          error.field ++
          "\n" ++
          "  " ++
          error.message ++ "\n"
        })
        ->Js.Array.joinWith("\n")

      header ++ summary ++ issuesList
    }
  }
}
