function Get-DiskInfo {
 foreach ($domain in (Get-ADForest).domains) { 
   $hosts = Get-ADDomainController -filter * -server $domain | 
   Sort-Object -Prop hostname
   ForEach ($host in $hosts) { 
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $host
    $props = @{'ComputerName' = $host
               'DomainController' = $host
               'Manufacturer' = $cs.manufacturer
               'Model' = $cs.model
               'TotalPhysicalMemory'=$cs.totalphysicalmemory / 1GB
               }
     $obj = New-Object -Type PSObject -Prop $props
     $obj.psobject.typenames.insert(0,'Toolmaking.DiskInfo')
     Write-Output $obj
   } #foreach $host
  } #foreach $domain
} #function

Export-ModuleMember -function Get-DiskInfo