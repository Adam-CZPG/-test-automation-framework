# Import helpers
. "Utils\UIHelper.ps1"
. "Utils\APIHelper.ps1"

# Test: DemoQA Elements Page
function Test-DemoQAElements {
    Write-Host "
=== Testing DemoQA Elements Page ===" -ForegroundColor Yellow
    
    $driver = $null
    try {
        # Start browser
        $driver = Start-Browser -BrowserType "Chrome"
        
        if ($driver) {
            # Navigate to DemoQA Elements
            $url = "https://demoqa.com/elements"
            Navigate-ToUrl -Driver $driver -Url $url
            
            # Wait for page load
            Start-Sleep -Seconds 3
            
            # Find and click Text Box
            $textBoxElement = Find-Element -Driver $driver -By "XPath" -Value "//span[text()='Text Box']"
            if ($textBoxElement) {
                $textBoxElement.Click()
                Write-TestResult -TestName "Text Box Click" -Passed $true -Message "Successfully clicked Text Box"
                
                Start-Sleep -Seconds 2
                
                # Fill in the form
                $fullNameField = Find-Element -Driver $driver -By "Id" -Value "userName"
                if ($fullNameField) {
                    $fullNameField.SendKeys("Test User")
                    Write-TestResult -TestName "Full Name Input" -Passed $true -Message "Successfully entered full name"
                }
                
                $emailField = Find-Element -Driver $driver -By "Id" -Value "userEmail"
                if ($emailField) {
                    $emailField.SendKeys("test@example.com")
                    Write-TestResult -TestName "Email Input" -Passed $true -Message "Successfully entered email"
                }
                
                # Submit the form
                $submitButton = Find-Element -Driver $driver -By "Id" -Value "submit"
                if ($submitButton) {
                    $submitButton.Click()
                    Write-TestResult -TestName "Form Submit" -Passed $true -Message "Successfully submitted form"
                    
                    Start-Sleep -Seconds 2
                    
                    # Verify output
                    $output = Find-Element -Driver $driver -By "Id" -Value "output"
                    if ($output) {
                        Write-TestResult -TestName "Form Output" -Passed $true -Message "Form output displayed successfully"
                        Write-Host "Form submitted successfully!" -ForegroundColor Green
                    }
                }
            }
            
            # Keep browser open for 5 seconds to see result
            Write-Host "Keeping browser open for 5 seconds..." -ForegroundColor Blue
            Start-Sleep -Seconds 5
        }
        
    }
    catch {
        Write-TestResult -TestName "UI Test Error" -Passed $false -Message "Error: $($_.Exception.Message)"
    }
    finally {
        if ($driver) { Close-Browser -Driver $driver }
    }
}

# Main execution
Write-Host "Starting DemoQA UI Tests..." -ForegroundColor Green
Test-DemoQAElements
Write-Host "
DemoQA UI Tests Completed!" -ForegroundColor Green
