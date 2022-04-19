[CmdletBinding()]
param (
    [Parameter()]
    [string]
    $MachineType = 'all'
)

function Write-GistFiles {
    param (
        # The object containing the jason and the code
        [Parameter(Mandatory)]
        [object]
        $Object,
        # The type of machine being generated
        [Parameter(Mandatory)]
        [string]
        $MachineType,
        # The path to the gist repo
        [Parameter(Mandatory)]
        [string]
        $GistPath
    )
    $($Object).json | ConvertTo-Json -depth 32 > (join-path $GistPath "$MachineType.machine.json")
    $($Object).code > (join-path $GistPath "$MachineType.machine.ps1")
}

#write-output "start $($MyInvocation.MyCommand.Source) $MachineType"
#[object]$this.json = $null 
$gistRepoPath = '..\2573a7affd2021a946d2b767c6579f87'

class BaseMachine {
    [bool] $WindowsBaseSoftware = $true
    [bool] $WindowsUpdate = $true
    [object] $json = $null
    [string] $code = $null
    [int] $AddPackageCalls = 0
    AddPackage($PackageId) {
        [object]$j = "[{`"PackageIdentifier`" : `"$PackageId`"}]" | ConvertFrom-Json -Depth 32
        $this.json.Sources[0].Packages += $j
        $this.AddPackageCalls++
        $file = ".\json\addpackage$($this.AddPackageCalls).json"
        write-debug "writing add package json($($this.json | ConvertTo-Json -depth 32 > $file ))"
    }
    AddCode($code) {
        $this.code += "$code`n"
        $this.code += Get-Content '.\test.pending.reboot.ps1' -raw
    }
    BaseMachine() {
        write-output 'start BaseMachine()'
        $content = Get-Content '.\winget.empty.json' -raw
        write-debug "writing inital content($($content > '.\json\initial.content.json'))"
        $this.json = $content | ConvertFrom-Json -Depth 32
        write-debug "writing inital json($($this.json | ConvertTo-Json -depth 32 > '.\json\initial.json'))"

        $this.AddCode((Get-Content '.\call.winget.ps1' -raw))

        if ($this.WindowsBaseSoftware) { 
            $this.AddPackage('Malwarebytes.Malwarebytes')
        }
        write-debug "writing intermediate base json($($this.json | ConvertTo-Json -depth 32 > '.\json\base.machine.json'))"
        write-debug "writing intermediate base code($($this.code > '.\code\base.machine.ps1'))"
        write-output 'end BaseMachine()'
    }
}

class ProductivityMachine : BaseMachine {
    [bool] $GeneralSoftware = $true    
    [bool] $InstallChrome = $true    
    [bool] $InstallFireFox = $false
    [bool] $InstallBrave = $false
    ProductivityMachine() : base() {
        write-output 'start ProductivityMachine()'
        if ($this.GeneralSoftware) { 
            if ($this.InstallChrome) { $this.AddPackage('Google.Chrome') }
            if ($this.InstallFireFox) { $this.AddPackage('Mozilla.Firefox') }
            if ($this.InstallBrave) { $this.AddPackage('BraveSoftware.BraveBrowser') }
            $this.AddPackage('LogMeIn.LastPass')
            $this.AddPackage('9NBHCS1LX4R0') # paint.net
            $this.AddPackage('CodeJelly.Launchy')
            $this.AddPackage('Notepad++.Notepad++')
            $this.AddPackage('WinDirStat.WinDirStat')
            $this.AddPackage('Spotify.Spotify')
            $this.AddPackage('Zoom.Zoom')
            $this.AddPackage('SlackTechnologies.Slack')
        }
        
        write-debug "writing intermediate productivity json($($this.json | ConvertTo-Json -depth 32 > '.\json\productivity.machine.json'))"
        write-debug "writing intermediate productivity code($($this.code > '.\code\productivity.machine.ps1'))"
        write-output 'end ProductivityMachine()'
    }
}

class MediaServer : BaseMachine {
    [bool] $HtpcSoftware = $true
    [bool] $WindowsPower = $false
    MediaServer() : base() {
        write-output 'start MediaServer()'
        if ($this.HtpcSoftware) { 
            $this.AddPackage('CodecGuide.K-LiteCodecPack.Full')
            $this.AddPackage('Microsoft.SQLServer.2019.Express')
            $this.AddPackage('Microsoft.SQLServerManagementStudio')
            $this.AddPackage('Plex.PlexMediaServer')
            $this.AddPackage('Valve.Steam')
            $this.AddPackage('2BrightSparks.SyncBackFree')
            $this.AddPackage('XBMCFoundation.Kodi')
            $this.AddPackage('9P4CLT2RJ1RS') # musicbee
        }
        write-debug "writing intermediate mediaserver json($($this.json | ConvertTo-Json -depth 32 > '.\json\mediaserver.machine.json'))"
        write-debug "writing intermediate mediaserver code($($this.code > '.\code\mediaserver.machine.ps1'))"
        write-output 'end MediaServer()'
    }
}

class DevMachine : ProductivityMachine {
    [bool] $GeneralDevSoftware = $true
    [bool] $DotnetDevSoftware = $true
    [bool] $HyperV = $false
    [bool] $Docker = $false
    [bool] $InstallPython2 = $false
    [bool] $InstallVisualStudio = $false
    [bool] $InstallRider = $false
    DevMachine() : base() {
        write-output 'start DevMachine()'
        if ($this.GeneralDevSoftware) { 
            $this.AddPackage('Google.Chrome.Dev')
            $this.AddPackage('Mozilla.Firefox.DeveloperEdition')
            $this.AddPackage('BraveSoftware.BraveBrowser.Dev')
            $this.AddPackage('7zip.7zip')
            $this.AddPackage('Lexikos.AutoHotkey')
            $this.AddPackage('ScooterSoftware.BeyondCompare4')
            $this.AddPackage('Git.Git')
            $this.AddPackage('GitHub.GitLFS')
            $this.AddPackage('Microsoft.GitCredentialManagerCore')
            $this.AddPackage('Microsoft.VisualStudioCode')
            $this.AddPackage('Microsoft.PowerShell')
            $this.AddPackage('Telerik.Fiddler.Everywhere')
            $this.AddPackage('Python.Python.3')
            $this.AddPackage('Microsoft.WindowsTerminal')
            $this.AddPackage('Hashicorp.Vagrant')
            $this.AddPackage('Microsoft.Teams ')
            $this.AddPackage('9P7KNL5RWT25') #sysinternals
            $this.AddPackage('WestWind.MarkdownMonster')
            if ($this.InstallPython2) { 
                $this.AddPackage('Python.Python.2') 
                $this.AddCode('python -m pip install --upgrade pip')
                $this.AddCode('python -m pip install cfn-lint')
            }

            $this.AddCode('wsl -install')
            $this.AddCode('wsl -install -distribution Ubuntu')
            $this.AddCode('choco upgrade westwindwebsurge --confirm')
            $this.AddCode('choco upgrade vscode-python --confirm')
            $this.AddCode('choco upgrade vscode-markdownlint --confirm')
            $this.AddCode('choco upgrade vscode-python --confirm')
            $this.AddCode('choco upgrade vscode-yaml --confirm')
            $this.AddCode('choco upgrade vscode-pull-request-github --confirm')
            $this.AddCode('choco upgrade vscode-gitlens --confirm')
            $this.AddCode('choco upgrade vscode-powershell --confirm')
            $this.AddCode('choco upgrade vscode-autohotkey --confirm')

            if ($this.DotnetDevSoftware) { 
                $this.AddPackage('Microsoft.dotNetFramework')
                $this.AddPackage('Microsoft.dotnet')
                $this.AddCode('choco install vscode-csharp --confirm')
                if ($this.InstallRider) { $this.AddPackage('JetBrains.Rider') }
                if ($this.InstallVisualStudio) { $this.AddPackage('Microsoft.VisualStudio.2022.Community') }
            }
            if ($this.HyperV) { 
                $this.AddCode('Microsoft-Hyper-V-All -source windowsFeatures')
            }
            if ($this.Docker) { 
                $this.AddPackage('Docker.DockerDesktop')
                $this.AddCode('vscode-docker')
            }
            write-debug "writing intermediate dev json($($this.json | ConvertTo-Json -depth 32 > '.\json\dev.machine.json'))"
            write-debug "writing intermediate dev code($($this.code > '.\code\dev.machine.ps1'))"
            write-output 'end DevMachine()'
        }
    }
}

class CloudDevMachine : DevMachine {
    [bool] $CloudDevSoftware = $true
    [bool] $InstallAzure = $true
    [bool] $InstallAWS = $true
    CloudDevMachine() : base() {
        write-output 'start CloudDevMachine()'
        if ($this.CloudDevSoftware) { 
            $this.AddPackage('Postman.Postman')
            if ($this.InstallAzure) {
                $this.AddPackage('Microsoft.AzureCLI')
                $this.AddPackage('Microsoft.Bicep')
                $this.AddPackage('Microsoft.AzureStorageExplorer')
                $this.AddPackage('Microsoft.AzureStorageEmulator')
                $this.AddPackage('Microsoft.AzureFunctionsCoreTools')
                $this.AddPackage('Microsoft.AzureDataStudio')
                $this.AddPackage('Microsoft.AzureCosmosEmulator')
                $this.AddPackage('Microsoft.AzureDataCLI')
            }
            if ($this.InstallAWS) {
                $this.AddPackage('Amazon.AWSCLI')
            }

            $this.AddCode('choco upgrade vscode-azurerm-tools --confirm')
            $this.AddCode('choco upgrade aws-vault --confirm')
            $this.AddCode('choco upgrade awstools.powershell --confirm')
            $this.AddCode('choco upgrade awslambdapscore --confirm')
        }
        $this.AddCode('choco upgrade terraform --confirm')
        $this.AddCode('choco upgrade Terraform-Docs --confirm')
        
        write-debug "writing intermediate cloud dev json($($this.json | ConvertTo-Json -depth 32 > '.\json\cloud.dev.machine.json'))"
        write-debug "writing intermediate cloud dev code($($this.code > '.\code\cloud.dev.machine.ps1'))"
        write-output 'end CloudDevMachine()'
    }    
}

switch ($MachineType) {
    
    { ($_ -eq 'all' -or $_ -eq 'plato') } {
        $o = New-Object ProductivityMachine
        Write-GistFiles -Object $o -MachineType 'plato' -GistPath $gistRepoPath
    }
    { ($_ -eq 'all' -or $_ -eq 'galileo') } {
        $o = New-Object CloudDevMachine
        Write-GistFiles -Object $o -MachineType 'galileo' -GistPath $gistRepoPath
    }
    { ($_ -eq 'all' -or $_ -eq 'socrates') } {
        $o = New-Object MediaServer
        Write-GistFiles -Object $o -MachineType 'socrates' -GistPath $gistRepoPath
    }
    { ($_ -eq 'all' -or $_ -eq 'newton') } {
        $o = New-Object DevMachine
        Write-GistFiles -Object $o -MachineType 'newton' -GistPath $gistRepoPath

    }
}

$currentFolder = Get-Location 

git commit -am"Machine files generated by build.machines on $(get-date)"
git pull
git push

Set-Location -Path $currentFolder

return $o
