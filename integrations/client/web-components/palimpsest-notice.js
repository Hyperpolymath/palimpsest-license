// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

/**
 * Palimpsest License Notice Web Component
 *
 * A custom HTML element for displaying a full Palimpsest License notice.
 *
 * @example
 * <palimpsest-notice
 *   version="0.4"
 *   language="en"
 *   theme="light"
 *   work-title="My Work"
 *   author-name="Jane Doe">
 * </palimpsest-notice>
 */

class PalimpsestNotice extends HTMLElement {
  constructor() {
    super();
    this.attachShadow({ mode: 'open' });
  }

  static get observedAttributes() {
    return ['version', 'language', 'theme', 'license-url', 'work-title', 'author-name'];
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

  get workTitle() {
    return this.getAttribute('work-title');
  }

  get authorName() {
    return this.getAttribute('author-name');
  }

  render() {
    const text = this.language === 'nl' ? {
      main: `Dit werk is beschermd onder de <strong>Palimpsest Licentie v${this.version}</strong>.`,
      requirement: 'Afgeleiden moeten de emotionele en culturele integriteit van het origineel behouden.',
      link: 'Lees de volledige licentie'
    } : {
      main: `This work is protected under the <strong>Palimpsest License v${this.version}</strong>.`,
      requirement: "Derivatives must preserve the original's emotional and cultural integrity.",
      link: 'Read the full license'
    };

    const styles = this.theme === 'dark' ? {
      bgColor: '#0d1117',
      borderColor: '#30363d',
      textColor: '#c9d1d9',
      linkColor: '#58a6ff'
    } : {
      bgColor: '#f6f8fa',
      borderColor: '#e1e4e8',
      textColor: '#24292e',
      linkColor: '#0366d6'
    };

    const workInfo = (this.workTitle || this.authorName) ? `
      <div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid ${styles.borderColor}; font-size: 12px; opacity: 0.8;">
        ${this.workTitle ? `<div><strong>Work:</strong> ${this.escapeHtml(this.workTitle)}</div>` : ''}
        ${this.authorName ? `<div><strong>Author:</strong> ${this.escapeHtml(this.authorName)}</div>` : ''}
      </div>
    ` : '';

    this.shadowRoot.innerHTML = `
      <style>
        :host {
          display: block;
        }

        .notice {
          border: 1px solid ${styles.borderColor};
          border-radius: 6px;
          padding: 16px;
          background: ${styles.bgColor};
          color: ${styles.textColor};
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          font-size: 14px;
          line-height: 1.5;
          margin: 20px 0;
        }

        .content {
          display: flex;
          align-items: flex-start;
        }

        svg {
          margin-right: 12px;
          flex-shrink: 0;
          margin-top: 2px;
        }

        p {
          margin: 0 0 8px 0;
        }

        .requirement {
          font-size: 13px;
          opacity: 0.8;
        }

        a {
          color: ${styles.linkColor};
          text-decoration: none;
          font-weight: 500;
        }

        a:hover {
          text-decoration: underline;
        }

        a:focus {
          outline: 2px solid ${styles.linkColor};
          outline-offset: 2px;
          border-radius: 2px;
        }

        strong {
          font-weight: 600;
        }
      </style>

      <div class="notice">
        <div class="content">
          <svg width="24" height="24" viewBox="0 0 24 24" fill="none">
            <path d="M12 2L2 7L12 12L22 7L12 2Z"
                  stroke="${styles.linkColor}"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"/>
            <path d="M2 17L12 22L22 17"
                  stroke="${styles.linkColor}"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"/>
            <path d="M2 12L12 17L22 12"
                  stroke="${styles.linkColor}"
                  stroke-width="2"
                  stroke-linecap="round"
                  stroke-linejoin="round"/>
          </svg>
          <div>
            <p>${text.main}</p>
            <p class="requirement">${text.requirement}</p>
            <a href="${this.licenseUrl}"
               target="_blank"
               rel="license noopener noreferrer">${text.link} →</a>
            ${workInfo}
          </div>
        </div>
      </div>
    `;
  }

  escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }
}

customElements.define('palimpsest-notice', PalimpsestNotice);
