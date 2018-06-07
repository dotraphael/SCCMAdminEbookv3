$inifile = @"
[Identification]
Action=RecoverPrimarySite

CDLatest=1

[Options]
ProductID=EVAL
SiteCode=001
SiteName=Training Lab
SMSInstallDir=c:\ConfigMgr
SDKServer=SRV0002.classroom.intranet
PrerequisiteComp=1
PrerequisitePath=\\srv0001\TrainingFiles\Source\SCCMCB\Redist
AdminConsole=0
JoinCEIP=0

[SQLConfigOptions]
SQLServerName=SRV0002.classroom.intranet
DatabaseName=CM_001
SQLSSBPort=4022
SQLDataFilePath=C:\SQLServer\MSSQL13.MSSQLSERVER\MSSQL\DATA\
SQLLogFilePath=C:\SQLServer\MSSQL13.MSSQLSERVER\MSSQL\DATA\

[CloudConnectorOptions]
CloudConnector=0
CloudConnectorServer=
UseProxy=0
ProxyName=
ProxyPort=

[SystemCenterOptions]
SysCenterId=noBrzNn4z23AIHXl/w4kkO1Cp5bc/pxa6q23N56BIUM=

[HierarchyExpansionOption]

[RecoveryOptions]
ServerRecoveryOptions=4
DatabaseRecoveryOptions=10
BackupLocation=\\srv0001\SCCMBackup\001Backup
"@

$inifile -replace "`n", "`r`n"| Out-File -FilePath "\\srv0001\TempFiles\restorecmcb.ini"

Start-Process -Filepath ("\\srv0001\SCCMBackup\001Backup\CD.Latest\SMSSETUP\BIN\X64\setup.exe") -ArgumentList ('/script "\\srv0001\TempFiles\restorecmcb.ini"') -wait
