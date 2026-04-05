### local check for Checkmk
### Reads a failover cluster node via Get-ClusterNode (Hyper-V / Failover Clustering).
### Exit: 0 = State Up (OK), 1 = Paused (WARN), 2 = all other states or errors (CRIT)
###
### Date of last change: 2026-03-28
### Version 0.2

param(
    [string]$NodeName = $env:COMPUTERNAME,
    [string]$Cluster = "",
    [string]$ServiceName = "Hyper-V_ClusterNode_Status"
)

$status = 2
$statusDescription = "Unknown cluster node check state."

try {
    Import-Module FailoverClusters -ErrorAction Stop

    $getNodeParams = @{
        Name        = $NodeName
        ErrorAction = 'Stop'
    }
    if (-not [string]::IsNullOrWhiteSpace($Cluster)) {
        $getNodeParams['Cluster'] = $Cluster
    }

    $node = Get-ClusterNode @getNodeParams
    if (@($node).Count -ne 1) {
        throw "Expected exactly one cluster node for Name='$NodeName', got $(@($node).Count)."
    }

    $stateText = $node.State.ToString()

    if ($stateText -eq 'Up' -or $stateText -eq 'OK') {
        $status = 0
        $statusDescription = "Cluster node '$NodeName' is OK (State=$stateText)."
    }
    elseif ($stateText -eq 'Paused') {
        $status = 1
        $statusDescription = "Cluster node '$NodeName' is Paused (State=$stateText)."
    }
    else {
        $status = 2
        $statusDescription = "Cluster node '$NodeName' is not OK (State=$stateText)."
    }
}
catch {
    $status = 2
    $statusDescription = "Cluster node check failed for '$NodeName': $($_.Exception.Message)"
}

$checkResult = "$status $ServiceName - $statusDescription"
Write-Host $checkResult
exit $status
