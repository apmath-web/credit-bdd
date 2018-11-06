Feature: integration test
  #java -jar karate.jar tests/bdd/get-payments-test.feature

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('get-payments')
    * url 'http://localhost:' + serverMock.port + '/credit'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

  Scenario Outline: list payments for credit
    Given path <id>
    And path 'payments'
    And param type = <type>
    And param state = <state>
    When method get
    Then status 200

    Examples:
      | id | type      | state  |
      | 0  | 'early'   | 'paid' |
      | 0  | 'regular' | 'paid' |

  Scenario Outline: list payments for credit with corrupted data
    Given path <id>
    And path 'payments'
    And param type = <type>
    And param state = <state>
    When method get
    Then status 404

    Examples:
      | id | type        | state      |
      | 0  | 'early'     | 'now'      |
      | 0  | 'reg32ular' | 'paid'     |
      | 0  | 'rrere'     | 'paid'     |
      | 0  | 'r123das'   | 'upcoming' |
      | 0  | 'early'     | 'upcoming' |