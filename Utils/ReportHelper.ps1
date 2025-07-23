# Professional Test Reporting Functions
$global:TestResults = @()
$global:TestSummary = @{
    Total = 0
    Passed = 0
    Failed = 0
    StartTime = Get-Date
    EndTime = $null
    Duration = $null
}

function Initialize-TestReport {
    param([string]$TestSuiteName = "API Test Suite")
    
    $global:TestResults = @()
    $global:TestSummary = @{
        TestSuite = $TestSuiteName
        Total = 0
        Passed = 0
        Failed = 0
        StartTime = Get-Date
        EndTime = $null
        Duration = $null
        Environment = "Test"
        Tester = $env:USERNAME
    }
    
    Write-Host "=== $TestSuiteName STARTED ===" -ForegroundColor Magenta
    Write-Host "Start Time: $($global:TestSummary.StartTime)" -ForegroundColor Cyan
}

function Add-TestResult {
    param(
        [string]$TestName,
        [string]$TestCategory,
        [bool]$Passed,
        [string]$Message,
        [int]$ResponseTime = 0,
        [string]$ApiEndpoint = "",
        [string]$ErrorDetails = ""
    )
    
    $result = @{
        TestName = $TestName
        Category = $TestCategory
        Status = if($Passed) { "PASS" } else { "FAIL" }
        Message = $Message
        ResponseTime = $ResponseTime
        ApiEndpoint = $ApiEndpoint
        ErrorDetails = $ErrorDetails
        Timestamp = Get-Date
    }
    
    $global:TestResults += $result
    $global:TestSummary.Total++
    
    if ($Passed) {
        $global:TestSummary.Passed++
        Write-Host "[PASS] $TestName - $Message" -ForegroundColor Green
    } else {
        $global:TestSummary.Failed++
        Write-Host "[FAIL] $TestName - $Message" -ForegroundColor Red
    }
}

function Complete-TestReport {
    $global:TestSummary.EndTime = Get-Date
    $global:TestSummary.Duration = $global:TestSummary.EndTime - $global:TestSummary.StartTime
    
    Write-Host "`n=== TEST EXECUTION SUMMARY ===" -ForegroundColor Magenta
    Write-Host "Total Tests: $($global:TestSummary.Total)" -ForegroundColor White
    Write-Host "Passed: $($global:TestSummary.Passed)" -ForegroundColor Green
    Write-Host "Failed: $($global:TestSummary.Failed)" -ForegroundColor Red
    
    if ($global:TestSummary.Total -gt 0) {
        $successRate = (($global:TestSummary.Passed / $global:TestSummary.Total) * 100).ToString('F2')
        Write-Host "Success Rate: $successRate%" -ForegroundColor Yellow
    }
    
    Write-Host "Duration: $($global:TestSummary.Duration.TotalSeconds.ToString('F2')) seconds" -ForegroundColor Cyan
    Write-Host "End Time: $($global:TestSummary.EndTime)" -ForegroundColor Cyan
}

function Export-HTMLReport {
    param([string]$OutputPath = "Reports\TestReport.html")
    
    # Create Reports directory
    if (-not (Test-Path "Reports")) { 
        New-Item -Path "Reports" -ItemType Directory 
    }
    
    $successRate = if($global:TestSummary.Total -gt 0) { 
        (($global:TestSummary.Passed / $global:TestSummary.Total) * 100).ToString('F2') 
    } else { 0 }
    
    # Simple HTML report
    $htmlContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Test Report - $($global:TestSummary.TestSuite)</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background-color: #f5f5f5; }
        .header { background-color: #2c3e50; color: white; padding: 20px; border-radius: 5px; }
        .summary { background-color: white; padding: 20px; margin: 20px 0; border-radius: 5px; }
        .pass { color: #27ae60; font-weight: bold; }
        .fail { color: #e74c3c; font-weight: bold; }
        table { width: 100%; border-collapse: collapse; background-color: white; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #34495e; color: white; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🏆 Test Execution Report</h1>
        <h2>$($global:TestSummary.TestSuite)</h2>
        <p>Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>
    </div>
    
    <div class="summary">
        <h2>📊 Summary</h2>
        <p><strong>Total Tests:</strong> $($global:TestSummary.Total)</p>
        <p><strong>Passed:</strong> <span class="pass">$($global:TestSummary.Passed)</span></p>
        <p><strong>Failed:</strong> <span class="fail">$($global:TestSummary.Failed)</span></p>
        <p><strong>Success Rate:</strong> $successRate%</p>
        <p><strong>Duration:</strong> $($global:TestSummary.Duration.TotalSeconds.ToString('F2')) seconds</p>
    </div>
    
    <div class="summary">
        <h2>📋 Test Results</h2>
        <table>
            <tr><th>Test Name</th><th>Category</th><th>Status</th><th>Message</th><th>Response Time</th></tr>
"@
    
    foreach ($result in $global:TestResults) {
        $statusClass = if($result.Status -eq "PASS") { "pass" } else { "fail" }
        $responseTimeText = if($result.ResponseTime -gt 0) { "$($result.ResponseTime)ms" } else { "N/A" }
        
        $htmlContent += "<tr><td>$($result.TestName)</td><td>$($result.Category)</td><td class='$statusClass'>$($result.Status)</td><td>$($result.Message)</td><td>$responseTimeText</td></tr>"
    }
    
    $htmlContent += @"
        </table>
    </div>
</body>
</html>
"@
    
    $htmlContent | Out-File -FilePath $OutputPath -Encoding UTF8
    Write-Host "📄 HTML Report generated: $OutputPath" -ForegroundColor Green
    
    # Try to open the report
    try {
        Start-Process $OutputPath
        Write-Host "📖 Report opened in browser!" -ForegroundColor Green
    }
    catch {
        Write-Host "Report saved. Open manually: $OutputPath" -ForegroundColor Yellow
    }
}
