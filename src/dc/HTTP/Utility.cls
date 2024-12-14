Class dc.HTTP.Utility
{

ClassMethod Call(pServer As %String, pPort As %String, pURL As %String, pType As %String, pCred As %String, pSSLConfig As %String, ByRef pResponse As %Net.HttpResponse) As %Status
{
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Utility - Call()"
	Set tSC = $$$OK
	If ($Get(pServer) = "") Set pServer = "localhost"
	If ($Get(pPort) = "") Set pPort = 52773
	If ($Get(pURL) = "") Set pURL = "/"
	If ($Get(pType) = "") Set pType = "get"
	If ($Get(pCred) = "None") Set pCred = ""
	If ($Get(pSSLConfig) = "") Set pSSLConfig = "ISC.FeatureTracker.SSL.Config"
	Set pCred = $Get(pCred)
	Set ^TESTunit(0-$Get(^TESTunit),"pServer") = pServer
	Set ^TESTunit(0-$Get(^TESTunit),"pPort") = pPort
	Set ^TESTunit(0-$Get(^TESTunit),"pURL") = pURL
	Set ^TESTunit(0-$Get(^TESTunit),"pType") = pType
	Set ^TESTunit(0-$Get(^TESTunit),"pCred") = pCred
	Set ^TESTunit(0-$Get(^TESTunit),"pSSLConfig") = pSSLConfig
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
	Set test = 0
	Set reset = 1
	Set tSC = tRequest.Send(pType,pURL,test,reset)
	Set ^TESTunit(0-$Get(^TESTunit),"Send") = $System.Status.GetErrorText(tSC)
	//Set pResponse = tRequest.HttpResponse
	//Set tmp = ##class(%Stream.TmpCharacter).%New(tRequest.HttpResponse.Data)
	Set pResponse = ##class(EnsLib.HTTP.GenericMessage).%New(tRequest.HttpResponse.Data)
	Set ^TESTunit(0-$Get(^TESTunit),"pResponse") = pResponse
	Set tSC = pResponse.%Save()
	Set ^TESTunit(0-$Get(^TESTunit),"Save") = $System.Status.GetErrorText(tSC)
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_pResponse_" : "_$System.Status.GetErrorText(tSC)
	Quit tSC
}

}
