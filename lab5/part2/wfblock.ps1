param(
    [string]$Action = 'add'
)
$ConfirmPreference = 'None'
$ruleName = 'BlockOutgoingTraffic'
if ($Action -eq 'delete') {
    Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue |
        Remove-NetFirewallRule -ErrorAction SilentlyContinue
    Write-Host 'Outgoing traffic block removed.'
    exit 0
}
if (-not (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name $ruleName -DisplayName $ruleName -Direction Outbound -Action Block -Enabled True | Out-Null
    Write-Host 'Outgoing traffic is now blocked.'
} else {
    Write-Host 'Outgoing traffic is already blocked.'
}
