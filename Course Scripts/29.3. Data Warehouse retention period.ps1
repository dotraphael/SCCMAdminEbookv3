$SiteCode = "001"
$servername = "SRV0002.classroom.intranet"

$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=SRV0002;Initial Catalog=CM_$($SiteCode );trusted_connection = true;"
$conn.Open()

$SqlCommand = $Conn.CreateCommand()
$SqlCommand.CommandTimeOut = 0
$SqlCommand.CommandText = "UPDATE sc_sysresuse_property SET Value3 = 1095 WHERE Name = 'DataRetentionDays'"
$SqlCommand.ExecuteNonQuery()
$conn.close()
