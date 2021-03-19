param
(
    [Parameter(Mandatory)]
    [string]$DownloadLink,
    
    [Parameter(Mandatory)]
    [string]$DomainName = "Devland.com",

	[string]$MountDrive = "F:"

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
$isoFile = Split-Path $DownloadLink -leaf
Write-Host "################################Executing Mount SQL Server 2012 script###################################"
Write-Host "DownloadLink:   $DownloadLink"
Write-Host "SqlServerImage: $isoFile"
Write-Host "Drive:          E:"
Write-Host "##################################################################################################"

Try
{
    $path = "C:\DevOps"
    If(!(test-path $path))
    {
          New-Item -ItemType Directory -Force -Path $path
    }
    $output = "$path\$isoFile"
    $start_time = Get-Date
    If(!(Test-Path $output -PathType Leaf))
    {
        (New-Object System.Net.WebClient).DownloadFile($DownloadLink, $output)
        Write-Host "#############################Finished download################################"
        Write-Host "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
        Write-Host "##############################################################################"
    }
    else{
        Write-Host "#############################Iso file already exists################################"
    }

    Write-Host "#############################Mounting Image################################"
    Mount-DiskImage -ImagePath $output
    Write-Host "Image succesfully mounted in drive E:"

    Write-Host "#############################Installing SQL Server 2012################################"
    Write-Host .\Start-AbilaDBServerConfiguration.ps1 -Domain $DomainName -MountDrive E:
    Write-Host "##############################################################################"

    Set-Location "C:\DevOps\AbilaDevOps\Infrastructure\IAC\Configuration\DBServer"
    .\Start-AbilaDBServerConfiguration.ps1 -Domain $DomainName -MountDrive $MountDrive

}
Catch
{
    HandleLastError
}