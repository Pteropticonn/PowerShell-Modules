Function New-TeamsMessage {
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true)][String]$Message,
        [Parameter(Position = 1, Mandatory = $true)][String]$Title,
        [Parameter(Position = 2, Mandatory = $true)][String]$URI
    )
    # To Tell PowerShell to execute this function for every object coming in, you must include a process block.
    # Inside the process block, you put the code you want to execute each time the functions recives pipeline input. 
    Process {
        $Params = @{
            "URI" = $URI
            "Method" = 'POST'
            "Body" = [PSCustomObject][Ordered]@{
                "@type" = 'MessageCard'
                "@context" = 'http://schema.org/extension'
                "summary" = $Title
                "title" = $Title
                "text" = ($Message | Out-String)
            }
            "Content-Type" = 'application/json'
        }
        Invoke-RestMethod @Param | Out-Null
    }
}