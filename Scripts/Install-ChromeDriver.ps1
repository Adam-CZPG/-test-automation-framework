# Chrome Driver Auto-Installer
function Install-ChromeDriver {
    Write-Host "Installing correct ChromeDriver version..." -ForegroundColor Yellow
    
    try {
        # Get Chrome version
        $chromeExe = "C:\Program Files\Google\Chrome\Application\chrome.exe"
        if (Test-Path $chromeExe) {
            $chromeVersion = (Get-ItemProperty $chromeExe).VersionInfo.ProductVersion
            $majorVersion = $chromeVersion.Split('.')[0]
            Write-Host "Detected Chrome version: $chromeVersion (Major: $majorVersion)" -ForegroundColor Blue
        } else {
            $majorVersion = "120" # Default to recent version
        }
        
        # Create WebDrivers directory
        $webDriverPath = "$PSScriptRoot\WebDrivers"
        if (-not (Test-Path $webDriverPath)) {
            New-Item -Path $webDriverPath -ItemType Directory
        }
        
        # Download appropriate ChromeDriver
        $driverUrl = "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$majorVersion"
        try {
            $latestVersion = Invoke-RestMethod -Uri $driverUrl
            $downloadUrl = "https://chromedriver.storage.googleapis.com/$latestVersion/chromedriver_win32.zip"
            
            Write-Host "Downloading ChromeDriver $latestVersion..." -ForegroundColor Cyan
            $zipPath = "$webDriverPath\chromedriver.zip"
            
            Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath
            
            # Extract
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $webDriverPath)
            
            Remove-Item $zipPath
            Write-Host "ChromeDriver installed successfully!" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Failed to download for version $majorVersion, trying generic..." -ForegroundColor Yellow
            # Fallback: try to download a recent stable version
            $genericUrl = "https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_win32.zip"
            try {
                Invoke-WebRequest -Uri $genericUrl -OutFile "$webDriverPath\chromedriver.zip"
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                [System.IO.Compression.ZipFile]::ExtractToDirectory("$webDriverPath\chromedriver.zip", $webDriverPath)
                Remove-Item "$webDriverPath\chromedriver.zip"
                Write-Host "Generic ChromeDriver installed!" -ForegroundColor Green
                return $true
            }
            catch {
                Write-Host "ChromeDriver download failed: $($_.Exception.Message)" -ForegroundColor Red
                return $false
            }
        }
    }
    catch {
        Write-Host "ChromeDriver installation failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Run the installer
Install-ChromeDriver
