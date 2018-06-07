. c:\TrainingFiles\Scripts\Add-CMDeploymentTypeGlobalCondition.ps1
. c:\TrainingFiles\Scripts\Set-CMDetectionRule.ps1

$SiteCode = "001"
$dkserver = "SRV0002.classroom.intranet"

$AppName = "Office 365 English Installer"
$DTName = "Office 365 Default Deployment Type"
$FolderName = '\\srv0001\TempFiles\Office365EN'
$Branch = 'Current'
$Channel = 'Monthly'
$Architecture = '64'

New-Item -ItemType Directory -path "filesystem::$($FolderName)" -force

$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile('https://go.microsoft.com/fwlink/?linkid=851216', "$($env:temp)\releasehistory.cab")
cmd.exe /c "C:\Windows\System32\expand.exe" -F:ReleaseHistory.xml "$($env:temp)\releasehistory.cab" "$($env:temp)\ReleaseHistory.xml"
remove-item "$($env:temp)\releasehistory.cab"

$HistoryXML = [xml](gc "$($env:Temp)\releasehistory.xml")
$ReleaseVersion = (($HistoryXML.ReleaseHistory.UpdateChannel | Where-Object {$_.Name -eq $Branch}).Update | where-object {$_.Latest -eq $true}).LegacyVersion

$WebClient.DownloadFile('https://go.microsoft.com/fwlink/?linkid=851217', "$($env:temp)\ofl.cab")
cmd.exe /c "C:\Windows\System32\expand.exe" -F:"o365client_$($Architecture)bit.xml" "$($env:temp)\ofl.cab" "$($env:temp)\"
remove-item "$($env:temp)\ofl.cab"

$officeXML = [xml](gc "$($env:Temp)\o365client_$($Architecture)bit.xml")
$BaseURL = ($officeXML.UpdateFiles.baseURL | Where-Object {$_.branch -eq $Branch}).URL


$officeXML.UpdateFiles.File | where {($_.language -in (0, 1033)) -and ([string]::IsNullOrEmpty($_.rename))} | foreach {
    $Path = ($_.RelativePath -replace '%version%', $ReleaseVersion)
    $FileName = ($_.Name -replace '%version%', $ReleaseVersion)
    $Download = "$($baseURL)$($_.RelativePath -replace '%version%', $ReleaseVersion)$($_.Name -replace '%version%', $ReleaseVersion)"
    $Path = "filesystem::$($FolderName)$($Path.Replace('/','\'))"
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -path $Path -force
    }
    if (-not (Test-Path "$($Path)$($FileName)")) {
        "Downloading $Download"
        $WebClient.DownloadFile($Download, "$($env:temp)\$($FileName)")
        Move-Item "$($env:temp)\$($FileName)" "$($Path)"
    }
}

if (-not (Test-Path "filesystem::$($FolderName)\setup.exe")) {
    "Downloading https://go.microsoft.com/fwlink/?linkid=851215"
    $WebClient.DownloadFile('https://go.microsoft.com/fwlink/?linkid=851215', "$($env:temp)\setup.exe")
    Move-Item "$($env:temp)\setup.exe" "filesystem::$($FolderName)"
}

Copy-Item "filesystem::$($FolderName)\office\data\v$($Architecture)_$($ReleaseVersion).cab" "filesystem::$($FolderName)\office\data\v$($Architecture).cab"


$OfficeSetupFile = @"
<Configuration>
  <Add OfficeClientEdition="$($Architecture)" Channel="$($Channel)" Version="$($ReleaseVersion)" OfficeMgmtCOM="True">
    <Product ID="O365ProPlusRetail">
      <Language ID="en-US" />
    </Product>
  </Add>
  <Display AcceptEULA="TRUE" />
  <Property Name="SharedComputerLicensing" Value="1" />
  <Property Name="PinIconsToTaskbar" Value="TRUE" />
  <Property Name="AUTOACTIVATE" Value="1" />
</Configuration>
"@

$OfficeSetupFile -replace "`n", "`r`n" | Out-File -FilePath "filesystem::$($FolderName)\configuration.xml"

New-CMApplication -Name "$AppName"

#we will remove the need for product code later on, it is just easier to add like that
Add-CMScriptDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -InstallCommand 'setup.exe /configure configuration.xml' -ProductCode "{6313DBA3-0CA9-4CD8-93B3-373534146B7B}" -ContentLocation "$($FolderName)" -LogonRequirementType WhereOrNotUserLoggedOn
Get-CMDeploymentType -ApplicationName "$AppName" -DeploymentTypeName "$DTName" | Set-CMDeploymentType -MsiOrScriptInstaller -InstallationBehaviorType InstallForSystem

Add-CMDeploymentTypeGlobalCondition -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -sdkserver "$dkserver" -sitecode "$sitecode" -GlobalCondition OperatingSystem -Operator OneOf -Value "Windows/All_x64_Windows_7_Client;Windows/All_x64_Windows_8.1;Windows/All_x64_Windows_8.1_and_higher_Clients;Windows/All_x64_Windows_8.1_Client;Windows/All_x64_Windows_8_and_higher_Client;Windows/All_x64_Windows_8_Client;Windows/All_x64_Windows_10_and_higher_Clients;Windows/All_x64_Windows_10_higher;Windows/All_x64_Windows_Server_2008_R2;Windows/All_x64_Windows_Server_2012_R2;Windows/All_x64_Windows_Server_2012_R2_and_higher;Windows/All_x64_Windows_Server_8;Windows/All_x64_Windows_Server_8_and_higher"
Set-CMDetectionRule -ApplicationName "$AppName" -DeploymentTypeName "$DTName" -CreateRegistryValidation -RegistryKey "Software\Microsoft\Office\ClickToRun\Configuration" -RegistryKeyValue "VersionToReport" -RegistryKeyValidationValue ([System.Version]"$($ReleaseVersion)") -RegistryKeyValidationValueType ([Microsoft.SystemsManagementServer.DesiredConfigurationManagement.Expressions.DataType]::Version) -RegistryKeyValidationValueOperator ([Microsoft.ConfigurationManagement.DesiredConfigurationManagement.ExpressionOperators.ExpressionOperator]::GreaterEquals)
