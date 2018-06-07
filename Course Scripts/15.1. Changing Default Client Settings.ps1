$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$class = gwmi -Namespace "root\sms\site_$($SiteCode)" -query 'select * from SMS_InventoryReport where InventoryReportID = "{00000000-0000-0000-0000-000000000001}"'
$class.get()
$reportclasses = $class.ReportClasses

$classID = "MICROSOFT|SERVICE|1.0"
for($i=0;$i -lt $reportclasses.count; $i++) {
    if ($reportclasses[$i].SMSClassID -eq $classID) {
		$reportclasses[$i].ReportProperties += "State"
        break
    }  
}

$classID = "MICROSOFT|LOGICAL_DISK|1.0"
for($i=0;$i -lt $reportclasses.count; $i++) {
    if ($reportclasses[$i].SMSClassID -eq $classID) {
		$reportclasses[$i].ReportProperties += "FreeSpace"
        break
    }  
}

$classID = "MICROSOFT|NETWORK_ADAPTER|1.0"
for($i=0;$i -lt $reportclasses.count; $i++) {
    if ($reportclasses[$i].SMSClassID -eq $classID) {
	$reportclasses[$i].ReportProperties += "NetworkAddresses"
	$reportclasses[$i].ReportProperties += "Speed"
        break
    }  
}

$classID = "MICROSOFT|ENVIRONMENT|1.0"
$InventoryReportclass_class = [wmiclass]""
$InventoryReportclass_class.psbase.Path = "ROOT\SMS\site_$($SiteCode):SMS_InventoryReportClass"
$InventoryReportclass = $InventoryReportclass_class.createInstance()
        
$InventoryReportclass.SMSClassid = $classID
$InventoryReportclass.ReportProperties = @("Name", "UserName", "Caption", "Description", "InstallDate", "Status", "SystemVariable", "VariableValue") 

$reportclasses += $InventoryReportclass

$class.ReportClasses = $reportclasses
$class.Put()
