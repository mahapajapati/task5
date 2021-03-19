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

Write-Host "###################################Attach and Configure Disk Partitions########################################"
Write-Host "& diskpart /s diskpart $PSScriptRoot\Set-Disks-Partitions.txt"
Write-Host "###############################################################################################################"

Try
{
    & diskpart /s $PSScriptRoot\Set-Disks-Partitions.txt
}
Catch
{
    HandleLastError
}
finally
{
    Write-Host "####################Finished Attach and Configure Disk Partitions###################"
    Write-Host "& diskpart /s $PSScriptRoot\Set-Disks-Partitions.txt"
    Write-Host "####################################################################################"
}