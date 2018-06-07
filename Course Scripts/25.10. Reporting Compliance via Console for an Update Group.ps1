$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

Invoke-CMSoftwareUpdateSummarization
Start-Sleep 20
Get-CMSoftwareUpdate -IsDeployed $true | select LocalizedDisplayName, NumMissing, NumNotApplicable, NumPresent, NumTotal, NumUnknown, PercentCompliant
