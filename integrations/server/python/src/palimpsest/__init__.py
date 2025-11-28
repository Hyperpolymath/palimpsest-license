"""
Palimpsest License - Python Integration Library

Provides utilities for integrating the Palimpsest License into Python web applications,
including Flask, Django, and FastAPI support.
"""

from .core import (
    PalimpsestConfig,
    generate_jsonld,
    generate_html_meta,
    generate_license_widget,
    validate_metadata,
)

from .flask_integration import (
    PalimpsestFlask,
    palimpsest_decorator,
    license_info_route,
)

__version__ = "0.4.0"

__all__ = [
    "PalimpsestConfig",
    "generate_jsonld",
    "generate_html_meta",
    "generate_license_widget",
    "validate_metadata",
    "PalimpsestFlask",
    "palimpsest_decorator",
    "license_info_route",
]
