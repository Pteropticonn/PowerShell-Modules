function Set-TMServiceLogon {
    param (
        [string]$ServiceName,
        [string[]]$ComputerName,
        [string]$NewPassword,
        [string]$NewUser,
        [string]$ErrorLogFilePath
    )
    foreach ($computer in $ComputerName) {
        $option = New-CimSessionOption -Protocol Wsman
        $session = New-CimSession -SessionOption $option `
        -ComputerName $computer
        if ($PSBoundParameters.ContainsKey('NewUser')) {
            $args = @('StartName'=$NewUser;
            'StartPassword'= $NewPassword)
        } else {
            $args = @('StartPassword'=$NewPassword)
        }
        Invoke-CimMethod -ComputerName $computer -MethodName Change `
        -Query "SELECT * FROM Win32_Service WHERE name = '$ServiceName'" `
        -Arguments $args | 
        Select-Object -Property @{n='ComputerName';e={$computer}},
                                @{n='Result';e={$_ReturnValue}}
        $session | Remove-CimSession
    } # foreach
} # function