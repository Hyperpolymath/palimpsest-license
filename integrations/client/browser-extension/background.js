/**
 * Background service worker for Palimpsest License Verifier
 */

// Update badge based on license status
chrome.runtime.onMessage.addListener((request, sender) => {
  if (request.type === 'UPDATE_BADGE' && sender.tab) {
    const tabId = sender.tab.id;

    switch (request.status) {
      case 'valid':
        chrome.action.setBadgeText({ text: '✓', tabId });
        chrome.action.setBadgeBackgroundColor({ color: '#28a745', tabId });
        chrome.action.setTitle({
          title: 'Valid Palimpsest License detected',
          tabId
        });
        break;

      case 'warning':
        chrome.action.setBadgeText({ text: '!', tabId });
        chrome.action.setBadgeBackgroundColor({ color: '#ffc107', tabId });
        chrome.action.setTitle({
          title: 'License metadata found but invalid',
          tabId
        });
        break;

      case 'none':
        chrome.action.setBadgeText({ text: '', tabId });
        chrome.action.setTitle({
          title: 'No Palimpsest License detected',
          tabId
        });
        break;
    }
  }
});

// Store license data for popup
const licenseCache = new Map();

chrome.runtime.onMessage.addListener((request, sender) => {
  if (request.type === 'LICENSE_DETECTED' && sender.tab) {
    licenseCache.set(sender.tab.id, request.data);
  }
});

// Clean up cache when tabs are closed
chrome.tabs.onRemoved.addListener((tabId) => {
  licenseCache.delete(tabId);
});
