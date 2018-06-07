. c:\TrainingFiles\Scripts\Add-TDCMComplianceSetting.ps1

New-CMConfigurationItem -Name "Internet Explorer Default Start Page" -CreationType WindowsOS | Add-TDCMComplianceRegistrySetting -SettingName "IE Start Page" -RegRootKey CurrentUser -RegKey "Software\Microsoft\Internet Explorer\Main" -RegKeyValueName "Start Page" -CreateExistentialValidation -CreateMustExistValidation -CreateValueValidation -ValidationValue "http://www.thedesktopteam.com" -RemediateNonCompliant -ReportNonCompliant
