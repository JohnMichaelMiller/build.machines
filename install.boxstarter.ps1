# Install Boxstarter if not already installed
$_boxstarter_path = 'C:\ProgramData\Boxstarter\BoxstarterShell.ps1'

if (!(Test-Path $_boxstarter_path)) {
    ". { Invoke-WebRequest -useb 'http://boxstarter.org/bootstrapper.ps1' } | Invoke-Expression; get-boxstarter -Force"
    . { Invoke-WebRequest -useb 'http://boxstarter.org/bootstrapper.ps1' } | Invoke-Expression; get-boxstarter -Force
}

Boxstarter

# Allow reboots
$Boxstarter.RebootOk=$true
$Boxstarter.NoPassword=$false
$Boxstarter.AutoLogin=$true

# Prevent UAC interference
Disable-UAC
