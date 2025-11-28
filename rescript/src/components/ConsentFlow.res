// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Consent flow UI components
// Interactive forms for managing AI training and usage consents

open PalimpsestTypes

// Consent form configuration
type consentFormConfig = {
  showExplanations: bool,
  allowConditional: bool,
  requireJustification: bool,
  multiStep: bool,
}

let defaultFormConfig: consentFormConfig = {
  showExplanations: true,
  allowConditional: true,
  requireJustification: false,
  multiStep: true,
}

// Consent form state
type consentFormState = {
  usageType: usageType,
  status: consentStatus,
  conditions: option<string>,
  justification: option<string>,
  revocable: bool,
  expiryDate: option<string>,
}

// Get explanation text for usage type
let getUsageExplanation = (usage: usageType): string => {
  switch usage {
  | Interpretive =>
    "Interpretive use allows AI systems to analyse, understand, and interpret the meaning, emotions, and context of your work. This includes sentiment analysis, content moderation, and semantic understanding."
  | NonInterpretive =>
    "Non-interpretive use covers simple storage, display, and transmission of your work without AI analysis. This is generally permitted under the license."
  | Training =>
    "Training use allows AI models to learn from your work to improve their capabilities. This may include incorporating patterns, styles, or content from your work into the model's parameters."
  | Derivative =>
    "Derivative use permits creation of new works based on or inspired by your original work, including remixes, adaptations, and transformations."
  | Commercial =>
    "Commercial use allows your work to be used in profit-making activities or commercial products and services."
  | Personal =>
    "Personal use covers non-commercial, individual use of your work for learning, enjoyment, or personal projects."
  }
}

// Get recommendation for usage type
let getUsageRecommendation = (usage: usageType): (string, [#grant | #deny | #conditional]) => {
  switch usage {
  | Interpretive => (
      "Consider denying or adding conditions to protect emotional and symbolic content",
      #conditional,
    )
  | Training => (
      "Carefully consider whether you want AI to learn from your creative expressions",
      #conditional,
    )
  | NonInterpretive => ("Generally safe to grant for basic functionality", #grant)
  | Derivative => (
      "Consider conditions to preserve attribution and emotional lineage",
      #conditional,
    )
  | Commercial => ("Consider your monetisation strategy and attribution requirements", #conditional)
  | Personal => ("Generally safe to grant for non-commercial use", #grant)
  }
}

// Generate HTML for single consent option
let generateConsentOption = (
  ~usage: usageType,
  ~currentStatus: option<consentStatus>=?,
  ~config: consentFormConfig,
): string => {
  let usageName = usageTypeToString(usage)
  let explanation = if config.showExplanations {
    `<p class="consent-explanation">${getUsageExplanation(usage)}</p>`
  } else {
    ""
  }

  let (recommendation, recommendationType) = getUsageRecommendation(usage)
  let recommendationClass = switch recommendationType {
  | #grant => "recommendation-grant"
  | #deny => "recommendation-deny"
  | #conditional => "recommendation-conditional"
  }

  let recommendationHTML = if config.showExplanations {
    `<p class="consent-recommendation ${recommendationClass}">💡 ${recommendation}</p>`
  } else {
    ""
  }

  let selectedGranted = switch currentStatus {
  | Some(Granted) => "checked"
  | _ => ""
  }

  let selectedDenied = switch currentStatus {
  | Some(Denied) => "checked"
  | _ => ""
  }

  let selectedConditional = switch currentStatus {
  | Some(ConditionallyGranted(_)) => "checked"
  | _ => ""
  }

  let conditionalInput = if config.allowConditional {
    `
    <label class="consent-radio">
      <input type="radio" name="consent-${usageName}" value="conditional" ${selectedConditional}>
      <span>Conditional (specify conditions below)</span>
    </label>
    <div class="consent-conditions" id="conditions-${usageName}">
      <label for="conditions-text-${usageName}">Conditions:</label>
      <textarea id="conditions-text-${usageName}" name="conditions-${usageName}" rows="3"
                placeholder="E.g., 'Only for non-commercial research' or 'Must preserve cultural context'"></textarea>
    </div>
`
  } else {
    ""
  }

  `
<div class="consent-option" data-usage="${usageName}">
  <h4>${usageName} Use</h4>
  ${explanation}
  ${recommendationHTML}
  <div class="consent-choices">
    <label class="consent-radio">
      <input type="radio" name="consent-${usageName}" value="granted" ${selectedGranted}>
      <span>✓ Grant</span>
    </label>
    <label class="consent-radio">
      <input type="radio" name="consent-${usageName}" value="denied" ${selectedDenied}>
      <span>✗ Deny</span>
    </label>
    ${conditionalInput}
  </div>
</div>
`
}

// Generate complete consent form
let generateConsentForm = (~config: consentFormConfig=defaultFormConfig, ~existingConsents: array<consent>=[]): string => {
  // Key usage types to display in the form
  let usageTypes = [Interpretive, Training, Derivative, Commercial]

  let consentOptions = usageTypes
    ->Belt.Array.map(usage => {
      let currentStatus = existingConsents
        ->Belt.Array.getBy(c => c.usageType === usage)
        ->Belt.Option.map(c => c.status)

      generateConsentOption(~usage, ~currentStatus?, ~config)
    })
    ->Js.Array.joinWith("")

  let justificationField = if config.requireJustification {
    `
    <div class="consent-justification">
      <h4>Justification (Required)</h4>
      <p class="explanation">Please explain your reasoning for these consent choices:</p>
      <textarea name="justification" rows="4" required
                placeholder="Your reasoning helps others understand the context of your choices..."></textarea>
    </div>
`
  } else {
    ""
  }

  let revocableOption = `
<div class="consent-revocable">
  <label>
    <input type="checkbox" name="revocable" value="true" checked>
    <span>Allow me to revoke these consents in the future</span>
  </label>
  <p class="explanation-small">We recommend keeping consents revocable to maintain control over your work.</p>
</div>
`

  let expiryField = `
<div class="consent-expiry">
  <label for="expiry-date">Consent expiry date (optional):</label>
  <input type="date" id="expiry-date" name="expiry-date">
  <p class="explanation-small">Leave empty for indefinite consent. Set an expiry date for time-limited permissions.</p>
</div>
`

  `
<form class="palimpsest-consent-form" id="palimpsest-consent-form">
  <h3>Usage Consent Management</h3>
  <p class="form-intro">
    The Palimpsest License requires explicit consent for certain uses of your work.
    Please review each usage type carefully and indicate your preferences.
  </p>

  <div class="consent-options">
    ${consentOptions}
  </div>

  ${justificationField}
  ${revocableOption}
  ${expiryField}

  <div class="form-actions">
    <button type="submit" class="btn-primary">Save Consent Preferences</button>
    <button type="reset" class="btn-secondary">Reset Form</button>
  </div>
</form>
`
}

// Generate CSS for consent form
let generateConsentFormCSS = (): string => {
  `
.palimpsest-consent-form {
  max-width: 800px;
  margin: 2rem auto;
  padding: 2rem;
  background: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
}

.palimpsest-consent-form h3 {
  margin: 0 0 1rem 0;
  color: #663399;
  font-size: 1.5rem;
}

.form-intro {
  color: #666;
  margin-bottom: 2rem;
  padding: 1rem;
  background: #f5f5f5;
  border-left: 4px solid #663399;
  border-radius: 4px;
}

.consent-options {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.consent-option {
  padding: 1.5rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background: #fafafa;
}

.consent-option h4 {
  margin: 0 0 0.5rem 0;
  color: #663399;
  font-size: 1.1rem;
}

.consent-explanation {
  font-size: 0.9rem;
  color: #666;
  margin: 0.5rem 0 1rem 0;
  line-height: 1.5;
}

.consent-recommendation {
  font-size: 0.85rem;
  padding: 0.5rem;
  border-radius: 4px;
  margin: 0.5rem 0 1rem 0;
}

.recommendation-grant {
  background: #e8f5e9;
  border-left: 3px solid #4caf50;
}

.recommendation-deny {
  background: #ffebee;
  border-left: 3px solid #f44336;
}

.recommendation-conditional {
  background: #fff3e0;
  border-left: 3px solid #ff9800;
}

.consent-choices {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.consent-radio {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem;
  border: 2px solid #e0e0e0;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}

.consent-radio:hover {
  border-color: #663399;
  background: #f9f9f9;
}

.consent-radio input[type="radio"] {
  margin: 0;
}

.consent-radio input[type="radio"]:checked + span {
  font-weight: bold;
  color: #663399;
}

.consent-conditions {
  margin-top: 0.5rem;
  padding: 0.75rem;
  background: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 4px;
  display: none;
}

.consent-radio input[value="conditional"]:checked ~ .consent-conditions,
.consent-option input[value="conditional"]:checked + * + .consent-conditions {
  display: block;
}

.consent-conditions textarea {
  width: 100%;
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-family: inherit;
  font-size: 0.9rem;
  resize: vertical;
}

.consent-justification,
.consent-revocable,
.consent-expiry {
  margin: 1.5rem 0;
  padding: 1rem;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  background: #fafafa;
}

.consent-justification h4 {
  margin: 0 0 0.5rem 0;
  color: #663399;
}

.consent-justification textarea {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-family: inherit;
  font-size: 0.9rem;
  resize: vertical;
}

.consent-revocable label {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  cursor: pointer;
}

.consent-expiry label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: bold;
  color: #333;
}

.consent-expiry input[type="date"] {
  padding: 0.5rem;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 0.9rem;
}

.explanation,
.explanation-small {
  color: #666;
  font-size: 0.85rem;
  margin: 0.5rem 0 0 0;
  line-height: 1.4;
}

.explanation-small {
  font-size: 0.8rem;
}

.form-actions {
  display: flex;
  gap: 1rem;
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 1px solid #e0e0e0;
}

.btn-primary,
.btn-secondary {
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 4px;
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.2s;
}

.btn-primary {
  background: #663399;
  color: white;
}

.btn-primary:hover {
  background: #552288;
}

.btn-secondary {
  background: #e0e0e0;
  color: #333;
}

.btn-secondary:hover {
  background: #d0d0d0;
}
`
}

// Generate JavaScript for form interactions
let generateConsentFormJS = (): string => {
  `
(function() {
  const form = document.getElementById('palimpsest-consent-form');
  if (!form) return;

  // Show/hide conditional fields
  form.querySelectorAll('input[type="radio"]').forEach(radio => {
    radio.addEventListener('change', function() {
      const option = this.closest('.consent-option');
      const conditionsDiv = option.querySelector('.consent-conditions');

      if (conditionsDiv) {
        conditionsDiv.style.display = this.value === 'conditional' ? 'block' : 'none';
      }
    });
  });

  // Form submission
  form.addEventListener('submit', function(e) {
    e.preventDefault();

    const formData = new FormData(this);
    const consents = [];

    // Process each usage type
    const usageTypes = ['interpretive', 'training', 'derivative', 'commercial'];
    usageTypes.forEach(usage => {
      const status = formData.get('consent-' + usage);
      if (status) {
        const consent = {
          usageType: usage,
          status: status,
          revocable: formData.get('revocable') === 'true',
          expiryDate: formData.get('expiry-date') || null,
        };

        if (status === 'conditional') {
          consent.conditions = formData.get('conditions-' + usage);
        }

        consents.push(consent);
      }
    });

    const result = {
      consents: consents,
      justification: formData.get('justification'),
      timestamp: new Date().toISOString(),
    };

    // Dispatch custom event with consent data
    window.dispatchEvent(new CustomEvent('palimpsest:consent-updated', {
      detail: result
    }));

    // You can also send to server here
    console.log('Consent preferences saved:', result);
    alert('Consent preferences saved successfully!');
  });
})();
`
}

// Generate complete embeddable consent form
let generateEmbeddableConsentForm = (
  ~config: consentFormConfig=defaultFormConfig,
  ~existingConsents: array<consent>=[],
): string => {
  let css = "<style>" ++ generateConsentFormCSS() ++ "</style>"
  let html = generateConsentForm(~config, ~existingConsents)
  let js = "<script>" ++ generateConsentFormJS() ++ "</script>"

  css ++ html ++ js
}

// Generate simple consent toggle (for quick grant/deny)
let generateSimpleConsentToggle = (~usage: usageType, ~currentStatus: consentStatus): string => {
  let usageName = usageTypeToString(usage)
  let isGranted = switch currentStatus {
  | Granted | ConditionallyGranted(_) => "true"
  | _ => "false"
  }

  let checkedAttr = if isGranted === "true" {
    "checked"
  } else {
    ""
  }

  `
<div class="consent-toggle" data-usage="${usageName}">
  <label class="toggle-switch">
    <input type="checkbox" ${checkedAttr} data-usage="${usageName}">
    <span class="toggle-slider"></span>
  </label>
  <span class="toggle-label">${usageName} use</span>
</div>
`
}
