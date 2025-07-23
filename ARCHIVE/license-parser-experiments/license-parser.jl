module LicenseParser
using EzXML
export validate_license

function validate_license(filepath, license_id)
    doc = readxml(filepath)
    tags = findall("//syntheticLineageTag/license", doc)
    any(tag -> nodecontent(tag) == license_id, tags)
end
end
