Feature: integration test

Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('close-credit-mock')

    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

Scenario: Check on exist
    * url 'http://localhost:' + serverMock.port + '/credit'
    Given path 1000
    When method get
    Then status 404

    * url 'http://localhost:' + serverMock.port + '/credit' 
    Given path 1000
    When method delete
    Then status 404

Scenario: Check on validation
    * url 'http://localhost:' + serverMock.port + '/credit'
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":1,"percent":5}
    When method post
    Then status 200
    And def id = response.id

    * url 'http://localhost:' + serverMock.port + '/credit' 
    Given path id
    When method delete
    Then status 400

    * url 'http://localhost:' + serverMock.port + '/credit'
    Given request id
    When method put
    Then status 200

    * url 'http://localhost:' + serverMock.port + '/credit' 
    Given path id
    When method delete
    Then status 204

Scenario Outline: create credit positive
    * url 'http://localhost:' + serverMock.port + '/credit' 
    Given path <ID>
    When method delete
    Then status 400

    Examples:
    |ID|
    |"T1"|
    |"i"|
    |"m"|
    |"u"|
    |"r"|
    |"A0"|
    |"r!"|
    |"t"|
    |"e"|
    |"m"|
