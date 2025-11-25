# Run Windows System Preparation Tool
Write-Host "Preparing VM for image capture..." -ForegroundColor Cyan
Write-Host "This will shut down the VM!" -ForegroundColor Yellow

# Run sysprep
C:\Windows\System32\Sysprep\sysprep.exe /generalize /oobe /shutdown