$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Install-Module MicrosoftPowerBIMgmt -Scope CurrentUser -Force -AllowClobber
Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber

Write-Host "Modules installed."
