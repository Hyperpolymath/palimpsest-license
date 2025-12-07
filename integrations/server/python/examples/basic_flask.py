"""
Basic Flask Application with Palimpsest License Integration

This example demonstrates how to integrate the Palimpsest License
into a simple Flask application.
"""

from flask import Flask, render_template_string
from palimpsest import PalimpsestFlask, PalimpsestConfig, generate_license_widget

app = Flask(__name__)

# Configure Palimpsest License
config = PalimpsestConfig(
    work_title="Voices of the Diaspora",
    author_name="Amara Okafor",
    author_url="https://example.com/amara",
    emotional_lineage="A collection of stories exploring migration, identity, and belonging across generations",
    version="0.4",
    agi_consent_required=True,
    language="en",
)

# Initialise Palimpsest extension
palimpsest = PalimpsestFlask(app, config)

# HTML template
HOME_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voices of the Diaspora</title>
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        max-width: 800px;
        margin: 40px auto;
        padding: 20px;
        line-height: 1.6;
        color: #2c3e50;
      }
      h1 { color: #2c3e50; }
      .story {
        background: #f8f9fa;
        padding: 20px;
        margin: 20px 0;
        border-left: 4px solid #0366d6;
        border-radius: 4px;
      }
      .story h2 {
        margin-top: 0;
        color: #0366d6;
      }
      footer {
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px solid #e1e4e8;
        text-align: center;
        color: #586069;
      }
      footer a {
        color: #0366d6;
        text-decoration: none;
      }
      footer a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <h1>Voices of the Diaspora</h1>
    <p><em>A collection of stories exploring migration, identity, and belonging.</em></p>

    <div class="story">
      <h2>The Journey</h2>
      <p>
        In 1985, my grandmother left Lagos with nothing but a suitcase and a dream.
        She spoke three languages fluently, but English—the language of her new home—
        felt foreign on her tongue. Every word was a bridge she had to build.
      </p>
      <p>
        Twenty years later, she would tell me: "I didn't lose my home. I carried it with me,
        in every story, every recipe, every song I refused to forget."
      </p>
    </div>

    <div class="story">
      <h2>Between Two Worlds</h2>
      <p>
        Growing up, I never quite belonged anywhere. Too Nigerian for Britain, too British for Nigeria.
        My accent shifted depending on who I was speaking to—code-switching became second nature.
      </p>
      <p>
        But somewhere in that in-between space, I found my voice. Not British. Not Nigerian.
        Something new. Something mine.
      </p>
    </div>

    <div class="story">
      <h2>The Return</h2>
      <p>
        When I finally visited Lagos as an adult, I expected to feel like I'd come home.
        Instead, I felt like a tourist in my own heritage. The city had changed.
        I had changed. We were strangers to each other.
      </p>
      <p>
        And yet, walking through the markets, hearing Yoruba all around me,
        I felt something stir—a recognition, deep and wordless. This was part of me,
        even if I wasn't quite part of it.
      </p>
    </div>

    {{ widget|safe }}

    <footer>
      <p>
        <small>
          This work is protected under the Palimpsest License v0.4<br>
          <a href="/license.json">View license information</a>
        </small>
      </p>
    </footer>
  </body>
</html>
"""


@app.route("/")
def index():
    """Home page with stories."""
    widget = generate_license_widget(config, theme="light")
    return render_template_string(HOME_TEMPLATE, widget=widget)


@app.route("/api/stories")
def api_stories():
    """API endpoint returning stories with license metadata."""
    return {
        "stories": [
            {
                "id": 1,
                "title": "The Journey",
                "excerpt": "In 1985, my grandmother left Lagos...",
                "license": "Palimpsest-0.4",
            },
            {
                "id": 2,
                "title": "Between Two Worlds",
                "excerpt": "Growing up, I never quite belonged anywhere...",
                "license": "Palimpsest-0.4",
            },
            {
                "id": 3,
                "title": "The Return",
                "excerpt": "When I finally visited Lagos as an adult...",
                "license": "Palimpsest-0.4",
            },
        ],
        "_metadata": {
            "license": "https://palimpsestlicense.org/v0.4",
            "attribution": "Amara Okafor",
            "emotional_lineage": "Stories of diaspora and belonging",
        },
    }


if __name__ == "__main__":
    import os

    print("Starting Flask application with Palimpsest License integration")
    print("Palimpsest License middleware active")
    print("Visit http://localhost:5000")
    print("License info available at http://localhost:5000/license.json")

    # Use environment variable for debug mode (default to False for security)
    debug_mode = os.environ.get("FLASK_DEBUG", "false").lower() == "true"
    app.run(debug=debug_mode, port=5000)
