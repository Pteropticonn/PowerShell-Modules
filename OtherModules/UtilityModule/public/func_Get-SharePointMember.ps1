Function Get-SharePointMember { 
    [CmdletBinding()] 
    Param( 
        [Parameter(Position = 0, Mandatory = $true)][String]$URI, 
        [Parameter(Position = 1)][String]$Group 
    ) 
		
    Process { 
        $Params = @{ 
            "URI" = $URI 
        } 
        If ($Group) { 
            Get-SPOUser @Params | Where-Object -Contains $Group 
        }
        Else { 
            Get-SPOUser @Params 
        } 
    } 
}