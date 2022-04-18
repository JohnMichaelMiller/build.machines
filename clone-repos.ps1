git config --global user.email "jmiller@pdata.com"
git config --global user.name "John M. Miller"

git config --global core.editor "'C:\Program Files\Notepad\notepad.exe' -multiInst -notabbar -nosession -noPlugin"

git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status

git config --global alias.unstage 'reset HEAD --'

git config --global pull.rebase true

git config --global diff.tool bc
git config --global difftool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"

git config --global merge.tool bc
git config --global mergetool.bc.path "c:/Program Files/Beyond Compare 4/bcomp.exe"

$currentLocation = Get-Location

if (-not (test-path c:\git)) { mkdir c:\git }

Set-Location c:\git

$repos = @(
    'https://github.com/JohnMichaelMiller/build.machines.git',
    'https://gist.github.com/ff15ca29ac2a37ddec7fb0d06124c41d.git',
    'https://gist.github.com/2573a7affd2021a946d2b767c6579f87.git',
    'https://github.com/JohnMichaelMiller/acloud.guru.git',
    'https://github.com/JohnMichaelMiller/Kata.git',
    'https://github.com/JohnMichaelMiller/TemperatureConversionGrader.git',
    'https://github.com/Juxce/tuneage-azure-functions.git'
    'https://github.com/Juxce/tuneage-api-dotnet.git'    
)

$repos | ForEach-Object {
    $folder = ($_.Substring( $_.LastIndexOf('/') + 1  )).replace('.git', '')
    write-debug "folder($folder)"
    if (-not (test-path $folder )) { 
        write-verbose "creating folder $folder"
        mkdir $folder 
        write-verbose "cloning repo $_"
        git clone $_
        Set-Location $folder
    }
    else {
        write-verbose "getting latest from repo $_"
        Set-Location $folder

        git pull --rebase

    }
    if ($_.contains('Juxce')) {
        git config --local user.email "jmm@juxce.com"
    }
    else {
        git config --local user.email "johnmichaelmiller@outlook.com"
    }
    git config user.email
    Set-Location ..
}

set-Location $currentLocation
