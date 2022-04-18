Write-BoxstarterMessage 'start test.pending.reboot.ps1'

if (Test-PendingReboot) { 
    Write-BoxstarterMessage 'Reboot needed'
    Invoke-Reboot
}

Write-BoxstarterMessage 'end test.pending.reboot.ps1'

