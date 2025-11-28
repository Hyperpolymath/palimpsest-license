// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

/**
 * Palimpsest License Badge Web Component
 *
 * A custom HTML element for displaying a Palimpsest License badge.
 *
 * @example
 * <palimpsest-badge
 *   version="0.4"
 *   language="en"
 *   theme="light"
 *   license-url="https://palimpsestlicense.org/v0.4">
 * </palimpsest-badge>
 */

class PalimpsestBadge extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
  }

  static get observedAttributes() {
    return ['version', 'language', 'theme', 'license-url'];
  }

  connectedCallback() {
    this.render();
  }

  attributeChangedCallback() {
    this.render();
  }

  get version() {
    return this.getAttribute('version') || '0.4';
  }

  get language() {
    return this.getAttribute('language') || 'en';
  }

  get theme() {
    return this.getAttribute('theme') || 'light';
  }

  get licenseUrl() {
    return this.getAttribute('license-url') || `https://palimpsestlicense.org/v${this.version}`;
  }

  render() {
    const text = this.language === 'nl'
      ? `Palimpsest Licentie v${this.version}`
      : `Palimpsest License v${this.version}`;

    const styles = this.theme === 'dark' ? {
      bgColor: '#0d1117',
      borderColor: '#30363d',
      textColor: '#c9d1d9',
      hoverBorderColor: '#58a6ff'
    } : {
      bgColor: '#f6f8fa',
      borderColor: '#e1e4e8',
      textColor: '#24292e',
      hoverBorderColor: '#0366d6'
    };

    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: inline-block;
        }

        a {
          display: inline-flex;
          align-items: center;
          padding: 6px 12px;
          background: ${styles.bgColor};
          border: 1px solid ${styles.borderColor};
          border-radius: 6px;
          color: ${styles.textColor};
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          font-size: 12px;
          font-weight: 500;
          text-decoration: none;
          transition: border-color 0.2s ease;
        }

        a:hover {
          border-color: ${styles.hoverBorderColor};
        }

        a:focus {
          outline: 2px solid ${styles.hoverBorderColor};
          outline-offset: 2px;
        }

        svg {
          margin-right: 6px;
          flex-shrink: 0;
        }
      </style>

      <a href="${this.licenseUrl}"
         target="_blank"
         rel="license noopener noreferrer"
         aria-label="${text}">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none">
          <path d="M12 2L2 7L12 12L22 7L12 2Z"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"/>
          <path d="M2 17L12 22L22 17"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"/>
          <path d="M2 12L12 17L22 12"
                stroke="currentColor"
                stroke-width="2"
                stroke-linecap="round"
                stroke-linejoin="round"/>
        </svg>
        ${text}
      </a>
    `;
  }
}

customElements.define('palimpsest-badge', PalimpsestBadge);
