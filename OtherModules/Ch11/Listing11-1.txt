function Get-MachineInfo {
    Param(
        [string[]]$ComputerName,
        [string]$LogFailuresToPath,
        [string]$Protocol = "Wsman",
        [switch]$ProtocolFallback
    )
 
    foreach ($computer in $computername) {
 
        # Establish session protocol
        if ($protocol -eq 'Dcom') {
            $option = New-CimSessionOption -Protocol Dcom
        } else {
            $option = New-CimSessionOption -Protocol Wsman
        }
 
        # Connect session
        $session = New-CimSession -ComputerName $computer -SessionOption $option
  
        # Query data
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -CimSession $session
  
        # Close session
        $session | Remove-CimSession
  
        # Output data
        $os | Select-Object -Prop @{n='ComputerName';e={$computer}},
                                Version,ServicePackMajorVersion
 
    } #foreach
 
} #function
