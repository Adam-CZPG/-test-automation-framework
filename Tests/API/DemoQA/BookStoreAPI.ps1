# Import API Helper
. "Utils\APIHelper.ps1"

# Test: Get All Books from BookStore API
function Test-GetAllBooks {
    Write-Host "
=== Testing BookStore API - Get All Books ===" -ForegroundColor Yellow
    
    # Get configuration
    $config = Get-Config
    $endpoints = Get-Endpoints
    
    # Build URL
    $url = $config.baseUrl + $endpoints.bookstore.getAllBooks
    Write-Host "Testing URL: $url" -ForegroundColor Cyan
    
    # Make API call
    $result = Invoke-APIRequest -Method "GET" -Uri $url
    
    # Test 1: Verify response success
    if ($result.Success) {
        Write-TestResult -TestName "API Response" -Passed $true -Message "API call successful"
    } else {
        Write-TestResult -TestName "API Response" -Passed $false -Message "API call failed: $($result.Error)"
        return
    }
    
    # Test 2: Verify books array exists
    if ($result.Data.books) {
        Write-TestResult -TestName "Books Array" -Passed $true -Message "Books array found in response"
        Write-Host "Total books found: $($result.Data.books.Count)" -ForegroundColor Blue
    } else {
        Write-TestResult -TestName "Books Array" -Passed $false -Message "Books array not found in response"
    }
    
    # Test 3: Verify first book structure
    if ($result.Data.books.Count -gt 0) {
        $firstBook = $result.Data.books[0]
        $requiredFields = @("isbn", "title", "subTitle", "author", "publish_date", "publisher", "pages", "description", "website")
        
        $missingFields = @()
        foreach ($field in $requiredFields) {
            if (-not $firstBook.$field) {
                $missingFields += $field
            }
        }
        
        if ($missingFields.Count -eq 0) {
            Write-TestResult -TestName "Book Structure" -Passed $true -Message "All required fields present"
            Write-Host "Sample Book: $($firstBook.title)" -ForegroundColor Blue
        } else {
            Write-TestResult -TestName "Book Structure" -Passed $false -Message "Missing fields: $($missingFields -join ', ')"
        }
    }
    
    # Return result for reporting
    return $result
}

# Test: Get Specific Book
function Test-GetSpecificBook {
    Write-Host "
=== Testing BookStore API - Get Specific Book ===" -ForegroundColor Yellow
    
    $config = Get-Config
    $endpoints = Get-Endpoints
    $testData = Get-Content -Path "Config\testdata.json" | ConvertFrom-Json
    
    # Build URL with ISBN
    $isbn = $testData.books.testBook.isbn
    $url = $config.baseUrl + $endpoints.bookstore.getBook + "?ISBN=$isbn"
    Write-Host "Testing URL: $url" -ForegroundColor Cyan
    
    # Make API call
    $result = Invoke-APIRequest -Method "GET" -Uri $url
    
    # Verify response
    if ($result.Success) {
        Write-TestResult -TestName "Get Specific Book" -Passed $true -Message "Book retrieved successfully"
        
        # Verify correct book returned
        if ($result.Data.isbn -eq $isbn) {
            Write-TestResult -TestName "Correct Book" -Passed $true -Message "Correct book returned: $($result.Data.title)"
        } else {
            Write-TestResult -TestName "Correct Book" -Passed $false -Message "Wrong book returned"
        }
    } else {
        Write-TestResult -TestName "Get Specific Book" -Passed $false -Message "API call failed: $($result.Error)"
    }
    
    return $result
}

# Main execution
Write-Host "Starting BookStore API Tests..." -ForegroundColor Green
Test-GetAllBooks
Test-GetSpecificBook
Write-Host "
API Tests Completed!" -ForegroundColor Green
