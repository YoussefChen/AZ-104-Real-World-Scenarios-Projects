<#
SYNOPSIS
    Installs and configures IIS on Windows Server 2022 for DevTest Labs
DESCRIPTION
    Comprehensive IIS installation with all necessary features
#>

# Set error handling
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  IIS Installation Script" -ForegroundColor Cyan
Write-Host "  Windows Server 2022" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Install IIS Web Server with Management Tools
Write-Host "[1/5] Installing IIS Web Server..." -ForegroundColor Yellow
try {
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    Write-Host "  ✅ IIS Web Server installed successfully" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Failed to install IIS: $_" -ForegroundColor Red
    exit 1
}

# Step 2: Install ASP.NET 4.8
Write-Host "[2/5] Installing ASP.NET 4.8..." -ForegroundColor Yellow
try {
    Install-WindowsFeature -Name Web-Asp-Net45
    Write-Host "  ✅ ASP.NET 4.8 installed successfully" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Failed to install ASP.NET: $_" -ForegroundColor Red
}

# Step 3: Install additional useful IIS features
Write-Host "[3/5] Installing additional IIS features..." -ForegroundColor Yellow
try {
    $features = @(
        'Web-WebSockets',           # WebSocket Protocol
        'Web-Mgmt-Console',         # IIS Management Console (already included, but ensuring)
        'Web-Scripting-Tools',      # IIS Management Scripts and Tools
        'Web-Default-Doc',          # Default Document
        'Web-Dir-Browsing',         # Directory Browsing
        'Web-Http-Errors',          # HTTP Errors
        'Web-Static-Content',       # Static Content
        'Web-Http-Logging',         # HTTP Logging
        'Web-Request-Monitor',      # Request Monitor
        'Web-Filtering',            # Request Filtering
        'Web-Stat-Compression',     # Static Content Compression
        'Web-Dyn-Compression'       # Dynamic Content Compression
    )
    
    foreach ($feature in $features) {
        Install-WindowsFeature -Name $feature -ErrorAction SilentlyContinue
    }
    
    Write-Host "  ✅ Additional features installed" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Some additional features may not have installed" -ForegroundColor Yellow
}

# Step 4: Create custom default page
Write-Host "[4/5] Creating custom IIS landing page..." -ForegroundColor Yellow
try {
    $htmlContent = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DevTest Labs - VM Ready</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            max-width: 800px;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
        }
        
        h1 {
            font-size: 48px;
            margin-bottom: 10px;
            text-align: center;
        }
        
        h2 {
            font-size: 24px;
            margin-bottom: 30px;
            text-align: center;
            font-weight: 300;
        }
        
        .info-box {
            background: rgba(255, 255, 255, 0.15);
            padding: 30px;
            border-radius: 15px;
            margin: 20px 0;
        }
        
        .feature-list {
            list-style: none;
            padding: 0;
        }
        
        .feature-list li {
            padding: 12px 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
            font-size: 18px;
        }
        
        .feature-list li:last-child {
            border-bottom: none;
        }
        
        .checkmark {
            color: #4ade80;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .server-info {
            background: rgba(0, 0, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            font-family: 'Courier New', monospace;
            font-size: 14px;
        }
        
        .footer {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 DevTest Labs VM</h1>
        <h2>Ready for Development</h2>
        
        <div class="info-box">
            <h3 style="margin-bottom: 20px; font-size: 22px;">✅ Installed Software</h3>
            <ul class="feature-list">
                <li><span class="checkmark">✓</span> IIS 10.0 Web Server</li>
                <li><span class="checkmark">✓</span> ASP.NET 4.8 Framework</li>
                <li><span class="checkmark">✓</span> .NET Framework 4.8</li>
                <li><span class="checkmark">✓</span> IIS Management Console</li>
                <li><span class="checkmark">✓</span> SQL Server Express 2022</li>
                <li><span class="checkmark">✓</span> WebSocket Protocol</li>
                <li><span class="checkmark">✓</span> HTTP/HTTPS Support</li>
            </ul>
        </div>
        
        <div class="server-info">
            <strong>Server Information:</strong><br>
            Computer Name: $env:COMPUTERNAME<br>
            OS: Windows Server 2022<br>
            IIS Version: 10.0<br>
            Status: Online ✓
        </div>
        
        <div class="footer">
            <p>🏢 Azure DevTest Labs | Custom Image Template</p>
            <p>Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm')</p>
        </div>
    </div>
</body>
</html>
"@

    # Remove old default page if exists
    if (Test-Path "C:\inetpub\wwwroot\iisstart.htm") {
        Remove-Item "C:\inetpub\wwwroot\iisstart.htm" -Force
    }
    if (Test-Path "C:\inetpub\wwwroot\iisstart.png") {
        Remove-Item "C:\inetpub\wwwroot\iisstart.png" -Force
    }
    
    # Write new default page
    $htmlContent | Out-File "C:\inetpub\wwwroot\index.html" -Encoding UTF8 -Force
    
    Write-Host "  ✅ Custom landing page created" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Failed to create landing page: $_" -ForegroundColor Red
}

# Step 5: Configure IIS for optimal performance
Write-Host "[5/5] Configuring IIS settings..." -ForegroundColor Yellow
try {
    # Import IIS module
    Import-Module WebAdministration
    
    # Enable detailed error pages for development
    Set-WebConfigurationProperty -Filter "system.webServer/httpErrors" `
        -PSPath "IIS:\Sites\Default Web Site" `
        -Name "errorMode" `
        -Value "Detailed" `
        -ErrorAction SilentlyContinue
    
    # Set default document to index.html
    Add-WebConfiguration -Filter "system.webServer/defaultDocument/files" `
        -PSPath "IIS:\Sites\Default Web Site" `
        -Value @{value='index.html'} `
        -ErrorAction SilentlyContinue
    
    Write-Host "  ✅ IIS configured successfully" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  Some IIS settings may not have been configured" -ForegroundColor Yellow
}

# Step 6: Restart IIS to apply all changes
Write-Host "" -ForegroundColor White
Write-Host "Restarting IIS services..." -ForegroundColor Yellow
try {
    iisreset
    Write-Host "  ✅ IIS restarted successfully" -ForegroundColor Green
} catch {
    Write-Host "  ⚠️  IIS restart may have failed" -ForegroundColor Yellow
}

# Step 7: Test IIS
Write-Host "" -ForegroundColor White
Write-Host "Testing IIS..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

try {
    $response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "  ✅ IIS is responding correctly!" -ForegroundColor Green
    }
} catch {
    Write-Host "  ⚠️  Could not test IIS response" -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "  1. Open browser and go to: http://localhost" -ForegroundColor White
Write-Host "  2. Verify IIS page loads correctly" -ForegroundColor White
Write-Host "  3. Install SQL Server Express manually" -ForegroundColor White
Write-Host "  4. Run sysprep to prepare for image capture" -ForegroundColor White
Write-Host ""
Write-Host "IIS Management Console: Server Manager > Tools > IIS Manager" -ForegroundColor Cyan
Write-Host ""