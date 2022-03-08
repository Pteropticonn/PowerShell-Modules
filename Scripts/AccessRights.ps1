using namespace System.Security.AccessControl;
using namespace System.Security.Principal;

[Flags()]
#weird access masks represented by random 32 bit integer values
enum SessionAccessRight {
    All     = -536870912 
    Full    = 268435456 
    Read    = -2147483648 
    Write   = 1073741824 
    Execute = 536870912 
} 

function Get-PSSessionAcl {
    param (
        [Parameter(Mandatory)]
        [String[]]$Name
    )
    
    Get-PSSessionConfiguration -Name $Name | ForEach-Object {
        [CommonSecurityDescriptor]::new(
            $false,
            $false,
            $_.SecurityDescriptorSddl
        )
    }
}

function Get-PSSessionAccess {
    [CmdletBinding()]
    param (
       # Parameter help description
       [Parameter(Mandatory)]
       [String[]]
       $Name
    )

    (Get-PSSessionAcl -Name $Name).DiscrectionaryAcl | -Member Identity -MemberType ScriptProperty -Value {
            $this.SecurityIdentifier.Translate([NTAccount]) 
        } -PassThru | 
        Add-Member AccessRight -MemberType ScriptProperty -Value { 
            [SessionAccessRight]$this.AccessMask 
        } -PassThru 
}

# $identity = "$env{\USERDOMAIN\}$env:USERNAME"
# $acl = Get-PSSessionAcl  -Name "Microsoft.PowerShell"
# $acl.DiscretionaryAcl.AddAccess(
#     'Allow',

#     ([NTAccount]$identity).Translate([SecurityIdentifier]),
#     [Int][SessionAccessRight]'Full',
#     'None',     # Inheritance flags
#     'None'      # Propagation flags
# )

$identity = "$env:USERDOMAIN\$env:USERNAME"
$acl = Get-PSSessionAcl -Name "Microsoft.PowerShell"
$acl.DiscretionaryAcl.AddAccess(
    'Allow',
    ([NTAccount]$identity).Translate([SecurityIdentifier]),
    [Int][SessionAccessRight]'Full',
    'None',   # Inheritance flags
    'None'    # Propagation flags
)

$sddl = $acl.GetSddlForm('All') 
Set-PSSessionConfiguration Microsoft.PowerShell 
-SecurityDescriptorSddl $sddl 