$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

Write-Host "Starting Power BI connection test..."

$tenantId = $env:TENANT_ID
$appId    = $env:POWER_BI_APP_ID
$secret   = $env:CLIENT_SECRET

if (-not $tenantId) { throw "TENANT_ID not set" }
if (-not $appId)    { throw "POWER_BI_APP_ID not set" }
if (-not $secret)   { throw "CLIENT_SECRET not set" }

if (-not (Get-Module -ListAvailable MicrosoftPowerBIMgmt.Profile)) {
  Install-Module MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
}
Import-Module MicrosoftPowerBIMgmt.Profile -Force

$secure = ConvertTo-SecureString $secret -AsPlainText -Force
$cred   = New-Object System.Management.Automation.PSCredential($appId, $secure)

Connect-PowerBIServiceAccount -ServicePrincipal -Tenant $tenantId -Credential $cred | Out-Null
Write-Host "Authenticated."

# Lightweight API call (should succeed if permissions are OK)
$json = Invoke-PowerBIRestMethod -Url "groups?$top=1" -Method Get
$obj  = $json | ConvertFrom-Json
$first = $obj.value | Select-Object -First 1

if ($null -eq $first) {
  Write-Host "Connected, but no workspaces returned."
} else {
  Write-Host ("Connected. Sample workspace: {0} ({1})" -f $first.name, $first.id)
}

Write-Host "Connection test complete."
