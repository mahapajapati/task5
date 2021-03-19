param
(
    [Parameter(Mandatory)]
	[string]$DBInstance = "AWS63-DB01"
)

#
# Functions used in this script.
#

function HandleLastError
{
    [CmdletBinding()]
    param(
    )

    $message = $error[0].Exception.Message
    if ($message)
    {
        Write-Host -Object "ERROR: $message" -ForegroundColor Red
    }
    
    # IMPORTANT NOTE: Throwing a terminating error (using $ErrorActionPreference = "Stop") still
    # returns exit code zero from the PowerShell script when using -File. The workaround is to
    # NOT use -File when calling this script and leverage the try-catch-finally block and return
    # a non-zero exit code from the catch block.
    exit -1
}
$ErrorActionPreference = "Stop"

Write-Host "###################################Configuring Group Policies########################################"
Write-Host .\Import-GPO.ps1 -DBInstance $DBInstance -GPOGroupPath "C:\DevOps\AbilaDevOps\Utilities\GPO-Templates\"
Write-Host "#####################################################################################################"

Try
{
    Set-Location "C:\DevOps\AbilaDevOps\Infrastructure\IAC\Configuration\DomainController\GPOs"
    .\Import-GPO.ps1 -DBInstance $DBInstance -GPOGroupPath "C:\DevOps\AbilaDevOps\Utilities\GPO-Templates\"
    .\Set-GPOLinks.ps1
}
Catch
{
    HandleLastError
}