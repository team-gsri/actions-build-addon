[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory)]
    [ValidateScript({ if (Test-Path $_ -PathType Container) { $true } else { Throw '-Source must ba a valid directory' } })]
    [string]
    $Source,

    [Parameter(Mandatory)]
    [ValidateScript({ if (Test-Path $_ -PathType Container) { $true } else { Throw '-Target must ba a valid directory' } })]
    [string]
    $Target,

    [Parameter(Mandatory)]
    [string]
    $Prefix
)
Begin {
    if (-Not (Test-Path -Path ${env:ARMA3TOOLS} -PathType Container)) {
        Throw 'Arma 3 Tools not found'
    }
    $addonBuilderExe = Join-Path -Path ${env:ARMA3TOOLS} -ChildPath 'AddonBuilder/AddonBuilder.exe'
    if (-Not (Test-Path -Path $addonBuilderExe -PathType Leaf)) {
        Throw 'AddonBuilder.exe not found'
    }
    $Source = Resolve-Path $Source.TrimEnd('/\')
    $Target = Resolve-Path $Target.TrimEnd('/\')

    $includesFilename = New-TemporaryFile
    Set-Content -Path $includesFilename -Value '*'
}
Process {
    if ($PSCmdlet.ShouldProcess($Source)) {
        & $addonBuilderExe $Source $Target "-toolsDirectory=${env:ARMA3TOOLS}" -clear "-prefix=$Prefix" "-include=$includesFilename"
    }    
}
End {
    Remove-Item $includesFilename -Force
}