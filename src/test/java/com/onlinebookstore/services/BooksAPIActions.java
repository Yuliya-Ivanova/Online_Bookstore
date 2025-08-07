package com.onlinebookstore.services;

import com.onlinebookstore.model.Book;

public class BooksAPIActions extends BaseService{

    protected static final String BOOKS_BASE_PATH = "/api/v1/Books";
    protected static final String BOOKS_BY_ID_PATH = BOOKS_BASE_PATH + "/{id}";

    public void addNewBook(Book book) {
        executePostRequest(BOOKS_BASE_PATH, book);
    }

    public void getAllBooks() {
        executeGetRequest(BOOKS_BASE_PATH);
    }

    public void getBookById(Object bookId) {
        executeGetRequestWithPathParam(BOOKS_BY_ID_PATH, "id", bookId);
        deserializeResponseToBook();
    }

    private void deserializeResponseToBook() {
        if (response != null && response.getStatusCode() == 200) {
            Book bookResponse = response.as(Book.class);
        }
    }

    public void validateBookDetails(int expectedId) {
        validateResponseField("id", expectedId);
        validateResponseFieldNotNull("title");
    }

    public void addBookWithMalformedJson() {
        String malformedJson = "{ \"title\": \"Test\", \"description\": \"Test\", \"pageCount\": 100, \"publishDate\": \"2025-01-01T00:00:00Z\""; // Missing closing brace
        executePostRequest(BOOKS_BASE_PATH, malformedJson);
    }

    public void updateBookById(Book book) {
        executePutRequest(BOOKS_BY_ID_PATH, book, "id", book.getId());
    }

    public void validateBookIsUpdated(String expectedTitle, String expectedDescription, String expectedExcerpt, int expectedPageCount, String expectedPublishDate) {
        validateResponseField("title", expectedTitle);
        validateResponseField("description", expectedDescription);
        validateResponseField("excerpt", expectedExcerpt);
        validateResponseField("pageCount", expectedPageCount);
        validateResponseField("publishDate", expectedPublishDate);
    }

    public void deleteBookById(long bookId) {
        executeDeleteRequestWithIdInUrl(BOOKS_BASE_PATH, bookId);
    }



}
