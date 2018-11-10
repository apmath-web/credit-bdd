Feature: integration test
  #java -jar karate.jar tests/bdd/get-payments-test.feature

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('get-payments')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a full credit history

  #Create new credit
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

  #Perfrom 1st payment
    Given request {"payment":172600.00,"type":"regular","currency":"RUB","date":"2018-01-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  ##Get all payments
    Given path id
    And path 'payments'
    When method get
    Then status 200

  #Perfrom 2nd payment
    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-02"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  ##Get all paid payments
    Given path id
    And path 'payments'
    And param state = 'paid'
    When method get
    Then status 200

  #Perfrom 3nd payment
    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-03"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  ##Get all upcoming payments
    Given path id
    And path 'payments'
    And param state = 'upcoming'
    When method get
    Then status 200

  #Perfrom 4th payment
    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-04"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom 5th payment
    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-05"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  #Perfrom 6th payment
    Given request {"payment":171890.00,"type":"regular","currency":"USD","date":"2018-01-06"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

  ##Get all payments
    Given path id
    And path 'payments'
    When method get
    Then status 200

  #Delete credit
    Given path id
    When method DELETE
    Then status 204
    And match response == ''