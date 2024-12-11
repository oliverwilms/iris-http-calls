Class dc.Demo.Setup
{

ClassMethod Init(TokenValue As %String) As %Status
{
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Demo.Setup - Init('"_$Get(TokenValue)_"')"
    set st=$$$OK
    set production="dc.Demo.Production"

    set item="dc.Demo.RedditService"
    //set st=##class(shvarov.i14y.Settings).SetValue(production,item,"Limit",TokenValue)
    return st
}

ClassMethod StartProduction()
{
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Demo.Setup - StartProduction()"
    set prodClass = "dc.Demo.Production"
    do ##class(%EnsembleMgr).SetAutoStart($namespace, prodClass)
    job ##class(Ens.Director).StartProduction(prodClass)
}

}
