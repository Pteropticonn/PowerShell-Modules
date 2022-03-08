#The following validates that an IP address used as an argument falls in a private address range. 
# If the address is not part of a private range, or not a valid IP address, the command will throw an error:

using namespace System.Management.Automation;

class ValidatePrivateIPAddressAttribute : ValidateEnumeratedArgumentsAttribute {
    Hidden $ipAddress = [ipaddress]::Empty


Hidden [Boolean] IsValidIPAddress([string]$value)   {
    return [ipaddress]::TryParse($value, [Ref]$this.ipAddress)
}

Hidden [Boolean] IsPrivateIPAddress([ipaddress]$address) {
    $bytes = $address.GetAddressBytes()
    $isPrivateIPAddress = switch ($null) {
        { $bytes[0] -eq 192 -and
         $bytes[1] -eq 168 } {$true; break }
         { $bytes[0] -eq 172 -and
        $bytes[1] -ge 16 -and 
        $bytes[2] -le 31} {$true; break}
        { $bytes[0] -eq 10 } { $true; break }
            default { $false }
    }
    return $isPrivateIPAddress
}


[Void] ValidateElement([Object]$element) {
    if (-not $element -is [IPAddress]) {
        if ($this.IsValidIPAddress($element)) {
            $element = $this.ipAddress
        } else {
            throw '{0} is an invalid IP address format' -f $element
        }
    }
    if (-not $this.IsPrivateIPAddress($element)) {
        throw '{0} is not a private IP address' -f $element
    }
}


}

# The attribute defined in the preceding code may be used with any parameter to validate IP addressing,
# as shown in the following short function:

function Test-Validate {
    [CmdletBinding()]
    param (
        [ValidatePrivateIPAddress()]
        [IPAddress]$IPAddress
    )
 
    Write-Host $IPAddress
}