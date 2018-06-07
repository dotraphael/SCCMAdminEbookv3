$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$FeatureName = "Install Behavior for applications"
Get-CMSiteFeature  -Name $FeatureName | Enable-CMSiteFeature -force

Get-Process -Name Microsoft.ConfigurationManagement | Stop-Process
start-sleep 10
Start-Process -Filepath ("C:\ConfigMgr\AdminConsole\bin\Microsoft.ConfigurationManagement.exe")
