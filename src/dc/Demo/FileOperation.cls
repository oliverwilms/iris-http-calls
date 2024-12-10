Class dc.Demo.FileOperation Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.File.OutboundAdapter;

Parameter ADAPTER = "EnsLib.File.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method WriteToFile(pRequest As Ens.StreamContainer, Output pResponse As Ens.Response) As %Status
{
    Set filename = pRequest.OriginalFilename
    $$$QuitOnError(..Adapter.PutLine(filename, ""))
    $$$QuitOnError(..Adapter.PutLine(filename, " * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"))
    Return $$$OK
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="Ens.StreamContainer">
        <Method>WriteToFile</Method>
    </MapItem>
</MapItems>
}

}
