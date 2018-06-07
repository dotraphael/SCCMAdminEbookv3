. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1
. c:\TrainingFiles\Scripts\Set-CMDetectionRule.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "7-Zip 16"
$DTName = "7-Zip 16 Installation for Windows 8.1 and 10"

New-CMApplication -Name "$AppName"

#we will remove the need for product code later on, it is just easier to add like that
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"7z1604-x64.exe" /S' -ProductCode "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}" -ContentLocation "\\srv0001\Trainingfiles\Source\7-zip" -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"C:\Program Files\7-Zip\Uninstall.exe" /S'
Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem

Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateFileValidation -FolderPath "%ProgramFiles%\7-Zip" -FileName "7zFM.exe" -IsPath64bit $false -FileValidationValue "16.04"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
