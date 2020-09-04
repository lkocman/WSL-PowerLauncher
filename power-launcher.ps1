# https://docs.microsoft.com/en-us/windows/win32/api/wslapi/
# https://devblogs.microsoft.com/scripting/use-powershell-to-interact-with-the-windows-api-part-1/

#typedef enum  {
#  WSL_DISTRIBUTION_FLAGS_NONE,
#  WSL_DISTRIBUTION_FLAGS_ENABLE_INTEROP,
#  WSL_DISTRIBUTION_FLAGS_APPEND_NT_PATH,
#  WSL_DISTRIBUTION_FLAGS_ENABLE_DRIVE_MOUNTING
#} WSL_DISTRIBUTION_FLAGS;

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


#BOOL WslIsDistributionRegistered(
#  PCWSTR distributionName
#);

function WslIsDistributionRegistered ($distributionName){
    $Source =@'
    [DllImport("wslapi.dll", CharSet = CharSet.Unicode)]
    public static extern bool WslIsDistributionRegistered(string distributionName);
'@
    $WslApi = Add-Type -MemberDefinition $Source -Name "Wslapi" -PassThru
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
    $WslApi=Add-Type -MemberDefinition $Source -Name 'Wslapi' -PassThru
    return $WslApi::WslRegisterDistribution("$distributionName", "$tarGzFilename");
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

$distribution_name = "openSUSE Leap 15.2"

WslIsDistributionRegistered($distribution_name);