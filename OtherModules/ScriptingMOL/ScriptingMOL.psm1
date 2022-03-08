function Get-MachineInfo {
    Param(
        [string[]]$ComputerName,
        [string]$LogFailuresToPath,
        [string]$Protocol = "Wsman",
        [string]$ProtocolFallback
        )
        foreach ($computer in $computername) {
            # establish session protocol
            if($Protocol -eq 'Dcom') {
                $option = New-CimSessionOption -Protocol Dcom
            } else {
                $option = New-CimSessionOption -Protocol Wsman
            }
            # connect session
            $session = New-CimSession -ComputerName $computer -SessionOption $option
            #query data
            $os = Get-CimInstance -ClassName Win32_operatingSystem -CimSession $session
            #close session
            $session | Remove-CimSession
            #output data
            # Again, notice that you’re outputting a data structure—an object —to the pipeline. 
            # You haven’t explicitly used Write-Output , but it’s implicitly there because you didn’t
            # assign the results of that expression to a variable, nor did you explicitly pipe your object anyplace else.
            # You piped $os to Select-Object , and the result of that expression will end up in the pipeline.

            $os | Select-Object -prop @{n='ComputerName';e=($computer)},
            Version, ServicePackMajorVersion
        } #foreach 
} # function

