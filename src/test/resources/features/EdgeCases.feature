@edgeCases
Feature: BookStore - Edge Cases

  Scenario Outline: Invalid Book Id validation
    When Get Book By Id <id>
    Then Validate status code is <status code>

    Examples:
      | id        | status code |
      | -1        | 404         |
      | 0         | 404         |
      | 999999999 | 404         |
      | 1.5       | 400         |
      | "abc"     | 400         |
      | ""        | 400         |

  Scenario Outline: Boundary Value Edge Cases for Page Count
    When Add a new book with title "Boundary Test" description "Testing minimum pages" excerpt "Sample excerpt" page count <page count> and publish date "2025-01-01T00:00:00Z"
    Then Validate status code is <status code>

    Examples:
      | page count | status code |
      | -1         | 404         |
      | 0          | 404         |
      | 999999999  | 404         |
      | 1.5        | 400         |
      | "abc"      | 400         |
      | ""         | 400         |

  Scenario Outline: Special Characters and Long Strings Edge Cases
    When Add a new book with title "<title>" description "Testing special chars" excerpt "Sample excerpt with special chars !@#$%^&*()" page count 100 and publish date "2025-01-01T00:00:00Z"
    Then Validate status code is <status code>

    Examples:
      | title                                           | status code |
      | Test Book !@#$%^&*()_+-=[]{};':\",./<>?         | 200         |
      | Test Book with Unicode: 中文, Español, Français  | 200         |
      |                                                 | 400         |

  Scenario: Add book with very long title (1000 characters)
    When Add a new book with very long title description "Testing long title" excerpt "Sample excerpt" page count 100 and publish date "2025-01-01T00:00:00Z"
    Then Validate status code is 200

  Scenario: Try to add duplicate book with same title
    When Add a new book with title "Duplicated book title" description "Test description" excerpt "Sample excerpt" page count 100 and publish date "2025-01-01T00:00:00Z"
    When Add a new book with title "Duplicated book title" description "Test description" excerpt "Sample excerpt" page count 100 and publish date "2025-01-01T00:00:00Z"
    Then Validate status code is 400

  Scenario Outline: Try to update non-existent book
    When Update the book with id <bookId> to have title "<title>", description "<description>", excerpt "<excerpt>", page count <pageCount> and publish date "<publishDate>"
    Then Validate status code is 400

    Examples:
      | bookId | title        | description      | excerpt              | pageCount | publishDate          |
      | 999999 | Non-existent | This should fail | Non-existent excerpt | 123       | 2025-08-05T10:18:23Z |

  Scenario: Try to delete non-existent book
    When Delete the book with id 999999
    Then Validate status code is 400

  Scenario: Test API with malformed JSON
    When Send malformed JSON to add book endpoint
    Then Validate status code is 400
