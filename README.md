 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/iris-http-calls)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-http-calls&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-http-calls)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Firis-http-calls&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Firis-http-calls)
# iris-http-calls
This is an InterSystems IRIS Interoperability solution for HTTP calls

## Implements Idea DPI-I-456

[Idea](https://ideas.intersystems.com/ideas/DPI-I-456)

## What The Sample Does

This sample was cloned from [iris-interoperability-template](https://github.com/intersystems-community/iris-interoperability-template). I have reconfigured the interoperability [Production](https://github.com/oliverwilms/iris-http-calls/blob/master/src/dc/Demo/Production.cls) with an [Inbound HTTP Adapter](https://github.com/oliverwilms/iris-http-calls/blob/master/src/dc/HTTP/InboundAdapter.cls) which is used by a [HTTP Business Service](https://github.com/oliverwilms/iris-http-calls/blob/master/src/dc/HTTP/Service.cls). The configuration details for the business service are specified in [System Default Settings](https://github.com/oliverwilms/iris-http-calls/blob/master/src/i14y/Ens.Config.DefaultSettings.xml).
I configured Call Interval setting to call HTTPServer once every hour. You can change both the URL and frequency in the service's settings.
You can find [Online Demo](https://iris-http-calls.demo.community.intersystems.com/csp/sys/UtilHome.csp) here.
<img width="1411" alt="Screenshot" src="https://github.com/oliverwilms/bilder/blob/main/Capture_HTTP_Production.png">

Originally the HTTP Service had two targets. The response body from each call was sent as a HTTP Generic Message to a BPL business process and also a file operation which saved data to a folder iris-http-calls.

Now the HTTP Service sends a HTTP Generic Message to a file operation. Then a file service sends the file to a BPL business process.

The [BPL](https://github.com/oliverwilms/iris-http-calls/blob/master/src/dc/HTTP/Process.cls) summarizes the FHIR bundle like this:
<img width="1411" alt="Screenshot" src="https://github.com/oliverwilms/bilder/blob/main/HTTP_Process_Summary.png">

After mapping HS package from HSLIB, I can use HS FHIRModel package like this:
```
Set cls = $CLASSMETHOD("HS.FHIRModel.R4."_rType,"fromDao",dao)
```

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation: ZPM

Open any IRIS Namespace with Interoperability Enabled.
Open Terminal and call:
USER>zpm "install iris-http-calls"

## Installation: Docker
Clone/git pull the repo into any local directory

```
git clone https://github.com/oliverwilms/iris-http-calls.git
```

Open the terminal in this directory and run:

```
docker-compose build
```

3. Run the IRIS container with your project:

```
docker-compose up -d
```

## How to Run the Sample

Open the [production](http://localhost:52795/csp/user/EnsPortal.ProductionConfig.zen?PRODUCTION=dc.Demo.Production) and start it if it is not already running. It makes HTTP calls to HTTPServer using URL.

## How to alter the template
This repository is ready to code in VSCode with the ObjectScript plugin.
Install [VSCode](https://code.visualstudio.com/), [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker) and [ObjectScript](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript) plugin and open the folder in VSCode.

Use the handy VSCode menu to access the production and business rule editor and run a terminal:
<img width="656" alt="Screenshot 2020-10-29 at 20 15 56" src="https://user-images.githubusercontent.com/2781759/97608650-aa673480-1a23-11eb-999e-61e889304e59.png">


## environment variables usage

this example shows how you can introduce env variables in your dev environment.
Suppose you need to setup the production with some secret token to access a limited access API.
Of course you don't want to expose the secret to GitHub.
In this case Env variables mechanism could be helpful.
First introduce .env file and setup [.gitignore](https://github.com/intersystems-community/iris-interoperability-template/blob/0f0b932a971a2d8af49ce9e3d686042cec97c621/.gitignore) to filter .env from git.

Then add the secret token in .env in a form ENV_VARIABLE="TOKEN VALUE"

Next introduce make environment variables be imported to dockerfile. to make it work add the environment section into [docker-compose.yml](https://github.com/intersystems-community/iris-interoperability-template/blob/d2d7114de7c551e308e742359babebff5d535821/docker-compose.yml), .e.g:
```
environment:
      - SAMPLE_TOKEN=${SAMPLE_TOKEN}
```
Then you'll be able to init the running container with the data from env variables e.g. with the following call, which uses the value from .env file as a setting of the production:
```
USER> d ##class(dc.Demo.Setup).Init($system.Util.GetEnviron("SAMPLE_TOKEN"))
```

## package manager production parameters

Users of this module can use parameters to pass data to the module during installation and customize the File Path for the file operation and file service as well as modify URL.
it can be useful when setup parameters are secret tokens to access particular API.
You as a developer can provide such parameters with default tag in [module.xml](https://github.com/oliverwilms/iris-http-calls/blob/master/module.xml).
```
<Default Name="FilePath" Value="iris_http_calls" />
<Default Name="UrlModify" Value="/Patient?_id=egqBHVfQlt4Bw3XGXoxVxHg3" />
```

These default parameters enable users to call the installation of the package with the option of passing of parameters. E.g. the installation call could be run as:
```
zpm "install iris-http-calls -D FilePath=iris_http_calls -D UrlModify=/MedicationStatement?patient=egqBHVfQlt4Bw3XGXoxVxHg3"
```

```
USER>zpm "install iris-http-calls -D FilePath=iris_http_calls -D UrlModify=/MedicationStatement?patient=egqBHVfQlt4Bw3XGXoxVxHg3"

[USER|iris-http-calls]        Reload START (/usr/irissys/mgr/.modules/USER/iris-http-calls/0.3.37/)
[USER|iris-http-calls]        Reload SUCCESS
[iris-http-calls]       Module object refreshed.
[USER|iris-http-calls]        Validate START
[USER|iris-http-calls]        Validate SUCCESS
[USER|iris-http-calls]        Compile START
[USER|iris-http-calls]        Compile SUCCESS
[USER|iris-http-calls]        Activate START
[USER|iris-http-calls]        Configure START
[USER|iris-http-calls]        Configure SUCCESS
[USER|iris-http-calls]        Activate SUCCESS
```

The default parameters are used to setup the production in the following call:
```
<Invoke Class="dc.Demo.Setup" Method="Init" >
  <Arg>${FilePath}</Arg>
  <Arg>${UrlModify}</Arg>
</Invoke>
```
Method Init in dc.Demo.Setup class configures File Service and File Operation using the FilePath parameter. The UrlModify parameter is used to modify the URL setting of the HTTP service.

The production makes calls to HTTPServer using modified URL based on CallInterval. The response body is sent in a StreamContainer to a FileOperation. A file service reads the file and passes a Stream Container to a BPL process.
