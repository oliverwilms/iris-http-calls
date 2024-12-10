Class dc.Demo.EmailOperation Extends Ens.BusinessOperation
{

Property Adapter As EnsLib.EMail.OutboundAdapter;

Parameter ADAPTER = "EnsLib.EMail.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method SendEmail(pRequest As %Net.MailMessage, Output pResponse As Ens.Response) As %Status
{
    #dim mailMessage as %Net.MailMessage
    Set mailMessage = pRequest
    Set mailMessage.Charset="UTF-8"
    Return ..Adapter.SendMail(mailMessage)
}

XData MessageMap
{
<MapItems>
    <MapItem MessageType="%Net.MailMessage">
        <Method>SendEmail</Method>
    </MapItem>
</MapItems>
}

}
