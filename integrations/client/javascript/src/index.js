// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

/**
 * Palimpsest License - Client-side JavaScript Library
 *
 * This library provides utilities for verifying, displaying, and managing
 * Palimpsest License metadata in web browsers.
 *
 * @packageDocumentation
 */

/**
 * Default configuration for Palimpsest License
 */
const DEFAULT_CONFIG = {
  version: '0.4',
  licenseUrl: 'https://palimpsestlicense.org/v0.4',
  language: 'en',
  theme: 'light'
};

/**
 * Sanitize a URL to prevent XSS via javascript: or data: protocols
 *
 * @param {string} url - The URL to sanitize
 * @returns {string} Sanitized URL or empty string if invalid
 */
function sanitizeUrl(url) {
  if (typeof url !== 'string') {
    return '';
  }

  const trimmedUrl = url.trim().toLowerCase();

  // Block dangerous protocols
  if (trimmedUrl.startsWith('javascript:') ||
      trimmedUrl.startsWith('data:') ||
      trimmedUrl.startsWith('vbscript:')) {
    return '';
  }

  // Only allow http, https, and relative URLs
  if (trimmedUrl.startsWith('http://') ||
      trimmedUrl.startsWith('https://') ||
      trimmedUrl.startsWith('/') ||
      trimmedUrl.startsWith('./') ||
      trimmedUrl.startsWith('../')) {
    return url;
  }

  // For other cases, prepend https:// if it looks like a domain
  if (trimmedUrl.match(/^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z]{2,})+/)) {
    return 'https://' + url;
  }

  return '';
}

/**
 * Extract license metadata from the current page
 *
 * @returns {Object|null} License metadata object or null if not found
 */
export function extractLicenseMetadata() {
  // Try to find JSON-LD metadata
  const jsonLdScript = document.querySelector('script[type="application/ld+json"]');
  if (jsonLdScript) {
    try {
      const data = JSON.parse(jsonLdScript.textContent);
      if (data['@type'] === 'CreativeWork' && data.license) {
        return data;
      }
    } catch (e) {
      console.warn('Failed to parse JSON-LD:', e);
    }
  }

  // Try to extract from meta tags
  const metadata = {
    '@type': 'CreativeWork',
    license: getMetaContent('license') || getMetaContent('dcterms.license'),
    author: {
      '@type': 'Person',
      name: getMetaContent('author') || getMetaContent('dcterms.creator')
    }
  };

  // Extract Palimpsest-specific metadata
  const palimpsestVersion = getMetaContent('palimpsest:version');
  const agiConsent = getMetaContent('palimpsest:agi-consent');
  const emotionalLineage = getMetaContent('palimpsest:emotional-lineage');

  if (palimpsestVersion || agiConsent || emotionalLineage) {
    metadata.additionalProperty = [];

    if (palimpsestVersion) {
      metadata.additionalProperty.push({
        '@type': 'PropertyValue',
        name: 'Palimpsest:Version',
        value: palimpsestVersion
      });
    }

    if (agiConsent) {
      metadata.additionalProperty.push({
        '@type': 'PropertyValue',
        name: 'Palimpsest:AGIConsent',
        value: agiConsent === 'true'
          ? 'Explicit consent required for AI training. See license for details.'
          : 'Consent granted with attribution. See license for details.'
      });
    }

    if (emotionalLineage) {
      metadata.additionalProperty.push({
        '@type': 'PropertyValue',
        name: 'Palimpsest:EmotionalLineage',
        value: emotionalLineage
      });
    }
  }

  return metadata.license ? metadata : null;
}

/**
 * Get meta tag content by name
 *
 * @param {string} name - Meta tag name
 * @returns {string|null} Meta tag content or null
 */
function getMetaContent(name) {
  const meta = document.querySelector(`meta[name="${name}"], meta[property="${name}"]`);
  return meta ? meta.getAttribute('content') : null;
}

/**
 * Verify if the current page has valid Palimpsest License metadata
 *
 * @returns {Object} Verification result with valid and errors properties
 */
export function verifyLicense() {
  const metadata = extractLicenseMetadata();
  const errors = [];

  if (!metadata) {
    errors.push('No license metadata found on page');
    return { valid: false, errors, metadata: null };
  }

  if (!metadata.license) {
    errors.push('Missing required field: license');
  } else if (!metadata.license.toLowerCase().includes('palimpsest')) {
    errors.push('License URL does not reference Palimpsest License');
  }

  if (!metadata.author || !metadata.author.name) {
    errors.push('Missing required field: author.name');
  }

  if (metadata['@type'] !== 'CreativeWork') {
    errors.push('Invalid @type field (must be "CreativeWork")');
  }

  return {
    valid: errors.length === 0,
    errors,
    metadata
  };
}

/**
 * Create a license badge widget
 *
 * @param {Object} options - Configuration options
 * @param {string} options.version - License version
 * @param {string} options.licenseUrl - License URL
 * @param {string} options.language - Language (en or nl)
 * @param {string} options.theme - Theme (light or dark)
 * @returns {HTMLElement} License badge element
 */
export function createLicenseBadge(options = {}) {
  const config = { ...DEFAULT_CONFIG, ...options };
  const badge = document.createElement('a');

  // Sanitize URL to prevent XSS via javascript: protocol
  badge.href = sanitizeUrl(config.licenseUrl);
  badge.target = '_blank';
  badge.rel = 'license noopener noreferrer';
  badge.className = 'palimpsest-badge';
  badge.setAttribute('aria-label', `Palimpsest License v${config.version}`);

  const styles = config.theme === 'dark' ? {
    bgColor: '#0d1117',
    borderColor: '#30363d',
    textColor: '#c9d1d9'
  } : {
    bgColor: '#f6f8fa',
    borderColor: '#e1e4e8',
    textColor: '#24292e'
  };

  badge.style.cssText = `
    display: inline-flex;
    align-items: center;
    padding: 6px 12px;
    background: ${styles.bgColor};
    border: 1px solid ${styles.borderColor};
    border-radius: 6px;
    color: ${styles.textColor};
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    font-size: 12px;
    font-weight: 500;
    text-decoration: none;
    transition: border-color 0.2s ease;
  `;

  const text = config.language === 'nl'
    ? `Palimpsest Licentie v${config.version}`
    : `Palimpsest License v${config.version}`;

  // Create SVG element safely
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.setAttribute('width', '16');
  svg.setAttribute('height', '16');
  svg.setAttribute('viewBox', '0 0 24 24');
  svg.setAttribute('fill', 'none');
  svg.style.marginRight = '6px';

  const paths = [
    'M12 2L2 7L12 12L22 7L12 2Z',
    'M2 17L12 22L22 17',
    'M2 12L12 17L22 12'
  ];

  paths.forEach(d => {
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', d);
    path.setAttribute('stroke', 'currentColor');
    path.setAttribute('stroke-width', '2');
    svg.appendChild(path);
  });

  badge.appendChild(svg);

  // Create text node safely (prevents XSS)
  const textNode = document.createTextNode(text);
  badge.appendChild(textNode);

  badge.addEventListener('mouseenter', () => {
    badge.style.borderColor = config.theme === 'dark' ? '#58a6ff' : '#0366d6';
  });

  badge.addEventListener('mouseleave', () => {
    badge.style.borderColor = styles.borderColor;
  });

  return badge;
}

/**
 * Create a full license notice widget
 *
 * @param {Object} options - Configuration options
 * @returns {HTMLElement} License notice element
 */
export function createLicenseNotice(options = {}) {
  const config = { ...DEFAULT_CONFIG, ...options };
  const metadata = extractLicenseMetadata();

  const notice = document.createElement('div');
  notice.className = 'palimpsest-notice';

  const styles = config.theme === 'dark' ? {
    bgColor: '#0d1117',
    borderColor: '#30363d',
    textColor: '#c9d1d9',
    linkColor: '#58a6ff'
  } : {
    bgColor: '#f6f8fa',
    borderColor: '#e1e4e8',
    textColor: '#24292e',
    linkColor: '#0366d6'
  };

  notice.style.cssText = `
    border: 1px solid ${styles.borderColor};
    border-radius: 6px;
    padding: 16px;
    background: ${styles.bgColor};
    color: ${styles.textColor};
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
    font-size: 14px;
    line-height: 1.5;
    margin: 20px 0;
  `;

  const text = config.language === 'nl' ? {
    mainPrefix: 'Dit werk is beschermd onder de ',
    mainLicense: `Palimpsest Licentie v${config.version}`,
    mainSuffix: '.',
    requirement: 'Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.',
    link: 'Lees de volledige licentie'
  } : {
    mainPrefix: 'This work is protected under the ',
    mainLicense: `Palimpsest License v${config.version}`,
    mainSuffix: '.',
    requirement: "Derivatives must preserve the original's emotional and cultural integrity.",
    link: 'Read the full license'
  };

  // Build DOM safely to prevent XSS
  const container = document.createElement('div');
  container.style.cssText = 'display: flex; align-items: center;';

  // Create SVG safely
  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  svg.setAttribute('width', '24');
  svg.setAttribute('height', '24');
  svg.setAttribute('viewBox', '0 0 24 24');
  svg.setAttribute('fill', 'none');
  svg.style.cssText = 'margin-right: 12px; flex-shrink: 0;';

  const pathData = [
    'M12 2L2 7L12 12L22 7L12 2Z',
    'M2 17L12 22L22 17',
    'M2 12L12 17L22 12'
  ];

  pathData.forEach(d => {
    const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('d', d);
    path.setAttribute('stroke', styles.linkColor);
    path.setAttribute('stroke-width', '2');
    svg.appendChild(path);
  });

  container.appendChild(svg);

  // Create content div
  const contentDiv = document.createElement('div');

  // Main paragraph with safe text content
  const mainP = document.createElement('p');
  mainP.style.cssText = 'margin: 0 0 8px 0;';
  mainP.appendChild(document.createTextNode(text.mainPrefix));
  const strong = document.createElement('strong');
  strong.textContent = text.mainLicense;
  mainP.appendChild(strong);
  mainP.appendChild(document.createTextNode(text.mainSuffix));

  // Requirement paragraph
  const reqP = document.createElement('p');
  reqP.style.cssText = 'margin: 0 0 8px 0; font-size: 13px; opacity: 0.8;';
  reqP.textContent = text.requirement;

  // Link with URL validation
  const link = document.createElement('a');
  // Validate URL to prevent javascript: protocol injection
  const sanitizedUrl = sanitizeUrl(config.licenseUrl);
  link.href = sanitizedUrl;
  link.style.cssText = `color: ${styles.linkColor}; text-decoration: none; font-weight: 500;`;
  link.target = '_blank';
  link.rel = 'license noopener';
  link.textContent = text.link + ' →';

  contentDiv.appendChild(mainP);
  contentDiv.appendChild(reqP);
  contentDiv.appendChild(link);
  container.appendChild(contentDiv);
  notice.appendChild(container);

  return notice;
}

/**
 * Auto-initialize license widgets on page load
 *
 * Looks for elements with data-palimpsest-widget attribute
 */
export function autoInit() {
  document.addEventListener('DOMContentLoaded', () => {
    // Initialize badge widgets
    document.querySelectorAll('[data-palimpsest-widget="badge"]').forEach(element => {
      const options = {
        version: element.dataset.version,
        licenseUrl: element.dataset.licenseUrl,
        language: element.dataset.language,
        theme: element.dataset.theme
      };
      const badge = createLicenseBadge(options);
      element.appendChild(badge);
    });

    // Initialize notice widgets
    document.querySelectorAll('[data-palimpsest-widget="notice"]').forEach(element => {
      const options = {
        version: element.dataset.version,
        licenseUrl: element.dataset.licenseUrl,
        language: element.dataset.language,
        theme: element.dataset.theme
      };
      const notice = createLicenseNotice(options);
      element.appendChild(notice);
    });
  });
}

/**
 * Palimpsest License API
 */
const Palimpsest = {
  extractLicenseMetadata,
  verifyLicense,
  createLicenseBadge,
  createLicenseNotice,
  autoInit,
  version: '0.4.0'
};

// Auto-initialize if script is loaded directly
if (typeof window !== 'undefined') {
  window.Palimpsest = Palimpsest;

  // Check if auto-init is enabled
  const currentScript = document.currentScript;
  if (currentScript && currentScript.hasAttribute('data-auto-init')) {
    autoInit();
  }
}

export default Palimpsest;
