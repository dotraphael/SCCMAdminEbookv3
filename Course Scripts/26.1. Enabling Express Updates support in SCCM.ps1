$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

set-CMSoftwareUpdatePointComponent -ContentFileOption ExpressForWindows10Only -SiteCode $SiteCode

$ClientSettingsName = "Windows 10 Express Updates"
New-CMClientSetting -Name "$ClientSettingsName" -Type Device
Set-CMClientSettingSoftwareUpdate -Name "$ClientSettingsName" -Enable $true

$CS = (gwmi -namespace root\sms\site_001 -query "select * from SMS_ClientSettings where Name = '$ClientSettingsName'")
$CS.Get()
$ac = $CS.AgentConfigurations
$agent = $ac[0]
$agent.EnableExpressUpdates = $true
$agent.ExpressUpdatesPort = 8005
$CS.AgentConfigurations = $ac
$CS.Put()

Start-CMClientSettingDeployment -ClientSettingName "$ClientSettingsName" -CollectionName "Windows 10 Workstations"

New-NetFirewallRule -DisplayName "IIS Distribution Point Express Updates (TCP 8005) Inbound" -Action Allow -Direction Inbound -LocalPort 8005 -Protocol TCP