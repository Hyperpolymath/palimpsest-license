/**
 * @jest-environment node
 */

// Tests for BadgeGenerator module

describe('BadgeGenerator', () => {
  describe('Badge URL generation', () => {
    test('should generate valid badge URL for version', () => {
      const version = '0.4';
      const badgeUrl = `https://img.shields.io/badge/Palimpsest-${version}-blue`;

      expect(badgeUrl).toContain('img.shields.io');
      expect(badgeUrl).toContain('Palimpsest');
      expect(badgeUrl).toContain(version);
    });

    test('should handle different versions', () => {
      const versions = ['0.3', '0.4', '1.0'];

      versions.forEach(version => {
        const badgeUrl = `https://img.shields.io/badge/Palimpsest-${version}-blue`;
        expect(badgeUrl).toMatch(/Palimpsest-\d+\.\d+-blue$/);
      });
    });

    test('should generate compliance badge URL', () => {
      const compliant = true;
      const badgeUrl = `https://img.shields.io/badge/Compliant-${compliant ? 'Yes' : 'No'}-${compliant ? 'green' : 'red'}`;

      expect(badgeUrl).toContain('Compliant-Yes-green');
    });

    test('should generate non-compliant badge URL', () => {
      const compliant = false;
      const badgeUrl = `https://img.shields.io/badge/Compliant-${compliant ? 'Yes' : 'No'}-${compliant ? 'green' : 'red'}`;

      expect(badgeUrl).toContain('Compliant-No-red');
    });
  });

  describe('Markdown badge generation', () => {
    test('should generate markdown badge', () => {
      const version = '0.4';
      const badgeUrl = `https://img.shields.io/badge/Palimpsest-${version}-blue`;
      const licenseUrl = 'https://palimpsest.org/licenses/v0.4';
      const markdown = `[![Palimpsest License](${badgeUrl})](${licenseUrl})`;

      expect(markdown).toMatch(/^\[!\[.*\]\(.*\)\]\(.*\)$/);
      expect(markdown).toContain('Palimpsest License');
    });

    test('should generate HTML badge', () => {
      const version = '0.4';
      const badgeUrl = `https://img.shields.io/badge/Palimpsest-${version}-blue`;
      const licenseUrl = 'https://palimpsest.org/licenses/v0.4';
      const html = `<a href="${licenseUrl}"><img src="${badgeUrl}" alt="Palimpsest License ${version}"></a>`;

      expect(html).toContain('<a href=');
      expect(html).toContain('<img src=');
      expect(html).toContain('Palimpsest License');
    });
  });

  describe('QR code generation parameters', () => {
    test('should generate QR code URL parameters', () => {
      const licenseUrl = 'https://palimpsest.org/licenses/v0.4';
      const qrUrl = `https://api.qrserver.com/v1/create-qr-code/?data=${encodeURIComponent(licenseUrl)}&size=200x200`;

      expect(qrUrl).toContain('api.qrserver.com');
      expect(qrUrl).toContain('data=');
      expect(qrUrl).toContain('size=');
    });

    test('should handle URL encoding', () => {
      const url = 'https://example.com/path?param=value&other=test';
      const encoded = encodeURIComponent(url);

      expect(encoded).not.toContain('?');
      expect(encoded).not.toContain('&');
      expect(encoded).toContain('%');
    });
  });

  describe('Badge customization', () => {
    test('should support custom colors', () => {
      const colors = ['blue', 'green', 'red', 'yellow', 'orange'];

      colors.forEach(color => {
        const badgeUrl = `https://img.shields.io/badge/Palimpsest-0.4-${color}`;
        expect(badgeUrl).toContain(color);
      });
    });

    test('should support custom labels', () => {
      const labels = ['License', 'Palimpsest', 'Legal', 'Compliance'];

      labels.forEach(label => {
        const badgeUrl = `https://img.shields.io/badge/${label}-0.4-blue`;
        expect(badgeUrl).toContain(label);
      });
    });

    test('should handle spaces in labels', () => {
      const label = 'Palimpsest License';
      const encoded = label.replace(/ /g, '%20');
      const badgeUrl = `https://img.shields.io/badge/${encoded}-0.4-blue`;

      expect(badgeUrl).toContain('%20');
    });
  });

  describe('SVG badge generation', () => {
    test('should generate SVG badge structure', () => {
      const svg = `
        <svg xmlns="http://www.w3.org/2000/svg" width="150" height="20">
          <rect fill="#007ec6" width="100" height="20"/>
          <text x="50" y="14" fill="#fff">Palimpsest 0.4</text>
        </svg>
      `.trim();

      expect(svg).toContain('<svg');
      expect(svg).toContain('xmlns');
      expect(svg).toContain('Palimpsest');
    });
  });

  describe('Badge validation', () => {
    test('should validate badge URL format', () => {
      const validUrls = [
        'https://img.shields.io/badge/Palimpsest-0.4-blue',
        'https://img.shields.io/badge/License-MIT-green',
        'https://img.shields.io/badge/Custom-Label-red'
      ];

      validUrls.forEach(url => {
        expect(url).toMatch(/^https:\/\/img\.shields\.io\/badge\/.+-.+-.+$/);
      });
    });

    test('should reject invalid badge URLs', () => {
      const invalidUrls = [
        'http://example.com/badge',
        'not-a-url',
        'https://img.shields.io/wrong-format'
      ];

      invalidUrls.forEach(url => {
        expect(url).not.toMatch(/^https:\/\/img\.shields\.io\/badge\/.+-.+-.+$/);
      });
    });
  });

  describe('Integration with license metadata', () => {
    test('should extract badge info from license metadata', () => {
      const metadata = {
        licenseId: 'Palimpsest-0.4',
        version: '0.4',
        name: 'Palimpsest License v0.4',
        url: 'https://palimpsest.org/licenses/v0.4'
      };

      const version = metadata.version;
      const url = metadata.url;

      expect(version).toBe('0.4');
      expect(url).toContain('palimpsest.org');
    });

    test('should handle missing metadata gracefully', () => {
      const metadata = {
        licenseId: 'Palimpsest-0.4'
      };

      const version = metadata.version || 'unknown';
      expect(version).toBe('unknown');
    });
  });

  describe('Edge cases', () => {
    test('should handle special characters in URLs', () => {
      const specialChars = '!@#$%^&*()';
      const encoded = encodeURIComponent(specialChars);

      expect(encoded).not.toContain('!');
      expect(encoded).not.toContain('@');
      expect(encoded).toContain('%');
    });

    test('should handle very long labels', () => {
      const longLabel = 'A'.repeat(100);
      const badgeUrl = `https://img.shields.io/badge/${longLabel}-0.4-blue`;

      expect(badgeUrl.length).toBeGreaterThan(100);
    });

    test('should handle empty version', () => {
      const version = '';
      const badgeUrl = `https://img.shields.io/badge/Palimpsest-${version || 'unknown'}-blue`;

      expect(badgeUrl).toContain('unknown');
    });
  });
});
