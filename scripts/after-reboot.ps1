$ProgressPreference='SilentlyContinue'
Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot

# The sleeps may seem whacky because they are
# Might beable to remove after 2016 RTMs
# For now after much trial and error, this is what works
Write-Host "waiting 5 minutes"
Start-Sleep -Seconds 300

$uninstallSuccess = $false
while(!$uninstallSuccess) {
  Write-Host "Attempting to uninstall features..."
  try {

    if (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue) {
      Write-Host "Server Detected - Removing Features."
      Get-WindowsFeature | ? { $_.InstallState -eq 'Available' } | Uninstall-WindowsFeature -Remove -ErrorAction Stop
    } elseif (Get-Command Get-WindowsOptionalFeature -ErrorAction SilentlyContinue) {
      Write-Host "NonServer Detected - Removing Optional Features"
      Get-WindowsOptionalFeature –Online | Where-Object { $_.State –eq “Enabled” } | Disable-WindowsOptionalFeature -Online -Remove -ErrorAction Stop -NoRestart
    } else {
      Write-Host "Unknown Windows Version Detected."
    }

    Write-Host "Uninstall succeeded!"
    $uninstallSuccess = $true
  }
  catch {
    Write-Host "Waiting two minutes before next attempt"
    Start-Sleep -Seconds 120
  }
}
