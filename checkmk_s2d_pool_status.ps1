### local check for Checkmk
### Exits with status "0" if the storage pool is completely healthy and "1" if there is a problem with the pool

### Date of last change: 2023-05-30
### Version 0.1

$poolstatus = Get-StoragePool | Select-Object OperationalStatus, HealthStatus

if ($poolstatus.OperationalStatus -eq "OK" -and $poolstatus.HealthStatus -eq "Healthy") 
    {
        $status = "0"
        $statusdescription = "The Storage Pool seems to be healthy!"
    } 
else 
    {
        $status = "1"
        $statusdescription = "There is something wrong with the Storage Pool - please investigate!"
    }

$check_result = $status + " S2D_Storage-Pool_Status" + " - " + $statusdescription
Write-Host $check_result 
