<#
.SYNOPSIS
    Revierta el bloqueo de tráfico de salida creado por el script de Active Response.
    Elimina la regla de firewall 'BlockOutgoingTraffic'.
#>

$ruleName = "BlockOutgoingTraffic"

if (Get-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue) {
    Write-Host "Eliminando la regla de bloqueo: $ruleName..." -ForegroundColor Yellow
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    Write-Host "Tráfico de salida restaurado correctamente." -ForegroundColor Green
} else {
    Write-Host "No se encontró la regla de bloqueo '$ruleName'. El sistema no parece estar en cuarentena." -ForegroundColor Cyan
}

# Opcional: Asegurar que los perfiles del firewall estén activos pero sin la regla restrictiva
# Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True
