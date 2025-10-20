<#
DESCRIPTION
    Creates test files and verifies sync to Azure Files
#>

# Variables
$localPath = "F:\CompanyData"
$testFolder = "$localPath\SyncTest"

Write-Host "Creating test files..." -ForegroundColor Cyan

# Create test folder
New-Item -Path $testFolder -ItemType Directory -Force

# Create test files with timestamps
1..10 | ForEach-Object {
    $content = "Test file created at $(Get-Date) - File number $_"
    $content | Out-File "$testFolder\TestFile_$_.txt"
}

Write-Host "Test files created. Check Azure Portal for sync status." -ForegroundColor Green
Write-Host "Path: $testFolder" -ForegroundColor Yellow

# Show sync status
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
Get-StorageSyncServer