# SimpleHealthCheck.ps1
# A simple script that checks the health of a Windows computer
# and saves the results to a text file.

$reportFile = "health_report.txt"
Start-Transcript -Path $reportFile -Force | Out-Null

# 1. Basic computer info
Write-Host "=== Computer Info ==="
$os = Get-CimInstance Win32_OperatingSystem
Write-Host "Computer name : $env:COMPUTERNAME"
Write-Host "Operating system : $($os.Caption)"
Write-Host "Last restart : $($os.LastBootUpTime)"

# 2. Memory (RAM) usage
Write-Host ""
Write-Host "=== Memory ==="
$memUsedPercent = [math]::Round((($os.TotalVisibleMemorySize - $os.FreePhysicalMemory) / $os.TotalVisibleMemorySize) * 100)
Write-Host "Memory used : $memUsedPercent %"
if ($memUsedPercent -gt 85) {
    Write-Host "WARNING: memory use is high" -ForegroundColor Yellow
}

# 3. Disk space
Write-Host ""
Write-Host "=== Disk Space ==="
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 } | ForEach-Object {
    $total = $_.Used + $_.Free
    $usedPercent = [math]::Round(($_.Used / $total) * 100)
    Write-Host "Drive $($_.Name): $usedPercent % full"
    if ($usedPercent -gt 85) {
        Write-Host "WARNING: drive $($_.Name) is almost full" -ForegroundColor Yellow
    }
}

# 4. Top 5 processes using the most CPU
Write-Host ""
Write-Host "=== Top 5 Processes (CPU) ==="
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 Name, CPU | Format-Table

# 5. Services that should be running but are stopped
Write-Host "=== Stopped Automatic Services ==="
Get-Service | Where-Object { $_.StartType -eq "Automatic" -and $_.Status -eq "Stopped" } | Select-Object Name, DisplayName | Format-Table

# 6. Internet check
Write-Host "=== Internet Check ==="
if (Test-Connection -ComputerName 8.8.8.8 -Count 2 -Quiet) {
    Write-Host "Internet connection: OK" -ForegroundColor Green
} else {
    Write-Host "Internet connection: FAILED" -ForegroundColor Red
}

Stop-Transcript | Out-Null
Write-Host ""
Write-Host "Report saved to $reportFile"
