### local check for Checkmk
### Exits with status "1" if a specific user is logged in and "0" if that user is not logged in

### Date of last change: 2026-03-23
### Version 0.1

$listloggedinusers = get-wmiobject -class win32_computersystem | select-object -expand username

if ($listloggedinusers -match "admin")
{
    $status = "1"
    $statusdescription = "User is active!"
}
        else
{
    $status = "0"
    $statusdescription = "User is NOT active!"
}

$check_result = $status + " State_of_User" + " - " + $statusdescription
	Write-Host $check_result
