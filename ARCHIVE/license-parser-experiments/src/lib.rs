use serde::{Deserialize, Serialize};
use wasm_bindgen::prelude::*;

// Define the validation result structure
#[derive(Serialize, Deserialize)]
struct ValidationResult {
    valid: bool,
    errors: Vec<String>,
}

// Exported function: Validate advanced schemas (e.g., Quantum AI)
#[wasm_bindgen]
pub fn validate_advanced_schema(data: &str, schema_version: &str) -> String {
    // Parse input JSON
    let parsed_data: serde_json::Value = match serde_json::from_str(data) {
        Ok(v) => v,
        Err(e) => {
            let result = ValidationResult {
                valid: false,
                errors: vec![format!("JSON parse error: {}", e)],
            };
            return serde_json::to_string(&result).unwrap();
        }
    };

    // Initialize result
    let mut valid = true;
    let mut errors = Vec::new();

    // Example: Validate against v1.1 schema (for Quantum AI)
    if schema_version == "v1.1" {
        // Check for Quantum AI-specific policy
        if let Some(ai_boundaries) = parsed_data.get("ai_boundaries") {
            if let Some(default_consent) = ai_boundaries.get("default_consent") {
                // Require "qai" policy to be "deny"
                if let Some(qai_policy) = default_consent.get("qai") {
                    if qai_policy != "deny" {
                        errors.push("QAI must be denied in v1.1 schema".to_string());
                        valid = false;
                    }
                } else {
                    errors.push("Missing 'qai' policy in v1.1 schema".to_string());
                    valid = false;
                }
            }
        }
    }

    // Return result as JSON
    let result = ValidationResult { valid, errors };
    serde_json::to_string(&result).unwrap()
}
