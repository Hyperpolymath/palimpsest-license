# API Documentation - Palimpsest ReScript

Complete API reference for the Palimpsest License ReScript implementation.

## Table of Contents

- [Core Modules](#core-modules)
  - [PalimpsestTypes](#palimpsesttypes)
  - [MetadataParser](#metadataparser)
  - [ComplianceChecker](#compliancechecker)
  - [MetadataValidator](#metadatavalidator)
- [Components](#components)
  - [BadgeGenerator](#badgegenerator)
  - [MetadataDisplay](#metadatadisplay)
  - [ConsentFlow](#consentflow)
- [Widgets](#widgets)
  - [LicenseWidget](#licensewidget)
- [Utilities](#utilities)
  - [WebIntegration](#webintegration)

---

## Core Modules

### PalimpsestTypes

Core type definitions for the Palimpsest License system.

#### Types

##### `licenseVersion`

```rescript
type licenseVersion =
  | V03
  | V04
  | Custom(string)
```

Represents the license version.

##### `language`

```rescript
type language =
  | En  // English
  | Nl  // Dutch
  | Other(string)
```

Language codes (ISO 639-1).

##### `usageType`

```rescript
type usageType =
  | Interpretive     // AI systems that interpret/understand content
  | NonInterpretive  // Simple storage/display
  | Derivative       // Creating derivative works
  | Training         // AI training/learning
  | Commercial       // Commercial use
  | Personal         // Personal/non-commercial use
```

Types of usage as defined in the license.

##### `consentStatus`

```rescript
type consentStatus =
  | Granted
  | Denied
  | ConditionallyGranted(string)  // with conditions
  | NotSpecified
```

Consent status for different usage types.

##### `metadata`

```rescript
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
```

Complete license metadata structure.

#### Functions

##### `versionToString`

```rescript
let versionToString: licenseVersion => string
```

Converts a license version to its string representation.

**Example:**
```javascript
import { versionToString, V04 } from './PalimpsestTypes.bs.js';

const versionStr = versionToString(V04); // "0.4"
```

##### `versionFromString`

```rescript
let versionFromString: string => licenseVersion
```

Parses a string into a license version.

##### `isConsentGranted`

```rescript
let isConsentGranted: consent => bool
```

Checks if consent is effectively granted (including conditional).

##### `isConsentValid`

```rescript
let isConsentValid: (consent, ~currentDate: option<string>=?) => bool
```

Checks if consent is still valid (not expired).

---

### MetadataParser

Parser for Palimpsest License metadata (JSON-LD and plain JSON).

#### Functions

##### `parse`

```rescript
let parse: Js.Json.t => result<metadata, string>
```

Parses JSON object into metadata structure.

**Parameters:**
- `json`: JSON object to parse

**Returns:**
- `Ok(metadata)` if successful
- `Error(message)` if parsing fails

**Example:**
```javascript
import { parse } from './MetadataParser.bs.js';

const json = {
  version: "0.4",
  workTitle: "My Creative Work",
  licenseUri: "https://palimpsest.org/licenses/v0.4",
  // ... more fields
};

const result = parse(json);
if (result.TAG === 'Ok') {
  console.log('Parsed:', result._0);
} else {
  console.error('Error:', result._0);
}
```

##### `parseString`

```rescript
let parseString: string => result<metadata, string>
```

Parses JSON string into metadata structure.

**Example:**
```javascript
import { parseString } from './MetadataParser.bs.js';

const jsonStr = '{"workTitle": "My Work", "licenseUri": "..."}';
const result = parseString(jsonStr);
```

##### `serialise`

```rescript
let serialise: metadata => Js.Json.t
```

Serialises metadata to JSON object.

##### `serialiseString`

```rescript
let serialiseString: metadata => string
```

Serialises metadata to JSON string.

---

### ComplianceChecker

Validates usage against license terms and consent grants.

#### Functions

##### `check`

```rescript
let check: (
  metadata,
  array<usageType>,
  ~currentDate: option<string>=?
) => complianceResult
```

Performs comprehensive compliance check for requested usages.

**Parameters:**
- `metadata`: License metadata to check against
- `requestedUsages`: Array of usage types to verify
- `currentDate`: Optional current date for expiry checking (ISO 8601)

**Returns:**
- `complianceResult` with compliance status and issues

**Example:**
```javascript
import { check } from './ComplianceChecker.bs.js';
import { Interpretive, Training } from './PalimpsestTypes.bs.js';

const result = check(
  metadata,
  [Interpretive, Training],
  { currentDate: '2025-11-22' }
);

console.log('Compliant:', result.isCompliant);
console.log('Issues:', result.issues);
```

##### `checkUsage`

```rescript
let checkUsage: (
  metadata,
  usageType,
  ~currentDate: option<string>=?
) => complianceResult
```

Quick check for single usage type.

##### `checkMetadataIntegrity`

```rescript
let checkMetadataIntegrity: (
  metadata,  // original
  metadata   // derivative
) => array<complianceIssue>
```

Checks if metadata has been stripped (Clause 2.3 violation).

##### `generateReport`

```rescript
let generateReport: complianceResult => string
```

Generates human-readable compliance report.

---

### MetadataValidator

Validates metadata structure and content.

#### Functions

##### `validate`

```rescript
let validate: metadata => validationResult
```

Validates complete metadata structure.

**Returns:**
- `Valid` if all checks pass
- `Invalid(array<validationError>)` with list of errors/warnings

**Example:**
```javascript
import { validate } from './MetadataValidator.bs.js';

const result = validate(metadata);
if (result.TAG === 'Valid') {
  console.log('Metadata is valid');
} else {
  console.log('Validation errors:', result._0);
}
```

##### `isValid`

```rescript
let isValid: metadata => bool
```

Quick boolean validation check.

##### `getErrors`

```rescript
let getErrors: validationResult => array<validationError>
```

Extracts only errors (not warnings).

##### `getWarnings`

```rescript
let getWarnings: validationResult => array<validationError>
```

Extracts only warnings.

##### `generateReport`

```rescript
let generateReport: validationResult => string
```

Generates human-readable validation report.

---

## Components

### BadgeGenerator

Generates license badges in various formats.

#### Functions

##### `generateVersionBadge`

```rescript
let generateVersionBadge: (metadata, ~style: badgeStyle=?) => string
```

Generates SVG badge showing license version.

**Parameters:**
- `metadata`: License metadata
- `style`: Optional badge style (Flat, FlatSquare, Plastic, ForTheBadge)

**Returns:**
- SVG string

**Example:**
```javascript
import { generateVersionBadge } from './BadgeGenerator.bs.js';

const svg = generateVersionBadge(metadata);
document.getElementById('badge').innerHTML = svg;
```

##### `generateComplianceBadge`

```rescript
let generateComplianceBadge: (complianceResult, ~style: badgeStyle=?) => string
```

Generates badge showing compliance status.

##### `generateFromMetadata`

```rescript
let generateFromMetadata: (metadata, ~style: badgeStyle=?) => badgePackage
```

Generates complete badge package (SVG, HTML, Markdown, data URI).

**Returns:**
```rescript
type badgePackage = {
  svg: string,
  svgDataUri: string,
  html: string,
  markdown: string,
}
```

##### `generateShieldsIoUrl`

```rescript
let generateShieldsIoUrl: (
  ~label: string,
  ~message: string,
  ~colour: string=?,
  ~style: string=?
) => string
```

Generates shields.io compatible URL for badge.

---

### MetadataDisplay

Renders license metadata in various formats.

#### Functions

##### `display`

```rescript
let display: (metadata, ~style: displayStyle=?) => string
```

Main display function with configurable style.

**Parameters:**
- `metadata`: License metadata to display
- `style`: Display style configuration

**Style options:**
```rescript
type displayStyle = {
  format: displayFormat,      // Compact | Standard | Detailed | Technical
  showIcons: bool,
  showLinks: bool,
  highlightTrauma: bool,
}
```

**Example:**
```javascript
import { display } from './MetadataDisplay.bs.js';

const style = {
  format: { TAG: 1 }, // Standard
  showIcons: true,
  showLinks: true,
  highlightTrauma: true
};

const html = display(metadata, { style });
document.getElementById('info').innerHTML = html;
```

##### `generateAttributionText`

```rescript
let generateAttributionText: (metadata, ~includeLineage: bool=?) => string
```

Generates plain text attribution.

##### `generateMicrodataAttribution`

```rescript
let generateMicrodataAttribution: metadata => string
```

Generates HTML with Schema.org microdata.

---

### ConsentFlow

Interactive forms for managing usage consents.

#### Functions

##### `generateConsentForm`

```rescript
let generateConsentForm: (
  ~config: consentFormConfig=?,
  ~existingConsents: array<consent>=?
) => string
```

Generates complete HTML consent form.

**Configuration:**
```rescript
type consentFormConfig = {
  showExplanations: bool,
  allowConditional: bool,
  requireJustification: bool,
  multiStep: bool,
}
```

##### `generateEmbeddableConsentForm`

```rescript
let generateEmbeddableConsentForm: (
  ~config: consentFormConfig=?,
  ~existingConsents: array<consent>=?
) => string
```

Generates form with CSS and JavaScript included.

---

## Widgets

### LicenseWidget

Complete, interactive license information display.

#### Functions

##### `generateWidget`

```rescript
let generateWidget: (
  ~metadata: metadata,
  ~config: widgetConfig=?,
  ~complianceResult: option<complianceResult>=?,
  ~includeCSS: bool=?
) => string
```

Generates complete widget HTML.

**Configuration:**
```rescript
type widgetConfig = {
  showBadge: bool,
  showMetadata: bool,
  showCompliance: bool,
  showConsents: bool,
  expandable: bool,
  theme: [#light | #dark | #auto],
}
```

##### `generateEmbeddableSnippet`

```rescript
let generateEmbeddableSnippet: (
  ~metadata: metadata,
  ~config: widgetConfig=?,
  ~complianceResult: option<complianceResult>=?
) => string
```

Generates widget with CSS, HTML, and JavaScript.

---

## Utilities

### WebIntegration

Web platform integration helpers.

#### Functions

##### `extractMetadataFromScript`

```rescript
let extractMetadataFromScript: string => option<metadata>
```

Extracts metadata from script tag by ID.

##### `injectBadge`

```rescript
let injectBadge: (
  ~elementId: string,
  ~badge: string,
  ~format: [#svg | #html]=?
) => result<unit, string>
```

Injects badge into DOM element.

##### `injectMetadataDisplay`

```rescript
let injectMetadataDisplay: (
  ~elementId: string,
  ~metadata: metadata
) => result<unit, string>
```

Injects metadata display into DOM.

##### `autoInitialise`

```rescript
let autoInitialize: (
  ~metadataSource: [#scriptId(string) | #metaTags | #inline(metadata)]
) => unit
```

Auto-initialises license display on page load.

##### `generateStructuredData`

```rescript
let generateStructuredData: metadata => string
```

Generates JSON-LD structured data for search engines.

---

## Error Handling

All parsing and validation functions use ReScript's `result` type:

```rescript
type result<'ok, 'error> =
  | Ok('ok)
  | Error('error)
```

In JavaScript, this compiles to:

```javascript
// Success
{ TAG: 'Ok', _0: value }

// Error
{ TAG: 'Error', _0: errorMessage }
```

**Example error handling:**
```javascript
const result = parse(json);
if (result.TAG === 'Ok') {
  const metadata = result._0;
  // Use metadata
} else {
  const error = result._0;
  console.error('Parse error:', error);
}
```

---

## Type Safety

ReScript provides complete type safety. When using compiled JavaScript:

- Variants are represented as objects with `TAG` field
- Options are `undefined` (None) or the value (Some)
- Records are plain objects
- Arrays are standard JavaScript arrays

For best IDE support, consider using TypeScript definitions (to be generated).

---

**Version:** 0.4.0
**Last Updated:** 2025-11-22
