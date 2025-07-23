# Simple UI Helper Functions for Selenium WebDriver
function Start-Browser {
    param(
        [string]$BrowserType = "Edge",
        [bool]$Headless = $false
    )
    
    try {
        Import-Module Selenium
        
        # Simple Edge driver without complex options
        $driver = New-Object OpenQA.Selenium.Edge.EdgeDriver
        Write-Host "Using Microsoft Edge browser (simple mode)" -ForegroundColor Blue
        
        $driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
        $driver.Manage().Window.Maximize()
        
        return $driver
    }
    catch {
        Write-Host "[ERROR] Failed to start browser: $($_.Exception.Message)" -ForegroundColor Red
        
        # Fallback: Try Chrome with simple mode
        try {
            Write-Host "Trying Chrome as fallback..." -ForegroundColor Yellow
            $driver = New-Object OpenQA.Selenium.Chrome.ChromeDriver
            Write-Host "Using Chrome browser (simple mode)" -ForegroundColor Blue
            
            $driver.Manage().Timeouts().ImplicitWait = [TimeSpan]::FromSeconds(10)
            $driver.Manage().Window.Maximize()
            
            return $driver
        }
        catch {
            Write-Host "[ERROR] Both Edge and Chrome failed: $($_.Exception.Message)" -ForegroundColor Red
            return $null
        }
    }
}

function Navigate-ToUrl {
    param(
        [object]$Driver,
        [string]$Url
    )
    
    try {
        $Driver.Navigate().GoToUrl($Url)
        Write-Host "Navigated to: $Url" -ForegroundColor Cyan
        return $true
    }
    catch {
        Write-Host "[ERROR] Failed to navigate to $Url : $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Find-Element {
    param(
        [object]$Driver,
        [string]$By,
        [string]$Value
    )
    
    try {
        switch ($By) {
            "Id" { return $Driver.FindElement([OpenQA.Selenium.By]::Id($Value)) }
            "XPath" { return $Driver.FindElement([OpenQA.Selenium.By]::XPath($Value)) }
            "ClassName" { return $Driver.FindElement([OpenQA.Selenium.By]::ClassName($Value)) }
            "Name" { return $Driver.FindElement([OpenQA.Selenium.By]::Name($Value)) }
            default { throw "Unsupported locator type: $By" }
        }
    }
    catch {
        Write-Host "[ERROR] Element not found ($By = $Value): $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Close-Browser {
    param([object]$Driver)
    
    if ($Driver) {
        try {
            $Driver.Quit()
            $Driver.Dispose()
            Write-Host "Browser closed successfully" -ForegroundColor Green
        }
        catch {
            Write-Host "Browser cleanup completed" -ForegroundColor Green
        }
    }
}
