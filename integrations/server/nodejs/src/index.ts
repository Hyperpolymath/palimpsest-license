/**
 * Palimpsest License Middleware for Node.js/Express
 *
 * This middleware automatically injects Palimpsest License metadata into HTTP responses
 * and provides utilities for license validation and compliance checking.
 *
 * @packageDocumentation
 */

import { Request, Response, NextFunction } from 'express';

/**
 * Configuration options for the Palimpsest License middleware
 */
export interface PalimpsestConfig {
  /** Version of the Palimpsest License (e.g., "0.4") */
  version?: string;
  /** License URL */
  licenseUrl?: string;
  /** Work title */
  workTitle?: string;
  /** Author name */
  authorName?: string;
  /** Author URL or identifier */
  authorUrl?: string;
  /** Emotional lineage description */
  emotionalLineage?: string;
  /** Whether AGI consent is required (default: true) */
  agiConsentRequired?: boolean;
  /** Whether to inject HTTP headers */
  injectHeaders?: boolean;
  /** Whether to inject HTML meta tags */
  injectHtmlMeta?: boolean;
  /** Whether to inject JSON-LD in HTML responses */
  injectJsonLd?: boolean;
  /** Custom license text path */
  customLicensePath?: string;
  /** Language preference (en, nl) */
  language?: 'en' | 'nl';
}

/**
 * Default configuration values
 */
const DEFAULT_CONFIG: Required<Omit<PalimpsestConfig, 'workTitle' | 'authorName' | 'authorUrl' | 'emotionalLineage' | 'customLicensePath'>> = {
  version: '0.4',
  licenseUrl: 'https://palimpsestlicense.org/v0.4',
  agiConsentRequired: true,
  injectHeaders: true,
  injectHtmlMeta: true,
  injectJsonLd: true,
  language: 'en'
};

/**
 * Generate JSON-LD metadata for the Palimpsest License
 */
export function generateJsonLd(config: PalimpsestConfig): string {
  const mergedConfig = { ...DEFAULT_CONFIG, ...config };

  const jsonLd = {
    '@context': 'https://schema.org',
    '@type': 'CreativeWork',
    name: config.workTitle || '[Work Title]',
    author: {
      '@type': 'Person',
      name: config.authorName || '[Author Name]',
      ...(config.authorUrl && { url: config.authorUrl })
    },
    license: mergedConfig.licenseUrl,
    usageInfo: 'https://palimpsestlicense.org',
    additionalProperty: [
      {
        '@type': 'PropertyValue',
        name: 'Palimpsest:Version',
        value: mergedConfig.version
      },
      ...(config.emotionalLineage ? [{
        '@type': 'PropertyValue',
        name: 'Palimpsest:EmotionalLineage',
        value: config.emotionalLineage
      }] : []),
      {
        '@type': 'PropertyValue',
        name: 'Palimpsest:AGIConsent',
        value: mergedConfig.agiConsentRequired
          ? 'Explicit consent required for AI training. See license for details.'
          : 'Consent granted with attribution. See license for details.'
      },
      {
        '@type': 'PropertyValue',
        name: 'Palimpsest:MetadataPreservation',
        value: 'Mandatory. Removal or modification constitutes license breach.'
      }
    ]
  };

  return JSON.stringify(jsonLd, null, 2);
}

/**
 * Generate HTML meta tags for the Palimpsest License
 */
export function generateHtmlMeta(config: PalimpsestConfig): string {
  const mergedConfig = { ...DEFAULT_CONFIG, ...config };
  const language = mergedConfig.language;

  const licenseDescription = language === 'nl'
    ? `Dit werk is beschermd onder de Palimpsest Licentie v${mergedConfig.version}`
    : `This work is protected under the Palimpsest License v${mergedConfig.version}`;

  const tags = [
    `<meta name="license" content="${mergedConfig.licenseUrl}">`,
    `<meta name="license-type" content="Palimpsest-${mergedConfig.version}">`,
    `<meta property="og:license" content="${mergedConfig.licenseUrl}">`,
    `<meta name="dcterms.license" content="${mergedConfig.licenseUrl}">`,
    `<meta name="dcterms.rights" content="${licenseDescription}">`,
    `<meta name="palimpsest:version" content="${mergedConfig.version}">`,
    `<meta name="palimpsest:agi-consent" content="${mergedConfig.agiConsentRequired}">`,
  ];

  if (config.authorName) {
    tags.push(`<meta name="author" content="${config.authorName}">`);
    tags.push(`<meta name="dcterms.creator" content="${config.authorName}">`);
  }

  if (config.emotionalLineage) {
    tags.push(`<meta name="palimpsest:emotional-lineage" content="${config.emotionalLineage}">`);
  }

  return tags.join('\n    ');
}

/**
 * Express middleware for Palimpsest License injection
 *
 * @example
 * ```typescript
 * import express from 'express';
 * import { palimpsestMiddleware } from '@palimpsest/license-middleware';
 *
 * const app = express();
 *
 * app.use(palimpsestMiddleware({
 *   workTitle: 'My Creative Work',
 *   authorName: 'Jane Doe',
 *   emotionalLineage: 'A reflection on diaspora and belonging',
 *   version: '0.4'
 * }));
 * ```
 */
export function palimpsestMiddleware(config: PalimpsestConfig = {}) {
  const mergedConfig = { ...DEFAULT_CONFIG, ...config };

  return (req: Request, res: Response, next: NextFunction) => {
    // Store original send method
    const originalSend = res.send;

    // Inject HTTP headers
    if (mergedConfig.injectHeaders) {
      res.setHeader('X-License', `Palimpsest-${mergedConfig.version}`);
      res.setHeader('X-License-Url', mergedConfig.licenseUrl);
      res.setHeader('X-Palimpsest-Version', mergedConfig.version);
      res.setHeader('X-Palimpsest-AGI-Consent', mergedConfig.agiConsentRequired.toString());
      res.setHeader('Link', `<${mergedConfig.licenseUrl}>; rel="license"`);

      if (config.authorName) {
        res.setHeader('X-Author', config.authorName);
      }
    }

    // Override send method to inject HTML content
    res.send = function(data: any): Response {
      // Only modify HTML responses
      const contentType = res.getHeader('content-type');
      if (contentType && typeof contentType === 'string' && contentType.includes('text/html')) {
        let html = data.toString();

        // Inject meta tags in <head>
        if (mergedConfig.injectHtmlMeta && html.includes('</head>')) {
          const metaTags = generateHtmlMeta(config);
          html = html.replace('</head>', `    ${metaTags}\n  </head>`);
        }

        // Inject JSON-LD before </body>
        if (mergedConfig.injectJsonLd && html.includes('</body>')) {
          const jsonLd = generateJsonLd(config);
          const scriptTag = `\n    <script type="application/ld+json">\n${jsonLd}\n    </script>`;
          html = html.replace('</body>', `${scriptTag}\n  </body>`);
        }

        data = html;
      }

      return originalSend.call(this, data);
    };

    next();
  };
}

/**
 * Validate that required Palimpsest License metadata is present
 */
export function validateMetadata(metadata: Record<string, any>): { valid: boolean; errors: string[] } {
  const errors: string[] = [];

  if (!metadata.license) {
    errors.push('Missing required field: license');
  }

  if (!metadata.author?.name) {
    errors.push('Missing required field: author.name');
  }

  if (!metadata['@type'] || metadata['@type'] !== 'CreativeWork') {
    errors.push('Invalid or missing @type field (must be "CreativeWork")');
  }

  if (metadata.license && !metadata.license.includes('palimpsest')) {
    errors.push('License URL does not reference Palimpsest License');
  }

  return {
    valid: errors.length === 0,
    errors
  };
}

/**
 * Express route handler that returns license information as JSON
 *
 * @example
 * ```typescript
 * app.get('/license', licenseInfoHandler({
 *   workTitle: 'My Work',
 *   authorName: 'Jane Doe'
 * }));
 * ```
 */
export function licenseInfoHandler(config: PalimpsestConfig) {
  return (req: Request, res: Response) => {
    const mergedConfig = { ...DEFAULT_CONFIG, ...config };

    const licenseInfo = {
      license: {
        name: `Palimpsest License v${mergedConfig.version}`,
        version: mergedConfig.version,
        url: mergedConfig.licenseUrl,
        identifier: `Palimpsest-${mergedConfig.version}`
      },
      work: {
        title: config.workTitle || null,
        author: config.authorName || null,
        authorUrl: config.authorUrl || null
      },
      protections: {
        emotionalLineage: config.emotionalLineage || null,
        agiConsentRequired: mergedConfig.agiConsentRequired,
        metadataPreservationRequired: true,
        quantumProofTraceability: true
      },
      compliance: {
        guideUrl: 'https://palimpsestlicense.org/guides/compliance',
        auditTemplateUrl: 'https://palimpsestlicense.org/toolkit/audit'
      }
    };

    res.json(licenseInfo);
  };
}

/**
 * Generate a complete HTML license notice widget
 */
export function generateLicenseWidget(config: PalimpsestConfig, theme: 'light' | 'dark' = 'light'): string {
  const mergedConfig = { ...DEFAULT_CONFIG, ...config };
  const language = mergedConfig.language;

  const text = language === 'nl' ? {
    main: `Dit werk is beschermd onder de <strong>Palimpsest Licentie v${mergedConfig.version}</strong>.`,
    requirement: 'Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.',
    link: 'Lees de volledige licentie'
  } : {
    main: `This work is protected under the <strong>Palimpsest License v${mergedConfig.version}</strong>.`,
    requirement: 'Derivatives must preserve the original\'s emotional and cultural integrity.',
    link: 'Read the full license'
  };

  const styles = theme === 'dark' ? {
    borderColor: '#30363d',
    fontColor: '#c9d1d9',
    linkColor: '#58a6ff',
    bgColor: '#0d1117'
  } : {
    borderColor: '#e1e4e8',
    fontColor: '#24292e',
    linkColor: '#0366d6',
    bgColor: '#f6f8fa'
  };

  return `
<div class="palimpsest-notice" style="border: 1px solid ${styles.borderColor}; border-radius: 6px; padding: 16px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 14px; line-height: 1.5; color: ${styles.fontColor}; background-color: ${styles.bgColor}; margin: 20px 0;">
  <div style="display: flex; align-items: center;">
    <svg style="width: 24px; height: 24px; margin-right: 12px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="${styles.linkColor}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M2 17L12 22L22 17" stroke="${styles.linkColor}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M2 12L12 17L22 12" stroke="${styles.linkColor}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <div>
      <p style="margin: 0 0 8px 0;">${text.main}</p>
      <p style="margin: 0 0 8px 0; font-size: 13px; opacity: 0.8;">${text.requirement}</p>
      <a href="${mergedConfig.licenseUrl}" style="color: ${styles.linkColor}; text-decoration: none; font-weight: 500;">${text.link} →</a>
    </div>
  </div>
</div>`.trim();
}

export default palimpsestMiddleware;
