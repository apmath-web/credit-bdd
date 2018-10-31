Feature: integration test

Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('take-credit-mock')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

Scenario: close credit successfully
    Given request {id: 1}
    When method post
    Then status 200
    And match response == { "Credit closed successfully" }
