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

  badge.href = config.licenseUrl;
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

  badge.innerHTML = `
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" style="margin-right: 6px;">
      <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="currentColor" stroke-width="2"/>
      <path d="M2 17L12 22L22 17" stroke="currentColor" stroke-width="2"/>
      <path d="M2 12L12 17L22 12" stroke="currentColor" stroke-width="2"/>
    </svg>
    ${text}
  `;

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
    main: `Dit werk is beschermd onder de <strong>Palimpsest Licentie v${config.version}</strong>.`,
    requirement: 'Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.',
    link: 'Lees de volledige licentie'
  } : {
    main: `This work is protected under the <strong>Palimpsest License v${config.version}</strong>.`,
    requirement: "Derivatives must preserve the original's emotional and cultural integrity.",
    link: 'Read the full license'
  };

  notice.innerHTML = `
    <div style="display: flex; align-items: center;">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" style="margin-right: 12px; flex-shrink: 0;">
        <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="${styles.linkColor}" stroke-width="2"/>
        <path d="M2 17L12 22L22 17" stroke="${styles.linkColor}" stroke-width="2"/>
        <path d="M2 12L12 17L22 12" stroke="${styles.linkColor}" stroke-width="2"/>
      </svg>
      <div>
        <p style="margin: 0 0 8px 0;">${text.main}</p>
        <p style="margin: 0 0 8px 0; font-size: 13px; opacity: 0.8;">${text.requirement}</p>
        <a href="${config.licenseUrl}" style="color: ${styles.linkColor}; text-decoration: none; font-weight: 500;" target="_blank" rel="license noopener">${text.link} →</a>
      </div>
    </div>
  `;

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
