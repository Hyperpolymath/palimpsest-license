/**
 * Popup script for Palimpsest License Verifier
 */

// Get current tab and request license information
chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
  const tab = tabs[0];

  chrome.tabs.sendMessage(tab.id, { type: 'GET_LICENSE_INFO' }, (response) => {
    if (chrome.runtime.lastError) {
      showError('Unable to check this page. The extension may not have loaded yet.');
      return;
    }

    if (response) {
      displayLicenseInfo(response.metadata, response.verification);
    } else {
      showError('No response from page.');
    }
  });
});

function displayLicenseInfo(metadata, verification) {
  const content = document.getElementById('content');

  if (!metadata) {
    content.innerHTML = `
      <div class="status error">
        <span class="status-icon">✗</span>
        <div>
          <strong>No License Detected</strong><br>
          This page does not contain Palimpsest License metadata.
        </div>
      </div>
      <div class="actions">
        <button onclick="window.open('https://palimpsestlicense.org', '_blank')">
          Learn More
        </button>
      </div>
    `;
    return;
  }

  const statusClass = verification.valid ? 'valid' : 'warning';
  const statusIcon = verification.valid ? '✓' : '!';
  const statusText = verification.valid
    ? 'Valid Palimpsest License'
    : 'License Metadata Found (Invalid)';

  let html = `
    <div class="status ${statusClass}">
      <span class="status-icon">${statusIcon}</span>
      <div><strong>${statusText}</strong></div>
    </div>
  `;

  // Show errors if any
  if (verification.errors.length > 0) {
    html += `
      <div class="errors">
        <h3>Validation Errors</h3>
        <ul>
          ${verification.errors.map(error => `<li>${escapeHtml(error)}</li>`).join('')}
        </ul>
      </div>
    `;
  }

  // Show metadata
  html += '<div class="metadata">';

  if (metadata.license) {
    html += `
      <div class="metadata-row">
        <div class="metadata-label">License:</div>
        <div class="metadata-value">
          <a href="${escapeHtml(metadata.license)}" target="_blank">
            ${escapeHtml(metadata.license)}
          </a>
        </div>
      </div>
    `;
  }

  if (metadata.author && metadata.author.name) {
    html += `
      <div class="metadata-row">
        <div class="metadata-label">Author:</div>
        <div class="metadata-value">${escapeHtml(metadata.author.name)}</div>
      </div>
    `;
  }

  if (metadata.name) {
    html += `
      <div class="metadata-row">
        <div class="metadata-label">Work:</div>
        <div class="metadata-value">${escapeHtml(metadata.name)}</div>
      </div>
    `;
  }

  // Show Palimpsest-specific properties
  if (metadata.additionalProperty) {
    metadata.additionalProperty.forEach(prop => {
      if (prop.name.startsWith('Palimpsest:')) {
        const label = prop.name.replace('Palimpsest:', '');
        let value = prop.value;

        if (label === 'AGIConsent') {
          value = value === true || value === 'true'
            ? 'Required'
            : 'Not Required';
        }

        html += `
          <div class="metadata-row">
            <div class="metadata-label">${escapeHtml(label)}:</div>
            <div class="metadata-value">${escapeHtml(String(value))}</div>
          </div>
        `;
      }
    });
  }

  html += '</div>';

  // Actions
  html += `
    <div class="actions">
      <button onclick="copyMetadata()">Copy Metadata</button>
      <button class="primary" onclick="window.open('${escapeHtml(metadata.license)}', '_blank')">
        View License
      </button>
    </div>
  `;

  content.innerHTML = html;

  // Store metadata for copying
  window.currentMetadata = metadata;
}

function showError(message) {
  const content = document.getElementById('content');
  content.innerHTML = `
    <div class="status error">
      <span class="status-icon">✗</span>
      <div><strong>Error</strong><br>${escapeHtml(message)}</div>
    </div>
  `;
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

function copyMetadata() {
  if (window.currentMetadata) {
    const json = JSON.stringify(window.currentMetadata, null, 2);
    navigator.clipboard.writeText(json).then(() => {
      const button = event.target;
      const originalText = button.textContent;
      button.textContent = 'Copied!';
      setTimeout(() => {
        button.textContent = originalText;
      }, 2000);
    });
  }
}
