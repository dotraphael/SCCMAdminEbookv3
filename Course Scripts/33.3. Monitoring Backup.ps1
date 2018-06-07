Get-Eventlog -Newest 100 -LogName Application -Source "SMS Server" -After (Get-Date).AddMinutes(-60) | where {$_.eventID -in (5055, 6829,3197,3198,5056,5057,6833)} | select EventID, Message, TimeGenerated | sort-object TimeGenerated -Descending | format-list