# https://docs.microsoft.com/en-us/windows/win32/api/wslapi/
# https://devblogs.microsoft.com/scripting/use-powershell-to-interact-with-the-windows-api-part-1/

#typedef enum  {
#  WSL_DISTRIBUTION_FLAGS_NONE,
#  WSL_DISTRIBUTION_FLAGS_ENABLE_INTEROP,
#  WSL_DISTRIBUTION_FLAGS_APPEND_NT_PATH,
#  WSL_DISTRIBUTION_FLAGS_ENABLE_DRIVE_MOUNTING
#} WSL_DISTRIBUTION_FLAGS;

$WSL_DISTRIBUTION_FLAGS = @'
[DllImport("wslapi.dll", CharSet = CharSet.Unicode)]
public enum WSL_DISTRIBUTION_FLAGS {
    WSL_DISTRIBUTION_FLAGS_NONE,
    WSL_DISTRIBUTION_FLAGS_ENABLE_INTEROP,
    WSL_DISTRIBUTION_FLAGS_APPEND_NT_PATH,
    WSL_DISTRIBUTION_FLAGS_ENABLE_DRIVE_MOUNTING
}
'@

#HRESULT WslGetDistributionConfiguration(
#  PCWSTR                 distributionName,
#  ULONG                  *distributionVersion,
#  ULONG                  *defaultUID,
#  WSL_DISTRIBUTION_FLAGS *wslDistributionFlags,
#  PSTR                   **defaultEnvironmentVariables,
#  ULONG                  *defaultEnvironmentVariableCount
#);


# HRESULT WslConfigureDistribution(
#  PCWSTR                 distributionName,
#  ULONG                  defaultUID,
#  WSL_DISTRIBUTION_FLAGS wslDistributionFlags
#);

function WslConfigureDistribution ($distributionName, $defaultUID, $wslDistributionFlags) {
    $Source =@'
    [DllImport("wslapi.dll", CharSet = CharSet.Unicode)]
    public enum WSL_DISTRIBUTION_FLAGS {
        WSL_DISTRIBUTION_FLAGS_NONE,
        WSL_DISTRIBUTION_FLAGS_ENABLE_INTEROP,
        WSL_DISTRIBUTION_FLAGS_APPEND_NT_PATH,
        WSL_DISTRIBUTION_FLAGS_ENABLE_DRIVE_MOUNTING
    }
    public static extern bool WslIsDistributionRegistered(string distributionName, uint defaultUID, WSL_DISTRIBUTION_FLAGS wslDistributionFlags);
'@
    $WslApi = Add-Type -MemberDefinition $Source -Name "WslapiWslConfigureDistribution" -PassThru
    return $WslApi::WslIsDistributionRegistered($distributionName, $defaultUID, $wslDistributionFlags)
}


#BOOL WslIsDistributionRegistered(
#  PCWSTR distributionName
#);

function WslIsDistributionRegistered ($distributionName){
    $Source =@'
    [DllImport("wslapi.dll", CharSet = CharSet.Unicode)]
    public static extern bool WslIsDistributionRegistered(string distributionName);
'@
    $WslApi = Add-Type -MemberDefinition $Source -Name "WslapiDistributionRegistered" -PassThru
    return $WslApi::WslIsDistributionRegistered($distributionName)
}

# HRESULT WslRegisterDistribution(
#  PCWSTR distributionName,
#  PCWSTR tarGzFilename
#);

function WslRegisterDistribution ($distributionName, $tarGzFilename){
    $Source =@'
    [DllImport("wslapi.dll", CharSet = CharSet.Unicode)]
    public static extern uint WslRegisterDistribution(string distributionName, string tarGzFilename);
'@
    $WslApi=Add-Type -MemberDefinition $Source -Name 'WslapiRegisterDistribution' -PassThru
    return $WslApi::WslRegisterDistribution($distributionName, $tarGzFilename)
}

# HRESULT WslLaunch(
#  PCWSTR distributionName,
#  PCWSTR command,
#  BOOL   useCurrentWorkingDirectory,
#  HANDLE stdIn,
#  HANDLE stdOut,
#  HANDLE stdErr,
#  HANDLE *process
#);


# HRESULT WslLaunchInteractive(
#  PCWSTR distributionName,
#  PCWSTR command,
#  BOOL   useCurrentWorkingDirectory,
#  DWORD  *exitCode
#);

# HRESULT WslUnregisterDistribution(
#  PCWSTR distributionName
#);

function WslUnregisterDistribution ($distributionName) {
    $Source =@'
    [DllImport("wslapi.dll", CharSet = CharSet.Unicode)]

    public static extern uint WslUnregisterDistribution(string distributionName);
'@
    $WslApi=Add-Type -MemberDefinition $Source -Name 'WslapiUnregisterDistributio' -PassThru
    return $WslApi::WslUnregisterDistribution($distributionName)
}

$wslapidllPath = "C:\Windows\System32\wslapi.dll"
if (-not (Test-Path $wslapidllPath)) {
    "Error: $wslapidllPath was not found. Exiting"
    exit 1
}

$distributionName = "PowerLauncherTestDistro 1.0"
$tarGzPath = "install.tar.gz"
$distributionDefUUID = 500
$wslApiFlags=Add-Type -MemberDefinition $WSL_DISTRIBUTION_FLAGS -Name 'WslapiDistributionFlags' -PassThru
$distributionFlags = $wslApiFlags::WSL_DISTRIBUTION_FLAGS(0)

WslIsDistributionRegistered($distributionName)
WslRegisterDistribution($distributionName, $tarGzPath)
WslConfigureDistribution($distributionName, $distributionDefUUID, $distributionFlags)