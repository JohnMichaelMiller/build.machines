[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $jsonFile
)

Write-BoxstarterMessage 'start call.winget.ps1'

if (test-path $jsonFile) {
    Write-BoxstarterMessage 'Running winget import to install Windows Store packages'

    winget import `
        --ignore-unavailable `
        --ignore-versions `
        --accept-package-agreements `
        --accept-source-agreements `
        --import-file $jsonFile
}
else {
    Write-BoxstarterMessage "winget json file ($jsonFile) not found"
    throw "winget json file ($jsonFile) not found"
}

Write-BoxstarterMessage 'end call.winget.ps1'
