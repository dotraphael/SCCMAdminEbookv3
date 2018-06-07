$inifile = @"
[Identification]
Action=InstallPrimarySite


[Options]
ProductID=EVAL
SiteCode=001
SiteName=Training Lab
SMSInstallDir=c:\ConfigMgr
SDKServer=SRV0002.classroom.intranet
RoleCommunicationProtocol=HTTPorHTTPS
ClientsUsePKICertificate=0
PrerequisiteComp=1
PrerequisitePath=\\srv0001\Trainingfiles\Source\SCCMCB\Redist
MobileDeviceLanguage=0
AdminConsole=1
JoinCEIP=0

[SQLConfigOptions]
SQLServerName=SRV0002.classroom.intranet
DatabaseName=CM_001
SQLSSBPort=4022
SQLDataFilePath=C:\SQLServer\MSSQL13.MSSQLSERVER\MSSQL\DATA\
SQLLogFilePath=C:\SQLServer\MSSQL13.MSSQLSERVER\MSSQL\DATA\

[CloudConnectorOptions]
CloudConnector=1
CloudConnectorServer=SRV0002.classroom.intranet
UseProxy=0
ProxyName=
ProxyPort=

[SystemCenterOptions]
SysCenterId=x2ctA79R2ED90XmgV4SwzfKYYJ6lr5gT8IVycMy7Jpg=

[HierarchyExpansionOption]

"@

$inifile -replace "`n", "`r`n"| Out-File -FilePath "\\srv0001\TempFiles\installcmcb.ini"

Start-Process -Filepath ("\\srv0001\TrainingFiles\Source\SCCMCB\Extract\SMSSETUP\BIN\X64\setup.exe") -ArgumentList ('/script "\\srv0001\TempFiles\installcmcb.ini"') -wait
