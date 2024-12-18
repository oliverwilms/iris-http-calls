Class dc.Demo.Production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="dc.Demo.Production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description>This is a sample Reddit cats and dogs production</Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="dc.HTTP.Service" Category="" ClassName="dc.HTTP.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">EnsLib.File.PassthroughOperation</Setting>
  </Item>
  <Item Name="EnsLib.File.PassthroughOperation" Category="" ClassName="EnsLib.File.PassthroughOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="EnsLib.File.PassthroughService" Category="" ClassName="EnsLib.File.PassthroughService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">dc.HTTP.Process</Setting>
  </Item>
  <Item Name="dc.HTTP.Process" Category="" ClassName="dc.HTTP.Process" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
</Production>
}

}
