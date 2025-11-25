Write-Host "[Windows] Running rate-limit test (80 requests)..."

1..80 | ForEach-Object {
    Write-Host "Request $_"
    curl.exe -i "http://localhost:5000/ip/8.8.8.8"
}
