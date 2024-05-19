# Rearm Windows if internet is available

# Function to check internet connectivity
function Test-InternetConnection {
    try {
        $response = Invoke-WebRequest -Uri "http://www.microsoft.com" -UseBasicParsing -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Check if an internet connection is available
if (Test-InternetConnection) {
    Write-Output "Internet connection is available. Proceeding with Windows rearm."
    
    # Rearm Windows
    try {
        slmgr /rearm
        Write-Output "Windows has been rearmed successfully. Rebooting ...."
        Restart-Computer -Force
    } catch {
        Write-Output "Failed to rearm Windows."
    }
} else {
    Write-Output "No internet connection available. Aborting rearm operation."
}
