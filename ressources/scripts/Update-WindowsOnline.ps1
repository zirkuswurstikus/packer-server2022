# Import the PSWindowsUpdate module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force

# Get available updates
Get-WindowsUpdate

# Install all available updates and auto-reboot if necessary
Install-WindowsUpdate -AcceptAll -AutoReboot

# Check if a reboot is pending after updates
$rebootStatus = Get-WURebootStatus
if ($rebootStatus) {
    Write-Host "Reboot required."
    # Optionally initiate a reboot
    Restart-Computer
}