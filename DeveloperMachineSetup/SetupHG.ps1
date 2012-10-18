param
(
  $firstName = $(read-host "First Name"),
  $lastName = $(read-host "Last Name"),
  $emailAddress = $(read-host "Email Address")
)

$file = $Env:UserProfile + "\mercurial.ini"

"[ui]" | Out-File $file -encoding ascii 
"editor = Notepad" | Out-File $file -append -encoding ascii 
"username = " + $firstName + " " + $lastName + " <" + $emailAddress + ">" | Out-File $file -append -encoding ascii 
"" | Out-File $file -append -encoding ascii 
"[hostfingerprints]" | Out-File $file -append -encoding ascii 
"source.bleak.homeip.net = d7:e9:f6:b5:2f:ea:01:37:f3:59:81:d9:e6:20:b4:fd:96:fc:8f:17" | Out-File $file -append -encoding ascii 
"" | Out-File $file -append -encoding ascii 
"[extensions]" | Out-File $file -append -encoding ascii 
"hgext.purge=" | Out-File $file -append -encoding ascii 
"#or, if purge.py not in the hgext dir:" | Out-File $file -append -encoding ascii 
"#purge=/path/to/purge.py" | Out-File $file -append -encoding ascii 