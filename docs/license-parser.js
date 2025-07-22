// wasm/license-parser.js
import init, { parse_license } from '../wasm/palimpsest_license_wasm.js';

await init();

document.addEventListener("DOMContentLoaded", () => {
  const xml = `<?xml version="1.0" encoding="UTF-8"?>
  <license version="0.3" xmlns="http://palimpsest.license/ns" xml:lang="en">
    <title>Palimpsest License v0.3</title>
    <quote lang="en">“There are moments we cross from what was to what might be. This license is built for that moment.” — Palimpsest Core, Clause 0</quote>
    <language version="en"><summary>A symbolic, layered licensing framework...</summary></language>
  </license>`;

  const result = parse_license(xml);
  console.log("Parsed License:", result);
});
