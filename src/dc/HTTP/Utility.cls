Class dc.HTTP.Utility
{

ClassMethod Call(pServer As %String, pPort As %String, pURL As %String, pType As %String, ByRef pResponse As %Net.HttpResponse) As %Status
{
	Set tSC = $$$OK
	If ($Get(pServer) = "") Set pServer = "localhost"
	If ($Get(pPort) = "") Set pPort = 52773
	If ($Get(pURL) = "") Set pURL = "/"
	If ($Get(pType) = "") Set pType = "get"
	;
	Set tRequest = ##class(%Net.HttpRequest).%New()
	Set tRequest.Server = pServer
	Set tRequest.Port = pPort
	Set test = 0
	Set reset = 1
	Set tSC = tRequest.Send(pType,pURL,test,reset)
	Set pResponse = tRequest.HttpResponse
	Quit tSC
}

}
