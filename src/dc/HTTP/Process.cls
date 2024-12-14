/// 
Class dc.HTTP.Process Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Ens.StreamContainer' response='Ens.Response' height='2000' width='2000' >
<sequence xend='200' yend='450' >
<code xpos='200' ypos='250' >
<![CDATA[ Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Process - Code"]]>
</code>
<code name='doPatient' xpos='200' ypos='350' >
<annotation><![CDATA[Convert the JSON payload to a Dynamic Object]]></annotation>
<![CDATA[ // Put JSON representation of Patient resource into a dynamic object
 Set doPatient = ##class(%DynamicObject).%FromJSONFile(request.OriginalFilename)
 
 Set rType = doPatient.resourceType
 Set ^TESTunit(0-$Get(^TESTunit),"rType") = rType]]>
</code>
</sequence>
</process>
}

}
