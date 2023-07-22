 ### local check for Checkmk
### Exits with status "0" if all physical disks are healthy and "1" if there is a problem with at least one physical disk

### Date of last change: 2023-07-16
### Version 0.1

$errorcounter = 0

$vdisks_status = Get-VirtualDisk | Select-Object FriendlyName, OperationalStatus, HealthStatus

foreach ($vdisk in $vdisks_status) 
{
    if ($vdisk.OperationalStatus -eq "OK" -and $vdisk.HealthStatus -eq "Healthy") 
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
    $statusdescription = "All vdisks seem to be healthy!"
}
else 
{
    $status = "1"
    $statusdescription = "There is something wrong with at least one vdisk - please investigate!"
}

$check_result = $status + " S2D_Vdisks_Status" + " - " + $statusdescription
	Write-Host $check_result 
