#steps 05and 06
$IPAddresss = '<Change ME by the Public IP Address>'
Add-Content -Path "C:\WINDOWS\system32\drivers\etc\hosts" -Value "`r`n$IPAddresss    clouddp.classroom.intranet"