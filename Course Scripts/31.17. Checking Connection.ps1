$SMSCli = [wmiclass] "root\ccm:SMS_Client"
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000021}")
start-sleep 10
$SMSCli.TriggerSchedule("{00000000-0000-0000-0000-000000000022}")
Start-Sleep 60

$AppName = "7-Zip 16"
$app = gwmi -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' | Where-Object { ($_.Name -eq "$($AppName)") -and ($_.InstallState -eq "NotInstalled") -and ($_.AllowedActions -contains "Install")}

if ($app) {
	"Successfully connected. $AppName is now available in Software Center"
} else {
	throw "Error connecting. $AppName is not available in Software Center"
}