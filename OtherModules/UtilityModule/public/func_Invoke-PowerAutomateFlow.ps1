Function Invoke-PowerAutomateFlow { 
    [CmdletBinding()] 
    Param( 
        [Parameter(Position = 0, Mandatory = $true)][String]$URI 
				) 
				Process { 
        $Params = @{ 
            "URI"         = $URI 
            "ContentType" = 'application/json' 
            "Method"      = 'GET' 
        } 
        Invoke-WebRequest @Params 
				} 
}