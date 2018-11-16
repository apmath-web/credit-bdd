Feature: integration test

Background:
* def serverConfig = read('mocks/start-mock.js')
* def serverMock = serverConfig('close-credit-mock')

* configure afterScenario = read('mocks/stop-mock.js')
* configure headers = { 'Content-Type': 'application/json' }

Scenario: Check all

    
    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path 5
    When method delete
    Then status 404

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path 1
    When method delete
    Then status 404

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path 2
    When method delete
    Then status 404

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path 9
    When method delete
    Then status 404

    * url 'http://localhost:' + serverMock.port + '/credit'
    Given request {"person":{"firstName":"Alexandra","lastName":"Chernyshova"},"credit":1000000,"agreementAt":"2018-10-08","currency":"RUB","duration":6,"percent":5}
    When method post
    Then status 200
    And def id = response.id

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path id
    When method delete
    Then status 204

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path "s1"
    When method delete
    Then status 400

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path "2-3"
    When method delete
    Then status 400

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path "i"
    When method delete
    Then status 400

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path "o"
    When method delete
    Then status 400

    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    Given path "!"
    When method delete
    Then status 400
