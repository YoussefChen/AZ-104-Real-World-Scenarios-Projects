<#
DESCRIPTION
    Shows which files are tiered to the cloud and volume free space
#>

$localPath = "F:\CompanyData"

Write-Host "Checking Cloud Tiering Status..." -ForegroundColor Cyan

# Get volume info
$volume = Get-Volume | Where-Object {$_.DriveLetter -eq 'F'}
$freeSpacePercent = [math]::Round(($volume.SizeRemaining / $volume.Size) * 100, 2)

Write-Host "`nVolume Information:" -ForegroundColor Yellow
Write-Host "Total Size: $([math]::Round($volume.Size / 1GB, 2)) GB"
Write-Host "Free Space: $([math]::Round($volume.SizeRemaining / 1GB, 2)) GB ($freeSpacePercent%)"

# Check for tiered files (files with offline attribute)
Write-Host "`nScanning for tiered files..." -ForegroundColor Cyan
$tieredFiles = Get-ChildItem -Path $localPath -Recurse -File | 
    Where-Object {$_.Attributes -match 'Offline'}

if ($tieredFiles) {
    Write-Host "Found $($tieredFiles.Count) tiered files:" -ForegroundColor Green
    $tieredFiles | Select-Object Name, Length, LastAccessTime | Format-Table
} else {
    Write-Host "No files currently tiered. Wait 30 days or manually tier files." -ForegroundColor Yellow
}