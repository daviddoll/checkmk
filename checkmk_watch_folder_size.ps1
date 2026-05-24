### local check for Checkmk
### Exits with status "0" (ok) when foldersize is below sizelimit and "1" (warn) if foldersize is above sizelimit

### Date of last change: 2026-05-24
### Version 0.1

$sizelimit = 21474836480

$files = Get-ChildItem -Recurse C:\inetpub\logs\LogFiles\W3SVC1
$totalsize = ($files | Measure-Object -Sum Length).Sum

if ($sizelimit -gt $totalsize)
    {
        $status = "0"
        $statusdescription = "Folder size limit not reached! Please continue!"
    }
else
    {
        $status = "1"
        $statusdescription = "Folder size limit reached - please investigate!"
    }

$check_result = $status + " Inetpub_Logs_W3SVC1" + " - " + $statusdescription
Write-Host $check_result
