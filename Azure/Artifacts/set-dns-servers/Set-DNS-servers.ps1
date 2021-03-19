Param(
        [parameter(Mandatory = $true)]
        [String]$DNSServers = "10.0.0.100"
    )

$computer = Get-WmiObject -Class Win32_ComputerSystem
if ($computer.domain -eq 'WORKGROUP') {
    $adapter = Get-NetAdapter -Name 'Ethernet*'
    Set-DNSClientServerAddress -InterfaceAlias $adapter.Name -ServerAddresses ($DNSServers)
}