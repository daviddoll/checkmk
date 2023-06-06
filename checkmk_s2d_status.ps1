### local check for Checkmk
### Exits with status "0" if Storage Spaces Direct is installed/enabled or "1" if S2D is not installed/disabled

### Date of last change: 2023-06-06
### Version 0.1

$s2d_status = Get-ClusterStorageSpacesDirect | Select-Object State

if ($s2d_status.State -eq "Enabled") 
    {
        $status = "0"
        $statusdescription = "S2D is active!"
    } 
else 
    {
        $status = "1"
        $statusdescription = "S2D is NOT active!" 
    }

$check_result = $status + " S2D_Vdisks_Status" + " - " + $statusdescription 
Write-Host $check_result
