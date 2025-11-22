"""
Flask integration for Palimpsest License.

Provides Flask-specific middleware, decorators, and utilities for
integrating the Palimpsest License into Flask applications.
"""

from functools import wraps
from typing import Optional, Callable, Any

from flask import Flask, Response, make_response, jsonify, g, request
from .core import (
    PalimpsestConfig,
    generate_jsonld,
    generate_html_meta,
    get_http_headers,
    generate_license_info,
)


class PalimpsestFlask:
    """
    Flask extension for Palimpsest License integration.

    This extension automatically injects license metadata into responses
    and provides utilities for license validation.

    Example:
        >>> from flask import Flask
        >>> from palimpsest import PalimpsestFlask, PalimpsestConfig
        >>>
        >>> app = Flask(__name__)
        >>> config = PalimpsestConfig(
        ...     work_title="My App",
        ...     author_name="Jane Doe"
        ... )
        >>> palimpsest = PalimpsestFlask(app, config)
    """

    def __init__(
        self, app: Optional[Flask] = None, config: Optional[PalimpsestConfig] = None
    ):
        """
        Initialise the Palimpsest Flask extension.

        Args:
            app: Flask application instance (optional)
            config: Palimpsest configuration (optional)
        """
        self.config = config or PalimpsestConfig()
        if app is not None:
            self.init_app(app)

    def init_app(self, app: Flask) -> None:
        """
        Initialise the extension with a Flask application.

        Args:
            app: Flask application instance
        """
        app.before_request(self._before_request)
        app.after_request(self._after_request)

        # Store config in app extensions
        if not hasattr(app, "extensions"):
            app.extensions = {}
        app.extensions["palimpsest"] = self

        # Register license info route
        @app.route("/license.json")
        def _license_info():
            return jsonify(generate_license_info(self.config))

    def _before_request(self) -> None:
        """Store request time for potential use in metadata."""
        g.palimpsest_config = self.config

    def _after_request(self, response: Response) -> Response:
        """
        Inject Palimpsest License metadata into responses.

        Args:
            response: Flask response object

        Returns:
            Modified response with license metadata
        """
        # Inject HTTP headers
        if self.config.inject_headers:
            headers = get_http_headers(self.config)
            for key, value in headers.items():
                response.headers[key] = value

        # Inject HTML metadata for HTML responses
        content_type = response.headers.get("Content-Type", "")
        if "text/html" in content_type:
            data = response.get_data(as_text=True)

            # Inject meta tags in <head>
            if self.config.inject_html_meta and "</head>" in data:
                meta_tags = generate_html_meta(self.config)
                data = data.replace("</head>", f"    {meta_tags}\n  </head>")

            # Inject JSON-LD before </body>
            if self.config.inject_jsonld and "</body>" in data:
                jsonld = generate_jsonld(self.config)
                script_tag = (
                    f'\n    <script type="application/ld+json">\n{jsonld}\n    </script>'
                )
                data = data.replace("</body>", f"{script_tag}\n  </body>")

            response.set_data(data)

        return response


def palimpsest_decorator(config: Optional[PalimpsestConfig] = None) -> Callable:
    """
    Decorator for adding Palimpsest License metadata to specific routes.

    Use this decorator when you want to apply different license configurations
    to different routes, or when you don't want to use the global extension.

    Args:
        config: Palimpsest configuration (optional)

    Returns:
        Decorator function

    Example:
        >>> from flask import Flask
        >>> from palimpsest import palimpsest_decorator, PalimpsestConfig
        >>>
        >>> app = Flask(__name__)
        >>> config = PalimpsestConfig(work_title="My Work")
        >>>
        >>> @app.route('/')
        >>> @palimpsest_decorator(config)
        >>> def index():
        ...     return '<h1>Hello</h1>'
    """
    cfg = config or PalimpsestConfig()

    def decorator(f: Callable) -> Callable:
        @wraps(f)
        def decorated_function(*args: Any, **kwargs: Any) -> Response:
            response = make_response(f(*args, **kwargs))

            # Inject headers
            if cfg.inject_headers:
                headers = get_http_headers(cfg)
                for key, value in headers.items():
                    response.headers[key] = value

            # Inject HTML metadata for HTML responses
            content_type = response.headers.get("Content-Type", "")
            if "text/html" in content_type:
                data = response.get_data(as_text=True)

                if cfg.inject_html_meta and "</head>" in data:
                    meta_tags = generate_html_meta(cfg)
                    data = data.replace("</head>", f"    {meta_tags}\n  </head>")

                if cfg.inject_jsonld and "</body>" in data:
                    jsonld = generate_jsonld(cfg)
                    script_tag = f'\n    <script type="application/ld+json">\n{jsonld}\n    </script>'
                    data = data.replace("</body>", f"{script_tag}\n  </body>")

                response.set_data(data)

            return response

        return decorated_function

    return decorator


def license_info_route(config: PalimpsestConfig) -> Callable:
    """
    Create a route handler that returns license information.

    Args:
        config: Palimpsest configuration

    Returns:
        Flask route handler function

    Example:
        >>> from flask import Flask
        >>> from palimpsest import license_info_route, PalimpsestConfig
        >>>
        >>> app = Flask(__name__)
        >>> config = PalimpsestConfig(work_title="My Work")
        >>> app.add_url_rule('/license', 'license', license_info_route(config))
    """

    def handler():
        return jsonify(generate_license_info(config))

    return handler
