@ignore
Feature: reusable scenario for create book

  Background:
    * url api.baseUrl
    * def createBooking = '/booking'
    * def myJsonFile = read('classpath:jsonBase/request.json')

  @ReuseSuccessfulBookCreate
  Scenario Outline: Reussable Successful book create with all body data required
    Given path createBooking
    And header Content-Type = '<header>'
    And header Accept = '<header>'
    And request myJsonFile
    When method POST
    Then status 200
    * def varId = response.bookingid
    Examples:
      | header           |
      | application/json |