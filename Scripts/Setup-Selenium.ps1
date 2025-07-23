# Selenium WebDriver Setup Script
Write-Host "Setting up Selenium WebDriver..." -ForegroundColor Yellow

# Check if Selenium WebDriver module exists
if (-not (Get-Module -ListAvailable -Name Selenium)) {
    Write-Host "Installing Selenium PowerShell module..." -ForegroundColor Cyan
    try {
        Install-Module -Name Selenium -Force -Scope CurrentUser
        Write-Host "[SUCCESS] Selenium module installed" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Failed to install Selenium: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
}

# Download Chrome WebDriver
Write-Host "Setting up Chrome WebDriver..." -ForegroundColor Cyan

# Create WebDriver folder
$webDriverPath = "$PSScriptRoot\..\WebDrivers"
if (-not (Test-Path $webDriverPath)) {
    New-Item -Path $webDriverPath -ItemType Directory
}

Write-Host "[SUCCESS] Selenium setup completed!" -ForegroundColor Green
Write-Host "WebDriver path: $webDriverPath" -ForegroundColor Blue
