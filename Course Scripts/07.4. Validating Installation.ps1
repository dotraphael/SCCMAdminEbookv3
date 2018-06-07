$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=SRV0002;Initial Catalog=Master;trusted_connection = true;"
$conn.Open()

$SqlCommand = $Conn.CreateCommand()
$SqlCommand.CommandTimeOut = 0
$SqlCommand.CommandText = "select @@version"
$DataAdapter = new-object System.Data.SqlClient.SqlDataAdapter $SqlCommand
$dataset = new-object System.Data.Dataset
$DataAdapter.Fill($dataset)

$SqlCommand2 = $Conn.CreateCommand()
$SqlCommand2.CommandTimeOut = 0
$SqlCommand2.CommandText = "SELECT SERVERPROPERTY ('productversion'),SERVERPROPERTY ('productlevel'), SERVERPROPERTY ('edition')"
$DataAdapter2 = new-object System.Data.SqlClient.SqlDataAdapter $SqlCommand2
$dataset2 = new-object System.Data.Dataset
$DataAdapter2.Fill($dataset2)

$dataset.Tables[0] | select Column1
$dataset2.Tables[0] | select Column1,Column2,Column3

$conn.close()

$webclient = new-object System.Net.WebClient
$webclient.Credentials = new-object System.Net.NetworkCredential("sccmadmin", 'Pa$$w0rd', "classroom")
$webclient.DownloadString("http://SRV0002/ReportServer")
