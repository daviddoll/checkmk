### local check for Checkmk
### Exits with status "0" if the keyword is found on the website and "1" if the keyword is not found

### Date of last change: 2026-03-23
### Version 0.2

$website = "https://www.cnn.com"
$cfa = Invoke-WebRequest -Uri $website
$searchkeyword = $cfa.tostring() -split "[`r`n]" | select-string "Trump"

if ($searchkeyword)
    {
        $status = "0"
        $statusdescription = "He is still here!!"
    } 
else 
    {
        $status = "1"
        $statusdescription = "He is gone ..." 
    }

$check_result = $status + " CFA" + " - " + $statusdescription
Write-Host $check_result
