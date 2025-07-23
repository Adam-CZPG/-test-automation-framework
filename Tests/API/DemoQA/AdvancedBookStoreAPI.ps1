# Import API Helper
. "Utils\APIHelper.ps1"

# Test: Invalid ISBN Handling
function Test-InvalidISBN {
    Write-Host "`n=== Testing Invalid ISBN ===" -ForegroundColor Yellow
    
    $config = Get-Config
    $endpoints = Get-Endpoints
    
    # Test with invalid ISBN
    $invalidISBN = "invalid123"
    $url = $config.baseUrl + $endpoints.bookstore.getBook + "?ISBN=$invalidISBN"
    Write-Host "Testing URL: $url" -ForegroundColor Cyan
    
    $result = Invoke-APIRequest -Method "GET" -Uri $url
    
    # Should return empty response for invalid ISBN
    if ($result.Success) {
        if (-not $result.Data.isbn) {
            Write-TestResult -TestName "Invalid ISBN Response" -Passed $true -Message "Correctly returned empty response for invalid ISBN"
        } else {
            Write-TestResult -TestName "Invalid ISBN Response" -Passed $false -Message "Unexpected: Found book with invalid ISBN"
        }
    } else {
        Write-TestResult -TestName "Invalid ISBN Response" -Passed $true -Message "API correctly rejected invalid ISBN"
    }
    
    return $result
}

# Test: Response Time Performance
function Test-ResponseTime {
    Write-Host "`n=== Testing Response Time ===" -ForegroundColor Yellow
    
    $config = Get-Config
    $endpoints = Get-Endpoints
    $url = $config.baseUrl + $endpoints.bookstore.getAllBooks
    
    # Measure response time
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    $result = Invoke-APIRequest -Method "GET" -Uri $url
    $stopwatch.Stop()
    
    $responseTime = $stopwatch.ElapsedMilliseconds
    Write-Host "Response Time: $responseTime ms" -ForegroundColor Blue
    
    # Test if response time is acceptable (under 5 seconds)
    if ($responseTime -lt 5000) {
        Write-TestResult -TestName "Response Time" -Passed $true -Message "Response time acceptable: $responseTime ms"
    } else {
        Write-TestResult -TestName "Response Time" -Passed $false -Message "Response time too slow: $responseTime ms"
    }
    
    return $result
}

# Main execution
Write-Host "Starting Advanced BookStore API Tests..." -ForegroundColor Green
Test-InvalidISBN
Test-ResponseTime
Write-Host "`nAdvanced API Tests Completed!" -ForegroundColor Green
