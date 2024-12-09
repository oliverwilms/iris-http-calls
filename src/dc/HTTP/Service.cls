Class dc.HTTP.Service Extends Ens.BusinessService
{

Property Adapter As dc.HTTP.InboundAdapter;

Property TargetConfigNames As Ens.DataType.ConfigName;

Parameter ADAPTER = "dc.HTTP.InboundAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pInput As %Net.Remote.Object, Output pOutput As %RegisteredObject) As %Status
{
	Set targets = $LFS(..TargetConfigNames)
	Set tSC = $$$OK
	For i=1:1:$LL(targets) {
		Set target = $LG(targets, i)
		Set tSC = ..SendRequestAsync(target, pInput)
		Quit:$$$ISERR(tSC)
	}
	Quit tSC
}

}
