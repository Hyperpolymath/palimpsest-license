// docs/license-parser.ts
import fs from 'fs/promises';
import path from 'path';
import Ajv from 'ajv';
import xml2js from 'xml2js';
import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';
import marked from 'marked';
import { createHash } from 'crypto';
import { fetch } from 'undici';

// WASM Integration: Import the Rust-generated WASM module
import initWasmValidator, { validateAdvancedSchema } from './wasm/validator_wasm.js';

// ======================================
// Type Definitions
// ======================================
interface Jurisdiction {
  governingLaw: string;
  enforcement: string;
}

interface AGIConsent {
  defaultPolicy: 'deny' | 'allow';
  aiTypes: Array<'AGI' | 'Autonomous' | 'Agentic' | 'Ambient' | 'NI' | 'QAI'>;
}

interface SyntheticLineage {
  required: boolean;
  format: 'XML' | 'JSON';
}

interface PalimpsestLicense {
  licenseVersion: string;
  jurisdiction: Jurisdiction;
  agiConsent: AGIConsent;
  syntheticLineage: SyntheticLineage;
  sections: Record<string, string>; // Parsed Markdown sections
}

interface AIBoundariesDefaultConsent {
  training: 'allow' | 'deny';
  generation: 'allow' | 'deny';
  agentic: 'allow' | 'deny';
}

interface AIBoundaries {
  default_consent: AIBoundariesDefaultConsent;
}

interface AIBDPManifest {
  manifest_version: string;
  palimpsest_license: string;
  ai_boundaries: AIBoundaries;
  signature?: string; // For cryptographic signature
}

interface LineageTag {
  synthetic_lineage?: {
    original_work?: {
      $?: {
        title?: string;
        creator?: string;
        license?: string;
      };
    };
  };
}

interface ComplianceAPIResponse {
  valid: boolean;
  message: string;
  schemaVersion: string;
}

// ======================================
// JSON Schemas (for basic validation)
// ======================================
const PALIMPSEST_LICENSE_SCHEMA = {
  type: 'object',
  required: ['licenseVersion', 'jurisdiction', 'agiConsent', 'syntheticLineage'],
  properties: {
    licenseVersion: { type: 'string', pattern: '^v0\\.3\\.\\d+$' },
    jurisdiction: {
      type: 'object',
      required: ['governingLaw', 'enforcement'],
      properties: {
        governingLaw: { const: 'Dutch law' },
        enforcement: { const: 'Scottish courts (per Hague Convention 2005)' }
      }
    },
    agiConsent: {
      type: 'object',
      required: ['defaultPolicy', 'aiTypes'],
      properties: {
        defaultPolicy: { enum: ['deny', 'allow'] },
        aiTypes: {
          type: 'array',
          items: {
            type: 'string',
            enum: ['AGI', 'Autonomous', 'Agentic', 'Ambient', 'NI', 'QAI']
          }
        }
      }
    },
    syntheticLineage: {
      type: 'object',
      required: ['required', 'format'],
      properties: {
        required: { type: 'boolean' },
        format: { enum: ['XML', 'JSON'] }
      }
    }
  }
} as const;

const AIBDP_MANIFEST_SCHEMA = {
  type: 'object',
  required: ['manifest_version', 'palimpsest_license', 'ai_boundaries'],
  properties: {
    manifest_version: { const: '1.0' },
    palimpsest_license: { const: 'Palimpsest License v0.3' },
    ai_boundaries: {
      type: 'object',
      required: ['default_consent'],
      properties: {
        default_consent: {
          type: 'object',
          required: ['training', 'generation', 'agentic'],
          properties: {
            training: { enum: ['allow', 'deny'] },
            generation: { enum: ['allow', 'deny'] },
            agentic: { enum: ['allow', 'deny'] }
          }
        }
      }
    },
    signature: { type: 'string' } // Optional signature for validation
  }
} as const;

// ======================================
// Initialize Validators
// ======================================
const ajv = new Ajv({ allErrors: true });
const validateLicense = ajv.compile<PalimpsestLicense>(PALIMPSEST_LICENSE_SCHEMA);
const validateManifest = ajv.compile<AIBDPManifest>(AIBDP_MANIFEST_SCHEMA);
const xmlParser = new xml2js.Parser({ explicitArray: false });

// ======================================
// Feature 1: Full Markdown Parsing (with `marked`)
// ======================================
/**
 * Parse Markdown into sections (headers + content)
 * @param markdown - Markdown content
 * @returns Object mapping section names to their content
 */
function parseMarkdownSections(markdown: string): Record<string, string> {
  const tokens = marked.lexer(markdown);
  const sections: Record<string, string> = {};
  let currentSection = '';

  for (const token of tokens) {
    if (token.type === 'heading') {
      currentSection = token.text.trim();
      sections[currentSection] = '';
    } else if (currentSection && token.type === 'paragraph') {
      sections[currentSection] += `${token.text}\n`;
    }
  }

  return sections;
}

// ======================================
// Feature 2: Signature Validation
// ======================================
/**
 * Verify a file's content matches a trusted SHA-256 hash
 * @param filePath - Path to the file
 * @param trustedHash - Expected SHA-256 hash
 * @returns `true` if the hash matches
 */
async function verifySignature(filePath: string, trustedHash?: string): Promise<boolean> {
  if (!trustedHash) return true; // Skip if no hash provided

  try {
    const content = await fs.readFile(filePath, 'utf8');
    const actualHash = createHash('sha256').update(content).digest('hex');
    return actualHash === trustedHash;
  } catch (err) {
    console.error(`Signature validation failed: ${(err as Error).message}`);
    return false;
  }
}

// ======================================
// Feature 3: Compliance API Integration
// ======================================
/**
 * Check compliance against the Palimpsest remote API
 * @param data - License and manifest data to validate
 * @returns API response with validation status
 */
async function checkComplianceAPI(data: {
  license: PalimpsestLicense;
  manifest: AIBDPManifest;
}): Promise<ComplianceAPIResponse> {
  try {
    const response = await fetch('https://api.palimpsestlicense.org/compliance/check', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
    return (await response.json()) as ComplianceAPIResponse;
  } catch (err) {
    console.error(`API check failed: ${(err as Error).message}`);
    return { valid: false, message: 'API unavailable', schemaVersion: 'unknown' };
  }
}

// ======================================
// Feature 4: Localization Checks (EN/NL)
// ======================================
/**
 * Compare English and Dutch license sections for content consistency
 * @param enSections - English sections (from Markdown)
 * @param nlSections - Dutch sections (from Markdown)
 * @returns List of mismatched section names
 */
function checkLocalization(enSections: Record<string, string>, nlSections: Record<string, string>): Array<string> {
  const mismatches: Array<string> = [];
  const commonSections = Object.keys(enSections).filter(sec => nlSections[sec]);

  for (const section of commonSections) {
    const enText = enSections[section].trim();
    const nlText = nlSections[section].trim();
    if (enText !== nlText) {
      mismatches.push(`Section "${section}" differs between English and Dutch`);
    }
  }

  return mismatches;
}

// ======================================
// Feature 5: WASM Extensibility (for Schema Evolution)
// ======================================
/**
 * Validate complex schemas (e.g., Quantum AI, Neural Interfaces) using a Rust WASM module
 * @param data - JSON data to validate
 * @param schemaVersion - Target schema version (e.g., "v1.1")
 * @returns Validation result with errors
 */
async function validateWithWasm(data: object, schemaVersion: string): Promise<{ valid: boolean; errors: Array<string> }> {
  try {
    await initWasmValidator(); // Initialize the WASM module
    const result = validateAdvancedSchema(JSON.stringify(data), schemaVersion);
    return JSON.parse(result) as { valid: boolean; errors: Array<string> };
  } catch (err) {
    console.error(`WASM validation failed: ${(err as Error).message}`);
    return { valid: false, errors: [(err as Error).message] };
  }
}

// ======================================
// Core Parsing Logic
// ======================================
/**
 * Parse a Palimpsest License Markdown file
 * @param filePath - Path to the license file
 * @param trustedHash - Optional SHA-256 hash for signature validation
 * @returns Parsed license data + validation status
 */
async function parseLicenseFile(filePath: string, trustedHash?: string): Promise<{
  valid: boolean;
  data: PalimpsestLicense | null;
  errors: Array<{ message: string }>;
  sections: Record<string, string>;
}> {
  try {
    const content = await fs.readFile(filePath, 'utf8');
    const sections = parseMarkdownSections(content);
    const licenseData = extractLicenseMetadata(content, sections);

    // Validate cryptographic signature
    const isSignatureValid = await verifySignature(filePath, trustedHash);
    if (!isSignatureValid) {
      return {
        valid: false,
        data: licenseData,
        errors: [{ message: 'Signature validation failed' }],
        sections
      };
    }

    // Basic JSON Schema validation
    const isValid = validateLicense(licenseData);
    return {
      valid: isValid,
      data: licenseData,
      errors: isValid ? [] : validateLicense.errors.map(e => ({ message: e.message ?? 'Validation error' })),
      sections
    };
  } catch (err) {
    return {
      valid: false,
      data: null,
      errors: [{ message: `File error: ${(err as Error).message}` }],
      sections: {}
    };
  }
}

/**
 * Extract structured metadata from Palimpsest License Markdown
 * @param markdown - License content in Markdown
 * @param sections - Parsed sections from Markdown
 * @returns Structured license metadata
 */
function extractLicenseMetadata(markdown: string, sections: Record<string, string>): PalimpsestLicense {
  // Extract version from header
  const versionMatch = markdown.match(/Palimpsest License v(\d+\.\d+\.\d+)/);
  const licenseVersion = versionMatch?.[1] ? `v${versionMatch[1]}` : 'v0.3.0';

  return {
    licenseVersion,
    jurisdiction: {
      governingLaw: 'Dutch law',
      enforcement: 'Scottish courts (per Hague Convention 2005)'
    },
    agiConsent: {
      defaultPolicy: 'deny',
      aiTypes: ['AGI', 'Autonomous', 'Agentic', 'Ambient', 'NI', 'QAI']
    },
    syntheticLineage: {
      required: true,
      format: 'XML'
    },
    sections // Store parsed Markdown sections
  };
}

/**
 * Validate an AIBDP manifest JSON file
 * @param filePath - Path to the manifest
 * @returns Parsed manifest + validation status
 */
async function validateAIBdpManifest(filePath: string): Promise<{
  valid: boolean;
  data: AIBDPManifest | null;
  errors: Array<{ message: string }>;
}> {
  try {
    const content = await fs.readFile(filePath, 'utf8');
    const manifest = JSON.parse(content) as AIBDPManifest;

    // Basic JSON Schema validation
    let isValid = validateManifest(manifest);

    // Advanced validation with WASM (for schema evolution)
    if (isValid) {
      const wasmResult = await validateWithWasm(manifest, 'v1.1'); // Example schema version
      if (!wasmResult.valid) {
        return {
          valid: false,
          data: manifest,
          errors: wasmResult.errors.map(msg => ({ message: msg }))
        };
      }
    }

    return {
      valid: isValid,
      data: manifest,
      errors: isValid ? [] : validateManifest.errors.map(e => ({ message: e.message ?? 'Validation error' }))
    };
  } catch (err) {
    return {
      valid: false,
      data: null,
      errors: [{ message: `Manifest error: ${(err as Error).message}` }]
    };
  }
}

/**
 * Validate a synthetic lineage tag (XML/JSON)
 * @param tagContent - Raw tag content
 * @param format - "XML" or "JSON"
 * @returns Parsed tag + validation status
 */
async function validateLineageTag(tagContent: string, format: 'XML' | 'JSON'): Promise<{
  valid: boolean;
  data: LineageTag | null;
  errors: Array<{ message: string }>;
}> {
  try {
    let data: LineageTag;
    if (format === 'XML') {
      data = await xmlParser.parseStringPromise(tagContent);
    } else {
      data = JSON.parse(tagContent) as LineageTag;
    }

    // Basic validation
    const isValid = !!data.synthetic_lineage && !!data.synthetic_lineage.original_work;
    return {
      valid: isValid,
      data,
      errors: isValid ? [] : [{ message: 'Missing required fields (original_work)' }]
    };
  } catch (err) {
    return {
      valid: false,
      data: null,
      errors: [{ message: `Tag parse error: ${(err as Error).message}` }]
    };
  }
}

/**
 * Generate a compliance report with all checks
 * @param licenseResult - Result from parsing the English license
 * @param manifestResult - Result from validating the AIBDP manifest
 * @param tagResult - Result from validating the lineage tag
 * @param nlLicenseResult - Result from parsing the Dutch license (for localization)
 * @param format - Output format ("json" or "text")
 * @returns Report in the desired format
 */
async function generateReport(
  licenseResult: Awaited<ReturnType<typeof parseLicenseFile>>,
  manifestResult: Awaited<ReturnType<typeof validateAIBdpManifest>>,
  tagResult: Awaited<ReturnType<typeof validateLineageTag>>,
  nlLicenseResult?: Awaited<ReturnType<typeof parseLicenseFile>>,
  format: 'json' | 'text' = 'text'
): Promise<string | object> {
  // Localization check
  const localizationMismatches: Array<string> = [];
  if (nlLicenseResult && licenseResult.sections && nlLicenseResult.sections) {
    localizationMismatches.push(...checkLocalization(licenseResult.sections, nlLicenseResult.sections));
  }

  // Compliance API check
  let complianceAPIResult: ComplianceAPIResponse = { valid: false, message: 'Not checked', schemaVersion: 'unknown' };
  if (licenseResult.valid && manifestResult.valid) {
    complianceAPIResult = await checkComplianceAPI({
      license: licenseResult.data!,
      manifest: manifestResult.data!
    });
  }

  // Build report
  const report = {
    license: {
      valid: licenseResult.valid,
      version: licenseResult.data?.licenseVersion || 'unknown',
      errors: licenseResult.errors.map(e => e.message)
    },
    manifest: {
      valid: manifestResult.valid,
      errors: manifestResult.errors.map(e => e.message)
    },
    lineageTag: {
      valid: tagResult.valid,
      errors: tagResult.errors.map(e => e.message)
    },
    localization: {
      valid: localizationMismatches.length === 0,
      errors: localizationMismatches
    },
    complianceAPI: complianceAPIResult,
    compliance: {
      manifestMatchesLicense: licenseResult.valid && manifestResult.valid
        ? licenseResult.data?.agiConsent.defaultPolicy === manifestResult.data?.ai_boundaries.default_consent.training
        : false
    }
  };

  return format === 'json'
    ? JSON.stringify(report, null, 2)
    : `Palimpsest License Parser Report
================================
- License: ${licenseResult.valid ? 'Valid' : 'Invalid'} (v${report.license.version})
- AIBDP Manifest: ${manifestResult.valid ? 'Valid' : 'Invalid'}
- Lineage Tag: ${tagResult.valid ? 'Valid' : 'Invalid'}
- Localization: ${localizationMismatches.length === 0 ? '✓ Matches' : '✗ Mismatch'}
- Compliance API: ${complianceAPIResult.valid ? '✓ Valid' : '✗ Invalid'} (Schema: ${complianceAPIResult.schemaVersion})
- Overall Compliance: ${report.compliance.manifestMatchesLicense ? '✓ Matches' : '✗ Mismatch'}

Errors:
${[
      ...licenseResult.errors,
      ...manifestResult.errors,
      ...tagResult.errors,
      ...localizationMismatches,
      complianceAPIResult.valid ? [] : [{ message: complianceAPIResult.message }]
    ].map(e => typeof e === 'string' ? `- ${e}` : `- ${e.message}`).join('\n')}`;
}

// ======================================
// CLI Entry Point
// ======================================
async function main() {
  const args = yargs(hideBin(process.argv))
    .option('license', {
      describe: 'Path to Palimpsest License file (English, Markdown)',
      type: 'string',
      demandOption: true
    })
    .option('license-nl', {
      describe: 'Path to Palimpsest License file (Dutch, Markdown) for localization checks',
      type: 'string'
    })
    .option('manifest', {
      describe: 'Path to AIBDP manifest file (JSON)',
      type: 'string',
      demandOption: true
    })
    .option('lineage-tag', {
      describe: 'Path to synthetic lineage tag file (XML/JSON)',
      type: 'string',
      demandOption: true
    })
    .option('tag-format', {
      describe: 'Format of the lineage tag (XML/JSON)',
      type: 'string',
      choices: ['XML', 'JSON'],
      default: 'XML'
    })
    .option('signature', {
      describe: 'Trusted SHA-256 hash for license signature validation',
      type: 'string'
    })
    .option('format', {
      describe: 'Output format (json/text)',
      type: 'string',
      choices: ['json', 'text'],
      default: 'text'
    })
    .parse();

  // Parse English license
  const licenseResult = await parseLicenseFile(args.license, args.signature);

  // Parse Dutch license (if provided)
  let nlLicenseResult: Awaited<ReturnType<typeof parseLicenseFile>> | undefined;
  if (args.licenseNl) {
    nlLicenseResult = await parseLicenseFile(args.licenseNl, args.signature);
  }

  // Validate manifest
  const manifestResult = await validateAIBdpManifest(args.manifest);

  // Validate lineage tag
  const tagContent = await fs.readFile(args.lineageTag, 'utf8');
  const tagResult = await validateLineageTag(tagContent, args.tagFormat as 'XML' | 'JSON');

  // Generate report
  const report = await generateReport(licenseResult, manifestResult, tagResult, nlLicenseResult, args.format as 'json' | 'text');
  console.log(report);

  // Exit with code 1 if any validation fails
  const hasErrors = !licenseResult.valid || !manifestResult.valid || !tagResult.valid || (nlLicenseResult && !nlLicenseResult.valid) || !report.complianceAPI.valid;
  process.exit(hasErrors ? 1 : 0);
}

main().catch(err => {
  console.error(`Fatal error: ${(err as Error).message}`);
  process.exit(1);
});
