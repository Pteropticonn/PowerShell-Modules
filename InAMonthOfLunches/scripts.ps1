<# 
#>

function Print-Msg {
    param (
        [Parameter(Mandatory=$true, HelpMesssages='String to Output')][string]$msg, [string]$color = "Green")
        Write-Host ('{0} -f $msg')
    )
    Function Create-Shortcut {
        param ( [Parameter(Mandatory=$true,HelpMessage='Target path')][string]$SourceExe
        , [Parameter(Mandatory=$true,HelpMessage='Arguments to the path/exe')][AllowEmptyString()]$ArgumentsToSourceExe
        , [Parameter(Mandatory=$true,HelpMessage='The destination of the desktop link')][string]$DestinationPath
        , [Parameter(Mandatory=$true,HelpMessage='Temporary path to create the link at')][string]$TempPath

    }
}