Class dc.Demo.Setup
{

/// Import System Default Settings
ClassMethod Init(pFilePath As %String = "", pUrlModify As %String = "") As %Status
{
    Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.Demo.Setup - Init('"_$Get(TokenValue)_"')"
    Set tSC = $$$OK
    Set tDirectory = "/usr/irissys/mgr/i14y"
    Set tFilename = "Ens.Config.DefaultSettings.xml"
    If ##class(%File).DirectoryExists(tDirectory) {
        //Set tSC = ##class(Ens.Config.DefaultSettings).%DeleteExtent()
        //$$$ThrowOnError(tSC)
        If $$$ISERR(tSC) {
	        Do ##class(%SYS.System).WriteToConsoleLog("Unable to Delete Extent Ens.Config.DefaultSettings",0,0)
	    }
	    Set pImport = tDirectory_"/"_tFilename
	    Set tSC = ##class(Ens.Config.DefaultSettings).%Import(pImport)
	    If $$$ISERR(tSC) {
		    Set ^TESTunit(0-$Get(^TESTunit),"Import") = $System.Status.GetErrorText(tSC)
		}
    }
    Set prodClass = "dc.Demo.Production"
    Set tDirectory = $ZU(12)_pFilePath
    Set tBoolean = ##class(%File).CreateNewDir($ZU(12),pFilePath)
    If ##class(%File).DirectoryExists(tDirectory) {
        Set tConfigItem = "EnsLib.File.PassthroughOperation"
        Set tSetting = "FilePath"
        Try {
            Set st = ##class(shvarov.i14y.Settings).SetValue(prodClass,tConfigItem,tSetting,tDirectory)
        } Catch {}
    }
    If (pUrlModify '= "") {
        Set tConfigItem = "dc.HTTP.Service"
        Set tSetting = "URL"
        Set tSC = ##class(dc.Oliver.Ensemble).GetSetting(prodClass,tConfigItem,tSetting,.value)
        Set tModifiedURL = $Get(value)_pUrlModify
        Try {
            Set st = ##class(shvarov.i14y.Settings).SetValue(prodClass,tConfigItem,tSetting,tModifiedURL)
        } Catch {}
    }
    Try {
        Set tSC = ##class(dc.Oliver.Epic.Utility).SetupCredentials()
    } Catch {}
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
