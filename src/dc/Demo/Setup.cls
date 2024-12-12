Class dc.Demo.Setup
{

/// Import System Default Settings
ClassMethod Init(pTokenValue As %String = "") As %Status
{
    Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Demo.Setup - Init('"_$Get(TokenValue)_"')"
    Set tSC=$$$OK
    Set tDirectory = "/usr/irissys/mgr/i14y"
    Set tFilename = "Ens.Config.DefaultSettings.xml"
    If ##class(%File).DirectoryExists(tDirectory) {
        //Set tSC = ##class(Ens.Config.DefaultSettings).%DeleteExtent()
        //$$$ThrowOnError(tSC)
        If $$$ISERR(tSC) {
	        Do ##class(%SYS.System).WriteToConsoleLog("Unable to Delete Extent Ens.Config.DefaultSettings",0,0)
	    }
	    Set pImport = tDirectory_"\"_tFilename
	    Set tSC = ##class(Ens.Config.DefaultSettings).%Import(pImport)
	    If $$$ISERR(tSC) {
		    Set ^TESTunit(0-$Get(^TESTunit)) = $System.Status.GetErrorText(tSC)
		}
    }
    Quit tSC
}

ClassMethod StartProduction()
{
    Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Demo.Setup - StartProduction()"
    set prodClass = "dc.Demo.Production"
    do ##class(%EnsembleMgr).SetAutoStart($namespace, prodClass)
    job ##class(Ens.Director).StartProduction(prodClass)
}

}
