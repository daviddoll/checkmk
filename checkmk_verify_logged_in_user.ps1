### local check for Checkmk
### Exits with status "1" if any interactive user is logged in and "0" if none

### Date of last change: 2026-03-27
### Version 0.2

$loggedInUser = Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty UserName

if (-not [string]::IsNullOrWhiteSpace($loggedInUser)) {
    $status = "1"
    $statusdescription = "User is active: $loggedInUser"
}
else {
    $status = "0"
    $statusdescription = "No interactive user logged in."
}

$check_result = $status + " State_of_User" + " - " + $statusdescription
Write-Host $check_result
