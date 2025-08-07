# Use OpenJDK 21 as base image (matching pom.xml configuration)
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy pom.xml first for better layer caching
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the project
RUN mvn clean compile test-compile -B

# Create a script to run tests with configurable parameters
RUN echo '#!/bin/bash\n\
# Set default values\n\
BASE_URL=${BASE_URL:-"https://fakerestapi.azurewebsites.net"}\n\
TEST_TAGS=${TEST_TAGS:-"@happyPath"}\n\
TEST_RUNNER=${TEST_RUNNER:-"TestRunner"}\n\
PARALLEL_THREADS=${PARALLEL_THREADS:-"1"}\n\
ALLURE_RESULTS_DIR=${ALLURE_RESULTS_DIR:-"allure-results"}\n\
ALLURE_REPORT_DIR=${ALLURE_REPORT_DIR:-"allure-report"}\n\
\n\
echo "🚀 Starting API tests with configuration:"\n\
echo "📍 Base URL: $BASE_URL"\n\
echo "🏷️  Test Tags: $TEST_TAGS"\n\
echo "🏃 Test Runner: $TEST_RUNNER"\n\
echo "🧵 Parallel Threads: $PARALLEL_THREADS"\n\
echo "📊 Allure Results Dir: $ALLURE_RESULTS_DIR"\n\
echo "📈 Allure Report Dir: $ALLURE_REPORT_DIR"\n\
echo ""\n\
\n\
# Create directories if they don\'t exist\n\
mkdir -p $ALLURE_RESULTS_DIR\n\
mkdir -p $ALLURE_REPORT_DIR\n\
\n\
# Set system properties for RestAssured and Allure\n\
export MAVEN_OPTS="-Drestassured.baseURI=$BASE_URL -Dcucumber.execution.parallel.enabled=true -Dcucumber.execution.parallel.config.strategy=fixed -Dcucumber.execution.parallel.config.fixed.parallelism=$PARALLEL_THREADS -Dallure.results.directory=$ALLURE_RESULTS_DIR -Dallure.report.directory=$ALLURE_REPORT_DIR"\n\
\n\
# Run tests based on the specified runner\n\
case $TEST_RUNNER in\n\
    "TestRunner")\n\
        echo "🏃 Running TestRunner..."\n\
        mvn test -Dtest=TestRunner -Dcucumber.filter.tags="$TEST_TAGS" -B\n\
        ;;\n\
    "EdgeCasesRunner")\n\
        echo "🏃 Running EdgeCasesRunner..."\n\
        mvn test -Dtest=TestRunner -Dcucumber.filter.tags="$TEST_TAGS" -B\n\
        ;;\n\
    "All")\n\
        echo "🏃 Running all tests..."\n\
        mvn test -Dcucumber.filter.tags="$TEST_TAGS" -B\n\
        ;;\n\
    *)\n\
        echo "❌ Unknown test runner: $TEST_RUNNER"\n\
        echo "📋 Available runners: TestRunner, EdgeCasesRunner, All"\n\
        exit 1\n\
        ;;\n\
esac\n\
\n\
# Generate Allure report after tests complete\n\
echo "📊 Generating Allure report..."\n\
if [ -d "$ALLURE_RESULTS_DIR" ] && [ "$(ls -A $ALLURE_RESULTS_DIR)" ]; then\n\
    echo "Found Allure results, generating report..."\n\
    # Install Allure command line tool if not available\n\
    if ! command -v allure &> /dev/null; then\n\
        echo "Installing Allure command line tool..."\n\
        curl -o allure-2.24.0.tgz -Ls https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.24.0/allure-commandline-2.24.0.tgz\n\
        tar -zxvf allure-2.24.0.tgz -C /opt/\n\
        ln -s /opt/allure-2.24.0/bin/allure /usr/local/bin/allure\n\
    fi\n\
    \n\
    # Generate the report\n\
    allure generate $ALLURE_RESULTS_DIR --clean -o $ALLURE_REPORT_DIR\n\
    echo "✅ Allure report generated successfully in $ALLURE_REPORT_DIR"\n\
else\n\
    echo "⚠️  No Allure results found in $ALLURE_RESULTS_DIR"\n\
    # Create a fallback report\n\
    mkdir -p $ALLURE_REPORT_DIR\n\
    echo "<!DOCTYPE html><html><head><title>Allure Report - No Results</title><style>body{font-family:Arial,sans-serif;margin:40px}.container{max-width:800px;margin:0 auto}.header{background:#f5f5f5;padding:20px;border-radius:5px}.content{margin-top:20px}</style></head><body><div class=\"container\"><div class=\"header\"><h1>📊 Allure Test Report</h1><p><strong>Status:</strong> No test results available</p><p><strong>Generated:</strong> $(date)</p></div><div class=\"content\"><h2>No Test Results Found</h2><p>No Allure results were generated during test execution.</p></div></div></body></html>" > $ALLURE_REPORT_DIR/index.html\n\
fi\n\
\n\
# Check if tests passed\n\
if [ $? -eq 0 ]; then\n\
    echo ""\n\
    echo "✅ All tests passed successfully!"\n\
    echo "📊 Test reports available in target/ directory:"\n\
    ls -la target/*.html target/*.json 2>/dev/null || echo "No reports found"\n\
    echo "📊 Allure results available in $ALLURE_RESULTS_DIR directory:"\n\
    ls -la $ALLURE_RESULTS_DIR 2>/dev/null || echo "No Allure results found"\n\
    echo "📈 Allure report available in $ALLURE_REPORT_DIR directory:"\n\
    ls -la $ALLURE_REPORT_DIR 2>/dev/null || echo "No Allure report found"\n\
else\n\
    echo ""\n\
    echo "❌ Some tests failed"\n\
    echo "📊 Check test reports in target/ directory for details"\n\
    echo "📊 Allure results available in $ALLURE_RESULTS_DIR directory for analysis"\n\
    exit 1\n\
fi' > /app/run-tests.sh && chmod +x /app/run-tests.sh

# Create directories for test reports and Allure
RUN mkdir -p /app/reports /app/allure-results /app/allure-report

# Expose port (if needed for any web-based reporting)
EXPOSE 8080

# Set default environment variables
ENV BASE_URL=https://fakerestapi.azurewebsites.net
ENV TEST_TAGS=@happyPath
ENV TEST_RUNNER=TestRunner
ENV PARALLEL_THREADS=1
ENV ALLURE_RESULTS_DIR=allure-results
ENV ALLURE_REPORT_DIR=allure-report

# Set the entrypoint to run tests
ENTRYPOINT ["/app/run-tests.sh"] 