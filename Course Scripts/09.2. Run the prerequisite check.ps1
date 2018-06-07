$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$sccmversion = '1710'

while ($true) {
	$SiteUpdate = gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_CM_UpdatePackages where Name like 'Configuration Manager $($sccmversion)%' AND UpdateType = 0"
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 262146) {
			Write-Host "Update is in Downloading state..."
			Start-Sleep 30
		} else {
			Write-Host "Update is ready, executing pre-req"
			#https://msdn.microsoft.com/en-us/library/mt762101(v=cmsdk.16).aspx
			$SiteUpdate.UpdatePrereqAndStateFlags(1,2)
			break
		}
	} 
}