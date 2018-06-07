$SiteCode = "001"
 
$Secure = 'Pa$$w0rd'| ConvertTo-SecureString -AsPlainText -Force
$account = "CLASSROOM\svc_sccmna"
Set-CMAccount -UserName "$account" -Password $Secure -SiteCode $SiteCode

$account = "CLASSROOM\svc_ssrsea"
Set-CMAccount -UserName "$account" -Password $Secure -SiteCode $SiteCode

$account = "CLASSROOM\svc_sccmpush"
Set-CMAccount -UserName "$account" -Password $Secure -SiteCode $SiteCode
