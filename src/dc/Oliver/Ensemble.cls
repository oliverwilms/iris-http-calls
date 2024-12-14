Class dc.Oliver.Ensemble
{

ClassMethod FindSDS(production As %String = "", configName As %String = "", setting As %String = "", Output value As %String) As %Status
{
	If $c(0)[production Set production = ##class(Ens.Director).GetActiveProductionName()
	If production="" Quit $$$ERROR($$$GeneralError, "Missing production name")
	If $c(0)[configName Quit $$$ERROR($$$GeneralError, "Missing config name")
	If $c(0)[setting Quit $$$ERROR($$$GeneralError, "Missing setting name")
	Set pHostClassName = "*"
	Set pTargetType = ""
	Set tBoolean = ##class(Ens.Config.DefaultSettings).%GetSetting(production,configName,pHostClassName,pTargetType,setting,.value)
	Quit tBoolean
}

ClassMethod GetSetting(production As %String = "", configName As %String = "", setting As %String = "", Output value As %String) As %Status
{
	Kill value
	Quit ..ChangeOrGetSetting("Get", production, configName, setting, .value)
}

ClassMethod ChangeOrGetSetting(operation As %String = "Get", production As %String = "", configName As %String = "", setting As %String = "", ByRef value As %String = "") As %Status [ Internal, Private ]
{
	Set op = (operation="Change") // 0 = Get, 1 = Change
	If $c(0)[production Set production = ##class(Ens.Director).GetActiveProductionName()
	If production="" Quit $$$ERROR($$$GeneralError, "Missing production name")
	If $c(0)[configName Quit $$$ERROR($$$GeneralError, "Missing config name")
	If $c(0)[setting Quit $$$ERROR($$$GeneralError, "Missing setting name")
	If $c(0)[value Set value = "" If op Quit $$$ERROR($$$GeneralError, "Missing value")
	Set oItem = ""
	Set rsql = ##class(%ResultSet.SQL).%Prepare("select %id as mid from Ens_Config.Item where Production='"_production_"' and Name='"_configName_"' order by Enabled desc")
	If rsql.%SQLCODE=100 Quit $$$ERROR($$$GeneralError, "Can't find item: Production '"_production_"' ConfigName '"_configName_"'")
	If '(rsql.%SQLCODE) If rsql.%Next() Set oItem = rsql.mid
	If '$IsObject(oItem) Quit $$$ERROR($$$GeneralError, "Can't open item: Production '"_production_"' ConfigName '"_configName_"' Error: "_rsql.%SQLCODE_" ("_rsql.%Message_")")
	// Look for existing setting
	Set f = 0, new = 0, ok = 1
	For i = 1:1:oItem.Settings.Count() {
		Set o = oItem.Settings.GetAt(i)
		If o.Name=setting Set f = 1, v = o.Value Quit
	}
	If f, 'op Set value = v Quit $$$OK // Get
	If 'f Set new = 1, oS = ##class(Ens.Config.Setting).%New() // It's a new setting
	// Look up all host settings
	Set f = 0
	Set rs = ##class(%ResultSet).%New()
	Set rs.ClassName = oItem.ClassName
	Set rs.QueryName = "EnumerateSettings"
	If (rs.QueryIsValid()) {
		Set tSC = rs.Execute()
		While rs.Next() && 'f {
			Set name = $G(rs.Data("Name"))
			If name=setting {
				If 'f Set f = 1 Set:new oS.Target = "Host"
				If 'op Set v = oS.Value
				Else  Set ok = $classmethod(oItem.ClassName, setting_"IsValid", value)
				Quit
			}
		}
	}
	Do rs.Close()
	Set rs = ""
	If f, 'op Set value = v Quit $$$OK // Get
	If 'f {
		// Look up all adapter settings
		Set rs = ##class(%ResultSet).%New()
		Set rs.ClassName = oItem.AdapterClassName()
		Set rs.QueryName = "EnumerateSettings"
		If (rs.QueryIsValid()) {
			Set tSC = rs.Execute()
			While (rs.Next()) && 'f {
				Set name = $G(rs.Data("Name"))
				If name=setting {
					If 'f Set f = 1 Set:new oS.Target = "Adapter"
					If 'op Set v = oS.Value
					Else  Set ok = $classmethod(oItem.AdapterClassName(), setting_"IsValid", value)
					Quit
				}
			}
		}
		Do rs.Close()
		Set rs = ""
	}
	If f, 'op Set value = v Quit $$$OK // Get
	If 'f || 'op Quit $$$ERROR($$$GeneralError, "Can't find setting name '"_setting_"' for Production '"_production_"' ConfigName '"_configName_"'") Quit
	If 'ok Quit $$$ERROR($$$GeneralError, "Invalid value '"_value_"' for setting name '"_setting_"' for Production '"_production_"' ConfigName '"_configName_"'") Quit
	If new {
		Set oS.Name = setting
		Set oS.Value = value
		Do oItem.Settings.Insert(oS)
		}
	Else  {
		Set o.Value = value
	}
	Set s = oItem.%Save()
	Quit s
}

}
