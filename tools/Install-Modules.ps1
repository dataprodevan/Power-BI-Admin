$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

function Install-PowerBIPowerShell {
    [CmdletBinding()]
    param()

    # If already installed (MSI path), do nothing
    $msiPath = "${env:ProgramFiles(x86)}\WindowsPowerShell\Modules\MicrosoftPowerBIMgmt.Profile"
    if (Test-Path $msiPath) {
        Write-Host "Power BI PowerShell already present at: $msiPath"
        return
    }

    Write-Host "Installing Power BI PowerShell (MSI)..."
    $uri = "https://download.microsoft.com/download/8/0/5/805b0d4a-2e93-4c18-bd0b-0f1f3f3f0e41/PowerBIPowerShell.msi"
    $msi = Join-Path $env:TEMP "PowerBIPowerShell.msi"

    Invoke-WebRequest -Uri $uri -OutFile $msi -UseBasicParsing

    $p = Start-Process msiexec.exe -ArgumentList "/i `"$msi`" /qn /norestart" -Wait -PassThru
    if ($p.ExitCode -ne 0) {
        throw "MSI install failed with exit code $($p.ExitCode)"
    }

    Write-Host "MSI installed."
}

Install-PowerBIPowerShell

# Import module (works after MSI)
Import-Module MicrosoftPowerBIMgmt.Profile -Force
Write-Host "Imported MicrosoftPowerBIMgmt.Profile"
