# Import UI Helper
. "Utils\UIHelper.ps1"
. "Utils\APIHelper.ps1"

# Test: Simple Browser Launch
function Test-BrowserLaunch {
    Write-Host "`n=== Testing Browser Launch ===" -ForegroundColor Yellow
    
    try {
        # Start Edge browser
        Write-Host "Starting Edge browser..." -ForegroundColor Cyan
        $driver = Start-Browser -BrowserType "Edge" -Headless $false
        
        if ($driver) {
            Write-TestResult -TestName "Browser Launch" -Passed $true -Message "Edge browser started successfully"
            
            # Navigate to DemoQA
            $url = "https://demoqa.com"
            $navigated = Navigate-ToUrl -Driver $driver -Url $url
            
            if ($navigated) {
                Write-TestResult -TestName "Navigation" -Passed $true -Message "Successfully navigated to DemoQA"
                
                # Wait a moment and get page title
                Start-Sleep -Seconds 3
                $pageTitle = $driver.Title
                Write-Host "Page Title: $pageTitle" -ForegroundColor Blue
                
                if ($pageTitle -like "*ToolsQA*" -or $pageTitle -like "*DemoQA*") {
                    Write-TestResult -TestName "Page Load" -Passed $true -Message "Correct page loaded: $pageTitle"
                } else {
                    Write-TestResult -TestName "Page Load" -Passed $false -Message "Unexpected page title: $pageTitle"
                }
                
                # Keep browser open for 5 seconds so you can see it working
                Write-Host "Keeping browser open for 5 seconds..." -ForegroundColor Blue
                Start-Sleep -Seconds 5
            }
            
            # Close browser
            Write-Host "Closing browser..." -ForegroundColor Cyan
            Close-Browser -Driver $driver
            
        } else {
            Write-TestResult -TestName "Browser Launch" -Passed $false -Message "Failed to start browser"
        }
        
    }
    catch {
        Write-TestResult -TestName "Browser Test" -Passed $false -Message "Error: $($_.Exception.Message)"
        if ($driver) { Close-Browser -Driver $driver }
    }
}

# Main execution
Write-Host "Starting UI Browser Tests..." -ForegroundColor Green
Test-BrowserLaunch
Write-Host "`nUI Browser Tests Completed!" -ForegroundColor Green
