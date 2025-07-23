# Import Helpers
. "Utils\APIHelper.ps1"
. "Utils\ReportHelper.ps1"

# Enhanced API Tests with Professional Reporting
Initialize-TestReport -TestSuiteName "DemoQA BookStore API Test Suite"

# Test: Get All Books
function Test-GetAllBooksEnhanced {
    $config = Get-Config
    $endpoints = Get-Endpoints
    $url = $config.baseUrl + $endpoints.bookstore.getAllBooks
    
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Invoke-APIRequest -Method "GET" -Uri $url
    $stopwatch.Stop()
    
    $responseTime = $stopwatch.ElapsedMilliseconds
    
    if ($result.Success) {
        Add-TestResult -TestName "Get All Books API" -TestCategory "API" -Passed $true -Message "API call successful" -ResponseTime $responseTime -ApiEndpoint $url
        
        if ($result.Data.books) {
            Add-TestResult -TestName "Books Array Validation" -TestCategory "Data Validation" -Passed $true -Message "Found $($result.Data.books.Count) books" -ResponseTime $responseTime -ApiEndpoint $url
        } else {
            Add-TestResult -TestName "Books Array Validation" -TestCategory "Data Validation" -Passed $false -Message "No books array found" -ResponseTime $responseTime -ApiEndpoint $url
        }
    } else {
        Add-TestResult -TestName "Get All Books API" -TestCategory "API" -Passed $false -Message $result.Error -ResponseTime $responseTime -ApiEndpoint $url -ErrorDetails $result.Error
    }
}

# Execute Tests
Write-Host "Starting Enhanced API Tests with Professional Reporting..." -ForegroundColor Green
Test-GetAllBooksEnhanced

# Complete and Generate Report
Complete-TestReport
Export-HTMLReport

Write-Host "`n🏆 Professional Test Report Generated!" -ForegroundColor Green
