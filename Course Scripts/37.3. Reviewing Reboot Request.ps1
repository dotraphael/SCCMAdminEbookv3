Invoke-CMClientOperationSummarization
Start-Sleep 30

Get-CMClientOperation | Where-Object {($_.PrimaryActionType -eq 17) -and ($_.State -eq 1)} | select TargetCollectionName, TotalClients, CompletedClients,FailedClients,OfflineClients,UnknownClients,RequestedTime

