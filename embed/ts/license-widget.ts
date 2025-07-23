// embed/js/license-widget.ts

/**
 * Palimpsest License Widget v0.3 (TypeScript Version)
 * Dynamically inserts a license notice into a target element.
 *
 * This script is self-initializing and reads configuration from the <script> tag's data attributes.
 *
 * @usage
 * <div id="palimpsest-widget-container"></div>
 * <script src="dist/license-widget.js"
 *         data-target-id="palimpsest-widget-container"
 *         data-theme="light"
 *         data-lang="en"
 *         async>
 * </script>
 */

// Define the types for our widget's configuration and themes.
type Theme = 'light' | 'dark';
type Language = 'en' | 'nl';

interface WidgetOptions {
  targetId: string;
  theme: Theme;
  lang: Language;
}

interface StyleConfig {
  borderColor: string;
  fontColor: string;
  linkColor: string;
}

/**
 * Initializes and renders the Palimpsest license widget on the page.
 */
function initializeWidget(): void {
  // Type safety: document.currentScript can be null. We must check for it.
  const scriptTag = document.currentScript as HTMLScriptElement | null;
  if (!scriptTag) {
    console.error('Palimpsest Widget: Could not find the script tag. Make sure the script is not loaded as a module with `type="module"`.');
    return;
  }

  // Extract options from data attributes with type safety and defaults.
  const options: WidgetOptions = {
    targetId: scriptTag.getAttribute('data-target-id') || 'palimpsest-widget-container',
    theme: (scriptTag.getAttribute('data-theme') as Theme) || 'light',
    lang: (scriptTag.getAttribute('data-lang') as Language) || 'en',
  };

  // Type safety: The target element might not exist.
  const container = document.getElementById(options.targetId);
  if (!container) {
    console.error(`Palimpsest Widget: Target element with id "${options.targetId}" not found.`);
    return;
  }

  // Define styles and text content based on configuration.
  const styles: Record<Theme, StyleConfig> = {
    light: {
      borderColor: '#e1e4e8',
      fontColor: '#24292e',
      linkColor: '#0366d6',
    },
    dark: {
      borderColor: '#30363d',
      fontColor: '#c9d1d9',
      linkColor: '#58a6ff',
    },
  };
  const currentStyle = styles[options.theme];

  const textContent: Record<Language, { main: string; link: string }> = {
    en: {
      main: "This work is protected under the <strong>Palimpsest License v0.3</strong>.<br>Derivatives must preserve the original's emotional and cultural integrity.",
      link: 'Read the full license',
    },
    nl: {
      main: "Dit werk is beschermd onder de <strong>Palimpsest Licentie v0.3</strong>.<br>Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.",
      link: 'Lees de volledige licentie',
    },
  };
  const currentText = textContent[options.lang];

  // Generate the widget's HTML content.
  const widgetHTML = `
    <div class="palimpsest-notice" style="border: 1px solid ${currentStyle.borderColor}; border-radius: 6px; padding: 16px; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; font-size: 14px; line-height: 1.5; color: ${currentStyle.fontColor}; display: flex; align-items: center; background-color: ${options.theme === 'dark' ? '#0d1117' : '#f6f8fa'};">
      <a href="https://palimpsestlicense.org" target="_blank" rel="noopener noreferrer" style="margin-right: 16px; flex-shrink: 0;">
        <img src="https://palimpsestlicense.org/assets/branding/badge.svg" alt="Palimpsest License v0.3 Badge" style="height: 40px; width: auto; border: 0; display: block;">
      </a>
      <p style="margin: 0;">
        ${currentText.main}
        <a href="https://palimpsestlicense.org/v0.3/full-text" style="color: ${currentStyle.linkColor}; text-decoration: none; font-weight: 500;">${currentText.link}</a>.
      </p>
    </div>
  `;

  // Render the widget.
  container.innerHTML = widgetHTML;
}

// Ensure the DOM is ready before trying to find the target element.
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeWidget);
} else {
  initializeWidget();
}
