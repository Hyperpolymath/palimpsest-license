// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

/**
 * Content script for Palimpsest License Verifier browser extension
 *
 * This script runs on every page and extracts license metadata.
 */

// Extract license metadata from the page
function extractLicenseMetadata() {
  // Try JSON-LD first
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

  // Fall back to meta tags
  const getMetaContent = (name) => {
    const meta = document.querySelector(`meta[name="${name}"], meta[property="${name}"]`);
    return meta ? meta.getAttribute('content') : null;
  };

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

// Verify license metadata
function verifyLicense(metadata) {
  if (!metadata) {
    return { valid: false, errors: ['No license metadata found'] };
  }

  const errors = [];

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

  return { valid: errors.length === 0, errors };
}

// Extract and verify on page load
const metadata = extractLicenseMetadata();
const verification = verifyLicense(metadata);

// Send results to background script
chrome.runtime.sendMessage({
  type: 'LICENSE_DETECTED',
  data: {
    url: window.location.href,
    metadata,
    verification
  }
});

// Update badge icon
if (verification.valid) {
  chrome.runtime.sendMessage({ type: 'UPDATE_BADGE', status: 'valid' });
} else if (metadata) {
  chrome.runtime.sendMessage({ type: 'UPDATE_BADGE', status: 'warning' });
} else {
  chrome.runtime.sendMessage({ type: 'UPDATE_BADGE', status: 'none' });
}

// Listen for messages from popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
  if (request.type === 'GET_LICENSE_INFO') {
    sendResponse({
      metadata,
      verification
    });
  }
  return true;
});
