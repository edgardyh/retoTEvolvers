@ignore
Feature: reusable scenarios for generate token

  Background:
    * url api.baseUrl
    * def createBooking = '/booking'
    * def myJsonFile = read('classpath:jsonBase/request.json')

  @SucessfulGenerateToken
  Scenario Outline: Successful Get Booking created by id
    Given path '/auth'
    And header Content-Type = '<header>'
    And request { username: 'admin', password: 'password123' }
    When method POST
    Then status 200
    And match response == { token: '#notnull' }
    Examples:
      | header           |
      | application/json |