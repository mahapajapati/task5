param
(
    [Parameter(Mandatory)]
	[string]$Thumbprint = "ACDD1F072FA2283633BC4450BAD33600ECB9D8BB"
)
Set-Location "C:\DevOps\AbilaDevOps\Infrastructure\IAC\Configuration\OctopusTentacle"
Write-Host "################################Executing Tentacle DSC###################################"
Write-Host "&" .\Start-OctopusTentacleConfiguration.ps1 -Thumbprint $Thumbprint
Write-Host "#########################################################################################"
& .\Start-OctopusTentacleConfiguration.ps1 -Thumbprint $Thumbprint -EnableModuleCheck
