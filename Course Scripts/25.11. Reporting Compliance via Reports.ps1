$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$CollectionName = "Windows 8 Workstations"
$Coll = Get-CMCollection -Name $CollectionName

#Open Report
$dict = @{"Collection"="$($Coll.CollectionID) - $CollectionName"; "Vendor"="Microsoft"; "Update Class"="Critical Updates"; "Product"="Windows 8.1"; }
Invoke-CMReport -ReportPath "Software Updates - A Compliance/Compliance 4 - Updates by vendor month year" -SiteCode "$SiteCode" -SrsServerName "$servername" -ReportParameter $dict
