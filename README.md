# Online Bookstore API Testing

This is a comprehensive test automation project for a Book Store API. The project is written in Java and uses RestAssured, Cucumber, and JUnit to provide both happy path and edge case testing coverage. It includes Docker containerization, Allure reporting, and CI/CD pipeline integration.

The Online Bookstore API Testing project aims to automate the testing of an Online Bookstore API with comprehensive coverage including normal operations and edge cases. The tests are written in Gherkin language using Cucumber, and the assertions are made using RestAssured library. JUnit is used as the test runner.

## 🚀 Features

- **Happy Path Testing**: Complete CRUD operations testing for all API endpoints
- **Edge Case Testing**: Comprehensive boundary and error scenario testing
- **BDD Approach**: Behavior Driven Development with Gherkin syntax
- **Modular Structure**: Separated feature files for better organization
- **Allure Reporting**: Rich, interactive HTML test reports with detailed analytics
- **Docker Support**: Containerized test execution for consistent environments
- **CI/CD Integration**: GitHub Actions pipeline with automated testing and GitHub Pages deployment
- **Parallel Execution**: Multi-threaded test execution for faster results
- **Tag-based Execution**: Run specific test categories using Cucumber tags

### Technologies Used
The following technologies and libraries are used in this project:

- **Java 21**: Programming language used for writing the tests
- **RestAssured 5.3.0**: Library used for making HTTP requests and validating responses
- **Cucumber 7.12.0**: Framework used for writing BDD-style test scenarios
- **JUnit**: Test runner used for executing the tests
- **Maven**: Build tool and dependency management
- **Allure 2.24.0**: Advanced test reporting framework
- **Docker**: Containerization for consistent test environments
- **Lombok**: Reduces boilerplate code

## 📁 Project Structure

```
Online_Bookstore/
├── src/
│   ├── main/java/com/onlinebookstore/
│   └── test/
│       ├── java/com/onlinebookstore/
│       │   ├── runners/
│       │   │   └── TestRunner.java           # Unified test runner
│       │   ├── services/
│       │   │   ├── BaseService.java          # Base service class
│       │   │   ├── BooksAPIActions.java      # Books API service actions
│       │   │   └── AuthorsAPIActions.java    # Authors API service actions
│       │   ├── step_defs/
│       │   │   ├── BooksStepDefinitions.java # Books step definitions
│       │   │   ├── AuthorsStepsDefenitions.java # Authors step definitions
│       │   │   └── Hooks.java                # Test hooks
│       │   └── model/
│       │       └── Book.java                 # Book model class
│       └── resources/
│           ├── config.properties             # Configuration file
│           └── features/
│               ├── HappyPath.feature         # Happy path scenarios
│               └── EdgeCases.feature         # Edge case scenarios
├── .github/workflows/
│   └── ci-pipeline.yml                       # GitHub Actions CI pipeline
├── allure/                                   # Allure command line tool
├── allure-results/                           # Allure test results
├── allure-report/                            # Allure HTML reports
├── docker-compose.yml                        # Docker Compose configuration
├── docker-compose.ci.yml                     # CI/CD Docker configuration
├── Dockerfile                                # Docker image definition
├── run-allure-tests-macos.sh                 # macOS test execution script
├── run-allure-tests.bat                      # Windows test execution script
├── run-allure-tests.ps1                      # PowerShell test execution script
├── pom.xml                                   # Maven configuration
├── README.md                                 # This file
├── DOCKER_README.md                          # Docker setup guide
└── CI_CD_README.md                           # CI/CD pipeline guide
```

## 📋 Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Docker Support](#docker-support)
- [Allure Reporting](#allure-reporting)
- [CI/CD Pipeline](#cicd-pipeline)
- [Test Structure](#test-structure)
- [Edge Case Testing](#edge-case-testing)
- [Running Tests](#running-tests)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## 🔧 Installation

### Prerequisites
To use this project, you need to have the following software installed on your machine:

- **Java Development Kit (JDK)** - Version 21 or higher
- **Maven** - Version 3.6 or higher
- **Docker** - Version 20.10 or higher (optional, for containerized execution)
- **Docker Compose** - Version 2.0 or higher (optional, for containerized execution)

### Download Links
- **JDK 21**: Download from [Oracle](https://www.oracle.com/java/technologies/javase-jdk21-downloads.html) or [OpenJDK](https://openjdk.java.net/)
- **Maven**: Download from [Apache Maven](https://maven.apache.org/download.cgi)
- **Docker**: Download from [Docker](https://www.docker.com/products/docker-desktop)

### Setup
1. Clone this repository:
```bash
git clone https://github.com/Yuliya-Ivanova/Online_Bookstore.git
cd Online_Bookstore
```

2. Verify installation:
```bash
java -version
mvn -version
docker --version
```

## 🚀 Usage

### Basic Test Execution

#### Using Maven
```bash
# Run all tests
mvn clean test

# Run tests with specific base URL
mvn test -Drestassured.baseURI=https://your-api-url.com
```

#### Using Docker (Recommended)
```bash
# Run all tests with default configuration
docker-compose up --build

# Run tests with custom base URL
BASE_URL=https://your-api-url.com docker-compose up --build
```

#### Using Shell Scripts
```bash
# macOS/Linux
chmod +x run-allure-tests-macos.sh
./run-allure-tests-macos.sh

# Windows (Command Prompt)
run-allure-tests.bat

# Windows (PowerShell)
.\run-allure-tests.ps1
```

### Running Specific Test Categories

#### Using Maven Profiles
```bash
# Run all tests (default)
mvn test

# Run happy path tests only
mvn test -Phappy-path

# Run edge cases only
mvn test -Pedge-cases

# Run stage tests only
mvn test -Pstage
```

#### Using Docker Compose Profiles
```bash
# Run happy path tests only
docker-compose --profile happy-path up --build

# Run edge cases only
docker-compose --profile edge-cases up --build

# Run all tests
docker-compose --profile all-tests up --build
```

#### Using Direct Tag Filtering
```bash
# Run happy path tests only
mvn test -Dcucumber.filter.tags="@happyPath"

# Run edge case tests only
mvn test -Dcucumber.filter.tags="@edgeCases"

# Run specific combination
mvn test -Dcucumber.filter.tags="@happyPath and @STAGE"
```

## 🐳 Docker Support

This project includes comprehensive Docker support for consistent test execution across different environments.

### Quick Start with Docker
```bash
# Run tests with default configuration
docker-compose up --build

# Run specific test suite
docker-compose --profile happy-path up --build
```

### Docker Configuration
- **Base Image**: OpenJDK 21 slim
- **Build Tool**: Maven 3.6+
- **Test Reports**: Mounted volumes for easy access
- **Environment Variables**: Configurable API URLs and test parameters

### Docker Commands
```bash
# Build image
docker build -t bookstore-api-tests .

# Run with custom configuration
docker run --rm \
  -e BASE_URL=https://your-api-url.com \
  -e TEST_TAGS=@happyPath \
  -v $(pwd)/allure-results:/app/allure-results \
  -v $(pwd)/allure-report:/app/allure-report \
  bookstore-api-tests
```

For detailed Docker setup instructions, see [DOCKER_README.md](DOCKER_README.md).

## 📊 Allure Reporting

This project integrates Allure Framework for rich, interactive test reporting.

### Features
- **Interactive HTML Reports**: Detailed test execution information
- **Test Attachments**: API requests/responses, screenshots, logs
- **Trend Analysis**: Historical test execution data
- **Environment Information**: Base URL and configuration details
- **Failure Analysis**: Detailed error information and stack traces

### Generating Allure Reports
```bash
# Run tests and generate Allure results
mvn clean test

# Generate Allure report
mvn allure:report

# Open Allure report in browser
mvn allure:serve
```

### Using Allure with Docker
```bash
# Run tests with Allure reporting
docker-compose -f docker-compose.ci.yml --profile allure up --build

# Start Allure server
docker-compose -f docker-compose.ci.yml --profile allure up allure-server
```

### Allure Report Structure
- **Dashboard**: Test execution summary and trends
- **Test Details**: Step-by-step execution information
- **Categories**: Product defects, test defects, broken tests
- **Attachments**: API requests, responses, and additional files

## 🔄 CI/CD Pipeline

The project includes a streamlined CI/CD pipeline using GitHub Actions with Docker integration, automatic Allure reporting, and GitHub Pages deployment.

### Pipeline Features
- **Docker-Based Testing**: Consistent test execution across environments
- **Automatic Allure Reports**: Rich, interactive HTML test reports
- **GitHub Pages Deployment**: Live test reports accessible via web
- **Artifact Management**: Comprehensive test result storage

### GitHub Actions Workflow

#### Main CI Pipeline (`ci-pipeline.yml`)
- **Triggers**: Push to main/develop, Pull Requests, Manual dispatch
- **Features**: 
  - Docker-based test execution
  - Automatic Allure report generation
  - GitHub Pages deployment for live reports
  - Artifact management with 30-day retention
  - Fallback report generation for reliability

#### Pipeline Jobs
1. **Test and Generate Report** - Runs tests in Docker containers and generates Allure reports
2. **Deploy to GitHub Pages** - Publishes test reports to GitHub Pages for live access

## 📊 Test Structure

### Happy Path Scenarios (`HappyPath.feature`)
The main feature file contains the core functionality tests:

1. **Retrieve all books** - GET /api/v1/Books
2. **Get book by ID** - GET /api/v1/Books/{id}
3. **Add new book** - POST /api/v1/Books
4. **Update book** - PUT /api/v1/Books/{id}
5. **Delete book** - DELETE /api/v1/Books/{id}

### Edge Case Scenarios (`EdgeCases.feature`)
Comprehensive edge case testing covering:

#### 1. **Invalid ID Edge Cases**
- Negative IDs (-1)
- Zero ID (0)
- Very large IDs (999999999)
- Decimal IDs (1.5)
- String IDs ("abc")
- Empty IDs ("")

#### 2. **Boundary Value Analysis for Page Count**
- Minimum page count (0)
- Maximum page count (999999)
- Negative page count (-10)
- Boundary values (-1, 1, 999999, 1000000)
- Invalid data types (strings, decimals)

#### 3. **Special Characters and Unicode**
- Special characters in titles (!@#$%^&*()_+-=[]{}|;':",./<>?)
- Very long titles (1000 characters)
- Unicode characters (中文, Español, Français)

#### 4. **Data Validation Edge Cases**
- Duplicate book titles
- Malformed JSON requests
- Missing required fields
- Invalid date formats

#### 5. **Update and Delete Edge Cases**
- Updating non-existent books
- Deleting non-existent books
- Invalid update data

## 🏃‍♂️ Running Tests

### Command Line Options

#### Run All Tests
```bash
mvn clean test
```

#### Run Specific Test Categories
```bash
# Run only happy path tests
mvn test -Dcucumber.filter.tags="@happyPath"

# Run only edge case tests
mvn test -Dcucumber.filter.tags="@edgeCases"

# Run both happy path and edge case tests
mvn test -Dcucumber.filter.tags="@happyPath or @edgeCases"
```

#### Run Specific Test Types
```bash
# Run only invalid ID tests
mvn test -Dcucumber.filter.tags="@invalid-id"

# Run only boundary value tests
mvn test -Dcucumber.filter.tags="@boundary-values"

# Run only data format tests
mvn test -Dcucumber.filter.tags="@data-format"
```

### Parallel Execution
```bash
# Run tests in parallel with 4 threads
mvn test -Dcucumber.execution.parallel.enabled=true -Dcucumber.execution.parallel.config.strategy=fixed -Dcucumber.execution.parallel.config.fixed.parallelism=4
```

### IDE Integration
You can also run tests directly from your IDE:
- **IntelliJ IDEA**: Right-click on the runner class and select "Run"
- **Eclipse**: Right-click on the feature file and select "Run As" > "Cucumber Feature"

## 📈 Test Reports

After running the tests, detailed reports are generated:

### Allure Reports
- **Results Directory**: `allure-results/`
- **Report Directory**: `allure-report/`
- **HTML Report**: `allure-report/index.html`
- **Live Reports**: Available via GitHub Pages after CI/CD runs

## 🔧 Configuration

### API Base URL Configuration
The API base URL is configurable through multiple methods with the following priority order:

1. **System Property** (highest priority): `-Drestassured.baseURI=https://your-api-url.com`
2. **Environment Variable**: `BASE_URL=https://your-api-url.com`
3. **Properties File**: `src/test/resources/config.properties` (api.base.url property)
4. **Default Fallback**: `https://fakerestapi.azurewebsites.net`

#### Configuration Examples

**Using System Property:**
```bash
mvn test -Drestassured.baseURI=https://staging-api.example.com
```

**Using Environment Variable:**
```bash
BASE_URL=https://prod-api.example.com mvn test
```

**Using Properties File:**
Edit `src/test/resources/config.properties`:
```properties
api.base.url=https://your-api-url.com
```

**Docker Configuration:**
```bash
# Set base URL for Docker container
docker run --rm -e BASE_URL=https://your-api-url.com bookstore-api-tests

# Or using Docker Compose
BASE_URL=https://your-api-url.com docker-compose up --build
```

### Parallel Execution Configuration
```bash
# Configure parallel threads
PARALLEL_THREADS=4  # For faster execution
PARALLEL_THREADS=1  # For debugging
```

