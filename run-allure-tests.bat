@echo off
echo ========================================
echo Online Bookstore API Testing with Allure Report
echo ========================================

REM Set Allure PATH
set PATH=%PATH%;%CD%\allure\allure-2.24.0\bin

echo.
echo [1/4] Running tests...
echo Available profiles:
echo   - all-tests (default): mvn test
echo   - happy-path: mvn test -Phappy-path
echo   - edge-cases: mvn test -Pedge-cases
echo   - stage: mvn test -Pstage
echo.
echo Running all tests by default...
call mvn test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [WARNING] Some tests failed! Continuing with report generation...
    echo Check the output above for test failure details.
    echo.
)

echo.
echo [2/4] Generating Allure report...
call allure generate allure-results --clean --output allure-report

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] Failed to generate Allure report!
    pause
    exit /b 1
)

echo.
echo [3/4] Opening Allure report...
start allure open allure-report

echo.
echo [4/4] Allure report setup complete!
echo.
echo Report location: %CD%\allure-report
echo Results location: %CD%\allure-results
echo.
echo The report should open in your default browser.
echo If it doesn't open automatically, navigate to: %CD%\allure-report\index.html
echo.
echo Note: The report will show both passed and failed tests for analysis.
echo.
pause 