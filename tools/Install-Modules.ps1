$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

if (-not (Get-Module -ListAvailable MicrosoftPowerBIMgmt.Profile)) {
  Install-Module MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
}

Write-Host "MicrosoftPowerBIMgmt ready."
