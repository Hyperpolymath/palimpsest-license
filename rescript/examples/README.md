# Palimpsest ReScript Examples

This directory contains practical examples demonstrating how to integrate the Palimpsest License ReScript implementation into your projects.

## Available Examples

### 1. `basic-website.html`

A complete example showing how to:
- Embed license metadata in JSON-LD format
- Parse and validate metadata
- Generate and display license badges
- Show detailed metadata information
- Check compliance for specific usage types

**Use Case:** Static websites, blogs, portfolio sites

**Key Features:**
- Minimal dependencies
- Clear, well-commented code
- Demonstrates core functionality

### 2. `consent-form.html`

An interactive consent management form that allows creators to:
- Review different usage types
- Grant, deny, or conditionally permit usage
- Set expiry dates for consents
- Export consent preferences as metadata

**Use Case:** Creator dashboards, content management systems

**Key Features:**
- Full interactive form with explanations
- Real-time validation
- Event-driven architecture
- Backend integration example

### 3. `widget-integration.html` (Coming Soon)

Shows how to use the complete license widget:
- Expandable license information display
- Compliance checking
- Consent status display
- Customisable theming

## How to Use These Examples

### Step 1: Build the ReScript Project

First, ensure the ReScript code is compiled:

```bash
cd ..  # Navigate to rescript directory
npm install
npm run build
```

### Step 2: Update Import Paths

Each example file contains placeholder comments for imports. Update them to point to your compiled JavaScript files:

```javascript
// Change this:
// import { parseString } from '../lib/js/src/core/MetadataParser.bs.js';

// To this (adjust path as needed):
import { parseString } from '../lib/js/src/core/MetadataParser.bs.js';
```

### Step 3: Serve the Files

You can use any static file server. For example:

**Using Python:**
```bash
python3 -m http.server 8000
```

**Using Node.js (http-server):**
```bash
npx http-server -p 8000
```

**Using VS Code:**
Install the "Live Server" extension and click "Go Live"

### Step 4: Open in Browser

Navigate to `http://localhost:8000/examples/basic-website.html` (or whichever example you want to view).

## Customising the Examples

### Modifying Metadata

Edit the JSON-LD script tag in any example:

```html
<script type="application/ld+json" id="palimpsest-metadata">
{
    "version": "0.4",
    "workTitle": "Your Work Title",
    "licenseUri": "https://palimpsest.org/licenses/v0.4",
    "attribution": {
        "creators": [
            {
                "name": "Your Name",
                "identifier": "https://your-website.com"
            }
        ],
        "mustPreserveLineage": true
    },
    "consents": [
        {
            "usageType": "training",
            "status": "denied",
            "revocable": true
        }
    ]
}
</script>
```

### Changing Display Styles

Modify the display configuration:

```javascript
const style = {
    format: { TAG: 1 },  // 0=Compact, 1=Standard, 2=Detailed, 3=Technical
    showIcons: true,
    showLinks: true,
    highlightTrauma: true
};
```

### Badge Styles

Change badge appearance:

```javascript
// Badge styles (ReScript variants)
const Flat = { TAG: 0 };
const FlatSquare = { TAG: 1 };
const Plastic = { TAG: 2 };
const ForTheBadge = { TAG: 3 };

const badge = generateVersionBadge(metadata, { style: FlatSquare });
```

## Integration Patterns

### Pattern 1: Auto-Initialisation

Automatically detect and display license information on page load:

```javascript
import { autoInitialize } from '../lib/js/src/utils/WebIntegration.bs.js';

document.addEventListener('DOMContentLoaded', () => {
    autoInitialize({
        TAG: 0,  // scriptId
        _0: 'palimpsest-metadata'
    });
});
```

### Pattern 2: Dynamic Content

Load metadata from an API:

```javascript
async function loadAndDisplayLicense(workId) {
    const response = await fetch(`/api/works/${workId}/license`);
    const metadata = await response.json();

    const parseResult = parseString(JSON.stringify(metadata));
    if (parseResult.TAG === 'Ok') {
        const widget = generateWidget({
            metadata: parseResult._0,
            config: defaultConfig
        });
        document.getElementById('license').innerHTML = widget;
    }
}
```

### Pattern 3: Compliance Gating

Check compliance before allowing access:

```javascript
function checkAccess(metadata, requestedUsage) {
    const result = checkUsage(metadata, requestedUsage);

    if (!result.isCompliant) {
        showAccessDeniedMessage(result.issues);
        return false;
    }

    return true;
}
```

## Common Issues

### Issue: Module Not Found

**Problem:** Browser can't find the imported modules.

**Solution:**
1. Verify the build completed successfully
2. Check that import paths are correct
3. Ensure you're serving files with a static server (not opening HTML directly)

### Issue: CORS Errors

**Problem:** Browser blocks module loading due to CORS.

**Solution:** Use a proper static file server (see Step 3 above).

### Issue: Type Errors in JavaScript

**Problem:** Variants/options not working as expected.

**Solution:** Remember ReScript types compile to JavaScript objects:
- `Some(value)` → `value`
- `None` → `undefined`
- `Ok(value)` → `{ TAG: 'Ok', _0: value }`
- `Error(msg)` → `{ TAG: 'Error', _0: msg }`
- Variants → `{ TAG: number }` (0-indexed)

## Testing Your Integration

### Checklist

- [ ] Metadata parses without errors
- [ ] Validation passes (or expected warnings shown)
- [ ] Badge displays correctly
- [ ] Metadata display shows all fields
- [ ] Consent form is interactive
- [ ] Compliance checks work as expected
- [ ] Styling matches your site design

### Debugging

Enable console logging:

```javascript
console.log('Metadata:', metadata);
console.log('Validation result:', validationResult);
console.log('Compliance result:', complianceResult);
```

## Further Resources

- [Installation Guide](../docs/INSTALLATION.md)
- [API Documentation](../docs/API.md)
- [Integration Examples](../docs/INTEGRATION.md)
- [Developer Guide](../docs/DEVELOPER_GUIDE.md)

## Contributing Examples

Have a useful integration example? Please contribute!

1. Create a new HTML file in this directory
2. Follow the existing structure
3. Add comprehensive comments
4. Update this README
5. Submit a pull request

---

**Questions?** Open an issue or consult the main project documentation.
