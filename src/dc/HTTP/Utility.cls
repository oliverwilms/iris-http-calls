Class dc.HTTP.Utility
{

ClassMethod Call(pServer As %String, pPort As %String, pURL As %String, pType As %String, pCred As %String, pSSLConfig As %String, ByRef pResponse As %Net.HttpResponse, pTest = 0) As %Status
{
	Set myTESTunit = (0 - $Increment(^TESTunit))
	Set ^TESTunit(myTESTunit) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Utility - Call()"
	Set tSC = $$$OK
	If ($Get(pServer) = "") Set pServer = "localhost"
	If ($Get(pPort) = "") Set pPort = 52773
	If ($Get(pURL) = "") Set pURL = "/"
	If ($Get(pType) = "") Set pType = "get"
	If ($Get(pCred) = "None") Set pCred = ""
	If ($Get(pSSLConfig) = "") Set pSSLConfig = "ISC.FeatureTracker.SSL.Config"
	Set pCred = $Get(pCred)
	Set ^TESTunit(myTESTunit,"pServer") = pServer
	Set ^TESTunit(myTESTunit,"pPort") = pPort
	Set ^TESTunit(myTESTunit,"pURL") = pURL
	Set ^TESTunit(myTESTunit,"pType") = pType
	Set ^TESTunit(myTESTunit,"pCred") = pCred
	Set ^TESTunit(myTESTunit,"pSSLConfig") = pSSLConfig
	;
	Set tRequest = ##class(%Net.HttpRequest).%New()
	Set tRequest.Server = pServer
	Set tRequest.Port = pPort
	;
	If (pPort = 443) {
			Set tRequest.Https = 1
			//Set tRequest.SSLCheckServerIdentity = 0
			Set tRequest.SSLConfiguration = pSSLConfig
		}
	;
	Set objCredential = ##class(Ens.Config.Credentials).%OpenId(pCred)
	If $IsObject(objCredential) {
		Set tRequest.InitiateAuthentication = "Basic"
		Set tRequest.Username = objCredential.Username
		Set tRequest.Password = objCredential.Password
	}
	;
	Try {
			Set pSSLConfiguration = "ISC.FeatureTracker.SSL.Config"
			Set pApplicationName = "medbank"
			Set pScopes = "openid fhirUser"
			Do ##class(dc.Oliver.OAuth).Auth(pApplicationName,pScopes)
			Set tSC = ##class(%SYS.OAuth2.AccessToken).AddAccessToken(tRequest,"header",pSSLConfiguration,pApplicationName)
			Set ^TESTunit(myTESTunit,"AddAccessToken") = $System.Status.GetErrorText(tSC)
			Set pXML = "application/fhir+xml"
			Set pJSON = "application/fhir+json"
			Set tSC = tRequest.SetHeader("accept","application/fhir+json")
	} Catch {}
	;
	Set test = $Get(pTest,0)
	Set reset = 1
	Set tSC = tRequest.Send(pType,pURL,test,reset)
	Set ^TESTunit(myTESTunit,"Send") = $System.Status.GetErrorText(tSC)
	Set pResponse = tRequest.HttpResponse
	Set ^TESTunit(myTESTunit,"StatusLine") = pResponse.StatusLine
	//Set tmp = ##class(%Stream.TmpCharacter).%New(tRequest.HttpResponse.Data)
	Set pResponse = ##class(EnsLib.HTTP.GenericMessage).%New(tRequest.HttpResponse.Data)
	Set ^TESTunit(myTESTunit,"pResponse") = pResponse
	Set tSC = pResponse.%Save()
	Set ^TESTunit(myTESTunit,"Save") = $System.Status.GetErrorText(tSC)
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Utility - Call() returns "_$System.Status.GetErrorText(tSC)
	Quit tSC
}

ClassMethod TestCall(pTest = 1) As %Status
{
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Utility - TestCall()"
	Set prodClass = "dc.Demo.Production"
	Set tConfigItem = "dc.HTTP.Service"
	Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,"HTTPServer",.pHTTPServer)
	Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,"HTTPPort",.pHTTPPort)
	Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,"URL",.pURL)
	Set pType = "GET"
	Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,"Credentials",.pCredentials)
	Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,"SSLConfig",.pSSLConfig)
	Kill pResponse
	Set tSC = ##class(Utility).Call(pHTTPServer,pHTTPPort,pURL,pType,pCredentials,pSSLConfig,.pResponse,pTest)
	Quit tSC
}

}
