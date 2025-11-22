/**
 * Palimpsest License plugin for Eleventy (11ty)
 *
 * Installation:
 * 1. Copy this file to your project
 * 2. Add to .eleventy.js:
 *    const palimpsestPlugin = require('./palimpsest-plugin.js');
 *    module.exports = function(eleventyConfig) {
 *      eleventyConfig.addPlugin(palimpsestPlugin, {
 *        version: '0.4',
 *        author: 'Your Name',
 *        workTitle: 'My Site'
 *      });
 *    };
 */

module.exports = function(eleventyConfig, options = {}) {
  const config = {
    version: options.version || '0.4',
    licenseUrl: options.licenseUrl || `https://palimpsestlicense.org/v${options.version || '0.4'}`,
    workTitle: options.workTitle || 'My Work',
    author: options.author || 'Author Name',
    agiConsentRequired: options.agiConsentRequired !== false,
    emotionalLineage: options.emotionalLineage,
    language: options.language || 'en'
  };

  /**
   * Shortcode for license meta tags
   */
  eleventyConfig.addShortcode('palimpsestMeta', function() {
    const tags = [
      `<meta name="license" content="${config.licenseUrl}">`,
      `<meta name="license-type" content="Palimpsest-${config.version}">`,
      `<meta property="og:license" content="${config.licenseUrl}">`,
      `<meta name="dcterms.license" content="${config.licenseUrl}">`,
      `<meta name="palimpsest:version" content="${config.version}">`,
      `<meta name="palimpsest:agi-consent" content="${config.agiConsentRequired}">`,
    ];

    if (config.author) {
      tags.push(`<meta name="author" content="${config.author}">`);
      tags.push(`<meta name="dcterms.creator" content="${config.author}">`);
    }

    if (config.emotionalLineage) {
      tags.push(`<meta name="palimpsest:emotional-lineage" content="${config.emotionalLineage}">`);
    }

    return '<!-- Palimpsest License Metadata -->\n' +
           tags.join('\n') +
           '\n<!-- End Palimpsest License Metadata -->';
  });

  /**
   * Shortcode for JSON-LD
   */
  eleventyConfig.addShortcode('palimpsestJsonLd', function() {
    const metadata = {
      '@context': 'https://schema.org',
      '@type': 'CreativeWork',
      name: config.workTitle,
      author: {
        '@type': 'Person',
        name: config.author
      },
      license: config.licenseUrl,
      usageInfo: 'https://palimpsestlicense.org',
      additionalProperty: [
        {
          '@type': 'PropertyValue',
          name: 'Palimpsest:Version',
          value: config.version
        },
        {
          '@type': 'PropertyValue',
          name: 'Palimpsest:AGIConsent',
          value: config.agiConsentRequired
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

    if (config.emotionalLineage) {
      metadata.additionalProperty.splice(1, 0, {
        '@type': 'PropertyValue',
        name: 'Palimpsest:EmotionalLineage',
        value: config.emotionalLineage
      });
    }

    return `<script type="application/ld+json">\n${JSON.stringify(metadata, null, 2)}\n</script>`;
  });

  /**
   * Shortcode for license badge
   */
  eleventyConfig.addShortcode('palimpsestBadge', function(theme = 'light') {
    const text = config.language === 'nl'
      ? `Palimpsest Licentie v${config.version}`
      : `Palimpsest License v${config.version}`;

    const styles = theme === 'dark'
      ? 'background: #0d1117; border-color: #30363d; color: #c9d1d9;'
      : 'background: #f6f8fa; border-color: #e1e4e8; color: #24292e;';

    return `<a href="${config.licenseUrl}" target="_blank" rel="license noopener" style="display: inline-flex; align-items: center; padding: 6px 12px; border: 1px solid; border-radius: 6px; font-size: 12px; font-weight: 500; text-decoration: none; ${styles}">${text}</a>`;
  });

  /**
   * Filter to add license metadata to data
   */
  eleventyConfig.addGlobalData('palimpsest', config);
};
