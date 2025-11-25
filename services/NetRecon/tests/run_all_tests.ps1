# tests/run_all_tests.ps1

$ErrorActionPreference = 'Stop'

function Write-Green {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Green
}

function Write-Red {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Red
}

function Write-Yellow {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Yellow
}

function Write-Blue {
    param([string]$Text)
    Write-Host $Text -ForegroundColor Cyan
}

Write-Blue "=== NetRecon Windows Test Runner ==="
Write-Host ""

# Root windows test directory (tests/windows)
$Root = Join-Path $PSScriptRoot "windows"

if (-not (Test-Path $Root)) {
    Write-Red ("Windows test directory not found: " + $Root)
    exit 1
}

# Recursively discover all *.ps1 tests under tests/windows
$TestFiles = Get-ChildItem -Path $Root -Recurse -Filter "*.ps1" | Where-Object {
    $_.Name -ne "run_all_tests.ps1"
}

if (-not $TestFiles -or $TestFiles.Count -eq 0) {
    Write-Yellow ("No test files found under: " + $Root)
    exit 0
}

$Total  = 0
$Passed = 0
$Failed = 0

$TestFiles = Get-ChildItem -Path $Root -Recurse -Filter "*.ps1" | Where-Object {
    $_.Name -ne "run_all_tests.ps1" -and
    $_.FullName -notmatch "\\utils\\"
}

foreach ($Test in $TestFiles) {
    $Total = $Total + 1
    Write-Yellow ("-> Running test: " + $Test.FullName)

    # Run the test script
    & $Test.FullName
    $Exit = $LASTEXITCODE

    if ($Exit -eq $null -or $Exit -eq 0) {
        Write-Green ("PASS: " + $Test.Name)
        $Passed = $Passed + 1
    }
    else {
        Write-Red ("FAIL: " + $Test.Name + " (exit " + $Exit + ")")
        $Failed = $Failed + 1
    }

    Write-Host ""
}

Write-Blue "=== Test Summary ==="
Write-Host ("Total: " + $Total)
Write-Green ("Passed: " + $Passed)
Write-Red ("Failed: " + $Failed)

if ($Failed -eq 0) {
    exit 0
}
else {
    exit 1
}
