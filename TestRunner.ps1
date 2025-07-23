# Main Test Runner
param(
    [string]$TestType = "API", # API, UI, or ALL
    [string]$TestSuite = "DemoQA" # Specific test suite
)

Write-Host "=== Test Automation Framework ===" -ForegroundColor Magenta
Write-Host "Test Type: $TestType" -ForegroundColor Yellow
Write-Host "Test Suite: $TestSuite" -ForegroundColor Yellow
Write-Host "Started at: $(Get-Date)" -ForegroundColor Yellow

# Set location to project root
Set-Location $PSScriptRoot

# Run API Tests
if ($TestType -eq "API" -or $TestType -eq "ALL") {
    Write-Host "
### Running API Tests ###" -ForegroundColor Magenta
    & "Tests\\API\\DemoQA\\BookStoreAPI.ps1"
    & "Tests\\API\\DemoQA\\AdvancedBookStoreAPI.ps1"
}

# Run UI Tests (placeholder for now)
if ($TestType -eq "UI" -or $TestType -eq "ALL") {
    Write-Host "
### Running UI Tests ###" -ForegroundColor Magenta
    Write-Host "UI Tests coming next..." -ForegroundColor Yellow
}

Write-Host "
=== Test Execution Completed ===" -ForegroundColor Magenta
Write-Host "Finished at: $(Get-Date)" -ForegroundColor Yellow

