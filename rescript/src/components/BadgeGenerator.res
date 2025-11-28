// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// License badge generator for Palimpsest License
// Generates SVG badges and HTML snippets

open PalimpsestTypes

// Badge style configuration
type badgeStyle =
  | Flat
  | FlatSquare
  | Plastic
  | ForTheBadge

// Badge colour scheme
type badgeColour = {
  background: string,
  text: string,
}

// Predefined colour schemes
let defaultColours = {
  background: "#663399",  // Purple for Palimpsest
  text: "#ffffff",
}

let warningColours = {
  background: "#ff9800",  // Orange
  text: "#000000",
}

let errorColours = {
  background: "#f44336",  // Red
  text: "#ffffff",
}

let successColours = {
  background: "#4caf50",  // Green
  text: "#ffffff",
}

// Get colour scheme based on compliance status
let getColoursForCompliance = (isCompliant: bool): badgeColour => {
  if isCompliant {
    successColours
  } else {
    errorColours
  }
}

// Generate SVG badge
let generateSvgBadge = (
  ~label: string,
  ~message: string,
  ~colours: badgeColour=defaultColours,
  ~style: badgeStyle=Flat,
): string => {
  let (leftWidth, rightWidth, totalWidth) = {
    // Rough character width estimation
    let labelWidth = Js.String.length(label) * 6 + 10
    let messageWidth = Js.String.length(message) * 6 + 10
    (labelWidth, messageWidth, labelWidth + messageWidth)
  }

  let leftX = leftWidth / 2
  let rightX = leftWidth + rightWidth / 2

  let styleClass = switch style {
  | Flat => ""
  | FlatSquare => "rx=\"0\""
  | Plastic => "style=\"filter: drop-shadow(0 1px 2px rgba(0,0,0,0.2))\""
  | ForTheBadge => "style=\"font-weight: bold; text-transform: uppercase\""
  }

  `<svg xmlns="http://www.w3.org/2000/svg" width="${Belt.Int.toString(totalWidth)}" height="20" role="img" aria-label="${label}: ${message}">
  <title>${label}: ${message}</title>
  <linearGradient id="s" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <clipPath id="r">
    <rect width="${Belt.Int.toString(totalWidth)}" height="20" rx="3" fill="#fff" ${styleClass}/>
  </clipPath>
  <g clip-path="url(#r)">
    <rect width="${Belt.Int.toString(leftWidth)}" height="20" fill="#555"/>
    <rect x="${Belt.Int.toString(leftWidth)}" width="${Belt.Int.toString(rightWidth)}" height="20" fill="${colours.background}"/>
    <rect width="${Belt.Int.toString(totalWidth)}" height="20" fill="url(#s)"/>
  </g>
  <g fill="${colours.text}" text-anchor="middle" font-family="Verdana,Geneva,DejaVu Sans,sans-serif" font-size="110">
    <text x="${Belt.Int.toString(leftX * 10)}" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)">${label}</text>
    <text x="${Belt.Int.toString(leftX * 10)}" y="140" transform="scale(.1)" fill="#fff">${label}</text>
    <text x="${Belt.Int.toString(rightX * 10)}" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)">${message}</text>
    <text x="${Belt.Int.toString(rightX * 10)}" y="140" transform="scale(.1)" fill="${colours.text}">${message}</text>
  </g>
</svg>`
}

// Generate badge for license version
let generateVersionBadge = (metadata: metadata, ~style: badgeStyle=Flat): string => {
  generateSvgBadge(
    ~label="Palimpsest License",
    ~message="v" ++ versionToString(metadata.version),
    ~colours=defaultColours,
    ~style,
  )
}

// Generate badge for compliance status
let generateComplianceBadge = (result: complianceResult, ~style: badgeStyle=Flat): string => {
  let (message, colours) = if result.isCompliant {
    ("compliant", successColours)
  } else {
    ("non-compliant", errorColours)
  }

  generateSvgBadge(~label="Compliance", ~message, ~colours, ~style)
}

// Generate badge for specific consent status
let generateConsentBadge = (
  ~usageType: usageType,
  ~status: consentStatus,
  ~style: badgeStyle=Flat,
): string => {
  let usageLabel = usageTypeToString(usageType)

  let (message, colours) = switch status {
  | Granted => ("granted", successColours)
  | Denied => ("denied", errorColours)
  | ConditionallyGranted(_) => ("conditional", warningColours)
  | NotSpecified => ("not specified", warningColours)
  }

  generateSvgBadge(~label=usageLabel, ~message, ~colours, ~style)
}

// Generate HTML snippet for badge with link
let generateHtmlBadge = (
  ~svgContent: string,
  ~licenseUrl: option<string>=?,
  ~altText: string="Palimpsest License",
): string => {
  switch licenseUrl {
  | Some(url) =>
    `<a href="${url}" target="_blank" rel="license noopener">
  ${svgContent}
</a>`
  | None => svgContent
  }
}

// Generate Markdown snippet for badge
let generateMarkdownBadge = (
  ~svgDataUri: string,
  ~licenseUrl: option<string>=?,
  ~altText: string="Palimpsest License",
): string => {
  let imageMarkdown = `![${altText}](${svgDataUri})`

  switch licenseUrl {
  | Some(url) => `[${imageMarkdown}](${url})`
  | None => imageMarkdown
  }
}

// Convert SVG to data URI
let svgToDataUri = (svg: string): string => {
  // Encode SVG for data URI
  let encoded = Js.Global.encodeURIComponent(svg)
  "data:image/svg+xml," ++ encoded
}

// Generate complete badge package (SVG, HTML, Markdown)
type badgePackage = {
  svg: string,
  svgDataUri: string,
  html: string,
  markdown: string,
}

let generateBadgePackage = (
  ~label: string,
  ~message: string,
  ~licenseUrl: option<string>=?,
  ~colours: badgeColour=defaultColours,
  ~style: badgeStyle=Flat,
  ~altText: string="Palimpsest License",
): badgePackage => {
  let svg = generateSvgBadge(~label, ~message, ~colours, ~style)
  let svgDataUri = svgToDataUri(svg)
  let html = generateHtmlBadge(~svgContent=svg, ~licenseUrl?, ~altText)
  let markdown = generateMarkdownBadge(~svgDataUri, ~licenseUrl?, ~altText)

  {svg, svgDataUri, html, markdown}
}

// Generate badge package from metadata
let generateFromMetadata = (metadata: metadata, ~style: badgeStyle=Flat): badgePackage => {
  generateBadgePackage(
    ~label="Palimpsest License",
    ~message="v" ++ versionToString(metadata.version),
    ~licenseUrl=Some(metadata.licenseUri),
    ~colours=defaultColours,
    ~style,
    ~altText="Licensed under Palimpsest License v" ++ versionToString(metadata.version),
  )
}

// Generate badge package from compliance result
let generateFromCompliance = (result: complianceResult, ~style: badgeStyle=Flat): badgePackage => {
  let (message, colours) = if result.isCompliant {
    ("compliant", successColours)
  } else {
    ("non-compliant", errorColours)
  }

  generateBadgePackage(
    ~label="Compliance",
    ~message,
    ~colours,
    ~style,
    ~altText="Palimpsest License Compliance: " ++ message,
  )
}

// Generate shields.io compatible URL
let generateShieldsIoUrl = (
  ~label: string,
  ~message: string,
  ~colour: string="purple",
  ~style: string="flat",
): string => {
  let encodedLabel = Js.Global.encodeURIComponent(label)
  let encodedMessage = Js.Global.encodeURIComponent(message)

  `https://img.shields.io/badge/${encodedLabel}-${encodedMessage}-${colour}?style=${style}`
}

// Generate shields.io URL for license
let generateLicenseShieldsUrl = (metadata: metadata, ~style: string="flat"): string => {
  generateShieldsIoUrl(
    ~label="license",
    ~message="Palimpsest v" ++ versionToString(metadata.version),
    ~colour="purple",
    ~style,
  )
}
