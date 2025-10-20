# Get current ACL
$acl = Get-Acl "F:\CompanyData\HR"

# Add permission for demonstration
$permission = "BUILTIN\Users","ReadAndExecute","ContainerInherit,ObjectInherit","None","Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.AddAccessRule($accessRule)
Set-Acl "F:\CompanyData\HR" $acl

Write-Host "Permissions configured!" -ForegroundColor Green