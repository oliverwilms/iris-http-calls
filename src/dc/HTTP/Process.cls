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
<context>
<property name='summary' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='' />
</parameters>
</property>
</context>
<sequence xend='200' yend='550' >
<code xpos='200' ypos='250' >
<![CDATA[ Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.Process - Code"]]>
</code>
<code name='summary' xpos='200' ypos='350' >
<annotation><![CDATA[Convert the JSON payload to a Dynamic Object]]></annotation>
<![CDATA[ // Put JSON representation of Patient resource into a dynamic object
 Try {
   Set dao = ##class(%DynamicObject).%FromJSONFile(request.OriginalFilename)
   Set rType = dao.resourceType
   Set ^TESTunit(0-$Get(^TESTunit),"rType") = rType
   Set summary = {}
   Set list = dao.%Get("entry")
   Set ^TESTunit(0-$Get(^TESTunit),"list") = list
   Set itr = list.iterator()
   While (itr.hasNext()) {
     Set entryValue = itr.next().value
     Set ^TESTunit(0-$Get(^TESTunit),"entryValue") = entryValue.%ToJSON()
     Set rsc = entryValue.%Get("resource")
     Set ^TESTunit(0-$Get(^TESTunit),"rsc") = rsc.%ToJSON()
     Set rscName = rsc.resourceType
     Set ^TESTunit(0-$Get(^TESTunit),"rscName") = rscName
     Set count = summary.%Get(rscName,0)+1
     Set ^TESTunit(0-$Get(^TESTunit),"count") = count
     Do summary.%Set(rscName,count)
     Set ^TESTunit(0-$Get(^TESTunit),rscName,count) = rsc
   }
   Set ^TESTunit(0-$Get(^TESTunit),"summary") = summary.%ToJSON()
   Set context.summary = $Get(summary).%ToJSON()
 } Catch {
   Set ^TESTunit(0-$Get(^TESTunit),"Catch") = $ZERROR
 }]]>
</code>
<trace name='context.summary' value='context.summary' xpos='200' ypos='450' />
</sequence>
</process>
}

}
