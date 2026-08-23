### local check for Checkmk
### Counts days since last Windows Updates
### Exits with status "0" if Windows Updates have been performed in X days or "1" if Windows have not been performed in X days. For X see $maxdayssincelastupdate
 
### Date of last change: 2026-08-23
### Version 0.1
 
$maxdayssincelastwu = 45
 
$actualdate = Get-Date -Format "dd/MM/yyyy"
 
$dateoflastwu = Get-HotFix | Sort-Object InstalledOn | Select-Object -Last 1 -ExpandProperty InstalledOn | date -f dd/MM/yyyy
 
$countdayssincelastwu = (New-TimeSpan -start $dateoflastwu -end $actualdate).Days
 
if ($maxdayssincelastwu -gt $countdayssincelastwu)
    {
        $status = "0"
        $statusdescription = "Last WU $countdayssincelastwu days ago - OK!"
    }
else
    {
        $status = "1"
        $statusdescription = "No WUs for $countdayssincelastwu days - Please act!"
    }
 
$check_result = $status + " Windows_Updates_Status" + " - " + $statusdescription
 
Write-Host $check_result
