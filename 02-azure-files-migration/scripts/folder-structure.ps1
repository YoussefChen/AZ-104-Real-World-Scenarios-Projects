# Create folder structure
New-Item -Path "F:\CompanyData" -ItemType Directory
New-Item -Path "F:\CompanyData\HR" -ItemType Directory
New-Item -Path "F:\CompanyData\Finance" -ItemType Directory
New-Item -Path "F:\CompanyData\IT" -ItemType Directory
New-Item -Path "F:\CompanyData\Sales" -ItemType Directory

# Create sample files
1..50 | ForEach-Object {
    "Sample HR Document $_" | Out-File "F:\CompanyData\HR\Document_$_.txt"
}

1..50 | ForEach-Object {
    "Sample Finance Report $_" | Out-File "F:\CompanyData\Finance\Report_$_.txt"
}

1..50 | ForEach-Object {
    "Sample IT Ticket $_" | Out-File "F:\CompanyData\IT\Ticket_$_.txt"
}

# Create some larger files (for tiering demo)
$size = 10MB
$bytes = New-Object byte[] $size
1..5 | ForEach-Object {
    [System.IO.File]::WriteAllBytes("F:\CompanyData\Sales\LargeFile_$_.dat", $bytes)
}

Write-Host "File structure created successfully!" -ForegroundColor Green