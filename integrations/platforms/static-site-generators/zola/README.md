# Zola Integration for Palimpsest License

This guide explains how to integrate the Palimpsest License with [Zola](https://www.getzola.org/), a fast static site generator written in Rust.

## Quick Start

1. Copy `config.example.toml` settings to your site's `config.toml`
2. Add license metadata to your templates (see below)
3. Configure your `/.well-known/ai-boundary.json` file

## Template Integration

### Base Template

Add to your `templates/base.html`:

```html
<head>
    <!-- Palimpsest License metadata -->
    <link rel="license" href="{{ config.extra.license_url }}">
    <meta name="license" content="{{ config.extra.license }}">
    <meta name="ai-training-consent" content="{{ config.extra.ai_training_allowed }}">
    <meta name="creator" content="{{ config.extra.creator_name }}">
    <meta name="creator-type" content="{{ config.extra.creator_type }}">
    <meta name="ai-involved" content="{{ config.extra.ai_involved }}">
</head>
```

### HTTP Headers

If you can configure HTTP headers (via Netlify, Vercel, or your web server), add:

```
Content-License: Palimpsest-0.6
Content-Creator: type=human; name="Your Name"
Content-Provenance: type=human-created; ai-involved=false
```

## AI Boundary Declaration

Create `static/.well-known/ai-boundary.json`:

```json
{
  "ai-boundary": {
    "version": "1.0",
    "license": "Palimpsest-0.6",
    "license_url": "https://palimpsest.license/v0.6",
    "training": {
      "allowed": true,
      "attribution_required": true,
      "ethical_use_required": true
    },
    "attribution": {
      "creator": "Your Name",
      "format": "html_meta"
    }
  }
}
```

## Shortcodes

Create `templates/shortcodes/palimpsest-notice.html`:

```html
<div class="palimpsest-notice">
    <p>
        This work is licensed under the
        <a href="{{ config.extra.license_url }}">Palimpsest License v0.6</a>.
    </p>
    <p>
        AI training is permitted with attribution and ethical use requirements.
    </p>
</div>
```

Use in your content:

```markdown
{{/* palimpsest_notice() */}}
```

## Build Configuration

Zola has built-in SASS processing, so your styles will be compiled automatically.

Run locally:

```bash
zola serve
```

Build for production:

```bash
zola build
```

## Deployment

### Netlify

Add `netlify.toml`:

```toml
[build]
command = "zola build"
publish = "public"

[[headers]]
for = "/*"
[headers.values]
Content-License = "Palimpsest-0.6"
```

### Vercel

Add `vercel.json`:

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "Content-License", "value": "Palimpsest-0.6" }
      ]
    }
  ]
}
```

## Further Reading

- [Palimpsest License v0.6](/licenses/v0-6/)
- [AI Boundary Declaration Protocol](/guides/aibdp/)
- [Content Provenance Protocol](/guides/provenance/)
