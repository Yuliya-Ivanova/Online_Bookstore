# Online BookStore API Testing - Docker Setup

This document explains how to use Docker to run the BookStore API automation tests in a containerized environment.

## 🐳 Quick Start

### Prerequisites
- Docker installed on your system
- Docker Compose (usually comes with Docker Desktop)

### Basic Usage

1. **Build and run tests with default configuration:**
   ```bash
   docker-compose up --build
   ```

2. **Run tests with custom base URL:**
   ```bash
   BASE_URL=https://your-api-url.com docker-compose up --build
   ```

## 🚀 Advanced Usage

### Using Docker Compose Profiles

The project includes several pre-configured profiles for different test scenarios:

#### Happy Path Tests Only
```bash
docker-compose --profile happy-path up --build
```

#### Edge Cases Tests Only
```bash
docker-compose --profile edge-cases up --build
```

#### All Tests
```bash
docker-compose --profile all-tests up --build
```

### Environment Variables

You can customize the test execution using environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `BASE_URL` | `https://fakerestapi.azurewebsites.net` | The base URL for the API under test |
| `TEST_PROFILE` | `all-tests` | Maven profile to use for test execution |
| `PARALLEL_THREADS` | `1` | Number of parallel threads for test execution |
| `MAVEN_OPTS` | `-Xmx2g` | Maven JVM options |

### Examples

**Run edge cases with custom base URL:**
```bash
BASE_URL=https://fakerestapi.azurewebsites.net docker-compose --profile edge-cases up --build
```

**Run all tests in parallel:**
```bash
PARALLEL_THREADS=4 docker-compose --profile all-tests up --build
```

**Run with custom Maven options:**
```bash
MAVEN_OPTS="-Xmx4g -XX:+UseG1GC" docker-compose up --build
```

## 🔧 Using Docker Commands Directly

### Build the Image
```bash
docker build -t bookstore-api-tests .
```

### Run Tests with Default Settings
```bash
docker run --rm bookstore-api-tests
```

### Run Tests with Custom Configuration
```bash
docker run --rm \
  -e BASE_URL=https://your-api-url.com \
  -e TEST_PROFILE=happy-path \
  -e PARALLEL_THREADS=2 \
  -v $(pwd)/target:/app/target \
  bookstore-api-tests
```

## 📊 Allure Reporting with Docker

### Using Allure Docker Compose Configuration

The project includes a separate Docker Compose file for Allure reporting:

```bash
# Run tests with Allure reporting
docker-compose -f docker-compose.ci.yml --profile allure up --build

# Start Allure server only
docker-compose -f docker-compose.ci.yml --profile allure up allure-server
```

### Allure Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TEST_TAGS` | `@happyPath` | Cucumber tags to filter test scenarios |
| `TEST_RUNNER` | `TestRunner` | Test runner class to use |
| `ALLURE_RESULTS_DIR` | `allure-results` | Directory for Allure results |
| `ALLURE_REPORT_DIR` | `allure-report` | Directory for Allure reports |

### Allure Test Profiles

#### Happy Path Tests with Allure
```bash
docker-compose -f docker-compose.ci.yml --profile allure up happy-path-allure --build
```

#### Edge Cases Tests with Allure
```bash
docker-compose -f docker-compose.ci.yml --profile allure up edge-cases-allure --build
```

#### All Tests with Allure
```bash
docker-compose -f docker-compose.ci.yml --profile allure up all-tests-allure --build
```

## 🏷️ Available Test Tags

- `@happyPath`: Happy path test scenarios
- `@edgeCases`: Edge case scenarios
- `@STAGE`: Stage-specific tests
- `@afterScenario_revertTestData`: Tests that revert data after execution

### Standard Docker Compose
- `./reports:/app/reports` - Test reports directory
- `./target:/app/target` - Maven target directory with HTML reports

### Allure Docker Compose
- `./allure-results:/app/allure-results` - Allure test results
- `./allure-report:/app/allure-report` - Allure HTML reports
- `./target:/app/target` - Maven target directory

## 🔧 Dockerfile Details

The project uses a multi-stage Docker build:

1. **Build Stage**: Uses OpenJDK 21 slim image with Maven
2. **Runtime Stage**: Uses OpenJDK 21 slim image for test execution
3. **Dependencies**: Copies Maven dependencies for faster builds
4. **Source Code**: Copies test source code and resources
5. **Configuration**: Sets up environment variables and working directory

### Key Features
- **Multi-stage build** for optimized image size
- **Dependency caching** for faster builds
- **Non-root user** for security
- **Health checks** for container monitoring
- **Environment variable support** for configuration