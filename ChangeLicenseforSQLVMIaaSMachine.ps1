# Import the Azure module
Import-Module Az

# Connect to your Azure account
Connect-AzAccount

# Get all subscriptions the user has access to
$subscriptions = Get-AzSubscription

# Define the new license type (e.g., "AHUB" for Azure Hybrid Benefit or "PAYG" for Pay-As-You-Go)
$newLicenseType = "PAYG"

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    Set-AzContext -SubscriptionId $subscription.Id

    # Get all SQL VMs in the current subscription
    $sqlVMs = Get-AzSqlVM

    # Loop through each SQL VM and update the license type
    foreach ($vm in $sqlVMs) {
        $vmName = $vm.Name
        $resourceGroup = $vm.ResourceGroupName

        # Update the VM with the new license type
        Update-AzSqlVM -ResourceGroupName $resourceGroup -Name $vmName -LicenseType $newLicenseType

        Write-Output "Updated license type for VM: $vmName in Resource Group: $resourceGroup to $newLicenseType"
    }
}

Write-Output "License type update completed for all SQL VMs in all subscriptions."
