package com.onlinebookstore.step_defs;

import io.cucumber.java.Before;
import io.cucumber.java.After;
import io.cucumber.java.Scenario;
import io.restassured.RestAssured;
import io.qameta.allure.Allure;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Hooks {
    @Before
    public void setUp() {
        String baseUrl = getBaseUrl();
        RestAssured.baseURI = baseUrl;
        System.out.println("Setting RestAssured baseURI to: " + baseUrl);
        Allure.addAttachment("Base URL", "text/plain", baseUrl);
    }

    @After
    public void tearDown(Scenario scenario) {
        if (scenario.isFailed()) {
            Allure.addAttachment("Failed Scenario", "text/plain",
                    "Scenario: " + scenario.getName() + "\n" +
                            "Status: " + scenario.getStatus() + "\n" +
                            "Error: " + scenario.getStatus().toString());
        }
    }

    private String getBaseUrl() {
        // Priority 1: System property
        String baseUrl = System.getProperty("restassured.baseURI");
        if (baseUrl != null && !baseUrl.trim().isEmpty()) {
            return baseUrl;
        }

        // Priority 2: Environment variable
        baseUrl = System.getenv("BASE_URL");
        if (baseUrl != null && !baseUrl.trim().isEmpty()) {
            return baseUrl;
        }

        // Priority 3: Properties file
        try {
            Properties props = new Properties();
            InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties");
            if (input != null) {
                props.load(input);
                baseUrl = props.getProperty("api.base.url");
                if (baseUrl != null && !baseUrl.trim().isEmpty()) {
                    return baseUrl;
                }
            }
        } catch (IOException e) {
            System.out.println("Warning: Could not load config.properties file: " + e.getMessage());
        }

        // Priority 4: Default fallback
        return "https://fakerestapi.azurewebsites.net";
    }
} 