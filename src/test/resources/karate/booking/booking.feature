Feature: I want validate the book creation for restful booker

  Background:
    * url api.baseUrl
    * def createBooking = '/booking'
    * def myJsonFile = read('classpath:jsonBase/request.json')

  @SuccessfulBookCreate
  Scenario Outline: Successful book create with all body data required
    Given path createBooking
    And header Content-Type = '<header>'
    And header Accept = '<header>'
    And request myJsonFile
    When method POST
    Then status 200

    Examples:
      | header           | firstname | lastname   | checkin    | checkout   | additionalneeds |
      | application/json | Carlos    | Gonzales   | 2023-08-12 | 2023-09-12 | Breakfast       |
      | application/json | Mario     | Petronildo | 2023-12-12 | 2024-03-11 | lunch           |
      | application/json | Mario     | Petronildo | 1900-12-21 | 1993-04-11 |                 |
      | application/json | ''' '''   | ****{}     | 1900-12-21 | 1993-04-11 |                 |
      | application/json | 1114444   | 24242      | 1900-12-21 | 1993-04-11 |                 |

  @FailedCreateBook
  Scenario Outline: Failed creation due to non-submission or empty value of mandatory fields
    Given path createBooking
    And header Content-Type = '<content-type>'
    And header Accept = '<accept>'
    And request myJsonFile
    When method POST
    Then status 500
    And assert response == 'Internal Server Error'

    Examples:
      | content-type     | accept           | firstname | lastname   | checkin    | checkout   | additionalneeds |
      | application/json | application/json |           | Petronildo | 1900-12-21 | 1993-04-11 | lunch           |
      | application/json | application/json | Mario     |            | 1900-12-21 | 1993-04-11 | lunch           |
      | application/json | application/json | Mario     | Petronildo |            |            |                 |
      | application/json | application/json | Carlos    | Gonzales   |            | 2023-09-12 | Breakfast       |

  @FailedCreateBook
  Scenario Outline: Failed scenario due to NO header submission
    Given path createBooking
    And header Content-Type = '<content-type>'
    And header Accept = '<accept>'
    And request myJsonFile
    When method POST
    Then status 418
    * print response
    * match $ == "I'm a Teapot"

    Examples:
      | content-type     | accept | firstname | lastname | checkin    | checkout   | additionalneeds |
      | application/json |        | Carlos    | Gonzales | 2023-08-12 | 2023-09-12 | Breakfast       |

  @BugOrderDateCreationBook
  Scenario Outline: Date checking is less than the checkout
    Given path createBooking
    And header Content-Type = '<content-type>'
    And header Accept = '<accept>'
    And request myJsonFile
    When method POST
    Then status 200

    Examples:
      | content-type     | accept           | firstname | lastname   | checkin    | checkout   | additionalneeds |
      | application/json | application/json | Carlos    | Gonzales   | 2023-08-12 | 2021-09-12 | Breakfast       |
      | application/json | application/json | Mario     | Petronildo | 1900-12-21 | 1800-04-11 | lunch           |

  @SuccessfulGetBook
  Scenario: Successful Get Booking created by id
    * def createBook = call read("classpath:karate/booking/create_book_snippets.feature@ReuseSuccessfulBookCreate")
    * def varSaveId = createBook.response.bookingid
    Given path '/booking/' + varSaveId
    And header Accept = 'application/json'
    When method GET
    Then status 200

  @GetAllBookCreated
    Scenario: Obtain all book registered at the moment
    Given path '/booking'
    And header Accept = 'application/json'
    When method GET
    Then status 200

  @DoesNotExistBook
  Scenario Outline: Id non-existent book
    Given path '/booking/' + '<idIvented>'
    And header Accept = 'application/json'
    When method GET
    Then status 404
    * match response == "Not Found"

    Examples:
      | idIvented  |
      | 99900999   |
      | 919399139  |
      | 303030313  |
      | 3939994413 |

  @SucessfulUpdateBook
  Scenario Outline: Updating successfully an specific book
    * def createBook = call read("classpath:karate/booking/create_book_snippets.feature@ReuseSuccessfulBookCreate")
    * def varSaveId = createBook.response.bookingid
    * def createBook = call read("classpath:karate/booking/create_token_snippets.feature@SucessfulGenerateToken")
    * def varSaveToken = createBook.response.token
    * print varSaveToken, varSaveId
    Given path '/booking/'+ varSaveId
    And header Content-Type = '<content-type>'
    And header Accept = '<accept>'
    And header Cookie = 'token='+ varSaveToken
    And request myJsonFile
    When method PUT
    Then status 200

    Examples:
      | content-type     | accept           | firstname  | lastname       | checkin    | checkout   | additionalneeds                              |
      | application/json | application/json | Carlos     | Gonzales       | 2023-08-12 | 2023-09-12 | Breakfast                                    |
      | application/json | application/json | Cristofoli | www.google.com | 1900-12-21 | 1993-04-11 | { "Breakfast":"kekded", "kekeke":"ededede" } |
