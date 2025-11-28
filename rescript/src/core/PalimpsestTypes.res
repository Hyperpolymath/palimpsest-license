// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Core type definitions for Palimpsest License metadata and operations

// License version
type licenseVersion =
  | V03
  | V04
  | Custom(string)

// Language codes (ISO 639-1)
type language =
  | En  // English
  | Nl  // Dutch
  | Other(string)

// Usage types as defined in the license
type usageType =
  | Interpretive  // AI systems that interpret/understand content
  | NonInterpretive  // Simple storage/display
  | Derivative  // Creating derivative works
  | Training  // AI training/learning
  | Commercial  // Commercial use
  | Personal  // Personal/non-commercial use

// Consent status for different usage types
type consentStatus =
  | Granted
  | Denied
  | ConditionallyGranted(string)  // with conditions
  | NotSpecified

// Emotional lineage information
type emotionalLineage = {
  origin: option<string>,
  culturalContext: option<string>,
  traumaMarker: bool,
  symbolicWeight: option<string>,
  narrativeIntent: option<string>,
}

// Creator information
type creator = {
  name: string,
  identifier: option<string>,  // URI, ORCID, etc.
  role: option<string>,
  contact: option<string>,
}

// Attribution requirements
type attribution = {
  creators: array<creator>,
  source: option<string>,
  originalTitle: option<string>,
  dateCreated: option<string>,
  mustPreserveLineage: bool,
}

// Consent record for specific usage
type consent = {
  usageType: usageType,
  status: consentStatus,
  grantedDate: option<string>,
  expiryDate: option<string>,
  conditions: option<array<string>>,
  revocable: bool,
}

// Traceability hash for quantum-proof verification
type traceabilityHash = {
  algorithm: string,
  value: string,
  timestamp: string,
  blockchainRef: option<string>,
}

// Complete license metadata
type metadata = {
  version: licenseVersion,
  language: language,
  workTitle: string,
  workIdentifier: option<string>,
  licenseUri: string,
  attribution: attribution,
  consents: array<consent>,
  emotionalLineage: option<emotionalLineage>,
  traceability: option<traceabilityHash>,
  customFields: option<Js.Dict.t<Js.Json.t>>,
}

// Validation result
type validationError = {
  field: string,
  message: string,
  severity: [#error | #warning],
}

type validationResult =
  | Valid
  | Invalid(array<validationError>)

// Compliance check result
type complianceIssue = {
  clause: string,
  description: string,
  severity: [#critical | #major | #minor],
  remediation: option<string>,
}

type complianceResult = {
  isCompliant: bool,
  issues: array<complianceIssue>,
  checkedAt: string,
}

// Helper functions for version handling
let versionToString = (version: licenseVersion): string => {
  switch version {
  | V03 => "0.3"
  | V04 => "0.4"
  | Custom(v) => v
  }
}

let versionFromString = (str: string): licenseVersion => {
  switch str {
  | "0.3" | "v0.3" => V03
  | "0.4" | "v0.4" => V04
  | v => Custom(v)
  }
}

// Helper functions for language handling
let languageToString = (lang: language): string => {
  switch lang {
  | En => "en"
  | Nl => "nl"
  | Other(code) => code
  }
}

let languageFromString = (str: string): language => {
  switch str {
  | "en" | "eng" => En
  | "nl" | "nld" | "dut" => Nl
  | code => Other(code)
  }
}

// Helper functions for usage type handling
let usageTypeToString = (usage: usageType): string => {
  switch usage {
  | Interpretive => "interpretive"
  | NonInterpretive => "non-interpretive"
  | Derivative => "derivative"
  | Training => "training"
  | Commercial => "commercial"
  | Personal => "personal"
  }
}

let usageTypeFromString = (str: string): option<usageType> => {
  switch str {
  | "interpretive" => Some(Interpretive)
  | "non-interpretive" | "noninterpretive" => Some(NonInterpretive)
  | "derivative" => Some(Derivative)
  | "training" => Some(Training)
  | "commercial" => Some(Commercial)
  | "personal" => Some(Personal)
  | _ => None
  }
}

// Helper to check if consent is effectively granted
let isConsentGranted = (consent: consent): bool => {
  switch consent.status {
  | Granted | ConditionallyGranted(_) => true
  | Denied | NotSpecified => false
  }
}

// Helper to check if consent is still valid (not expired)
let isConsentValid = (consent: consent, currentDate: option<string>=?): bool => {
  switch consent.expiryDate {
  | None => true
  | Some(expiry) => {
      // If no current date provided, assume it's valid
      switch currentDate {
      | None => true
      | Some(current) => current <= expiry  // Simple string comparison
      }
    }
  }
}
