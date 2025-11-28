// SPDX-License-Identifier: MIT
// SPDX-FileCopyrightText: 2024-2025 Palimpsest Stewardship Council

// Parser for Palimpsest License metadata (JSON-LD and plain JSON)

open PalimpsestTypes

// Helper to safely get string from JSON
let getString = (json: Js.Json.t): option<string> => {
  json->Js.Json.decodeString
}

// Helper to safely get object from JSON
let getObject = (json: Js.Json.t): option<Js.Dict.t<Js.Json.t>> => {
  json->Js.Json.decodeObject
}

// Helper to safely get array from JSON
let getArray = (json: Js.Json.t): option<array<Js.Json.t>> => {
  json->Js.Json.decodeArray
}

// Helper to get field from object
let getField = (dict: Js.Dict.t<Js.Json.t>, key: string): option<Js.Json.t> => {
  dict->Js.Dict.get(key)
}

// Helper to get string field
let getStringField = (dict: Js.Dict.t<Js.Json.t>, key: string): option<string> => {
  dict->getField(key)->Belt.Option.flatMap(getString)
}

// Helper to get boolean field
let getBoolField = (dict: Js.Dict.t<Js.Json.t>, key: string): bool => {
  dict
  ->getField(key)
  ->Belt.Option.flatMap(Js.Json.decodeBoolean)
  ->Belt.Option.getWithDefault(false)
}

// Parse creator from JSON
let parseCreator = (json: Js.Json.t): option<creator> => {
  json->getObject->Belt.Option.map(obj => {
    {
      name: obj->getStringField("name")->Belt.Option.getWithDefault("Unknown"),
      identifier: obj->getStringField("identifier"),
      role: obj->getStringField("role"),
      contact: obj->getStringField("contact"),
    }
  })
}

// Parse array of creators
let parseCreators = (json: Js.Json.t): array<creator> => {
  json
  ->getArray
  ->Belt.Option.map(arr => {
    arr->Belt.Array.keepMap(parseCreator)
  })
  ->Belt.Option.getWithDefault([])
}

// Parse attribution from JSON
let parseAttribution = (json: Js.Json.t): option<attribution> => {
  json->getObject->Belt.Option.map(obj => {
    let creators = obj->getField("creators")->Belt.Option.map(parseCreators)->Belt.Option.getWithDefault([])

    {
      creators: creators,
      source: obj->getStringField("source"),
      originalTitle: obj->getStringField("originalTitle"),
      dateCreated: obj->getStringField("dateCreated"),
      mustPreserveLineage: obj->getBoolField("mustPreserveLineage"),
    }
  })
}

// Parse emotional lineage from JSON
let parseEmotionalLineage = (json: Js.Json.t): option<emotionalLineage> => {
  json->getObject->Belt.Option.map(obj => {
    {
      origin: obj->getStringField("origin"),
      culturalContext: obj->getStringField("culturalContext"),
      traumaMarker: obj->getBoolField("traumaMarker"),
      symbolicWeight: obj->getStringField("symbolicWeight"),
      narrativeIntent: obj->getStringField("narrativeIntent"),
    }
  })
}

// Parse consent status from string
let parseConsentStatus = (str: string): consentStatus => {
  switch str {
  | "granted" => Granted
  | "denied" => Denied
  | "not-specified" | "notSpecified" => NotSpecified
  | s if Js.String.startsWith("conditional:", s) => {
      let condition = Js.String.sliceToEnd(~from=12, s)
      ConditionallyGranted(condition)
    }
  | _ => NotSpecified
  }
}

// Parse single consent from JSON
let parseConsent = (json: Js.Json.t): option<consent> => {
  json->getObject->Belt.Option.flatMap(obj => {
    obj->getStringField("usageType")->Belt.Option.flatMap(usageTypeString => {
      usageTypeFromString(usageTypeString)->Belt.Option.map(usageType => {
        let statusString = obj->getStringField("status")->Belt.Option.getWithDefault("not-specified")
        let conditions = obj
          ->getField("conditions")
          ->Belt.Option.flatMap(getArray)
          ->Belt.Option.map(arr => arr->Belt.Array.keepMap(getString))

        {
          usageType: usageType,
          status: parseConsentStatus(statusString),
          grantedDate: obj->getStringField("grantedDate"),
          expiryDate: obj->getStringField("expiryDate"),
          conditions: conditions,
          revocable: obj->getBoolField("revocable"),
        }
      })
    })
  })
}

// Parse array of consents
let parseConsents = (json: Js.Json.t): array<consent> => {
  json
  ->getArray
  ->Belt.Option.map(arr => arr->Belt.Array.keepMap(parseConsent))
  ->Belt.Option.getWithDefault([])
}

// Parse traceability hash from JSON
let parseTraceabilityHash = (json: Js.Json.t): option<traceabilityHash> => {
  json->getObject->Belt.Option.map(obj => {
    {
      algorithm: obj->getStringField("algorithm")->Belt.Option.getWithDefault("SHA-256"),
      value: obj->getStringField("value")->Belt.Option.getWithDefault(""),
      timestamp: obj->getStringField("timestamp")->Belt.Option.getWithDefault(""),
      blockchainRef: obj->getStringField("blockchainRef"),
    }
  })
}

// Main parser: converts JSON to metadata structure
let parse = (json: Js.Json.t): result<metadata, string> => {
  switch json->getObject {
  | None => Error("Invalid JSON: expected object")
  | Some(obj) => {
      // Extract required fields
      let version = obj
        ->getStringField("version")
        ->Belt.Option.map(versionFromString)
        ->Belt.Option.getWithDefault(V04)

      let language = obj
        ->getStringField("language")
        ->Belt.Option.map(languageFromString)
        ->Belt.Option.getWithDefault(En)

      let workTitle = obj->getStringField("workTitle")
      let licenseUri = obj->getStringField("licenseUri")

      // Validate required fields
      switch (workTitle, licenseUri) {
      | (None, _) => Error("Missing required field: workTitle")
      | (_, None) => Error("Missing required field: licenseUri")
      | (Some(title), Some(uri)) => {
          // Parse optional fields
          let attribution = obj
            ->getField("attribution")
            ->Belt.Option.flatMap(parseAttribution)
            ->Belt.Option.getWithDefault({
              creators: [],
              source: None,
              originalTitle: None,
              dateCreated: None,
              mustPreserveLineage: false,
            })

          let consents = obj
            ->getField("consents")
            ->Belt.Option.map(parseConsents)
            ->Belt.Option.getWithDefault([])

          let emotionalLineage = obj
            ->getField("emotionalLineage")
            ->Belt.Option.flatMap(parseEmotionalLineage)

          let traceability = obj
            ->getField("traceability")
            ->Belt.Option.flatMap(parseTraceabilityHash)

          let workIdentifier = obj->getStringField("workIdentifier")

          let metadata: metadata = {
            version: version,
            language: language,
            workTitle: title,
            workIdentifier: workIdentifier,
            licenseUri: uri,
            attribution: attribution,
            consents: consents,
            emotionalLineage: emotionalLineage,
            traceability: traceability,
            customFields: Some(obj),
          }

          Ok(metadata)
        }
      }
    }
  }
}

// Parse from JSON string
let parseString = (jsonString: string): result<metadata, string> => {
  try {
    let json = Js.Json.parseExn(jsonString)
    parse(json)
  } catch {
  | Js.Exn.Error(e) => {
      let message = Js.Exn.message(e)->Belt.Option.getWithDefault("JSON parse error")
      Error(message)
    }
  }
}

// Serialise metadata to JSON
let serialise = (metadata: metadata): Js.Json.t => {
  let obj = Js.Dict.empty()

  // Set basic fields
  Js.Dict.set(obj, "version", Js.Json.string(versionToString(metadata.version)))
  Js.Dict.set(obj, "language", Js.Json.string(languageToString(metadata.language)))
  Js.Dict.set(obj, "workTitle", Js.Json.string(metadata.workTitle))
  Js.Dict.set(obj, "licenseUri", Js.Json.string(metadata.licenseUri))

  // Set optional work identifier
  switch metadata.workIdentifier {
  | Some(id) => Js.Dict.set(obj, "workIdentifier", Js.Json.string(id))
  | None => ()
  }

  // Serialise attribution
  let attributionObj = Js.Dict.empty()
  let creatorsArray = metadata.attribution.creators->Belt.Array.map(creator => {
    let creatorObj = Js.Dict.empty()
    Js.Dict.set(creatorObj, "name", Js.Json.string(creator.name))

    switch creator.identifier {
    | Some(id) => Js.Dict.set(creatorObj, "identifier", Js.Json.string(id))
    | None => ()
    }

    switch creator.role {
    | Some(role) => Js.Dict.set(creatorObj, "role", Js.Json.string(role))
    | None => ()
    }

    switch creator.contact {
    | Some(contact) => Js.Dict.set(creatorObj, "contact", Js.Json.string(contact))
    | None => ()
    }

    Js.Json.object_(creatorObj)
  })

  Js.Dict.set(attributionObj, "creators", Js.Json.array(creatorsArray))
  Js.Dict.set(attributionObj, "mustPreserveLineage", Js.Json.boolean(metadata.attribution.mustPreserveLineage))
  Js.Dict.set(obj, "attribution", Js.Json.object_(attributionObj))

  // Serialise consents
  let consentsArray = metadata.consents->Belt.Array.map(consent => {
    let consentObj = Js.Dict.empty()
    Js.Dict.set(consentObj, "usageType", Js.Json.string(usageTypeToString(consent.usageType)))

    let statusString = switch consent.status {
    | Granted => "granted"
    | Denied => "denied"
    | NotSpecified => "not-specified"
    | ConditionallyGranted(condition) => "conditional:" ++ condition
    }
    Js.Dict.set(consentObj, "status", Js.Json.string(statusString))
    Js.Dict.set(consentObj, "revocable", Js.Json.boolean(consent.revocable))

    Js.Json.object_(consentObj)
  })
  Js.Dict.set(obj, "consents", Js.Json.array(consentsArray))

  Js.Json.object_(obj)
}

// Serialise to JSON string
let serialiseString = (metadata: metadata): string => {
  metadata->serialise->Js.Json.stringify
}
