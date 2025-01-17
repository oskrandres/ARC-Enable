# Connect to your Azure account
Connect-AzAccount

# Get all subscriptions
$subscriptions = Get-AzSubscription

foreach ($subscription in $subscriptions) {
    # Set the current subscription
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all resource groups in the current subscription
    $resourceGroups = Get-AzResourceGroup

    foreach ($resourceGroup in $resourceGroups) {
        # Get all VMs in the current resource group
        $vms = Get-AzVM -ResourceGroupName $resourceGroup.ResourceGroupName

        foreach ($vm in $vms) {
            # Check if the VM has SQL Server installed (you might need to adjust this check based on your environment)
            if ($vm.StorageProfile.ImageReference.Offer -like "*sql*") {
                # Register the VM as a SQL VM
                Register-AzSqlVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $vm.Name
                Write-Output "Registered VM $($vm.Name) in resource group $($resourceGroup.ResourceGroupName) as SQL VM."
            }
        }
    }
}
