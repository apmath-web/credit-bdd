Feature: integration test

  Background:
    * def serverConfig = read('mocks/start-mock.js')
    * def serverMock = serverConfig('close-credit-mock')
    * url 'http://localhost:' + serverMock.port + '/credit' + '/delete'
    * configure afterScenario = read('mocks/stop-mock.js')
    * configure headers = { 'Content-Type': 'application/json' }

    Scenario: Good request
        Given path 2
    	When method get
    	Then status 200
        And match response == {message : 'Done'}

    Scenario: Good request 
        Given path 4
        When method get
        Then status 200
        And match response == {message : 'Done'}

    Scenario: Bad request
        Given path "i"
        When method get
        Then status 400
        And match response == {message : 'Uncorrect'}

    Scenario: Bad request
        Given path 10
        When method get
        Then status 404
        And match response == {message : 'Not exist'}
