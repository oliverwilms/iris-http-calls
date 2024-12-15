Class dc.Oliver.OAuth Extends %RegisteredObject
{

ClassMethod MakeX509Credentials(pPath As %String = "/home/irisowner/dev/", pPrivateKey As %String = "privatekey.pem", pPublicKey As %String = "publickey509.pem") As %Status
{
    Set oX509Credentials = ##class(%SYS.X509Credentials).%New()
    Set oX509Credentials.Alias = "medbank"
    Set tSC = oX509Credentials.LoadCertificate(pPath_pPublicKey)
    Do $System.Status.DisplayError(tSC)
    Set tSC = oX509Credentials.LoadPrivateKey(pPath_pPrivateKey)
    Do $System.Status.DisplayError(tSC)
    Set tSC = oX509Credentials.%Save()
    Quit tSC
}

}
