# Instalar paquetes necesarios

Install-Module Az.ConnectedMachine
Install-Module Az.Accounts
Import-Module Az.ConnectedMachine

# Obtener todas las suscripciones a las que tienes acceso
$subscriptions = Get-AzSubscription

# Inicializar la variable acumuladora para el total de cores
$totalCoreCount = 0

# Crear un diccionario para almacenar el total de cores por suscripción
$coreCountBySubscription = @{}

# Iterar sobre cada suscripción
foreach ($subscription in $subscriptions) 
{
    # Cambiar a la suscripción actual
    Set-AzContext -SubscriptionId $subscription.Id
    
    # Inicializar el contador de cores para la suscripción actual
    $subscriptionCoreCount = 0
    
    $machines = Get-AzConnectedMachine | Where-Object { $_.Status -eq 'Connected' }
    #$machines = Get-AzConnectedMachine | Where-Object { $_.Status -eq 'Connected' -and $_.OSType -eq 'Windows' } # Para filtrar solo las máquinas Windows
    
    foreach ($machine in $machines)
    {
        $exp = Get-AzConnectedMachine -MachineName $machine.name -ResourceGroupName $machine.ResourceGroupName
        $detectedProperties = $exp.DetectedProperty | ConvertFrom-Json
        $coreCount = [int]$detectedProperties.coreCount
        
        # Sumar los núcleos al contador de la suscripción actual
        $subscriptionCoreCount += $coreCount
    }
    
    # Almacenar el total de cores de la suscripción en el diccionario
    $coreCountBySubscription[$subscription.Name] = $subscriptionCoreCount
    
    # Sumar al total general
    $totalCoreCount += $subscriptionCoreCount
}

# Mostrar el total de cores por suscripción
foreach ($subscription in $coreCountBySubscription.Keys) {
    Write-Output "Total Core Count for subscription '$subscription': $($coreCountBySubscription[$subscription])"
}

# Mostrar el total de cores en todas las suscripciones
Write-Output "Total Core Count across all connected machines: $totalCoreCount"
