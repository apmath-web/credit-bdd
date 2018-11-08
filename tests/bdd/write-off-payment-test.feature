Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('write-off-payment-mock')
    * url 'http://localhost:' + serverMock.port + '/'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario: Create a full credit history

    Given request {}
    When method PUT
    Then status 204
    And match response == ''

