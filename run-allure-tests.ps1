# BookStore API Testing with Allure Report
# PowerShell Script

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Online Bookstore API Testing with Allure Report" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

# Set Allure PATH
$env:PATH += ";$PWD\allure\allure-2.24.0\bin"

Write-Host ""
Write-Host "[1/4] Running tests..." -ForegroundColor Yellow
Write-Host "Available profiles:" -ForegroundColor Cyan
Write-Host "  - all-tests (default): mvn test" -ForegroundColor White
Write-Host "  - happy-path: mvn test -Phappy-path" -ForegroundColor White
Write-Host "  - edge-cases: mvn test -Pedge-cases" -ForegroundColor White
Write-Host "  - stage: mvn test -Pstage" -ForegroundColor White
Write-Host ""
Write-Host "Running all tests by default..." -ForegroundColor Yellow
mvn test

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[WARNING] Some tests failed! Continuing with report generation..." -ForegroundColor Yellow
    Write-Host "Check the output above for test failure details." -ForegroundColor Yellow
    Write-Host ""
}

Write-Host ""
Write-Host "[2/4] Generating Allure report..." -ForegroundColor Yellow
allure generate allure-results --clean --output allure-report

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "[ERROR] Failed to generate Allure report!" -ForegroundColor Red
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host ""
Write-Host "[3/4] Opening Allure report..." -ForegroundColor Yellow
Start-Process "allure" -ArgumentList "open", "allure-report" -NoNewWindow

Write-Host ""
Write-Host "[4/4] Allure report setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Report location: $PWD\allure-report" -ForegroundColor Cyan
Write-Host "Results location: $PWD\allure-results" -ForegroundColor Cyan
Write-Host ""
Write-Host "The report should open in your default browser." -ForegroundColor Green
Write-Host "If it doesn't open automatically, navigate to: $PWD\allure-report\index.html" -ForegroundColor Green
Write-Host ""
Write-Host "Note: The report will show both passed and failed tests for analysis." -ForegroundColor Yellow
Write-Host ""
Read-Host "Press Enter to continue" 