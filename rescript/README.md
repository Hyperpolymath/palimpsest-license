# Palimpsest License - ReScript Implementation

This directory contains the ReScript/ReasonML implementation of client-side tools for the Palimpsest License.

## Overview

The ReScript implementation provides type-safe, performant tools for:

- Parsing and validating Palimpsest License metadata
- Client-side compliance checking
- Embeddable widgets for license verification
- UI components for AI training consent flows
- Badge generation and display components

## Project Structure

```
rescript/
├── src/
│   ├── core/           # Core license logic and types
│   ├── components/     # Reusable UI components
│   ├── widgets/        # Embeddable widgets
│   └── utils/          # Utility functions
├── lib/                # Compiled JavaScript output
├── docs/               # Documentation
├── examples/           # Usage examples
├── bsconfig.json       # ReScript configuration
└── package.json        # Package metadata
```

## Installation

### From the rescript directory:

```bash
npm install
```

### Build the project:

```bash
npm run build
```

### Watch mode (for development):

```bash
npm run watch
```

## Quick Start

See the [documentation](./docs/) and [examples](./examples/) directories for detailed usage guides.

## Key Modules

- **PalimpsestTypes**: Core type definitions for license metadata
- **MetadataParser**: Parse and validate JSON-LD metadata
- **ComplianceChecker**: Verify compliance with license terms
- **BadgeGenerator**: Generate license badges
- **MetadataValidator**: Validate metadata structure and content
- **LicenseWidget**: Embeddable license verification widget
- **ConsentFlow**: UI components for AI training consent

## Integration

The compiled JavaScript can be integrated into any web project:

```javascript
import { MetadataParser, ComplianceChecker } from '@palimpsest/rescript';

// Parse license metadata
const metadata = MetadataParser.parse(jsonLdData);

// Check compliance
const isCompliant = ComplianceChecker.verify(metadata, usage);
```

## Documentation

See the [docs](./docs/) directory for:

- Installation Guide
- API Documentation
- Integration Examples
- Developer Guide

## License

This implementation is part of the Palimpsest License project. See the root LICENSE.md for details.
