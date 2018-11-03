Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('close-credit-mock')
    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

    Scenario: close credit
        Given path 2
    	When method get
    	Then status 200
        And match response == {message : 'deleted'}
    Scenario: hui
        Given path 4
        When method get
        Then status 200
        And match response == {message : 'deleted'}

    Scenario: close credit
        Given path "5ig"
        When method get
        Then status 400
        And match response == {message : 'not exist'}

    Scenario: close credit
        Given path 20
        When method get
        Then status 400
        And match response == {message : 'not exist'}