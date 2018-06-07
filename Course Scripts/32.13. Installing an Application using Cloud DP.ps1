$AppName = "7-Zip 16"
$app = gwmi -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' | Where-Object { ($_.Name -eq "$($AppName)") -and ($_.InstallState -eq "NotInstalled")}

[int]$code = Invoke-WmiMethod -Namespace 'root\CCM\ClientSDK' -Class 'CCM_Application' -Name Install -ArgumentList @(0, $app.Id, $app.IsMachineTarget, $false, 'High', $app.Revision) | select -ExpandProperty ReturnValue

if ($code -ne 0) {
	throw "Error invoking Installation of '$($app.Name)' ($code)."
} else {
	"Successfully invoked Installation of '$($app.Name)'."
}