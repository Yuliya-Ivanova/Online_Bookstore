package com.onlinebookstore.step_defs;

import com.onlinebookstore.model.Book;
import com.onlinebookstore.services.*;
import io.cucumber.java.en.Then;
import io.cucumber.java.en.When;
import io.qameta.allure.Allure;
import io.qameta.allure.Step;

public class BooksStepDefinitions {

    BooksAPIActions booksAPIActions = new BooksAPIActions();

    @When("Get All Books")
    @Step("Retrieve all books from the API")
    public void getAllBooks() {
        Allure.addAttachment("API Call", "text/plain", "GET /api/v1/Books");
        booksAPIActions.getAllBooks();
    }

    @Then("Validate status code is {}")
    @Step("Validate that the response status code is {code}")
    public void validateStatusCode(int code) {
        Allure.addAttachment("Expected Status Code", "text/plain", String.valueOf(code));
        booksAPIActions.validateResponse(code);
    }

    @When("Get Book By Id {}")
    public void getBookById(Object id) {
        booksAPIActions.getBookById(id);
    }

    @Then("Validate that the book {} details are correct")
    public void validateThatTheBookDetailsAreCorrect(int id) {
        booksAPIActions.validateBookDetails(id);
    }

    @When("Update the book with id {int} to have title {string}, description {string}, excerpt {string}, page count {int} and publish date {string}")
    public void updateBookWithParameters(int bookId, String title, String description, String excerpt, int pageCount, String publishDate) {
        Book book = new Book(title, description, excerpt, pageCount, publishDate);
        book.setId(bookId);
        booksAPIActions.updateBookById(book);
    }

    @Then("Validate that the book is updated to title {string}, description {string}, excerpt {string}, page count {int} and publish date {string}")
    public void validateBookUpdatedWithParameters(String title, String description, String excerpt, int pageCount, String publishDate) {
        booksAPIActions.validateBookIsUpdated(title, description, excerpt, pageCount, publishDate);
    }

    @When("Delete the book with id {}")
    public void deleteTheBookWithId(long bookId) {
        booksAPIActions.deleteBookById(bookId);
    }

    @When("Add a new book with title {string} description {string} excerpt {string} page count {} and publish date {string}")
    public void addNewBookWithParameters(String title, String description, String excerpt, Object pageCount, String publishDate) {
        Book book = new Book(title, description, excerpt, pageCount, publishDate);
        booksAPIActions.addNewBook(book);
    }

    @When("Add a new book with very long title description {string} excerpt {string} page count {int} and publish date {string}")
    public void addNewBookWithVeryLongTitleAndParams(String description, String excerpt, int pageCount, String publishDate) {
        String title = "a".repeat(1000);
        Book book = new Book(title, description, excerpt, pageCount, publishDate);
        booksAPIActions.addNewBook(book);
    }

    @When("Send malformed JSON to add book endpoint")
    public void sendMalformedJsonToAddBookEndpoint() {
        booksAPIActions.addBookWithMalformedJson();
    }
} 