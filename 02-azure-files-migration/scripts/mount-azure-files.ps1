<#
DESCRIPTION
    Maps Azure File Share as Z: drive for direct access
#>

# Variables - should be updated for each case
$storageAccountName = "stfileserverdemo123"
$fileShareName = "companydata-share"
$driveLetter = "Z"

Write-Host "Mounting Azure Files..." -ForegroundColor Cyan

# Prompt for storage key
Write-Host "`nGet your storage key from:" -ForegroundColor Yellow
Write-Host "Portal > Storage Account > Access Keys > Show key1" -ForegroundColor Yellow
$storageAccountKey = Read-Host -Prompt "Enter Storage Account Key" -AsSecureString
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($storageAccountKey)
$key = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# Test connectivity
Write-Host "`nTesting connection to $storageAccountName.file.core.windows.net..." -ForegroundColor Cyan
$testResult = Test-NetConnection -ComputerName "$storageAccountName.file.core.windows.net" -Port 445

if ($testResult.TcpTestSucceeded) {
    Write-Host "✅ Connection successful!" -ForegroundColor Green
    
    # Save credentials
    cmd.exe /C "cmdkey /add:`"$storageAccountName.file.core.windows.net`" /user:`"Azure\$storageAccountName`" /pass:`"$key`""
    
    # Mount drive
    $path = "\\$storageAccountName.file.core.windows.net\$fileShareName"
    
    # Remove existing mapping if exists
    if (Test-Path "${driveLetter}:") {
        Remove-PSDrive -Name $driveLetter -Force -ErrorAction SilentlyContinue
    }
    
    New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $path -Persist -Scope Global
    
    Write-Host "`n✅ SUCCESS! Azure Files mounted as ${driveLetter}:" -ForegroundColor Green
    Write-Host "Open File Explorer and browse to ${driveLetter}:\" -ForegroundColor Yellow
    
    # Show files
    Write-Host "`nTop-level folders:" -ForegroundColor Cyan
    Get-ChildItem "${driveLetter}:\" | Select-Object Name, LastWriteTime
    
} else {
    Write-Host "❌ Cannot connect to storage account!" -ForegroundColor Red
    Write-Host "Check:" -ForegroundColor Yellow
    Write-Host "  - Storage account firewall allows your IP" -ForegroundColor Yellow
    Write-Host "  - Port 445 not blocked by ISP" -ForegroundColor Yellow
}