$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$tenantId = $env:TENANT_ID
$clientId = $env:POWER_BI_APP_ID
$clientSecret = $env:CLIENT_SECRET

if (-not $tenantId) { throw "TENANT_ID not set" }
if (-not $clientId) { throw "POWER_BI_APP_ID not set" }
if (-not $clientSecret) { throw "CLIENT_SECRET not set" }

# Get OAuth token (client credentials) for Power BI
$tokenUri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

$tokenBody = @{
  client_id     = $clientId
  client_secret = $clientSecret
  scope         = "https://analysis.windows.net/powerbi/api/.default"
  grant_type    = "client_credentials"
}

Write-Host "Requesting access token..."
$tokenResponse = Invoke-RestMethod -Method Post -Uri $tokenUri -Body $tokenBody -ContentType "application/x-www-form-urlencoded"
$accessToken = $tokenResponse.access_token
if (-not $accessToken) { throw "Token request failed: no access_token returned." }

Write-Host "Token acquired. Testing Power BI REST API..."

$headers = @{ Authorization = "Bearer $accessToken" }

# Lightweight endpoint: list 1 workspace
$uri = "https://api.powerbi.com/v1.0/myorg/groups?`$top=1"
$result = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers

$first = $result.value | Select-Object -First 1
if ($null -eq $first) {
  Write-Host "Connected, but no workspaces returned (permissions may be limited)."
} else {
  Write-Host ("Connected. Sample workspace: {0} ({1})" -f $first.name, $first.id)
}

Write-Host "Connection test complete."
