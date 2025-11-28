# Palimpsest License - Python/Flask Integration

Official Python library for integrating the Palimpsest License into Flask, Django, and FastAPI applications.

## Features

- 🔄 Automatic license metadata injection
- 📝 HTTP headers with license information
- 🌐 HTML meta tags and JSON-LD support
- ✅ License validation utilities
- 🌍 Bilingual support (English & Dutch)
- 🎨 Customisable license widgets
- 🔒 Compliance checking
- 🐍 Type hints and docstrings
- 🧪 Comprehensive test coverage

## Installation

```bash
pip install palimpsest-license
```

For Django support:
```bash
pip install palimpsest-license[django]
```

For FastAPI support:
```bash
pip install palimpsest-license[fastapi]
```

## Quick Start - Flask

```python
from flask import Flask
from palimpsest import PalimpsestFlask, PalimpsestConfig

app = Flask(__name__)

# Configure Palimpsest License
config = PalimpsestConfig(
    work_title="My Creative Work",
    author_name="Jane Doe",
    author_url="https://example.com/jane",
    emotional_lineage="A reflection on diaspora and belonging",
    version="0.4",
    language="en"
)

# Initialise extension
palimpsest = PalimpsestFlask(app, config)

@app.route('/')
def index():
    return '''
        <!DOCTYPE html>
        <html>
          <head>
            <title>My Work</title>
          </head>
          <body>
            <h1>My Creative Work</h1>
            <p>Content goes here...</p>
          </body>
        </html>
    '''

if __name__ == '__main__':
    app.run()
```

The extension will automatically inject:
- HTTP headers (`X-License`, `X-Palimpsest-Version`, etc.)
- HTML meta tags in the `<head>` section
- JSON-LD metadata before `</body>`

## Configuration Options

```python
@dataclass
class PalimpsestConfig:
    work_title: Optional[str] = None          # Title of your work
    author_name: Optional[str] = None         # Author's name
    author_url: Optional[str] = None          # Author's URL or identifier
    emotional_lineage: Optional[str] = None   # Emotional/cultural context
    version: str = "0.4"                      # License version
    license_url: str = "..."                  # License URL
    agi_consent_required: bool = True         # AGI consent flag
    inject_headers: bool = True               # Inject HTTP headers
    inject_html_meta: bool = True             # Inject HTML meta tags
    inject_jsonld: bool = True                # Inject JSON-LD
    language: Literal["en", "nl"] = "en"      # Language preference
```

## Advanced Usage

### Route-Specific License Configuration

Use the decorator for different licenses on different routes:

```python
from flask import Flask
from palimpsest import palimpsest_decorator, PalimpsestConfig

app = Flask(__name__)

story_config = PalimpsestConfig(
    work_title="Personal Stories",
    author_name="Jane Doe",
    emotional_lineage="Stories of migration and identity"
)

@app.route('/stories')
@palimpsest_decorator(story_config)
def stories():
    return '<h1>My Stories</h1>'
```

### License Information Endpoint

The Flask extension automatically creates a `/license.json` endpoint:

```python
# GET /license.json returns:
{
  "license": {
    "name": "Palimpsest License v0.4",
    "version": "0.4",
    "url": "https://palimpsestlicense.org/v0.4",
    "identifier": "Palimpsest-0.4"
  },
  "work": {
    "title": "My Work",
    "author": "Jane Doe",
    "author_url": null
  },
  "protections": {
    "emotional_lineage": "A story of resilience",
    "agi_consent_required": true,
    "metadata_preservation_required": true,
    "quantum_proof_traceability": true
  },
  "compliance": {
    "guide_url": "https://palimpsestlicense.org/guides/compliance",
    "audit_template_url": "https://palimpsestlicense.org/toolkit/audit"
  }
}
```

### Generate License Widget

```python
from palimpsest import generate_license_widget, PalimpsestConfig

config = PalimpsestConfig(
    work_title="My Work",
    author_name="Jane Doe"
)

widget_html = generate_license_widget(config, theme='dark')
```

### Validate Metadata

```python
from palimpsest import validate_metadata

metadata = {
    '@type': 'CreativeWork',
    'license': 'https://palimpsestlicense.org/v0.4',
    'author': {'name': 'Jane Doe'}
}

result = validate_metadata(metadata)

if not result['valid']:
    print('Validation errors:', result['errors'])
```

### Headers Only (No HTML Injection)

```python
config = PalimpsestConfig(
    work_title="My Work",
    author_name="Jane Doe",
    inject_headers=True,
    inject_html_meta=False,
    inject_jsonld=False
)
```

### Dutch Language Support

```python
config = PalimpsestConfig(
    work_title="Mijn Werk",
    author_name="Jane Doe",
    emotional_lineage="Een reflectie op diaspora en verbondenheid",
    language="nl"
)
```

## Core Functions

### `generate_jsonld(config)`

Generate JSON-LD metadata string.

```python
from palimpsest import generate_jsonld, PalimpsestConfig

config = PalimpsestConfig(work_title="My Work")
jsonld = generate_jsonld(config)
```

### `generate_html_meta(config)`

Generate HTML meta tags string.

```python
from palimpsest import generate_html_meta, PalimpsestConfig

config = PalimpsestConfig(author_name="Jane Doe")
meta_tags = generate_html_meta(config)
```

### `generate_license_widget(config, theme)`

Generate HTML license widget.

```python
from palimpsest import generate_license_widget, PalimpsestConfig

widget = generate_license_widget(
    PalimpsestConfig(work_title="My Work"),
    theme='light'  # or 'dark'
)
```

### `validate_metadata(metadata)`

Validate Palimpsest License metadata.

```python
from palimpsest import validate_metadata

result = validate_metadata({
    '@type': 'CreativeWork',
    'license': 'https://palimpsestlicense.org/v0.4',
    'author': {'name': 'Jane Doe'}
})

# Returns: {'valid': True, 'errors': []}
```

## Compliance

This library helps ensure compliance with:
- **Clause 2.3**: Metadata preservation
- **Clause 1.2**: Non-Interpretive (NI) systems consent
- **Emotional lineage** protection
- **Quantum-proof traceability**

### What This Library Does

✅ Injects machine-readable metadata
✅ Preserves attribution information
✅ Declares AGI consent status
✅ Provides validation utilities

### What You Still Need To Do

- Obtain explicit consent for AI training (if applicable)
- Preserve emotional and cultural context in derivatives
- Maintain metadata when distributing content
- Review the [Compliance Roadmap](https://palimpsestlicense.org/guides/compliance)

## Examples

See the `examples/` directory for:
- Basic Flask application
- REST API with license validation
- Blueprint-based applications
- Multi-language support
- Custom license configurations

## Django Support (Coming Soon)

```python
# settings.py
INSTALLED_APPS = [
    # ...
    'palimpsest.django',
]

PALIMPSEST_CONFIG = {
    'work_title': 'My Django Site',
    'author_name': 'Jane Doe',
    'version': '0.4'
}
```

## FastAPI Support (Coming Soon)

```python
from fastapi import FastAPI
from palimpsest.fastapi import PalimpsestMiddleware, PalimpsestConfig

app = FastAPI()

app.add_middleware(
    PalimpsestMiddleware,
    config=PalimpsestConfig(
        work_title="My API",
        author_name="Jane Doe"
    )
)
```

## Testing

```bash
pytest tests/
```

## Type Checking

```bash
mypy src/palimpsest
```

## Contributing

See [CONTRIBUTING.md](../../../CONTRIBUTING.md) for guidelines.

## Licence

This library is licensed under the Palimpsest License v0.4.

## Support

- Documentation: https://palimpsestlicense.org
- Issues: https://github.com/palimpsest-license/palimpsest-license/issues
- Email: hello@palimpsestlicense.org

## Related Packages

- `@palimpsest/license-middleware` - Node.js/Express middleware
- `palimpsest-php` - PHP integration library
- `palimpsest-ruby` - Ruby/Rails integration gem
