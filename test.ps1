
class test {
    [object] $j = $null
    AddP($p){
        [object]$toAdd = "[{`"PackageIdentifier`" : `"$p`"}]" | ConvertFrom-Json -Depth 32
        $this.j.Sources[0].Packages += $toAdd
    }
    test() {
        $this.j = Get-Content .\winget.test.json | ConvertFrom-Json -Depth 32
        $this.AddP( 'Malwarebytes.Malwarebytes' )
        $this.AddP( 'TEST.2' )
    }
}

$o = New-Object -TypeName test 

$o.j | ConvertTo-Json -Depth 32
