$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"
$sccmversion = '1710'

while ($true) {
	$SiteUpdate = gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_CM_UpdatePackages where Name like 'Configuration Manager $($sccmversion)%' AND UpdateType = 0"
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 131074) {
			Write-Host "Pre-Check is still happening..."
			Start-Sleep 30
		} else {
			Write-Host "Pre-Req done, starting update"
			#https://msdn.microsoft.com/en-us/library/mt762101(v=cmsdk.16).aspx
			$SiteUpdate.UpdatePrereqAndStateFlags(2,2)
			Get-Process -Name Microsoft.ConfigurationManagement | Stop-Process
			break
		}
	} 
}

while ($true) {
	$SiteUpdate = gwmi -Namespace "root\SMS\site_$($SiteCode)" -query "select * from SMS_CM_UpdatePackages where Name like 'Configuration Manager $($sccmversion)%' AND UpdateType = 0" -ErrorAction SilentlyContinue
	if ($SiteUpdate -ne $null) {
		if ($SiteUpdate.State -ne 196612) {
			Write-Host "Installation is still happening..."
			Start-Sleep 30
		} else {
			Write-Host "Installation done, upgrading SCCM Console"
			$InstallationFolder = (Get-ItemProperty -Path "hklm:Software\Wow6432Node\Microsoft\ConfigMgr10\Setup" -ErrorAction SilentlyContinue)."UI Installation Directory"
			$Connection = (Get-ItemProperty -Path "hklm:Software\Wow6432Node\Microsoft\ConfigMgr10\AdminUI\Connection" -ErrorAction SilentlyContinue)."Server"
			if ($InstallationFolder -eq $null) {
				$InstallationFolder = "C:\ConfigMgr\AdminConsole"
			}
			if ($InstallationFolder.Substring($InstallationFolder.Length-1) -eq '\') {
				$InstallationFolder = $InstallationFolder.Substring(0, $InstallationFolder.Length-1)
			}
			if ($Connection -eq $null) {
				$Connection = $servername
			}
			cd c:
			Remove-Module ConfigurationManager -Force

			Start-Process -Filepath ("C:\ConfigMgr\bin\i386\consolesetup.exe") -ArgumentList ("/q TargetDir=`"$($InstallationFolder)`" EnableSQM=0 DefaultSiteServerName=$($Connection)") -Wait
			Start-Sleep 5
			Start-Process -Filepath ("C:\ConfigMgr\AdminConsole\bin\Microsoft.ConfigurationManagement.exe")
			break
		}
	} else {
		Write-Host "Installation is still happening..."
		Start-Sleep 30
	}
}