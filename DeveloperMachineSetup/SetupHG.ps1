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
"test.com = 00:ff:00:ff:00:ff:00:ff:00:ff:00:ff:00:ff:00:ff:00:ff:00:ff" | Out-File $file -append -encoding ascii 
"" | Out-File $file -append -encoding ascii 
"[extensions]" | Out-File $file -append -encoding ascii 
"hgext.purge=" | Out-File $file -append -encoding ascii 
"#or, if purge.py not in the hgext dir:" | Out-File $file -append -encoding ascii 
"#purge=/path/to/purge.py" | Out-File $file -append -encoding ascii 