$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$sccmversion = '1710'

$Update = gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_CM_UpdatePackages where Name like 'Configuration Manager $($sccmversion)%' AND UpdateType = 0"
if ($update -eq $null) {
    Write-Host "No update found for SCCM version $sccmversion, forcing check it now"
    $Component =  gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_SCI_Component where FileType = 2 and ItemName = 'SMS_DMP_DOWNLOADER|SMS Dmp Connector' and ItemType='Component' and SiteCode='$($SiteCode)'"
    $props = $component.Props
    $prop = $props | where {$_.PropertyName -eq 'EasySetupDownloadInterval'}
    $prop.Value = 1
    $component.Props = $props
    $component.Put() | Out-Null

    $Component =  gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_SCI_Component where FileType = 2 and ItemName = 'SMS_DMP_DOWNLOADER|SMS Dmp Connector' and ItemType='Component' and SiteCode='$($SiteCode)'"
    $props = $component.Props
    $prop = $props | where {$_.PropertyName -eq 'SyncNow'}
    $prop.Value = 0
    $prop.Value1 = 1513690313
    $component.Props = $props
    $component.Put() | Out-Null
    start-sleep 120
}

$Update = gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_CM_UpdatePackages where Name like 'Configuration Manager $($sccmversion)%' AND UpdateType = 0"
if ($update -eq $null) {
    Write-Host "ERROR: No update found for SCCM version $sccmversion" -ForegroundColor Red
} else {
    if ($Update.State -eq 262146) {
        Write-Host "Update found and ready to install"
    } elseif ($Update.State -ne 262145) {
        Write-Host "Update found, forcing download to start as soon as possbile"
        $Component =  gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_SCI_Component where FileType = 2 and ItemName = 'SMS_DMP_DOWNLOADER|SMS Dmp Connector' and ItemType='Component' and SiteCode='$($SiteCode)'"
        $props = $component.Props
        $prop = $props | where {$_.PropertyName -eq 'EasySetupDownloadInterval'}
        $prop.Value = 1
        $component.Props = $props
        $component.Put() | Out-Null

        $Update.SetPackageToBeDownloaded()
        Write-host "Package in the queue to be downloaded: $(($Update.PackageExistsInToBeDownloadedList()).PackageExists)"
    } else {
    	Write-Host "Update being downloaded"
    }
}
