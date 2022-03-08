# The following example shows a possible implementation that tests the value of ParameterSetName.
# The function accepts the name of a service as a string, a service object from Get-Service, 
# or a service returned from the Win32_Service class. The function finds the process associated
# with that service:



function Get-ServiceProcess {
    [CmdletBinding(DefaultParameterSetName = 'ByName')]
    param (
        [Parameter(Mandatory,  Position = 1, ParameterSetName = 'ByName')]
        [String]$Name,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromService')]
        [System.ServiceProcess.ServiceController]$Service,

        [Parameter(Mandatory, ValueFromPipeline, ParameterSetName = 'FromCimService')]
        [PSTypeName('Microsoft.Management.Infrastructure.CimInstance#root/cimv2/Win32_Service')]
        [CimInstance]$CimService
    )

    process {
        if ($pscmdlet.ParameterSetName -eq 'FromService') {
            $Name = $Service.Name
        }
        if ($Name) {
            $params = @{
                ClassName = 'Win32_Service'
                Filter    = 'Name="{0}"' -f $Name
                Property  = 'Name', 'ProcessId', 'State'
            }
            $CimService = Get-CimInstance @params
        }
        if ($CimService.State -eq 'Running') {
            Get-Process -Id $CimService.ProcessId
        } else {
            Write-Error ('The service {0} is not running' -f $CimService.Name)
        }
    }
}