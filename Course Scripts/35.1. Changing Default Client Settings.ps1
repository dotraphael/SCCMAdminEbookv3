$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$class = gwmi -Namespace "root\sms\site_$($SiteCode)" -query 'select * from SMS_InventoryReport where InventoryReportID = "{00000000-0000-0000-0000-000000000001}"'
$class.get()
$reportclasses = $class.ReportClasses

$classID = "MICROSOFT|Office365ProPlusConfigurations|1.0"
If (($reportclasses | where {$_.SMSClassID -eq 'MICROSOFT|Office365ProPlusConfigurations|1.0'}) -ne $null) {
    return
} else {
    $InventoryReportclass_class = [wmiclass]""
    $InventoryReportclass_class.psbase.Path = "ROOT\SMS\site_$($SiteCode):SMS_InventoryReportClass"
    $InventoryReportclass = $InventoryReportclass_class.createInstance()
        
    $InventoryReportclass.SMSClassid = $classID
    $InventoryReportclass.ReportProperties = @("AutoUpgrade", "CCMManaged", "CDNBaseUrl", "cfgUpdateChannel", "ClientCulture", "ClientFolder", "GPOChannel", "GPOOfficeMgmtCOM", "InstallationPath", "KeyName", "LastScenario", "LastScenarioResult", "OfficeMgmtCOM", "Platform", "SharedComputerLicensing", "UpdateChannel", "UpdatePath", "UpdatesEnabled", "UpdateUrl", "VersionToReport") 

    $reportclasses += $InventoryReportclass

    $class.ReportClasses = $reportclasses
    $class.Put()
}
