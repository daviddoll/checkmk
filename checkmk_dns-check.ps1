 ### local check for Checkmk
### Performs DNS request to nameserver and the result can be validated
### Exits with status "0" if everything works as expected and "1" if there is an unexpected result

### Date of last change: 2025-11-24
### Version 0.1

$hostname_to_be_checked = "www.kame.net"
$dns_server = "8.8.8.8"
$expected_result = "210.155.141.200"

$dns_request =  Resolve-DnsName $hostname_to_be_checked -Server $dns_server

if ($dns_request.IPAddress -eq $expected_result) 
    {
        $status = "0"
        $statusdescription = "DNS works fine!!"
    } 
else 
    {
        $status = "1"
        $statusdescription = "There is something wrong with DNS!" 
    }

$check_result = $status + " DNS Request Status (A-Record)" + " - " + $statusdescription 
Write-Host $check_result