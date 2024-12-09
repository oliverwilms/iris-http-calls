Class dc.HTTP.InboundAdapter Extends Ens.InboundAdapter
{

Property Server As %String;

Parameter SETTINGS = "Server:Connection";

Method OnTask() As %Status
{
	Set tSC = $$$OK
	Quit tSC
}

}
