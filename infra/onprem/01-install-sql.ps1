# Run this on your Windows Server 2025 as Administrator
# Downloads and silently installs SQL Server Express 2022

$ErrorActionPreference = "Stop"

Write-Host "Downloading SQL Server Express 2022..."
$installerUrl = "https://go.microsoft.com/fwlink/p/?linkid=2216019&clcid=0x409&culture=en-us&country=us"
$installerPath = "$env:TEMP\SQLServerExpress.exe"
Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath

Write-Host "Running silent install..."
& $installerPath /ACTION=Install /FEATURES=SQLEngine /INSTANCENAME=SQLEXPRESS `
  /SECURITYMODE=SQL /SAPWD="LabPassword123!" `
  /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" `
  /AGTSVCACCOUNT="NT AUTHORITY\NETWORK SERVICE" `
  /IACCEPTSQLSERVERLICENSETERMS /QUIET

Write-Host "Enabling TCP/IP on port 1433..."
$wmi = New-Object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer
$tcp = $wmi.ServerInstances["SQLEXPRESS"].ServerProtocols["Tcp"]
$tcp.IsEnabled = $true
$tcp.IPAddresses["IPAll"].IPAddressProperties["TcpPort"].Value = "1433"
$tcp.Alter()

Write-Host "Restarting SQL Server service..."
Restart-Service -Name "MSSQL`$SQLEXPRESS" -Force

Write-Host "Done. SQL Server Express is running on port 1433."
