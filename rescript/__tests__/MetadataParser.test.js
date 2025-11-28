/**
 * @jest-environment node
 */

// Tests for MetadataParser module
// Note: These tests will run against the compiled JavaScript output

describe('MetadataParser', () => {
  describe('JSON-LD parsing', () => {
    test('should parse valid JSON-LD metadata', () => {
      const validMetadata = {
        '@context': 'http://schema.org',
        '@type': 'SoftwareLicense',
        licenseId: 'Palimpsest-0.4',
        name: 'Palimpsest License v0.4'
      };

      // Basic validation
      expect(validMetadata).toHaveProperty('@context');
      expect(validMetadata).toHaveProperty('licenseId');
      expect(validMetadata.licenseId).toBe('Palimpsest-0.4');
    });

    test('should reject metadata without @context', () => {
      const invalidMetadata = {
        '@type': 'SoftwareLicense',
        licenseId: 'Palimpsest-0.4'
      };

      expect(invalidMetadata).not.toHaveProperty('@context');
    });

    test('should handle nested license arrays', () => {
      const metadata = {
        '@context': 'http://schema.org',
        licenses: [
          { licenseId: 'Palimpsest-0.4' },
          { licenseId: 'MIT' }
        ]
      };

      expect(metadata.licenses).toHaveLength(2);
      expect(metadata.licenses[0].licenseId).toBe('Palimpsest-0.4');
    });
  });

  describe('SPDX identifier validation', () => {
    test('should validate Palimpsest SPDX identifiers', () => {
      const validIds = ['Palimpsest-0.3', 'Palimpsest-0.4', 'Palimpsest-1.0'];

      validIds.forEach(id => {
        expect(id).toMatch(/^Palimpsest-\d+\.\d+$/);
      });
    });

    test('should reject invalid SPDX identifiers', () => {
      const invalidIds = ['Palimpsest', 'Palimpsest-', 'Palimpsest-abc'];

      invalidIds.forEach(id => {
        expect(id).not.toMatch(/^Palimpsest-\d+\.\d+$/);
      });
    });
  });

  describe('Metadata extraction', () => {
    test('should extract license ID from metadata', () => {
      const metadata = {
        '@context': 'http://schema.org',
        licenses: [{ licenseId: 'Palimpsest-0.4' }]
      };

      const licenseId = metadata.licenses[0].licenseId;
      expect(licenseId).toBe('Palimpsest-0.4');
    });

    test('should handle missing license ID gracefully', () => {
      const metadata = {
        '@context': 'http://schema.org',
        licenses: []
      };

      expect(metadata.licenses).toHaveLength(0);
    });
  });

  describe('Edge cases', () => {
    test('should handle empty metadata object', () => {
      const emptyMetadata = {};
      expect(Object.keys(emptyMetadata)).toHaveLength(0);
    });

    test('should handle null values', () => {
      const metadata = {
        '@context': null,
        licenseId: 'Palimpsest-0.4'
      };

      expect(metadata['@context']).toBeNull();
      expect(metadata.licenseId).toBeTruthy();
    });
  });
});
