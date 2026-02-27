$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\..\modules\PowerBIAdmin\PowerBIAdmin.psd1" -Force

$tenantId = $env:TENANT_ID
$clientId = $env:CLIENT_ID
$secret   = $env:CLIENT_SECRET

if (-not $tenantId -or -not $clientId -or -not $secret) {
    throw "Missing TENANT_ID, CLIENT_ID, or CLIENT_SECRET"
}

Connect-PbiServicePrincipal -TenantId $tenantId -ClientId $clientId -ClientSecret $secret

$out = Export-PbiTenantSettings -OutPath ".\exports"
Write-Host "Wrote: $out"
