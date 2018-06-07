$Name = "Workstation Baseline" 
$schedule = New-CMSchedule -RecurCount 1 -RecurInterval Days

##use New-CMBaselineDeployment
Start-CMBaselineDeployment -CollectionName "Windows 10 Workstations" -Name "$Name" -EnableEnforcement $false -Schedule $schedule
