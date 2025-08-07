package com.onlinebookstore.services;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import io.restassured.response.Response;
import io.restassured.specification.RequestSpecification;
import lombok.extern.slf4j.Slf4j;
import org.junit.Assert;

@Slf4j
public class BaseService {

    public static Response response;

    protected RequestSpecification createBaseRequest() {
        return RestAssured.given()
                .accept(ContentType.JSON);
    }

    protected RequestSpecification createJsonRequest() {
        return createBaseRequest()
                .contentType(ContentType.JSON);
    }

    protected void executeGetRequest(String endpoint) {
        response = createBaseRequest()
                .when().log().all()
                .get(endpoint)
                .prettyPeek();
    }

    protected void executeGetRequestWithPathParam(String endpoint, String paramName, Object paramValue) {
        response = createBaseRequest()
                .pathParam(paramName, paramValue)
                .when().log().all()
                .get(endpoint)
                .prettyPeek();
    }

    protected void executePostRequest(String endpoint, Object body) {
        response = createJsonRequest()
                .body(body)
                .when().log().all()
                .post(endpoint)
                .prettyPeek();
    }

    protected void executePutRequest(String endpoint, Object body, String paramName, Object paramValue) {
        response = createJsonRequest()
                .body(body)
                .pathParam(paramName, paramValue)
                .when().log().all()
                .put(endpoint)
                .prettyPeek();
    }

    protected void executeDeleteRequestWithIdInUrl(String baseEndpoint, Object id) {
        response = createBaseRequest()
                .contentType(ContentType.JSON)
                .when().log().all()
                .delete(baseEndpoint + "/" + id)
                .prettyPeek();
    }

    public void validateResponse(int expectedStatusCode) {
        if (response == null) {
            throw new RuntimeException("Response is null - no API call was made");
        }
        
        int actualStatusCode = response.statusCode();
        Assert.assertEquals("Status code validation failed", expectedStatusCode, actualStatusCode);
    }

    protected void validateResponseField(String fieldName, Object expectedValue) {
        if (response == null) {
            throw new RuntimeException("Response is null - no API call was made");
        }
        Object actualValue = response.path(fieldName);
        Assert.assertEquals("Field validation failed for: " + fieldName, expectedValue, actualValue);
    }

    protected void validateResponseFieldNotNull(String fieldName) {
        if (response == null) {
            throw new RuntimeException("Response is null - no API call was made");
        }
        Object value = response.path(fieldName);
        Assert.assertNotNull("Field should not be null: " + fieldName, value);
    }
} 