. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1
. c:\TrainingFiles\Scripts\Set-CMDetectionRule.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "Firefox 40"
$DTName = "Firefox 40 Installation for Windows 8.1 and 10"

New-CMApplication -Name "$AppName"

#we will remove the need for product code later on, it is just easier to add like that
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"Firefox Setup 40.0.exe" -ms' -ProductCode "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}" -ContentLocation "\\srv0001\TrainingFiles\Source\Firefox 40" -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" -ms'
Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem

Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateFileValidation -FolderPath "%ProgramFiles%\Mozilla Firefox" -FileName "firefox.exe" -IsPath64bit $false  -FileValidationValue "40.0"

Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
New-CMApplicationDeployment -CollectionName "Users OU" -Name "$AppName"

$AppName = "Firefox 49"
$DTName = "Firefox 49 Installation for Windows 8.1 and 10"

New-CMApplication -Name "$AppName"

#we will remove the need for product code later on, it is just easier to add like that
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"Firefox Setup 49.0.1.exe" -ms' -ProductCode "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}" -ContentLocation "\\srv0001\TrainingFiles\Source\Firefox 49" -LogonRequirementType WhereOrNotUserLoggedOn -UninstallCommand '"C:\Program Files (x86)\Mozilla Firefox\uninstall\helper.exe" -ms'
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateFileValidation -FolderPath "%ProgramFiles%\Mozilla Firefox" -FileName "firefox.exe" -IsPath64bit $false  -FileValidationValue "49.0"

Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem
Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"

$AppName = "Java8"
$DTName = "Java8 for Windows 10"

New-CMApplication -Name "$AppName"

#we will remove the need for product code later on, it is just easier to add like that
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"Java8.exe" /s' -ProductCode "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}" -ContentLocation "\\srv0001\trainingfiles\Source\Java8" -LogonRequirementType WhereOrNotUserLoggedOn
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients"
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateFileValidation -FolderPath "%ProgramFiles%\Java\jre1.8.0_101\bin" -FileName "java.exe" -IsPath64bit $false  -FileValidationValue "8.0.1010"

Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem
Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"

$AppName = "Acrobat Reader XI"
$DTName = "Acrobat Reader XI for Windows 10"

New-CMApplication -Name "$AppName"
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand '"AdbeRdr11010_en_US.exe" /msi EULA_ACCEPT=YES REMOVE_PREVIOUS=YES /qn' -ProductCode "{AC76BA86-7AD7-1033-7B44-AB0000000001}" -ContentLocation "\\srv0001\trainingfiles\Source\AdobeXI" -LogonRequirementType WhereOrNotUserLoggedOn
Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_8.1_Client"

Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem
Start-CMContentDistribution -ApplicationName "$AppName" -DistributionPointGroupName "Training Lab"
