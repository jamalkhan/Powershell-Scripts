param
(
  $username = $(read-host "User Name"),
  $password = $(read-host -AsSecureString "Password"),
  $AppName = $(read-host "App Name"),
  $WebsiteDirectory = $(read-host "Website Directory")
)


Function CreateAppPool($AppName, $username, $password)
{ 
	$exp = 'C:\windows\System32\inetsrv\appcmd.exe list apppool | where {$_ -match "v4.0" } | where {$_ -match "integrated"} | where {$_ -match $AppName}'
	$results = @(Invoke-Expression $exp)
	$results
	if ($results -eq "" -or $results.Count -eq 0)
	{
		Write-Host '  We will now create an App Pool named' $AppName -foregroundcolor 'magenta'

		$exp = 'C:\windows\System32\inetsrv\appcmd.exe add apppool /name:"' + $AppName + '" /managedRuntimeVersion:v4.0 /managedPipelineMode:Integrated'
		$exp
		Invoke-Expression $exp

		##%systemroot%\system32\inetsrv\APPCMD set apppool "MyAppPool" /managedRuntimeVersion:v1.1
	}
	else
	{
		Write-Host "A matching App already exists"
		Write-Host "  $results" -foregroundcolor 'green'
	}
  ##$exp = "c:\Windows\system32\inetsrv\appcmd.exe set config -section:system.applicationHost/applicationPools /+`".[name=`'" + $username + "`']`" /commit:apphost"
  ##$exp
  ##Invoke-Expression $exp
  ##$exp = 'c:\Windows\system32\inetsrv\appcmd.exe set config -section:system.applicationHost/applicationPools /.[name='' + $appPoolName + ''].processModel.identityType:"SpecificUser" /.[name='' + $appPoolName + ''].processModel.userName:"' + $username + '" /.[name='' + $appPoolName + ''].processModel.password:"' + $password + '" /commit:apphost'
  ##$exp
  ##Invoke-Expression $exp
}

Function CreateWebSite($AppName, $username, $password, $WebsiteDirectory)
{
	$exp = 'C:\windows\System32\inetsrv\appcmd.exe list sites | where {$_ -match $AppName }'
	$results = @(Invoke-Expression $exp)
	$results
	$exp = 'C:\windows\System32\inetsrv\appcmd.exe list site /name:"' + $AppName + '" /config /xml > C:\output.xml'
	Invoke-Expression $exp
	if ($results -eq "" -or $results.Count -eq 0)
	{
		[String]$passString = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password)); 	
	
		$configFile = "C:\" + $AppName + ".xml"

		
		'<?xml version="1.0" encoding="UTF-8"?>' | out-file $configFile -encoding ascii
		'<appcmd>' | out-file $configFile -encoding ascii -append
		'    <SITE SITE.NAME="' + $AppName + '" bindings="http/*:80:' + $AppName + '" state="Started">' | out-file $configFile -encoding ascii -append
		'        <site name="' + $AppName + '">' | out-file $configFile -encoding ascii -append
		'            <bindings>' | out-file $configFile -encoding ascii -append
		'                <binding protocol="http" bindingInformation="*:80:' + $AppName + '" />' | out-file $configFile -encoding ascii -append
		'            </bindings>' | out-file $configFile -encoding ascii -append
		'            <limits />' | out-file $configFile -encoding ascii -append
		'            <logFile />' | out-file $configFile -encoding ascii -append
		'            <traceFailedRequestsLogging />' | out-file $configFile -encoding ascii -append
		'            <applicationDefaults />' | out-file $configFile -encoding ascii -append
		'            <virtualDirectoryDefaults />' | out-file $configFile -encoding ascii -append
		'            <ftpServer>' | out-file $configFile -encoding ascii -append
		'                <connections />' | out-file $configFile -encoding ascii -append
		'                <security>' | out-file $configFile -encoding ascii -append
		'                    <dataChannelSecurity />' | out-file $configFile -encoding ascii -append
		'                    <commandFiltering>' | out-file $configFile -encoding ascii -append
		'                    </commandFiltering>' | out-file $configFile -encoding ascii -append
		'                    <ssl />' | out-file $configFile -encoding ascii -append
		'                    <sslClientCertificates />' | out-file $configFile -encoding ascii -append
		'                    <authentication>' | out-file $configFile -encoding ascii -append
		'                        <anonymousAuthentication />' | out-file $configFile -encoding ascii -append
		'                        <basicAuthentication />' | out-file $configFile -encoding ascii -append
		'                        <clientCertAuthentication />' | out-file $configFile -encoding ascii -append
		'                        <customAuthentication>' | out-file $configFile -encoding ascii -append
		'                            <providers>' | out-file $configFile -encoding ascii -append
		'                            </providers>' | out-file $configFile -encoding ascii -append
		'                        </customAuthentication>' | out-file $configFile -encoding ascii -append
		'                    </authentication>' | out-file $configFile -encoding ascii -append
		'                </security>' | out-file $configFile -encoding ascii -append
		'                <customFeatures>' | out-file $configFile -encoding ascii -append
		'                    <providers>' | out-file $configFile -encoding ascii -append
		'                    </providers>' | out-file $configFile -encoding ascii -append
		'                </customFeatures>' | out-file $configFile -encoding ascii -append
		'                <messages />' | out-file $configFile -encoding ascii -append
		'                <fileHandling />' | out-file $configFile -encoding ascii -append
		'                <firewallSupport />' | out-file $configFile -encoding ascii -append
		'                <userIsolation>' | out-file $configFile -encoding ascii -append
		'                    <activeDirectory />' | out-file $configFile -encoding ascii -append
		'                </userIsolation>' | out-file $configFile -encoding ascii -append
		'                <directoryBrowse />' | out-file $configFile -encoding ascii -append
		'                <logFile />' | out-file $configFile -encoding ascii -append
		'            </ftpServer>' | out-file $configFile -encoding ascii -append
		'            <application path="/" applicationPool="' + $AppName + '">' | out-file $configFile -encoding ascii -append
		'                <virtualDirectoryDefaults />' | out-file $configFile -encoding ascii -append
		'                <virtualDirectory path="/" physicalPath="' + $WebsiteDirectory + '" userName="' + $username + '" password="' + $passString + '" />' | out-file $configFile -encoding ascii -append
		'            </application>' | out-file $configFile -encoding ascii -append
		'        </site>' | out-file $configFile -encoding ascii -append
		'    </SITE>' | out-file $configFile -encoding ascii -append
		'</appcmd>' | out-file $configFile -encoding ascii -append

		$exp = 'C:\windows\System32\inetsrv\appcmd.exe add sites /in < "' + $configFile + '"'
		cmd /c ($exp)
	}
	else
	{
		Write-Host "A matching Website already exists"
		Write-Host "  $results" -foregroundcolor 'green'
	}
}

CreateAppPool $AppName $username $password
CreateWebSite $AppName $username $password $WebsiteDirectory 