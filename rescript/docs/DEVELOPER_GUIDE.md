# Developer Guide - Palimpsest ReScript

Comprehensive guide for developers working with the Palimpsest License ReScript implementation.

## Table of Contents

- [Getting Started](#getting-started)
- [Understanding the Architecture](#understanding-the-architecture)
- [Working with Types](#working-with-types)
- [Common Patterns](#common-patterns)
- [Best Practices](#best-practices)
- [Performance Optimisation](#performance-optimisation)
- [Debugging](#debugging)
- [Contributing](#contributing)

---

## Getting Started

### Development Environment Setup

1. **Install Dependencies**

```bash
cd rescript
npm install
```

2. **Start Watch Mode**

During development, keep watch mode running to automatically recompile on changes:

```bash
npm run watch
```

3. **Test Your Changes**

Create a simple HTML file to test your changes:

```html
<!DOCTYPE html>
<html>
<head><title>Test</title></head>
<body>
  <div id="output"></div>
  <script type="module">
    import { parse } from './lib/js/src/core/MetadataParser.bs.js';

    const result = parse({
      version: "0.4",
      workTitle: "Test",
      licenseUri: "https://test.com"
    });

    document.getElementById('output').textContent =
      JSON.stringify(result, null, 2);
  </script>
</body>
</html>
```

---

## Understanding the Architecture

### Module Structure

The codebase is organised into logical layers:

```
src/
├── core/          # Core business logic (types, parsing, validation)
├── components/    # Reusable UI components
├── widgets/       # Complete, standalone widgets
└── utils/         # Utility functions and helpers
```

**Design Principles:**

1. **Separation of Concerns**: Core logic is independent of UI
2. **Type Safety**: All data structures are strictly typed
3. **Immutability**: Data transformations return new values
4. **Composability**: Small, focused modules that work together

### Data Flow

```
JSON Input
    ↓
MetadataParser (parse/validate structure)
    ↓
PalimpsestTypes (typed metadata)
    ↓
ComplianceChecker / MetadataValidator (business logic)
    ↓
BadgeGenerator / MetadataDisplay (presentation)
    ↓
HTML Output
```

### Key Type Definitions

All types are defined in `PalimpsestTypes.res`:

- **`metadata`**: Complete license information
- **`consent`**: Usage permission record
- **`emotionalLineage`**: Cultural and narrative context
- **`validationResult`**: Validation outcome
- **`complianceResult`**: Compliance check outcome

---

## Working with Types

### Option Types

ReScript uses `option<'a>` for nullable values:

```rescript
// ReScript
let creator: option<string> = Some("Jane Doe")
let noCreator: option<string> = None

switch creator {
| Some(name) => Js.log("Creator: " ++ name)
| None => Js.log("No creator specified")
}
```

In JavaScript, `Some(value)` becomes `value`, and `None` becomes `undefined`:

```javascript
// Compiled JavaScript
const creator = "Jane Doe";      // Some("Jane Doe")
const noCreator = undefined;     // None

if (creator !== undefined) {
  console.log("Creator: " + creator);
}
```

### Result Types

For operations that can fail:

```rescript
// ReScript
let result = parse(json)

switch result {
| Ok(metadata) => Js.log("Success!")
| Error(message) => Js.log("Error: " ++ message)
}
```

In JavaScript:

```javascript
// Compiled JavaScript
const result = parse(json);

if (result.TAG === 'Ok') {
  console.log("Success!");
  const metadata = result._0;
} else {
  console.log("Error: " + result._0);
}
```

### Variant Types

Variants represent distinct possibilities:

```rescript
type usageType =
  | Interpretive
  | NonInterpretive
  | Training

let usage: usageType = Interpretive
```

In JavaScript, these become tagged objects:

```javascript
const Interpretive = { TAG: 0 };
const NonInterpretive = { TAG: 1 };
const Training = { TAG: 2 };

const usage = { TAG: 0 }; // Interpretive
```

### Record Types

Records are like objects:

```rescript
type creator = {
  name: string,
  role: option<string>,
}

let creator = {
  name: "Jane Doe",
  role: Some("Author"),
}
```

Compiles to plain JavaScript objects:

```javascript
const creator = {
  name: "Jane Doe",
  role: "Author"
};
```

---

## Common Patterns

### Pattern 1: Parsing and Validating Metadata

```rescript
// Safe parsing with error handling
let processMetadata = (jsonString: string): option<metadata> => {
  switch MetadataParser.parseString(jsonString) {
  | Ok(metadata) => {
      // Validate before using
      switch MetadataValidator.validate(metadata) {
      | Valid => Some(metadata)
      | Invalid(errors) => {
          Js.log("Validation errors:")
          errors->Belt.Array.forEach(error => {
            Js.log(error.message)
          })
          None
        }
      }
    }
  | Error(message) => {
      Js.log("Parse error: " ++ message)
      None
    }
  }
}
```

### Pattern 2: Building Metadata Programmatically

```rescript
let createMetadata = (
  ~workTitle: string,
  ~creatorName: string,
  ~licenseUri: string,
): metadata => {
  {
    version: V04,
    language: En,
    workTitle: workTitle,
    workIdentifier: None,
    licenseUri: licenseUri,
    attribution: {
      creators: [{
        name: creatorName,
        identifier: None,
        role: Some("Creator"),
        contact: None,
      }],
      source: None,
      originalTitle: None,
      dateCreated: None,
      mustPreserveLineage: false,
    },
    consents: [],
    emotionalLineage: None,
    traceability: None,
    customFields: None,
  }
}
```

### Pattern 3: Checking Multiple Usage Types

```rescript
let checkAllUsages = (metadata: metadata): complianceResult => {
  let allUsageTypes = [
    Interpretive,
    NonInterpretive,
    Training,
    Derivative,
    Commercial,
    Personal,
  ]

  ComplianceChecker.check(metadata, allUsageTypes)
}
```

### Pattern 4: Conditional Badge Generation

```rescript
let generateAppropriaBadge = (
  metadata: metadata,
  complianceResult: option<complianceResult>,
): string => {
  switch complianceResult {
  | Some(result) if !result.isCompliant =>
      BadgeGenerator.generateComplianceBadge(result)
  | _ =>
      BadgeGenerator.generateVersionBadge(metadata)
  }
}
```

### Pattern 5: Composing Display Components

```rescript
let generateFullDisplay = (metadata: metadata): string => {
  let badge = BadgeGenerator.generateVersionBadge(metadata)
  let metadataDisplay = MetadataDisplay.display(
    metadata,
    ~style={
      format: Detailed,
      showIcons: true,
      showLinks: true,
      highlightTrauma: true,
    },
  )

  let consentsDisplay = if Belt.Array.length(metadata.consents) > 0 {
    ConsentFlow.generateConsentForm(~existingConsents=metadata.consents)
  } else {
    ""
  }

  badge ++ metadataDisplay ++ consentsDisplay
}
```

---

## Best Practices

### 1. Always Validate Input

```rescript
// ❌ Bad: Assuming data is valid
let processJson = (json: string) => {
  let metadata = MetadataParser.parseString(json)
  // Might fail silently
}

// ✅ Good: Explicit validation
let processJson = (json: string): option<metadata> => {
  switch MetadataParser.parseString(json) {
  | Ok(metadata) => {
      if MetadataValidator.isValid(metadata) {
        Some(metadata)
      } else {
        None
      }
    }
  | Error(_) => None
  }
}
```

### 2. Use Belt for Safe Array Operations

```rescript
// ❌ Risky: Direct array access
let firstCreator = metadata.attribution.creators[0]

// ✅ Safe: Belt.Array helpers
let firstCreator = metadata.attribution.creators
  ->Belt.Array.get(0)
  ->Belt.Option.map(creator => creator.name)
  ->Belt.Option.getWithDefault("Unknown")
```

### 3. Handle Edge Cases

```rescript
let getConsentStatus = (metadata: metadata, usage: usageType): string => {
  metadata.consents
  ->Belt.Array.getBy(c => c.usageType === usage)
  ->Belt.Option.map(consent => {
    switch consent.status {
    | Granted => "Granted"
    | Denied => "Denied"
    | ConditionallyGranted(cond) => "Conditional: " ++ cond
    | NotSpecified => "Not specified"
    }
  })
  ->Belt.Option.getWithDefault("No consent record found")
}
```

### 4. Keep Functions Pure

```rescript
// ❌ Impure: Side effects
let processMetadata = (metadata: metadata): unit => {
  Js.log("Processing...")  // Side effect
  let badge = generateBadge(metadata)
  document.getElementById("badge").innerHTML = badge  // DOM mutation
}

// ✅ Pure: Returns value, no side effects
let processMetadata = (metadata: metadata): string => {
  generateBadge(metadata)
}

// Side effects in separate function
let displayBadge = (badge: string): unit => {
  document.getElementById("badge").innerHTML = badge
}
```

### 5. Document Complex Logic

```rescript
/**
 * Checks if a work requires special handling due to trauma markers.
 *
 * Works with trauma markers should:
 * - Display content warnings
 * - Preserve cultural context
 * - Require explicit consent for interpretive AI use
 *
 * @param metadata The license metadata to check
 * @returns true if trauma marker is present
 */
let requiresTraumaSensitiveHandling = (metadata: metadata): bool => {
  metadata.emotionalLineage
  ->Belt.Option.map(lineage => lineage.traumaMarker)
  ->Belt.Option.getWithDefault(false)
}
```

---

## Performance Optimisation

### 1. Cache Expensive Operations

```rescript
// Cache badge generation
module BadgeCache = {
  let cache: Js.Dict.t<string> = Js.Dict.empty()

  let getBadge = (metadata: metadata): string => {
    let key = metadata.workTitle ++ versionToString(metadata.version)

    switch Js.Dict.get(cache, key) {
    | Some(cached) => cached
    | None => {
        let badge = BadgeGenerator.generateVersionBadge(metadata)
        Js.Dict.set(cache, key, badge)
        badge
      }
    }
  }
}
```

### 2. Lazy Loading

```rescript
// Only generate widget when needed
let lazyWidget = (metadata: metadata): unit => {
  let button = document.getElementById("show-license")

  button->addEventListener("click", _ => {
    let widget = LicenseWidget.generateWidget(~metadata)
    document.getElementById("widget-container").innerHTML = widget
  })
}
```

### 3. Batch DOM Updates

```rescript
// ❌ Multiple DOM updates
metadata.consents->Belt.Array.forEach(consent => {
  let elem = document.createElement("div")
  elem.textContent = usageTypeToString(consent.usageType)
  container.appendChild(elem)
})

// ✅ Single DOM update
let html = metadata.consents
  ->Belt.Array.map(consent => {
    "<div>" ++ usageTypeToString(consent.usageType) ++ "</div>"
  })
  ->Js.Array.joinWith("")

container.innerHTML = html
```

---

## Debugging

### 1. Using Browser DevTools

Set breakpoints in compiled JavaScript:

```javascript
// In compiled .bs.js file
const result = parse(json);
debugger; // Browser will pause here
```

### 2. Logging in ReScript

```rescript
// Simple logging
Js.log("Metadata: ")
Js.log2("Work title:", metadata.workTitle)

// Logging objects
Js.Console.log(metadata)

// Conditional logging
if process.env["NODE_ENV"] === "development" {
  Js.log("Debug: Processing metadata")
}
```

### 3. Type Debugging

If you're unsure about a type, let ReScript infer it:

```rescript
// Hover over 'result' in your editor to see its type
let result = MetadataParser.parse(json)
```

### 4. Common Issues

**Issue: `undefined is not a function`**

Solution: Check variant/option unwrapping:

```javascript
// ❌ Wrong
const usage = metadata.usageType;
console.log(usageTypeToString(usage)); // Error if variant

// ✅ Correct
const usage = { TAG: 0 }; // Proper variant construction
console.log(usageTypeToString(usage));
```

**Issue: `Cannot read property 'TAG' of undefined`**

Solution: Check for None/undefined before accessing:

```javascript
if (metadata.emotionalLineage !== undefined) {
  // Safe to use
}
```

---

## Contributing

### Adding New Features

1. **Define Types** in `PalimpsestTypes.res`
2. **Implement Logic** in appropriate module
3. **Add Tests** (create test file)
4. **Update Documentation**
5. **Create Examples**

### Code Style

- Use descriptive variable names
- Prefer pattern matching over if/else
- Keep functions small and focused
- Document public APIs
- Use British English in comments

### Pull Request Checklist

- [ ] Code builds without errors (`npm run build`)
- [ ] Code is formatted (`npm run format`)
- [ ] Types are properly defined
- [ ] Edge cases are handled
- [ ] Documentation is updated
- [ ] Examples are provided
- [ ] Commit messages are descriptive

---

## Resources

- [ReScript Documentation](https://rescript-lang.org/docs)
- [ReScript Belt Standard Library](https://rescript-lang.org/docs/manual/latest/api/belt)
- [Palimpsest License Specification](../../LICENSES/v0.4/)
- [Project Governance](../../GOVERNANCE.md)

---

**Version:** 0.4.0
**Last Updated:** 2025-11-22
