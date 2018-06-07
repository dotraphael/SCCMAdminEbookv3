$DNSName = '<Unique Name created on Step 31.5>'
$mypwd = ConvertTo-SecureString -String 'Pa$$w0rd' -Force -AsPlainText
$cert = New-SelfSignedCertificate -Type Custom -KeySpec KeyExchange -Subject "CN=$($DNSName).cloudapp.net" -KeyExportPolicy Exportable -HashAlgorithm sha256 -KeyLength 2048 -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign
Get-ChildItem -Path "Cert:\CurrentUser\My\$($cert.Thumbprint)" | Export-PfxCertificate -FilePath C:\TrainingFiles\cloudmgcert.pfx -Password $mypwd
Export-Certificate -Type CERT -Cert $cert -FilePath "C:\TrainingFiles\cloudmgcert_azuremgmt.cer"