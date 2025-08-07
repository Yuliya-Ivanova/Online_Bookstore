# CI/CD Pipeline Documentation

This document provides comprehensive information about the CI/CD pipeline setup for the Online Bookstore API Testing project, including Docker integration, Allure reporting, and automated testing workflows.

## 🚀 Overview

The project includes a streamlined CI/CD pipeline using GitHub Actions with the following key features:

1. **Main CI Pipeline** (`ci-pipeline.yml`) - Complete test suite with Docker execution and GitHub Pages deployment

## 📋 Workflow Details

### Main CI Pipeline (`ci-pipeline.yml`)

**Triggers:**
- Push to `main` and `develop` branches
- Pull requests to `main` and `develop` branches
- Manual workflow dispatch

**Features:**
- ✅ Docker-based test execution
- ✅ Automatic Allure report generation
- ✅ GitHub Pages deployment for live reports
- ✅ Artifact management with 30-day retention
- ✅ Fallback report generation for reliability
- ✅ Comprehensive error handling

**Jobs:**
1. **Test and Generate Report** - Runs tests in Docker containers and generates Allure reports
2. **Deploy to GitHub Pages** - Publishes test reports to GitHub Pages for live access

## 🐳 Docker Integration

### Docker Configuration

The project uses Docker for consistent test execution across different environments:

**Base Image:** `openjdk:21-jdk-slim`
**Build Tool:** Maven 3.6+
**Test Framework:** Cucumber + RestAssured + JUnit
**Reporting:** Allure Framework

### Docker Commands in CI

```bash
# Build image
docker build -t bookstore-api-tests:${{ github.sha }} .

# Run tests with Allure reporting
docker run --rm \
  -e BASE_URL=${{ env.BASE_URL }} \
  -e TEST_TAGS='@happyPath or @edgeCases' \
  -e TEST_RUNNER=TestRunner \
  -e PARALLEL_THREADS=2 \
  -v $(pwd)/allure-results:/app/allure-results \
  -v $(pwd)/allure-report:/app/allure-report \
  bookstore-api-tests:${{ github.sha }}
```

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `BASE_URL` | `https://fakerestapi.azurewebsites.net` | API base URL |
| `TEST_TAGS` | `@happyPath or @edgeCases` | Cucumber tags to run |
| `TEST_RUNNER` | `TestRunner` | Test runner class |
| `PARALLEL_THREADS` | `2` | Number of parallel threads |
| `ALLURE_RESULTS_DIR` | `allure-results` | Allure results directory |
| `ALLURE_REPORT_DIR` | `allure-report` | Allure report directory |

## 📊 Allure Reporting

### Automatic Report Generation

The CI/CD pipeline automatically generates Allure reports with comprehensive error handling:

1. **Docker-based Generation** - Primary report generation in Docker container
2. **Local Fallback Generation** - Backup report generation if Docker fails
3. **Fallback HTML Report** - Emergency HTML report if Allure fails completely

### Report Features

- **Interactive HTML Reports** - Rich, detailed test execution information
- **Test Attachments** - API requests/responses, screenshots, logs
- **Trend Analysis** - Historical test execution data
- **Environment Information** - Base URL and configuration details
- **Failure Analysis** - Detailed error information and stack traces

### Accessing Reports

1. **GitHub Pages** - Live reports accessible via web browser
2. **GitHub Actions** - Download artifacts from workflow runs
3. **Local Development** - Use `mvn allure:serve` to view reports

## 🌐 GitHub Pages Deployment

### Automatic Deployment

The pipeline automatically deploys test reports to GitHub Pages:

- **Trigger**: After successful test execution
- **Content**: Allure HTML reports
- **Access**: Public web URL provided in workflow summary
- **Retention**: Reports persist across workflow runs

### Deployment Process

1. **Download Artifacts** - Retrieve Allure report from previous job
2. **Setup Pages** - Configure GitHub Pages environment
3. **Upload Artifacts** - Deploy HTML reports to Pages
4. **Deploy** - Make reports live on GitHub Pages

### Accessing Live Reports

After each pipeline run, you can access live reports via:
- **Workflow Summary** - Link provided in GitHub Actions
- **Repository Settings** - GitHub Pages section
- **Direct URL** - `https://[username].github.io/[repository-name]/`

## 🔧 Configuration

### Workflow Inputs

**Main CI Pipeline:**
- No manual inputs required - fully automated
- Environment variables configured in workflow

### Environment Configuration

The pipeline uses a single environment configuration:

```yaml
env:
  BASE_URL: https://fakerestapi.azurewebsites.net
```

## 📈 Monitoring and Analytics

### Test Metrics

The pipeline provides comprehensive test metrics:

- **Execution Time** - Test suite execution duration
- **Success Rate** - Pass/fail statistics
- **Coverage** - Test coverage information
- **Trends** - Historical performance data

### Artifact Management

- **Retention Period** - 30 days for all artifacts
- **Storage Optimization** - Efficient artifact compression
- **Access Control** - Public access for reports, secure for results

## 🚀 Getting Started

### Prerequisites

1. **GitHub Repository** - Push code to GitHub
2. **GitHub Actions** - Enable Actions in repository settings
3. **GitHub Pages** - Enable Pages in repository settings

## 🔄 Workflow Optimization

### Performance Improvements

- **Docker Layer Caching** - Optimized build times
- **Parallel Test Execution** - Multi-threaded test runs
- **Artifact Caching** - Efficient dependency management

### Reliability Features

- **Fallback Mechanisms** - Multiple report generation strategies
- **Error Recovery** - Graceful handling of failures
- **Comprehensive Logging** - Detailed execution information

### Manual Trigger

You can manually trigger the pipeline:

1. **Go to Actions tab** in GitHub repository
2. **Select CI Pipeline workflow**
3. **Click "Run workflow"**
4. **Choose branch and click "Run workflow"**