// Compliance checker for Palimpsest License
// Validates usage against license terms and consent grants

open PalimpsestTypes

// Get current ISO timestamp
let getCurrentTimestamp = (): string => {
  Js.Date.make()->Js.Date.toISOString
}

// Check if metadata has required attribution information
let checkAttribution = (metadata: metadata): array<complianceIssue> => {
  let issues = []

  // Check if creators are specified
  if Belt.Array.length(metadata.attribution.creators) === 0 {
    Js.Array.push(
      {
        clause: "2.3 - Attribution",
        description: "No creators specified in attribution metadata",
        severity: #major,
        remediation: Some("Add creator information to metadata"),
      },
      issues,
    )->ignore
  }

  // Check if lineage preservation is required but emotional lineage is missing
  if metadata.attribution.mustPreserveLineage && Belt.Option.isNone(metadata.emotionalLineage) {
    Js.Array.push(
      {
        clause: "2.3 - Emotional Lineage",
        description: "Lineage preservation required but emotional lineage data is missing",
        severity: #critical,
        remediation: Some("Add emotional lineage metadata including origin, cultural context, and narrative intent"),
      },
      issues,
    )->ignore
  }

  issues
}

// Check if traceability requirements are met
let checkTraceability = (metadata: metadata): array<complianceIssue> => {
  let issues = []

  // For v0.4+, traceability hash should be present
  switch metadata.version {
  | V04 | Custom(_) => {
      if Belt.Option.isNone(metadata.traceability) {
        Js.Array.push(
          {
            clause: "Quantum-Proof Traceability",
            description: "No traceability hash found for v0.4+ license",
            severity: #major,
            remediation: Some("Generate and include quantum-proof traceability hash"),
          },
          issues,
        )->ignore
      }
    }
  | V03 => () // Not required for v0.3
  }

  issues
}

// Find consent for specific usage type
let findConsent = (metadata: metadata, usageType: usageType): option<consent> => {
  metadata.consents->Belt.Array.getBy(consent => consent.usageType === usageType)
}

// Check if usage is permitted based on consents
let checkUsagePermission = (
  metadata: metadata,
  requestedUsage: usageType,
  currentDate: option<string>=?,
): array<complianceIssue> => {
  let issues = []

  switch findConsent(metadata, requestedUsage) {
  | None => {
      // No consent record found
      switch requestedUsage {
      | Interpretive | Training => {
          // Clause 1.2: Non-Interpretive systems require explicit consent
          Js.Array.push(
            {
              clause: "1.2 - Non-Interpretive Use",
              description: "Interpretive or training use requires explicit consent",
              severity: #critical,
              remediation: Some("Obtain explicit consent for AI interpretive use or training"),
            },
            issues,
          )->ignore
        }
      | NonInterpretive | Personal => () // Generally allowed
      | Derivative => {
          Js.Array.push(
            {
              clause: "Derivative Works",
              description: "No consent found for derivative works",
              severity: #major,
              remediation: Some("Verify if derivative use is permitted and obtain consent if needed"),
            },
            issues,
          )->ignore
        }
      | Commercial => {
          Js.Array.push(
            {
              clause: "Commercial Use",
              description: "No consent found for commercial use",
              severity: #major,
              remediation: Some("Obtain consent for commercial use"),
            },
            issues,
          )->ignore
        }
      }
    }
  | Some(consent) => {
      // Consent found, check status
      switch consent.status {
      | Denied => {
          Js.Array.push(
            {
              clause: "Usage Consent",
              description: "Consent explicitly denied for " ++ usageTypeToString(requestedUsage),
              severity: #critical,
              remediation: Some("This usage is not permitted under the license"),
            },
            issues,
          )->ignore
        }
      | NotSpecified => {
          Js.Array.push(
            {
              clause: "Usage Consent",
              description: "Consent status not specified for " ++ usageTypeToString(requestedUsage),
              severity: #major,
              remediation: Some("Clarify consent status with rights holder"),
            },
            issues,
          )->ignore
        }
      | Granted | ConditionallyGranted(_) => {
          // Check if consent is still valid (not expired)
          if !isConsentValid(consent, ~currentDate?) {
            Js.Array.push(
              {
                clause: "Usage Consent",
                description: "Consent has expired for " ++ usageTypeToString(requestedUsage),
                severity: #critical,
                remediation: Some("Renew consent with rights holder"),
              },
              issues,
            )->ignore
          }

          // If conditionally granted, note the conditions
          switch consent.status {
          | ConditionallyGranted(conditions) => {
              Js.Array.push(
                {
                  clause: "Usage Consent",
                  description: "Usage permitted with conditions: " ++ conditions,
                  severity: #minor,
                  remediation: Some("Ensure all specified conditions are met"),
                },
                issues,
              )->ignore
            }
          | _ => ()
          }
        }
      }
    }
  }

  issues
}

// Comprehensive compliance check
let check = (
  metadata: metadata,
  requestedUsages: array<usageType>,
  ~currentDate: option<string>=?,
): complianceResult => {
  let allIssues = []

  // Check attribution
  let attributionIssues = checkAttribution(metadata)
  Js.Array.pushMany(attributionIssues, allIssues)->ignore

  // Check traceability
  let traceabilityIssues = checkTraceability(metadata)
  Js.Array.pushMany(traceabilityIssues, allIssues)->ignore

  // Check each requested usage
  requestedUsages->Belt.Array.forEach(usage => {
    let usageIssues = checkUsagePermission(metadata, usage, ~currentDate?)
    Js.Array.pushMany(usageIssues, allIssues)->ignore
  })

  // Determine overall compliance
  let hasCriticalIssues = allIssues->Belt.Array.some(issue => issue.severity === #critical)

  {
    isCompliant: !hasCriticalIssues,
    issues: allIssues,
    checkedAt: getCurrentTimestamp(),
  }
}

// Quick check for single usage type
let checkUsage = (
  metadata: metadata,
  usage: usageType,
  ~currentDate: option<string>=?,
): complianceResult => {
  check(metadata, [usage], ~currentDate?)
}

// Check if metadata stripping has occurred (Clause 2.3 violation)
let checkMetadataIntegrity = (
  original: metadata,
  derivative: metadata,
): array<complianceIssue> => {
  let issues = []

  // Check if attribution is preserved
  if Belt.Array.length(derivative.attribution.creators) < Belt.Array.length(original.attribution.creators) {
    Js.Array.push(
      {
        clause: "2.3 - Metadata Preservation",
        description: "Creator attribution has been stripped or reduced",
        severity: #critical,
        remediation: Some("Restore complete creator attribution from original"),
      },
      issues,
    )->ignore
  }

  // Check if emotional lineage is preserved when required
  if original.attribution.mustPreserveLineage {
    switch (original.emotionalLineage, derivative.emotionalLineage) {
    | (Some(_), None) => {
        Js.Array.push(
          {
            clause: "2.3 - Emotional Lineage",
            description: "Emotional lineage metadata has been stripped",
            severity: #critical,
            remediation: Some("Restore emotional lineage metadata from original"),
          },
          issues,
        )->ignore
      }
    | _ => ()
    }
  }

  // Check if traceability is preserved
  switch (original.traceability, derivative.traceability) {
  | (Some(_), None) => {
      Js.Array.push(
        {
          clause: "Traceability",
          description: "Traceability hash has been stripped",
          severity: #critical,
          remediation: Some("Restore traceability hash or create new hash linking to original"),
        },
        issues,
      )->ignore
    }
  | _ => ()
  }

  issues
}

// Generate compliance report
let generateReport = (result: complianceResult): string => {
  let status = if result.isCompliant {
    "✓ COMPLIANT"
  } else {
    "✗ NON-COMPLIANT"
  }

  let header = "Palimpsest License Compliance Report\n"
  let statusLine = "Status: " ++ status ++ "\n"
  let timestamp = "Checked at: " ++ result.checkedAt ++ "\n\n"

  let issuesSection = if Belt.Array.length(result.issues) === 0 {
    "No compliance issues found.\n"
  } else {
    let issueCount = "Issues found: " ++ Belt.Int.toString(Belt.Array.length(result.issues)) ++ "\n\n"

    let issuesList = result.issues
      ->Belt.Array.mapWithIndex((idx, issue) => {
        let severitySymbol = switch issue.severity {
        | #critical => "🔴"
        | #major => "🟠"
        | #minor => "🟡"
        }

        let remediation = switch issue.remediation {
        | Some(r) => "\n  Remediation: " ++ r
        | None => ""
        }

        Belt.Int.toString(idx + 1) ++
        ". " ++
        severitySymbol ++
        " " ++
        issue.clause ++
        "\n" ++
        "  " ++
        issue.description ++
        remediation ++ "\n"
      })
      ->Js.Array.joinWith("\n")

    issueCount ++ issuesList
  }

  header ++ statusLine ++ timestamp ++ issuesSection
}
