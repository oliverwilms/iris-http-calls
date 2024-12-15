Class dc.Oliver.OAuth Extends %RegisteredObject
{

ClassMethod Auth(pClient As %String = "medbank", pScopes As %String = "", pDEBUG = 0) As %Status
{
    Set myTESTunit = (0 - $Increment(^TESTunit))
    Set ^TESTunit(myTESTunit) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Oliver.OAuth - Auth()"
    If pDEBUG {
        set ^%ISCLOG=3
        kill ^ISCLOG
    }
    If ($Get(pScopes) = "") Set pScopes = "openid fhirUser"
    Set ^TESTunit(myTESTunit,"pScopes") = pScopes
    Set isAuth = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(pClient,,pScopes,.accessToken,.idtoken,.responseProperties,.error)
    Set ^TESTunit(myTESTunit,"isAuth") = isAuth
    If isAuth { Quit isAuth }
    ;
    If $IsObject(error) {
        Set ^TESTunit(myTESTunit,"error") = error
    }
    Set tSC = ##class(%SYS.OAuth2.Authorization).GetAccessTokenClient(pClient,pScopes,.prop,.err)
    zw prop
    zw err
    Set ^TESTunit(myTESTunit,"GetAccessTokenClient") = $System.Status.GetErrorText(tSC)
    If $$$ISERR(tSC) { Do $System.Status.DisplayError(tSC) }
    //Set isAuth = ##class(%SYS.OAuth2.AccessToken).IsAuthorized(pClient,,pScopes,.accessToken,.idtoken,.responseProperties,.error)
    If pDEBUG {
        set ^%ISCLOG=0
    }
}

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
