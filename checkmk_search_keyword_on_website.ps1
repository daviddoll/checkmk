### local check for Checkmk
### Fetches a URL and checks whether a literal keyword appears in the response body.
### Exit: 0 = keyword found, 1 = keyword not found, 2 = request or script error

### Date of last change: 2026-03-27
### Version 0.3

param(
    [string]$Website = "https://www.cnn.com",
    [string]$Keyword = "Trump",
    [string]$ServiceName = "CFA",
    [int]$TimeoutSec = 30
)

$status = 2
$statusDescription = "Unknown check state."
$responseTimeMs = 0

try {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

    $response = Invoke-WebRequest -Uri $Website -UseBasicParsing -TimeoutSec $TimeoutSec -MaximumRedirection 5 -ErrorAction Stop

    $stopwatch.Stop()
    $responseTimeMs = [math]::Round($stopwatch.Elapsed.TotalMilliseconds, 0)

    $content = $response.Content
    if ($null -eq $content) {
        $status = 2
        $statusDescription = "Response had no content body for $Website."
    }
    elseif ($content.IndexOf($Keyword, [StringComparison]::OrdinalIgnoreCase) -ge 0) {
        $status = 0
        $statusDescription = "Keyword '$Keyword' found on $Website."
    }
    else {
        $status = 1
        $statusDescription = "Keyword '$Keyword' not found on $Website."
    }
}
catch {
    $status = 2
    $statusDescription = "Request failed for ${Website}: $($_.Exception.Message)"
}

$checkResult = "$status $ServiceName response_time_ms=$responseTimeMs;;;; - $statusDescription"
Write-Host $checkResult
exit $status
