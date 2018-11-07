Feature: integration test
  #java -jar karate.jar tests/bdd/get-payments-test.feature

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('get-payments')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a full credit history

    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

    Given request {"payment":172600.00,"type":"regular","currency":"RUB","date":"2018-01-01"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-02"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-03"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-04"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given request {"payment":172600.00,"type":"regular","currency":"USD","date":"2018-01-05"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given request {"payment":171890.00,"type":"regular","currency":"USD","date":"2018-01-06"}
    And path id
    When method put
    Then status 200
    And match response == {paymentExecutedAt:'#string'}

    Given path id
    When method DELETE
    Then status 204
    And match response == ''