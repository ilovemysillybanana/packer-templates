call winrm set winrm/config/service/auth @{Basic="false"}
call winrm set winrm/config/service @{AllowUnencrypted="false"}


# see: https://github.com/mwrock/packer-templates/issues/49
# netsh advfirewall firewall set rule name="WinRM-HTTP" new action=block

# change to on demand here, change back in SetupComplete
sc config winrm start=demand

C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend/unattend.xml /quiet /shutdown
