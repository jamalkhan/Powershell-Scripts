net stop MongoDB

& ($Env:ProgramFiles + "\7-zip\7z.exe") e mongodb-win32-i386-2.2.0.7z -oC:\mongodb -y

$mongoInstallDirectory = "C:\mongodb"
$logDirectory = $mongoInstallDirectory + "\log"
$dataDirectory = $mongoInstallDirectory + "\data"
$logLocation = $mongoInstallDirectory + "\log\mongo.log"
$configLocation = $mongoInstallDirectory + "\mongod.cfg"

if( -not(Test-Path -Path $logDirectory))
{
	& ("md") $logDirectory
}

if( -not(Test-Path -Path $dataDirectory))
{
	& ("md") $dataDirectory
}

"logpath=$logLocation" | out-file $configLocation -encoding ascii
"dbpath=$dataDirectory" | out-file $configLocation -encoding ascii -append

& ("$mongoInstallDirectory\mongod.exe") --config $configLocation --install --logappend

net start MongoDB

