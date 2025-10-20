<#
DESCRIPTION
    Checks backup policy and last backup status
#>

# Variables
$resourceGroup = "rg-fileserver-migration"
$vaultName = "rsv-fileserver-backup"

Write-Host "Checking backup status..." -ForegroundColor Cyan

# Set vault context
$vault = Get-AzRecoveryServicesVault -ResourceGroupName $resourceGroup -Name $vaultName
Set-AzRecoveryServicesVaultContext -Vault $vault

# Get backup items
$backupItems = Get-AzRecoveryServicesBackupItem `
    -BackupManagementType AzureStorage `
    -WorkloadType AzureFiles

Write-Host "`nBackup Items:" -ForegroundColor Yellow
$backupItems | Select-Object Name, ProtectionStatus, LastBackupTime | Format-Table

# Get recent backup jobs
Write-Host "`nRecent Backup Jobs:" -ForegroundColor Yellow
$jobs = Get-AzRecoveryServicesBackupJob -From (Get-Date).AddDays(-7) -To (Get-Date)
$jobs | Select-Object JobId, Operation, Status, StartTime, EndTime | Format-Table

Write-Host "Backup verification completed!" -ForegroundColor Green