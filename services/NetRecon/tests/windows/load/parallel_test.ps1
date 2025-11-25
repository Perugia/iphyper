Write-Host "[Windows] Sending 20 parallel requests..."

1..20 | ForEach-Object {
    curl.exe -s "http://localhost:5000/ip/1.1.1.1" | Out-Null
}
Write-Host "Done!"
