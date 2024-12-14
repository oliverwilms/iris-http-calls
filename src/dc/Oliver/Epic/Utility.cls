Class dc.Oliver.Epic.Utility Extends %RegisteredObject
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

ClassMethod SetupCredentials() As %Status
{
    Set tSC = $$$OK
    Set tId = "FHIR"
    If (0 = ##class(Ens.Config.Credentials).%ExistsId(tId)) {
        Set oCredential = ##class(Ens.Config.Credentials).%New()
        Set oCredential.Password = "EpicFhir11!"
        Set oCredential.SystemName = tId
        Set oCredential.Username = "FHIR"
        Set tSC = oCredential.%Save()
    }
    Set tId = "FHIRTWO"
    If (0 = ##class(Ens.Config.Credentials).%ExistsId(tId)) {
        Set oCredential = ##class(Ens.Config.Credentials).%New()
        Set oCredential.Password = "EpicFhir11!"
        Set oCredential.SystemName = tId
        Set oCredential.Username = "FHIRTWO"
        Set tSC = oCredential.%Save()
    }
    Quit tSC
}

}
