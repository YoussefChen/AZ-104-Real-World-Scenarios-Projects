<#
SYNOPSIS
    Deletes VMs in DevTest Labs that are older than 7 days
DESCRIPTION
    This runbook runs daily and removes VMs that have exceeded their lifetime.
    Helps control costs by ensuring test VMs don't run indefinitely.
NOTES
    Requires: Az.DevTestLabs2 module
    Permissions: Contributor on the resource group
#>

param(
    [Parameter(Mandatory=$false)]
    [int]$DaysOld = 7,
    
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroupName = "rg-devtest-automation",
    
    [Parameter(Mandatory=$false)]
    [string]$LabName = "dtl-company-devtest"
)

# Connect using Managed Identity
Write-Output "Connecting to Azure using Managed Identity..."
try {
    Connect-AzAccount -Identity
    Write-Output "Successfully connected to Azure"
} catch {
    Write-Error "Failed to connect to Azure: $_"
    throw
}

# Calculate cutoff date
$cutoffDate = (Get-Date).AddDays(-$DaysOld)
Write-Output "Cutoff date: $cutoffDate"
Write-Output "Will delete VMs created before this date"

# Get all VMs in the lab
Write-Output "Fetching VMs from lab: $LabName"
try {
    $vms = Get-AzResource -ResourceGroupName $ResourceGroupName `
        -ResourceType "Microsoft.DevTestLab/labs/virtualMachines" `
        -ExpandProperties
    
    Write-Output "Found $($vms.Count) VMs in the lab"
} catch {
    Write-Error "Failed to get VMs: $_"
    throw
}

# Track deletions
$deletedCount = 0
$errors = 0

# Check each VM
foreach ($vm in $vms) {
    $vmName = $vm.Name
    $createdDate = $vm.Properties.createdDate
    
    if ($null -eq $createdDate) {
        Write-Warning "VM $vmName has no creation date, skipping"
        continue
    }
    
    $vmAge = (Get-Date) - [DateTime]$createdDate
    Write-Output "VM: $vmName | Created: $createdDate | Age: $($vmAge.Days) days"
    
    # Check if VM is too old
    if ([DateTime]$createdDate -lt $cutoffDate) {
        Write-Output "  ⚠️  VM is older than $DaysOld days, deleting..."
        
        try {
            # Delete the VM
            Remove-AzResource -ResourceId $vm.ResourceId -Force
            Write-Output "  ✅ Successfully deleted $vmName"
            $deletedCount++
        } catch {
            Write-Error "  ❌ Failed to delete $vmName : $_"
            $errors++
        }
    } else {
        Write-Output "  ✓ VM is still within retention period"
    }
}

# Summary
Write-Output "`n========== SUMMARY =========="
Write-Output "Total VMs checked: $($vms.Count)"
Write-Output "VMs deleted: $deletedCount"
Write-Output "Errors: $errors"
Write-Output "=============================="

if ($deletedCount -gt 0) {
    Write-Output "✅ Cleanup completed successfully"
} else {
    Write-Output "ℹ️  No VMs needed deletion"
}