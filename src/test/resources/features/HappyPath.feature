@happyPath
Feature: BookStore - Happy Path

  Scenario: Retrieve a list of all books
    When Get All Books
    Then Validate status code is 200

  Scenario: Retrieve details of a specific book by its ID
    When Get Book By Id 1
    Then Validate status code is 200
    And Validate that the book 1 details are correct

  @afterScenario_revertTestData
  Scenario Outline: Add a new book to the system
    When Add a new book with title "<title>" description "<description>" excerpt "<excerpt>" page count <pageCount> and publish date "<publishDate>"
    Then Validate status code is 200

    Examples:
      | title     | description | excerpt                      | pageCount | publishDate          |
      | New Title | New Desc    | This is a new sample excerpt | 23        | 2025-08-05T10:18:23Z |

  @afterScenario_revertTestData
  Scenario Outline: Update an existing book by its ID
    When Update the book with id <bookId> to have title "<title>", description "<description>", excerpt "<excerpt>", page count <pageCount> and publish date "<publishDate>"
    Then Validate status code is 200
    And Validate that the book is updated to title "<title>", description "<description>", excerpt "<excerpt>", page count <pageCount> and publish date "<publishDate>"

    @STAGE
    Examples:
      | bookId | title         | description  | excerpt                  | pageCount | publishDate          |
      | 1      | New Title     | Updated Desc | This is a sample excerpt | 123       | 2025-08-05T10:18:23Z |
      | 2      | Another Title | Another Desc | Another sample excerpt   | 456       | 2026-01-01T00:00:00Z |

  @afterScenario_revertTestData
  Scenario: Delete a book by its ID.
    When Delete the book with id 1
    Then Validate status code is 200