Class dc.HTTP.InboundAdapter Extends Ens.InboundAdapter
{

/// Host name or IP address of the server to send HTTP requests to.
Property HTTPServer As %String(MAXLEN = 1000) [ Required ];

/// TCP Port on the server to send HTTP requests to (will use 80 by default, or 443 if SSLConfig is specified)
Property HTTPPort As %Integer(MAXVAL = 65535, MINVAL = 0);

/// In a multi-homed system, specify which network interface the TCP connection should go through.  An empty value means to use any interface. <br/>
/// To be able to bind to IPv6 interfaces you may need to enable IPv6 in your instance.  This is done in the System Management Portal under 
/// System Administration > Configuration > Additional Settings > Startup, by editing the IPv6 setting.
Property LocalInterface As %String(MAXLEN = 250);

/// Proxy server through which to send HTTP requests, if any
Property ProxyServer As %String(MAXLEN = 1000);

/// Proxy server port on which to send HTTP requests, if using a proxy server (will use 8080 by default)
Property ProxyPort As %Integer(MAXVAL = 65535, MINVAL = 0);

/// Should the proxy (if any) use HTTPS to communicate with the real HTTP/HTTPS server?
Property ProxyHTTPS As %Boolean;

/// Should the Adapter use the HTTP CONNECT command to establish a tunnel through the proxy to the target HTTP server?
Property ProxyHttpTunnel As %Boolean [ InitialExpression = 0 ];

/// The name of an existing SSL/TLS system configuration set to use (Secure Socket Layer / Transport Layer Security, configured via the system portal's Security Management page).
/// <p>If your SSL Configuration requires you to supply a password for the local private key file, specify it in 
/// the Private key password property of the SSL/TLS Configuration.
Property SSLConfig As %String;

/// When making an SSL connection check the server identity in the certificate matches the name of the system we are connecting to.
/// This defaults to being on and matches based on the rules layed out in section 3.1 of RFC 2818.
Property SSLCheckServerIdentity As %Boolean [ InitialExpression = 1 ];

/// URL path to request from the server (not including 'http://' or server address) <ul>
/// <li>If set to empty or '*' and used on a GenericOperation, this setting will employ the HTTPHeaders array value for the key 'URL' (case insensitive) contained in the GenericMessage being processed.</li>
/// <li>If this value starts with '^' and is used on a GenericOperation, this setting will remove the Application attribute from the URL of the GenericMessage being processed and replace it with the remaining portion of this value if any.
///     If combined with '*' the '^' should come first.</li>
/// <li>If this value starts with '|' and is used on a GenericOperation, this setting will remove the Application and ConfigName attributes from the URL of the GenericMessage being processed and replace them with the remaining portion of this value if any.
///     If combined with '*' the '|' should come first.</li></ul>
Property URL As %String(MAXLEN = 1000) [ Required ];

/// This is the ID name of the set of credentials values (Username, Password) to be used to access the HTTP server
Property Credentials As %String [ InitialExpression = "None" ];

/// Number of seconds to wait on each connection attempt
Property ConnectTimeout As %Numeric(MINVAL = 0) [ InitialExpression = 5 ];

/// Timeout for getting a response from the server (the timeout for opening the connection to the server is always 5 seconds). Setting the timeout to -1 means wait forever.
Property ResponseTimeout As %Numeric(MINVAL = -1) [ InitialExpression = 30, Required ];

/// Set this to the timeout to use when writing to the remote HTTP server.<br>
/// The default is -1 means it will wait indefinitely for the remote server to accept the
/// written data, change it to another value to specify the timeout in seconds.
Property WriteTimeout As %Numeric(MINVAL = -1) [ InitialExpression = -1 ];

/// These are the production settings for this object
Parameter SETTINGS = "RegistryID:Basic:selector?context={Ens.ServiceRegistry.External.ContextSearch/Services?Protocols_1=REST&Protocols_2=HTTP},HTTPServer:Basic,HTTPPort:Basic,SSLConfig:Connection:sslConfigSelector,SSLCheckServerIdentity:Connection,LocalInterface:Connection:selector?context={Ens.ContextSearch/TCPLocalInterfaces},ProxyServer:Connection,ProxyPort:Connection,ProxyHTTPS:Connection,ProxyHttpTunnel:Connection,URL:Basic,Credentials:Basic:credentialsSelector,UseCookies,ConnectTimeout:Connection,ResponseTimeout:Connection,WriteTimeout:Connection,ProvideMetricsForSAM:Alerting";

Method OnInit() As %Status
{
	Kill ^TESTunit
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.InboundAdapter - OnInit()"
	Quit $$$OK
}

Method OnTask() As %Status
{
	Set ^TESTunit(0-$I(^TESTunit)) = $ZDATETIME($NOW(),8,1,3)_" : "_$JOB_" : "_"dc.HTTP.InboundAdapter - OnTask()"
	Set pType = "GET"
	Kill pResponse
	Set tSC = ##class(Utility).Call(..HTTPServer,..HTTPPort,..URL,pType,..Credentials,..SSLConfig,.pResponse)
	If $IsObject(pResponse) {
		Set tSC = ..BusinessHost.ProcessInput(pResponse)
	}
	Set ..BusinessHost.%WaitForNextCallInterval = 1
	Quit tSC
}

}
