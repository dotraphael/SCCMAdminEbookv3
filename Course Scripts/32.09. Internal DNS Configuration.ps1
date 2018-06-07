$SiteCode = "001"
$sdkserver = "SRV0002.classroom.intranet"
$cloudDPName = 'clouddp.classroom.intranet'

$secPassword = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$cred  = New-Object System.Management.Automation.PSCredential ("classroom\sccmadmin", $secPassword)
$RemoteSession = New-PSSession -ComputerName $sdkserver -Credential $cred
try {
    $CloudDP = Invoke-Command -Session $RemoteSession -ScriptBlock {
    param ($SiteCode, $cloudDPName)
        gwmi -Namespace "root\sms\site_$($SiteCode)" -query "SELECT * FROM SMS_AzureService where ServiceCName = '$($cloudDPName)'"
    } -args $SiteCode, $cloudDPName

} finally {
    Remove-PSSession -Session $RemoteSession
}

Add-DnsServerResourceRecordCName -Name "clouddp" -HostNameAlias "$($CloudDP.Name).cloudapp.net" -ZoneName "classroom.intranet"

