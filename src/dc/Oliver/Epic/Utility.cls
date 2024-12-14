Class Oliver.Epic.Utility Extends %RegisteredObject
{

/// var allergySearchString = "/AllergyIntolerance?patient=" + patientId;
ClassMethod GetAllergySearchString() As %String
{
    Set tAllergySearchString = "/AllergyIntolerance?patient=#"
    Quit tAllergySearchString
}

ClassMethod GetBaseURL() As %String
{
    Set tBaseURL = "https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4"
    Quit tBaseURL
}

ClassMethod GetURL(pResource As %String = "", pPatient As %String = "") As %String
{
    Set tBaseURL = ..GetBaseURL()
    Set tURL = tBaseURL_"/"_pResource
    If (pResource = "Patient") {
        Set pQuery = "?_id="_pPatient
    } Else {
        Set pQuery = "?patient="_pPatient
    }
    Quit tURL_pQuery
}

}
