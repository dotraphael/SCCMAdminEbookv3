$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
<#
https://docs.microsoft.com/en-us/sccm/develop/reference/protect/sms_clientoperation-server-wmi-class
PrimaryActionType
#>
$ActionType = [int]17
$Device = Get-CMDevice -Name "WKS0001"
$Collection = Get-CMDeviceCollection -Name "Windows 10 Workstations"

Invoke-WMIMethod -Namespace "root\sms\site_$($SiteCode)" -Class SMS_ClientOperation -Name "InitiateClientOperation" -ArgumentList @($Null, $Collection.CollectionID, @($Device.ResourceID), $ActionType)
