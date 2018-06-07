$SiteCode = "001"

Invoke-CMCollectionUpdate -Name "All Systems"
Start-sleep 10

Get-CMDevice -name "WKS0001" | Install-CMClient -SiteCode "$SiteCode"
Get-CMDevice -name "WKS0002" | Install-CMClient -SiteCode "$SiteCode"
Get-CMDevice -name "WKS0004" | Install-CMClient -SiteCode "$SiteCode"
