$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "Starting Power BI Tenant Settings export..."

# Validate environment variables from GitHub Secrets
$tenantId = $env:TENANT_ID
$clientId = $env:POWER_BI_APP_ID
$clientSecret = $env:CLIENT_SECRET

if (-not $tenantId)     { throw "TENANT_ID not set." }
if (-not $clientId)     { throw "POWER_BI_APP_ID not set." }
if (-not $clientSecret) { throw "CLIENT_SECRET not set." }

Write-Host "Environment variables validated."

# Ensure module is available
if (-not (Get-Module -ListAvailable MicrosoftPowerBIMgmt.Profile)) {
    Write-Host "Installing MicrosoftPowerBIMgmt..."
    Install-Module MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
}

Import-Module MicrosoftPowerBIMgmt.Profile -Force

# Authenticate using Service Principal
Write-Host "Authenticating with Service Principal..."

$secureSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential   = New-Object System.Management.Automation.PSCredential($clientId, $secureSecret)

Connect-PowerBIServiceAccount `
    -ServicePrincipal `
    -Tenant $tenantId `
    -Credential $credential | Out-Null

Write-Host "Authentication successful."

# Create export directory
$exportPath = Join-Path $PSScriptRoot "..\exports"
if (-not (Test-Path $exportPath)) {
    New-Item -ItemType Directory -Path $exportPath | Out-Null
}

# Call Admin API
$relativeUrl = "admin/tenantsettings"

Write-Host "Calling Power BI Admin API: $relativeUrl"

$response = Invoke-PowerBIRestMethod `
    -Url $relativeUrl `
    -Method Get

# Save file
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$outputFile = Join-Path $exportPath "tenantsettings-$timestamp.json"

($response | ConvertFrom-Json) |
    ConvertTo-Json -Depth 100 |
    Out-File -FilePath $outputFile -Encoding utf8

Write-Host "Export complete: $outputFile"
