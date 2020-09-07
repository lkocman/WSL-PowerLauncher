$wslapidllPath = "C:\Windows\System32\wslapi.dll"
if (-not (Test-Path $wslapidllPath)) {
    "Error: $wslapidllPath was not found. Please make sure to use PowerShell for arm64 on Windows for ARM. Exiting"
    exit 1
}

if (Test-Path $PSScriptRoot\wslapi.psm1) { # DevEnv
    Import-Module $PSScriptRoot\wslapi.psm1 # Requires PowerShell v3+    
} else {
    Import-Module wslapi
}

$distributionName = "PowerLauncherTestDistro 1.0"
$tarGzPath = "$PSScriptRoot\install.tar.gz" # Has to be absolute github.com/microsoft/WSL/issues/4057
$distributionDefUUID = 500 # Needs to be set 
$distributionFlags = 0 # wslapi.pms1

if (-not (WslIsDistributionRegistered("$distributionName"))) {
    "Distribution: $distributionName is not registered. Registering!"
    if (WslRegisterDistribution($distributionName, $tarGzPath) == $E_ACCESSDENIED) {
        "Error: Acces denied while trying to register $distributionName."
        exit 2
    }
    WslConfigureDistribution($distributionName, $distributionDefUUID, $distributionFlags)
}