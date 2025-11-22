"""
Core Palimpsest License utilities for Python.

This module provides the fundamental functions for generating and validating
Palimpsest License metadata across different Python web frameworks.
"""

import json
from dataclasses import dataclass, field, asdict
from typing import Optional, Dict, List, Any, Literal


@dataclass
class PalimpsestConfig:
    """Configuration for Palimpsest License integration."""

    work_title: Optional[str] = None
    author_name: Optional[str] = None
    author_url: Optional[str] = None
    emotional_lineage: Optional[str] = None
    version: str = "0.4"
    license_url: str = "https://palimpsestlicense.org/v0.4"
    agi_consent_required: bool = True
    inject_headers: bool = True
    inject_html_meta: bool = True
    inject_jsonld: bool = True
    language: Literal["en", "nl"] = "en"
    custom_license_path: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        """Convert configuration to dictionary."""
        return {k: v for k, v in asdict(self).items() if v is not None}


def generate_jsonld(config: PalimpsestConfig) -> str:
    """
    Generate JSON-LD metadata for the Palimpsest License.

    Args:
        config: Palimpsest configuration object

    Returns:
        JSON-LD string formatted for embedding in HTML

    Example:
        >>> config = PalimpsestConfig(
        ...     work_title="My Work",
        ...     author_name="Jane Doe"
        ... )
        >>> jsonld = generate_jsonld(config)
    """
    metadata = {
        "@context": "https://schema.org",
        "@type": "CreativeWork",
        "name": config.work_title or "[Work Title]",
        "author": {
            "@type": "Person",
            "name": config.author_name or "[Author Name]",
        },
        "license": config.license_url,
        "usageInfo": "https://palimpsestlicense.org",
        "additionalProperty": [
            {
                "@type": "PropertyValue",
                "name": "Palimpsest:Version",
                "value": config.version,
            },
            {
                "@type": "PropertyValue",
                "name": "Palimpsest:AGIConsent",
                "value": (
                    "Explicit consent required for AI training. See license for details."
                    if config.agi_consent_required
                    else "Consent granted with attribution. See license for details."
                ),
            },
            {
                "@type": "PropertyValue",
                "name": "Palimpsest:MetadataPreservation",
                "value": "Mandatory. Removal or modification constitutes license breach.",
            },
        ],
    }

    # Add author URL if provided
    if config.author_url:
        metadata["author"]["url"] = config.author_url

    # Add emotional lineage if provided
    if config.emotional_lineage:
        metadata["additionalProperty"].insert(
            1,
            {
                "@type": "PropertyValue",
                "name": "Palimpsest:EmotionalLineage",
                "value": config.emotional_lineage,
            },
        )

    return json.dumps(metadata, indent=2, ensure_ascii=False)


def generate_html_meta(config: PalimpsestConfig) -> str:
    """
    Generate HTML meta tags for the Palimpsest License.

    Args:
        config: Palimpsest configuration object

    Returns:
        HTML meta tags as a string

    Example:
        >>> config = PalimpsestConfig(author_name="Jane Doe")
        >>> meta_tags = generate_html_meta(config)
    """
    license_description = (
        f"Dit werk is beschermd onder de Palimpsest Licentie v{config.version}"
        if config.language == "nl"
        else f"This work is protected under the Palimpsest License v{config.version}"
    )

    tags = [
        f'<meta name="license" content="{config.license_url}">',
        f'<meta name="license-type" content="Palimpsest-{config.version}">',
        f'<meta property="og:license" content="{config.license_url}">',
        f'<meta name="dcterms.license" content="{config.license_url}">',
        f'<meta name="dcterms.rights" content="{license_description}">',
        f'<meta name="palimpsest:version" content="{config.version}">',
        f'<meta name="palimpsest:agi-consent" content="{str(config.agi_consent_required).lower()}">',
    ]

    if config.author_name:
        tags.extend(
            [
                f'<meta name="author" content="{config.author_name}">',
                f'<meta name="dcterms.creator" content="{config.author_name}">',
            ]
        )

    if config.emotional_lineage:
        tags.append(
            f'<meta name="palimpsest:emotional-lineage" content="{config.emotional_lineage}">'
        )

    return "\n    ".join(tags)


def generate_license_widget(
    config: PalimpsestConfig, theme: Literal["light", "dark"] = "light"
) -> str:
    """
    Generate a complete HTML license notice widget.

    Args:
        config: Palimpsest configuration object
        theme: Visual theme ('light' or 'dark')

    Returns:
        HTML string containing the license widget

    Example:
        >>> config = PalimpsestConfig(work_title="My Work")
        >>> widget = generate_license_widget(config, theme="dark")
    """
    text = (
        {
            "main": f"Dit werk is beschermd onder de <strong>Palimpsest Licentie v{config.version}</strong>.",
            "requirement": "Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.",
            "link": "Lees de volledige licentie",
        }
        if config.language == "nl"
        else {
            "main": f"This work is protected under the <strong>Palimpsest License v{config.version}</strong>.",
            "requirement": "Derivatives must preserve the original's emotional and cultural integrity.",
            "link": "Read the full license",
        }
    )

    styles = (
        {
            "border_color": "#30363d",
            "font_color": "#c9d1d9",
            "link_color": "#58a6ff",
            "bg_color": "#0d1117",
        }
        if theme == "dark"
        else {
            "border_color": "#e1e4e8",
            "font_color": "#24292e",
            "link_color": "#0366d6",
            "bg_color": "#f6f8fa",
        }
    )

    return f"""
<div class="palimpsest-notice" style="border: 1px solid {styles['border_color']}; border-radius: 6px; padding: 16px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 14px; line-height: 1.5; color: {styles['font_color']}; background-color: {styles['bg_color']}; margin: 20px 0;">
  <div style="display: flex; align-items: center;">
    <svg style="width: 24px; height: 24px; margin-right: 12px; flex-shrink: 0;" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M12 2L2 7L12 12L22 7L12 2Z" stroke="{styles['link_color']}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M2 17L12 22L22 17" stroke="{styles['link_color']}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
      <path d="M2 12L12 17L22 12" stroke="{styles['link_color']}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <div>
      <p style="margin: 0 0 8px 0;">{text['main']}</p>
      <p style="margin: 0 0 8px 0; font-size: 13px; opacity: 0.8;">{text['requirement']}</p>
      <a href="{config.license_url}" style="color: {styles['link_color']}; text-decoration: none; font-weight: 500;">{text['link']} →</a>
    </div>
  </div>
</div>""".strip()


def validate_metadata(metadata: Dict[str, Any]) -> Dict[str, Any]:
    """
    Validate that required Palimpsest License metadata is present.

    Args:
        metadata: Dictionary containing license metadata

    Returns:
        Dictionary with 'valid' (bool) and 'errors' (list) keys

    Example:
        >>> metadata = {
        ...     '@type': 'CreativeWork',
        ...     'license': 'https://palimpsestlicense.org/v0.4',
        ...     'author': {'name': 'Jane Doe'}
        ... }
        >>> result = validate_metadata(metadata)
        >>> result['valid']
        True
    """
    errors: List[str] = []

    # Check required fields
    if "license" not in metadata:
        errors.append("Missing required field: license")

    if "author" not in metadata or "name" not in metadata.get("author", {}):
        errors.append("Missing required field: author.name")

    if metadata.get("@type") != "CreativeWork":
        errors.append('Invalid or missing @type field (must be "CreativeWork")')

    # Check license URL
    if "license" in metadata and "palimpsest" not in metadata["license"].lower():
        errors.append("License URL does not reference Palimpsest License")

    return {"valid": len(errors) == 0, "errors": errors}


def get_http_headers(config: PalimpsestConfig) -> Dict[str, str]:
    """
    Generate HTTP headers for Palimpsest License.

    Args:
        config: Palimpsest configuration object

    Returns:
        Dictionary of HTTP header names and values

    Example:
        >>> config = PalimpsestConfig(author_name="Jane Doe")
        >>> headers = get_http_headers(config)
        >>> headers['X-License']
        'Palimpsest-0.4'
    """
    headers = {
        "X-License": f"Palimpsest-{config.version}",
        "X-License-Url": config.license_url,
        "X-Palimpsest-Version": config.version,
        "X-Palimpsest-AGI-Consent": str(config.agi_consent_required).lower(),
        "Link": f'<{config.license_url}>; rel="license"',
    }

    if config.author_name:
        headers["X-Author"] = config.author_name

    return headers


def generate_license_info(config: PalimpsestConfig) -> Dict[str, Any]:
    """
    Generate complete license information dictionary.

    Args:
        config: Palimpsest configuration object

    Returns:
        Dictionary containing complete license information

    Example:
        >>> config = PalimpsestConfig(work_title="My Work")
        >>> info = generate_license_info(config)
    """
    return {
        "license": {
            "name": f"Palimpsest License v{config.version}",
            "version": config.version,
            "url": config.license_url,
            "identifier": f"Palimpsest-{config.version}",
        },
        "work": {
            "title": config.work_title,
            "author": config.author_name,
            "author_url": config.author_url,
        },
        "protections": {
            "emotional_lineage": config.emotional_lineage,
            "agi_consent_required": config.agi_consent_required,
            "metadata_preservation_required": True,
            "quantum_proof_traceability": True,
        },
        "compliance": {
            "guide_url": "https://palimpsestlicense.org/guides/compliance",
            "audit_template_url": "https://palimpsestlicense.org/toolkit/audit",
        },
    }
