### local check for Checkmk
### Performs DNS request to nameserver and validates response
### Exits with status "0" for expected response and "2" on errors/unexpected results
###
### Date of last change: 2026-03-27
### Version 0.2

param(
    [string]$HostnameToBeChecked = "www.kame.net",
    [string]$DnsServer = "8.8.8.8",
    [string]$ExpectedResult = "210.155.141.200",
    [string]$ServiceName = "DNS_Request_Status"
)

$status = 2
$statusDescription = "Unknown DNS check state."
$responseTimeMs = 0

try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    # DNS-only query against the configured resolver to avoid local hosts/DNS cache side effects.
    $dnsRequest = Resolve-DnsName -Name $HostnameToBeChecked -Type A -Server $DnsServer -DnsOnly -QuickTimeout -ErrorAction Stop

    $stopwatch.Stop()
    $responseTimeMs = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 0)

    $answerIps = @($dnsRequest | Where-Object { $_.IPAddress } | Select-Object -ExpandProperty IPAddress)

    if ($answerIps.Count -eq 0) {
        $status = 2
        $statusDescription = "DNS query returned no A record for $HostnameToBeChecked on $DnsServer."
    }
    elseif ($answerIps -contains $ExpectedResult) {
        $status = 0
        $statusDescription = "DNS works fine. $HostnameToBeChecked resolved to expected IP $ExpectedResult via $DnsServer."
    }
    else {
        $status = 2
        $statusDescription = "DNS returned unexpected A records: $($answerIps -join ', ') (expected: $ExpectedResult)."
    }
}
catch {
    $status = 2
    $statusDescription = "DNS query failed for $HostnameToBeChecked on $DnsServer. Error: $($_.Exception.Message)"
}

$checkResult = "$status $ServiceName response_time_ms=$responseTimeMs;;;; - $statusDescription"
Write-Host $checkResult
exit $status
