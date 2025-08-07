#!/bin/bash

# BookStore API Testing with Allure Report - macOS Version
# This script provides an easy way to run API tests with Allure reporting on macOS
# Updated to always generate reports after tests, even when tests fail

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}========================================"
    echo -e "Online Bookstore API Testing with Allure Report"
    echo -e "========================================"
    echo -e "${NC}"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [OPTIONS] [PROFILE]"
    echo ""
    echo "Profiles:"
    echo "  all-tests    Run all tests (default)"
    echo "  happy-path   Run happy path tests only"
    echo "  edge-cases   Run edge case tests only"
    echo "  stage        Run stage tests"
    echo ""
    echo "Options:"
    echo "  -h, --help   Show this help message"
    echo "  -c, --clean  Clean previous results before running"
    echo "  -o, --open   Open report in browser after generation (default)"
    echo "  --no-open    Do not open report in browser after generation"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run all tests"
    echo "  $0 happy-path         # Run happy path tests"
    echo "  $0 edge-cases -c      # Run edge cases with clean results"
    echo "  $0 all-tests -o       # Run all tests and open report"
}

# Function to check if Allure is available
check_allure() {
    if ! command -v allure &> /dev/null; then
        # Try to use the local Allure installation
        ALLURE_PATH="./allure/allure-2.24.0/bin/allure"
        if [ -f "$ALLURE_PATH" ]; then
            export PATH="$PATH:$(pwd)/allure/allure-2.24.0/bin"
            print_info "Using local Allure installation"
        else
            print_error "Allure is not installed or not in PATH"
            print_info "Please install Allure or ensure the local installation exists"
            exit 1
        fi
    fi
}

# Function to check if Maven is available
check_maven() {
    if ! command -v mvn &> /dev/null; then
        print_error "Maven is not installed or not in PATH"
        print_info "Please install Maven to run the tests"
        exit 1
    fi
}

# Function to clean previous results
clean_results() {
    print_info "Cleaning previous test results..."
    rm -rf allure-results allure-report target/surefire-reports
    print_success "Previous results cleaned"
}

# Function to run tests
run_tests() {
    local profile=$1
    local clean=$2
    
    print_info "Starting API tests with profile: $profile"
    
    if [ "$clean" = "true" ]; then
        clean_results
    fi
    
    # Create necessary directories
    mkdir -p allure-results allure-report target
    
    # Run tests based on profile
    case $profile in
        "all-tests")
            print_info "Running all tests..."
            mvn test || true  # Continue even if tests fail
            ;;
        "happy-path")
            print_info "Running happy path tests..."
            mvn test -Phappy-path || true  # Continue even if tests fail
            ;;
        "edge-cases")
            print_info "Running edge case tests..."
            mvn test -Pedge-cases || true  # Continue even if tests fail
            ;;
        "stage")
            print_info "Running stage tests..."
            mvn test -Pstage || true  # Continue even if tests fail
            ;;
        *)
            print_error "Unknown profile: $profile"
            show_usage
            exit 1
            ;;
    esac
    
    # Check if any test results were generated
    if [ -d "allure-results" ] && [ "$(ls -A allure-results 2>/dev/null)" ]; then
        print_info "Test results found in allure-results directory"
        return 0
    else
        print_warning "No test results found in allure-results directory"
        return 1
    fi
}

# Function to generate Allure report
generate_report() {
    print_info "Generating Allure report..."
    
    # Check if allure-results directory exists and has content
    if [ ! -d "allure-results" ] || [ -z "$(ls -A allure-results 2>/dev/null)" ]; then
        print_warning "No test results found. Creating empty report..."
        # Create a minimal allure-results structure for empty report
        mkdir -p allure-results
        echo '{"name":"No tests executed","status":"skipped","start":'$(date +%s)000',"stop":'$(date +%s)000'}' > allure-results/empty-result.json
    fi
    
    # Try system Allure first (Homebrew installation) - skip Maven plugin
    if command -v allure &> /dev/null; then
        if allure generate allure-results --clean --output allure-report; then
            print_success "Allure report generated successfully using system installation!"
            return 0
        else
            print_error "Failed to generate Allure report with system installation!"
            return 1
        fi
    else
        # Try to use the local Allure installation
        ALLURE_PATH="./allure/allure-2.24.0/bin/allure"
        if [ -f "$ALLURE_PATH" ] && [ -x "$ALLURE_PATH" ]; then
            if "$ALLURE_PATH" generate allure-results --clean --output allure-report; then
                print_success "Allure report generated successfully using local installation!"
                return 0
            else
                print_error "Failed to generate Allure report with local installation!"
                return 1
            fi
        else
            print_error "No Allure installation found. Cannot generate report."
            print_info "Please install Allure using: brew install allure"
            return 1
        fi
    fi
}

# Function to open report in browser
open_report() {
    local open_browser=$1
    
    if [ "$open_browser" = "true" ]; then
        print_info "Opening Allure report in browser..."
        
        # Check if report was generated successfully - try different possible file names
        if [ -f "allure-report/index.html" ]; then
            # Start a local web server to serve the report properly
            print_info "Starting local web server for Allure report..."
            
            # Kill any existing server on port 8080
            pkill -f "python3 -m http.server 8080" 2>/dev/null || true
            pkill -f "allure serve" 2>/dev/null || true
            
            # Start Python HTTP server in background
            cd allure-report && python3 -m http.server 8080 > /dev/null 2>&1 &
            SERVER_PID=$!
            
            # Wait a moment for server to start
            sleep 2
            
            # Try different ways to open the browser on macOS
            if command -v open &> /dev/null; then
                open http://localhost:8080
                print_success "Report opened in browser at http://localhost:8080"
                print_info "Server PID: $SERVER_PID (use 'kill $SERVER_PID' to stop server)"
            elif command -v xdg-open &> /dev/null; then
                xdg-open http://localhost:8080
                print_success "Report opened in browser at http://localhost:8080"
                print_info "Server PID: $SERVER_PID (use 'kill $SERVER_PID' to stop server)"
            else
                print_warning "Could not automatically open browser"
                print_info "Please manually open: http://localhost:8080"
                print_info "Server PID: $SERVER_PID (use 'kill $SERVER_PID' to stop server)"
            fi
            
            # Return to original directory
            cd ..
            
        elif [ -f "allure-report/allure-maven.html" ]; then
            # Try different ways to open the browser on macOS
            if command -v open &> /dev/null; then
                open allure-report/allure-maven.html
                print_success "Report opened in browser"
            elif command -v xdg-open &> /dev/null; then
                xdg-open allure-report/allure-maven.html
                print_success "Report opened in browser"
            else
                print_warning "Could not automatically open browser"
                print_info "Please manually open: $(pwd)/allure-report/allure-maven.html"
            fi
        else
            print_error "Report file not found. Cannot open browser."
            print_info "Available files in allure-report directory:"
            ls -la allure-report/ 2>/dev/null || echo "Directory not found"
        fi
    fi
}

# Function to provide test summary
provide_summary() {
    local test_exit_code=$1
    
    echo ""
    print_info "Test Execution Summary:"
    
    if [ $test_exit_code -eq 0 ]; then
        print_success "✓ All tests completed successfully!"
    else
        print_warning "⚠ Some tests failed or were skipped"
        print_info "Check the Allure report for detailed failure information"
    fi
    
    echo ""
    print_info "Report location: $(pwd)/allure-report"
    print_info "Results location: $(pwd)/allure-results"
    echo ""
    
    if [ "$OPEN_BROWSER" = "false" ]; then
        print_info "To open the report manually, run:"
        print_info "  open allure-report/index.html"
        echo ""
    fi
    
    print_info "Note: The report will show both passed and failed tests for analysis."
    echo ""
    
    if [ $test_exit_code -eq 0 ]; then
        print_success "Process completed successfully!"
    else
        print_warning "Process completed with test failures. Check the report for details."
        exit $test_exit_code
    fi
}

# Parse command line arguments
PROFILE="all-tests"
CLEAN_RESULTS=false
OPEN_BROWSER=true  # Changed default to true to automatically open browser

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_usage
            exit 0
            ;;
        -c|--clean)
            CLEAN_RESULTS=true
            shift
            ;;
        -o|--open)
            OPEN_BROWSER=true
            shift
            ;;
        --no-open)
            OPEN_BROWSER=false
            shift
            ;;
        all-tests|happy-path|edge-cases|stage)
            PROFILE="$1"
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

# Main execution
print_header

# Check prerequisites
check_maven
check_allure

print_info "Configuration:"
print_info "  Profile: $PROFILE"
print_info "  Clean Results: $CLEAN_RESULTS"
print_info "  Open Browser: $OPEN_BROWSER"
echo ""

# Run tests and capture exit code
run_tests "$PROFILE" "$CLEAN_RESULTS"
TEST_EXIT_CODE=$?

# Always generate report, regardless of test outcome
if generate_report; then
    # Open report if requested
    open_report "$OPEN_BROWSER"
else
    print_error "Failed to generate report. Exiting."
    exit 1
fi

# Provide final summary
provide_summary $TEST_EXIT_CODE 