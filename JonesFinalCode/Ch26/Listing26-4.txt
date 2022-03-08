function Get-DiskInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [string[]]$ComputerName
    )
    BEGIN {
        Set-StrictMode -Version 2.0
    }
    PROCESS {

        ForEach ($comp in $ComputerName) {

            $params = @{'ComputerName' = $comp
                        'ClassName' = 'Win32_LogicalDisk'}
            $disks = Get-CimInstance @params

            ForEach ($disk in $disks) {

                $props = @{'ComputerName' = $comp
                           'Size' = $disk.size
                           'FreeSpace' = $disk.freespace
                           'Drive' = $disk.deviceid
                           'DriveType' = $disk.drivetype}

                New-Object -TypeName PSObject -Property $props

            } #foreach disk

        } #foreach computer

    } #PROCESS
    END {}
}

function New-DiskInfoSQLTable {
    [CmdletBinding()]
    param()

    $conn = New-Object System.Data.SqlClient.SqlConnection
    $conn.ConnectionString = $DiskInfoSqlConnection
    $conn.Open()

    $sql = @"
        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='diskinfo' AND xtype='U')
            CREATE TABLE diskinfo (
                ComputerName VARCHAR(64),
                DiskSize BIGINT,
                DriveType TINYINT,
                FreeSpace BIGINT,
                DriveID CHAR(2),
                DateAdded DATETIME2
            )  
"@

    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $conn
    $cmd.CommandText = $sql
    $cmd.ExecuteNonQuery() | Out-Null

    $conn.Close()

}

function Export-DiskInfoToSQL {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$True,
                   ValueFromPipeline=$True)]
        [object[]]$DiskInfo
    )
    BEGIN {
        New-DiskInfoSQLTable
        $conn = New-Object System.Data.SqlClient.SqlConnection
        $conn.ConnectionString = $DiskInfoSqlConnection
        $conn.Open()

        $cmd = New-Object System.Data.SqlClient.SqlCommand
        $cmd.Connection = $conn
    }
    PROCESS {

        ForEach ($object in $DiskInfo) {

            if ($object.size -eq $null) { 
                $size = 0 
            } else { 
                $size = $object.size 
            }
            if ($object.freespace -eq $null) { 
                $freespace = 0 
            } else { 
                $freespace = $object.freespace 
            }

            $sql = @"
                INSERT INTO DiskInfo (ComputerName,
                    DiskSize,DriveType,FreeSpace,DriveID,DateAdded)
                VALUES('$($object.ComputerName)',
                       $size,
                       $($object.DriveType),
                       $freespace,
                       '$($object.Drive)',
                       '$(Get-Date)')
"@
            $cmd.CommandText = $sql
            Write-Verbose "EXECUTING QUERY `n $sql"
            $cmd.ExecuteNonQuery() | Out-Null

        } #ForEach

    } #PROCESS
    END {
        $conn.Close()
    }
}


$DiskInfoSqlConnection = "Server=localhost\SQLEXPRESS;Database=Scripting;Trusted_Connection=True;"

Export-ModuleMember -Function Get-DiskInfo,Export-DiskInfoToSQL
Export-ModuleMember -Variable DiskInfoSqlConnection

