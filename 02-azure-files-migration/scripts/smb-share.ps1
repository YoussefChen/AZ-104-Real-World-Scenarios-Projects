# Create SMB share
New-SmbShare -Name "CompanyData" -Path "F:\CompanyData" -FullAccess "Everyone"

# Verify share
Get-SmbShare -Name "CompanyData"