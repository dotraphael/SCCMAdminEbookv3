[flags()] 
enum CustomRebootBitFlags
{
    None              = 0
    ConfigMgr         = 1
    FileRename        = 2
    WindowsUpdate     = 4
    AddRemoveFeatures = 8
}

Get-CMDevice | Select Name, @{"N"="Client State Description"; "E"={[CustomRebootBitFlags]$_.ClientState}}