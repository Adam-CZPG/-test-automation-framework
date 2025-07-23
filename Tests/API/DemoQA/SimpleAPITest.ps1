Write-Host "=== Simple API Test ===" -ForegroundColor Yellow

try {
    $url = "https://demoqa.com/BookStore/v1/Books"
    Write-Host "Testing URL: $url" -ForegroundColor Cyan
    
    $response = Invoke-RestMethod -Uri $url -Method GET
    
    if ($response.books) {
        Write-Host "[PASS] API Response - Books found: $($response.books.Count)" -ForegroundColor Green
        Write-Host "Sample book: $($response.books[0].title)" -ForegroundColor Blue
    } else {
        Write-Host "[FAIL] No books found in response" -ForegroundColor Red
    }
}
catch {
    Write-Host "[FAIL] API call failed: $($_.Exception.Message)" -ForegroundColor Red
}
