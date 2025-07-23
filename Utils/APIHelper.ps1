# API Helper Functions
function Get-Config {
    $config = Get-Content -Path "Config\config.json" | ConvertFrom-Json
    return $config
}

function Get-Endpoints {
    $endpoints = Get-Content -Path "Config\endpoints.json" | ConvertFrom-Json
    return $endpoints
}

function Invoke-APIRequest {
    param(
        [string]$Method,
        [string]$Uri,
        [hashtable]$Headers = @{},
        [object]$Body = $null
    )
    
    try {
        $response = Invoke-RestMethod -Uri $Uri -Method $Method -Headers $Headers -Body $Body -ContentType "application/json"
        return @{
            Success = $true
            Data = $response
            StatusCode = 200
        }
    }
    catch {
        return @{
            Success = $false
            Error = $_.Exception.Message
            StatusCode = $_.Exception.Response.StatusCode.Value__
        }
    }
}

function Write-TestResult {
    param(
        [string]$TestName,
        [bool]$Passed,
        [string]$Message
    )
    
    $status = if($Passed) { "PASS" } else { "FAIL" }
    $color = if($Passed) { "Green" } else { "Red" }
    
    Write-Host "[$status] $TestName - $Message" -ForegroundColor $color
}
