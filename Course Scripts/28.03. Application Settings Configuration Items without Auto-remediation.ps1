. c:\TrainingFiles\Scripts\Add-TDCMComplianceSetting.ps1

New-CMConfigurationItem -Name "Validate Mozilla Firefox Version" -CreationType WindowsApplication | Add-TDCMComplianceRegistrySetting -SettingName "Mozila Firefox CurrentVersion" -RegRootKey LocalMachine -RegKey "Software\Mozilla\Mozilla Firefox" -RegKeyValueName "CurrentVersion" -CreateExistentialValidation -CreateMustExistValidation -CreateValueValidation -ValidationValue "49.0.1 (x64 en-GB)" -ReportNonCompliant
