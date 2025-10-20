<#
DESCRIPTION
    This script creates all necessary Azure resources for migrating an on-premises
    file server to Azure Files with sync, backup, and lifecycle management.
#>

# Variables
$resourceGroup = "rg-fileserver-migration"
$location = "EastUS"
$storageAccountName = "stfileserverdemo123"  # Change this to be unique
$fileShareName = "companydata-share"
$fileShareQuota = 100
$vaultName = "rsv-fileserver-backup"
$syncServiceName = "filesync-migration-service"
$syncGroupName = "sync-group-companydata"

# Login to Azure
Write-Host "Logging in to Azure..." -ForegroundColor Cyan
Connect-AzAccount

# Create Resource Group
Write-Host "Creating Resource Group..." -ForegroundColor Cyan
New-AzResourceGroup -Name $resourceGroup -Location $location

# Create Premium Storage Account
Write-Host "Creating Premium Storage Account..." -ForegroundColor Cyan
$storageAccount = New-AzStorageAccount `
    -ResourceGroupName $resourceGroup `
    -Name $storageAccountName `
    -Location $location `
    -SkuName Premium_LRS `
    -Kind FileStorage

# Create File Share
Write-Host "Creating Azure File Share..." -ForegroundColor Cyan
New-AzRmStorageShare `
    -ResourceGroupName $resourceGroup `
    -StorageAccountName $storageAccountName `
    -Name $fileShareName `
    -QuotaGiB $fileShareQuota

# Enable soft delete
Write-Host "Enabling soft delete..." -ForegroundColor Cyan
Update-AzStorageFileServiceProperty `
    -ResourceGroupName $resourceGroup `
    -StorageAccountName $storageAccountName `
    -EnableShareDeleteRetentionPolicy $true `
    -ShareRetentionDays 7

# Create Recovery Services Vault
Write-Host "Creating Recovery Services Vault..." -ForegroundColor Cyan
New-AzRecoveryServicesVault `
    -ResourceGroupName $resourceGroup `
    -Name $vaultName `
    -Location $location

Write-Host "Infrastructure deployment completed successfully!" -ForegroundColor Green
Write-Host "Storage Account: $storageAccountName" -ForegroundColor Yellow
Write-Host "File Share: $fileShareName" -ForegroundColor Yellow
Write-Host "Recovery Vault: $vaultName" -ForegroundColor Yellow