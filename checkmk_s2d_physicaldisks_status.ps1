  ### local check for Checkmk
### Exits with status "0" if all physical disks are healthy and "1" if there is a problem with at least one pdisk

### Date of last change: 2023-07-16
### Version 0.1

$errorcounter = 0

$pdisks_status = Get-PhysicalDisk | Select-Object OperationalStatus, HealthStatus

foreach ($pdisk in $pdisks_status) 
{
    if ($pdisk.OperationalStatus -eq "OK" -and $pdisk.HealthStatus -eq "Healthy") 
    {
        ### Nothing to do ...
    } 
    else 
    {
        $errorcounter++
    }
}

if (!$errorcounter)
{
    $status = "0"
    $statusdescription = "All physical disks seem to be healthy!"
}
else 
{
    $status = "1"
    $statusdescription = "There is something wrong with at least one physical disk - please investigate!"
}

$check_result = $status + " S2D_PhysicalDisks_Status" + " - " + $statusdescription
	Write-Host $check_result 
 