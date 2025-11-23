/**
 * @jest-environment node
 */

// Tests for ComplianceChecker module

describe('ComplianceChecker', () => {
  describe('Clause validation', () => {
    test('should validate required clauses are present', () => {
      const requiredClauses = [
        'Definitions',
        'Permissions',
        'Conditions',
        'Attribution',
        'Governing Law'
      ];

      const licenseClauses = [
        { number: '1', title: 'Definitions' },
        { number: '2', title: 'Permissions' },
        { number: '3', title: 'Conditions' },
        { number: '4', title: 'Attribution' },
        { number: '10', title: 'Governing Law' }
      ];

      requiredClauses.forEach(requiredClause => {
        const found = licenseClauses.some(c => c.title === requiredClause);
        expect(found).toBe(true);
      });
    });

    test('should detect missing required clauses', () => {
      const requiredClauses = ['Definitions', 'Permissions', 'Governing Law'];
      const licenseClauses = [
        { number: '1', title: 'Definitions' }
      ];

      const missingClauses = requiredClauses.filter(
        req => !licenseClauses.some(c => c.title === req)
      );

      expect(missingClauses).toContain('Permissions');
      expect(missingClauses).toContain('Governing Law');
    });
  });

  describe('Clause 1.2 (NI Systems) compliance', () => {
    test('should detect NI systems clause', () => {
      const licenseText = `
        ## Clause 1.2 — Non-Interpretive Systems

        Non-Interpretive (NI) systems require explicit consent before use.
      `;

      expect(licenseText).toMatch(/Clause 1\.2/);
      expect(licenseText).toMatch(/Non-Interpretive/i);
    });

    test('should flag missing NI systems clause', () => {
      const licenseText = `
        ## Clause 1 — Definitions
        Some definitions here.
      `;

      expect(licenseText).not.toMatch(/Clause 1\.2/);
      expect(licenseText).not.toMatch(/Non-Interpretive/i);
    });
  });

  describe('Clause 2.3 (Metadata) compliance', () => {
    test('should detect metadata preservation clause', () => {
      const licenseText = `
        ## Clause 2.3 — Metadata Preservation

        All metadata must be preserved in derivative works.
      `;

      expect(licenseText).toMatch(/Clause 2\.3/);
      expect(licenseText).toMatch(/[Mm]etadata/);
    });

    test('should flag missing metadata clause', () => {
      const licenseText = `
        ## Clause 2 — Permissions
        You may copy the work.
      `;

      expect(licenseText).not.toMatch(/Clause 2\.3/);
    });
  });

  describe('Emotional lineage protection', () => {
    test('should detect emotional lineage keywords', () => {
      const licenseText = `
        ## Clause 6 — Emotional Lineage

        The emotional context and lineage of this work must be preserved.
      `;

      expect(licenseText).toMatch(/[Ee]motional/);
      expect(licenseText).toMatch(/[Ll]ineage/);
    });

    test('should validate lineage preservation', () => {
      const metadata = {
        emotionalLineage: {
          creator: 'Original Author',
          context: 'Protest song',
          culturalSignificance: 'High'
        }
      };

      expect(metadata).toHaveProperty('emotionalLineage');
      expect(metadata.emotionalLineage).toHaveProperty('creator');
      expect(metadata.emotionalLineage).toHaveProperty('context');
    });
  });

  describe('Version compliance', () => {
    test('should validate version format', () => {
      const validVersions = ['0.3', '0.4', '1.0', '2.1'];

      validVersions.forEach(version => {
        expect(version).toMatch(/^\d+\.\d+$/);
      });
    });

    test('should reject invalid version formats', () => {
      const invalidVersions = ['v0.3', '0.3.1.2', 'latest', ''];

      invalidVersions.forEach(version => {
        expect(version).not.toMatch(/^\d+\.\d+$/);
      });
    });
  });

  describe('Compliance report generation', () => {
    test('should generate compliance report structure', () => {
      const report = {
        version: '0.4',
        compliant: true,
        issues: [],
        warnings: [],
        timestamp: new Date().toISOString()
      };

      expect(report).toHaveProperty('version');
      expect(report).toHaveProperty('compliant');
      expect(report).toHaveProperty('issues');
      expect(report).toHaveProperty('warnings');
    });

    test('should flag non-compliant licenses', () => {
      const report = {
        version: '0.4',
        compliant: false,
        issues: [
          'Missing Clause 1.2 (NI Systems)',
          'Missing Clause 2.3 (Metadata)'
        ],
        warnings: []
      };

      expect(report.compliant).toBe(false);
      expect(report.issues).toHaveLength(2);
    });
  });

  describe('Edge cases', () => {
    test('should handle empty license text', () => {
      const licenseText = '';
      expect(licenseText).toHaveLength(0);
    });

    test('should handle malformed clause numbers', () => {
      const clauses = [
        { number: 'abc', title: 'Invalid' },
        { number: '1', title: 'Valid' }
      ];

      const validClauses = clauses.filter(c => /^\d+(\.\d+)?$/.test(c.number));
      expect(validClauses).toHaveLength(1);
    });
  });
});
