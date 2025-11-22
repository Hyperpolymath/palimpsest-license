/**
 * Basic Express Application with Palimpsest License Integration
 *
 * This example demonstrates how to integrate the Palimpsest License
 * middleware into a simple Express application.
 */

import express from 'express';
import { palimpsestMiddleware, licenseInfoHandler } from '../src/index';

const app = express();
const PORT = process.env.PORT || 3000;

// Apply Palimpsest License middleware globally
app.use(palimpsestMiddleware({
  workTitle: 'Voices of the Diaspora',
  authorName: 'Amara Okafor',
  authorUrl: 'https://example.com/amara',
  emotionalLineage: 'A collection of stories exploring migration, identity, and belonging across generations',
  version: '0.4',
  agiConsentRequired: true,
  language: 'en'
}));

// Home page
app.get('/', (req, res) => {
  res.send(`
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
          }
          h1 { color: #2c3e50; }
          .story {
            background: #f8f9fa;
            padding: 20px;
            margin: 20px 0;
            border-left: 4px solid #0366d6;
          }
        </style>
      </head>
      <body>
        <h1>Voices of the Diaspora</h1>
        <p>A collection of stories exploring migration, identity, and belonging.</p>

        <div class="story">
          <h2>The Journey</h2>
          <p>In 1985, my grandmother left Lagos with nothing but a suitcase and a dream...</p>
        </div>

        <div class="story">
          <h2>Between Two Worlds</h2>
          <p>Growing up, I never quite belonged anywhere. Too Nigerian for Britain, too British for Nigeria...</p>
        </div>

        <footer>
          <p><small>View <a href="/license">license information</a></small></p>
        </footer>
      </body>
    </html>
  `);
});

// License information endpoint
app.get('/license', licenseInfoHandler({
  workTitle: 'Voices of the Diaspora',
  authorName: 'Amara Okafor',
  emotionalLineage: 'A collection of stories exploring migration, identity, and belonging across generations'
}));

// Story API endpoint
app.get('/api/stories', (req, res) => {
  res.json({
    stories: [
      {
        id: 1,
        title: 'The Journey',
        excerpt: 'In 1985, my grandmother left Lagos...',
        license: 'Palimpsest-0.4'
      },
      {
        id: 2,
        title: 'Between Two Worlds',
        excerpt: 'Growing up, I never quite belonged anywhere...',
        license: 'Palimpsest-0.4'
      }
    ],
    _metadata: {
      license: 'https://palimpsestlicense.org/v0.4',
      attribution: 'Amara Okafor',
      emotionalLineage: 'Stories of diaspora and belonging'
    }
  });
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
  console.log('Palimpsest License middleware active');
});

export default app;
