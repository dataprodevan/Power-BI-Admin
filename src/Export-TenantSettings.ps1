$ErrorActionPreference = "Stop"

Write-Host "Connecting to Power BI..."
Connect-PowerBIServiceAccount

$headers = @{
    Authorization = "Bearer $((Get-PowerBIAccessToken).Token)"
}

$uri = "https://api.powerbi.com/v1.0/myorg/admin/tenantsettings"

Write-Host "Calling API..."
$response = Invoke-RestMethod -Method Get -Uri $uri -Headers $headers

$response | ConvertTo-Json -Depth 100 | Out-File "tenantsettings.json"

Write-Host "Export complete."
