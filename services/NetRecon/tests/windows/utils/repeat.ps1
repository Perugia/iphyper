param(
    [int]$Count,
    [string]$Command
)

1..$Count | ForEach-Object {
    Write-Host "# $_"
    iex $Command
}
