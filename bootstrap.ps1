param([String]$build = 'galileo')

write-output "start $build $($MyInvocation.MyCommand.Source)"

# From a Administrator PowerShell, if Get-ExecutionPolicy returns Restricted, run:
if ((Get-ExecutionPolicy) -eq 'Restricted') {
    write-output 'Run the following command in an administrator PowerShell'
    write-output 'Set-ExecutionPolicy Unrestricted -Force'
}


$content = .\build.bs.ps1

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

$package = New-PackageFromScript -PackageName 'galileo' -Source '.\galileo.machine.ps1'

$cred = Get-Credential
Install-BoxstarterPackage -PackageName $package -Credential $cred

write-output "end $build $($MyInvocation.MyCommand.Source)"

