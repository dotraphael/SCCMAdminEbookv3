Start-Process -Filepath ("C:\ConfigMgr\bin\x64\00000409\preinst.exe") -ArgumentList ('/stopsite') -wait
Start-Sleep 5
