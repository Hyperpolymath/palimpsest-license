/**
 * TypeScript definitions for @palimpsest/license-client
 */

export interface LicenseMetadata {
  '@context'?: string;
  '@type': 'CreativeWork';
  name?: string;
  license: string;
  author: {
    '@type': 'Person';
    name: string;
    url?: string;
  };
  usageInfo?: string;
  additionalProperty?: PropertyValue[];
}

export interface PropertyValue {
  '@type': 'PropertyValue';
  name: string;
  value: string | boolean;
}

export interface VerificationResult {
  valid: boolean;
  errors: string[];
  metadata: LicenseMetadata | null;
}

export interface PalimpsestConfig {
  version?: string;
  licenseUrl?: string;
  language?: 'en' | 'nl';
  theme?: 'light' | 'dark';
}

/**
 * Extract license metadata from the current page
 */
export function extractLicenseMetadata(): LicenseMetadata | null;

/**
 * Verify if the current page has valid Palimpsest License metadata
 */
export function verifyLicense(): VerificationResult;

/**
 * Create a license badge widget
 */
export function createLicenseBadge(options?: PalimpsestConfig): HTMLElement;

/**
 * Create a full license notice widget
 */
export function createLicenseNotice(options?: PalimpsestConfig): HTMLElement;

/**
 * Auto-initialize license widgets on page load
 */
export function autoInit(): void;

/**
 * Palimpsest License API
 */
export interface PalimpsestAPI {
  extractLicenseMetadata: typeof extractLicenseMetadata;
  verifyLicense: typeof verifyLicense;
  createLicenseBadge: typeof createLicenseBadge;
  createLicenseNotice: typeof createLicenseNotice;
  autoInit: typeof autoInit;
  version: string;
}

declare const Palimpsest: PalimpsestAPI;

export default Palimpsest;

/**
 * Global declaration for browser usage
 */
declare global {
  interface Window {
    Palimpsest: PalimpsestAPI;
  }
}
