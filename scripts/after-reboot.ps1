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

    if (Get-Command Get-WindowsFeature -ErrorAction SilentlyContinue){
      Write-Host "Windows Server Detected...Removing Features..."
      $features = Get-WindowsFeature
      forEach ($feat in $features) {
        #skip the entry if it's .NET or PowerShell
        if ($feat.FeatureName.Contains("NetFx") -or $feat.FeatureName.Contains("PowerShellV2")){
          Write-Host "Skipping: $($feat.FeatureName)"
          continue
        } else {
          Write-Host "Disabling Feature: $($feat.FeatureName)"
          Uninstall-WindowsFeature -Name $feat.FeatureName -Remove -ErrorAction Stop
        }
      }
    }elseif (Get-Command Get-WindowsOptionalFeature -ErrorAction SilentlyContinue) {
      Write-Host "Windows NonServer Detected...Removing Optional Features..."
      $features = Get-WindowsOptionalFeature -Online
      forEach ($feat in $features) {
        #skip the entry if it's .NET or PowerShell
        if ($feat.FeatureName.Contains("NetFx") -or $feat.FeatureName.Contains("PowerShellV2")){
          Write-Host "Skipping: $($feat.FeatureName)"
          continue
        } else {
          Write-Host "Disabling Feature: $($feat.FeatureName)"
          Disable-WindowsOptionalFeature -FeatureName $feat.FeatureName -Online -NoRestart -Remove -ErrorAction Stop
        }
      }
    }else {
      Write-Host "Unable to determine the version of Windows running on this device."
    }

    Write-Host "Uninstall succeeded!"
    $uninstallSuccess = $true
  }
  catch {
    Write-Host "Waiting two minutes before next attempt"
    Start-Sleep -Seconds 120
  }
}
