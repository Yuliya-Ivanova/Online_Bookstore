package com.onlinebookstore.runners;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

/**
 * 
 * This runner can execute different test categories based on system properties:
 * - Run all tests: mvn test -Dtest=TestRunner
 * - Run happy path tests only: mvn test -Dtest=TestRunner -Dcucumber.filter.tags="@happyPath"
 * 
 * Default behavior: runs all tests if no tags are specified
 */
@RunWith(Cucumber.class)
@CucumberOptions(
        features = "src/test/resources/features",
        glue = "com/onlinebookstore/step_defs",
        plugin = {
                "html:target/cucumber-reports.html",
                "io.qameta.allure.cucumber7jvm.AllureCucumber7Jvm",
                "json:target/cucumber.json",
                "pretty"
        },
        dryRun = false,
        monochrome = true,
        publish = false
)
public class TestRunner {
} 